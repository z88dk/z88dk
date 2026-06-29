/*
 * ir_lower.c — Phase 1 dumb spill-everything lowerer (z80).
 *
 * For each op:
 *   1. Load operands from frame slots into HL / DE.
 *   2. Compute.
 *   3. Store the result back to the destination's frame slot.
 *
 * This produces correct but slow code — every read and write hits
 * memory. The point is to validate the lowering interface end-to-end
 * before adding an allocator. Phase 2 adds register allocation, which
 * keeps some vregs in registers and elides the load/store traffic.
 *
 * Limitations of the Phase 1 lowerer:
 *  - Z80 only. Other CPUs trap-and-abort with a diagnostic.
 *  - Subset of ops. Anything not in the dispatch table aborts.
 *  - No CallInfo / HelperInfo handling (Phase 1.3).
 *  - No __asm / __naked / __interrupt handling (Phase 1.3).
 *  - No far / sfr / addressmod / critical handling (Phase 1.3+).
 *  - No params handling — assumes the function takes no args, returns
 *    via HL. The selftest exercises this shape only.
 */

#include "ir_lower.h"
#include "ir_analysis.h"
#include "ir_alloc.h"
#include "ir_opt.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Global FRAMEPTR opt-in: -1 disabled, 1 IX, 0 IY. Owned by the
   compiler (data.c) but consulted directly here so the lowerer stays
   decoupled from ccdefs.h. Mirrors the walker's check. */
extern int c_framepointer_is_ix;

/* Per-TU string-literal queue label number. Walker emits string
   literal addresses as `ld hl,i_<litlab>+<offset>`; we mirror that
   for IR_LD_STR. */
extern int litlab;

/* ----- Frame-slot assignment ------------------------------------------- */

void ir_assign_slots(Func *f)
{
    free(f->vreg_spill_slot);
    f->vreg_spill_slot = calloc(f->n_vregs, sizeof(int));
    if (!f->vreg_spill_slot && f->n_vregs > 0) {
        fputs("ir_lower: out of memory in ir_assign_slots\n", stderr);
        abort();
    }

    /* Per-vreg "needs slot" decision is owned by ir_alloc.c: vregs with
       phys == IR_PR_SPILL go into the interference / coloring loop below;
       vregs with any register-pool assignment (IR_PR_HL / DE / BC /
       DEHL) get slot = -1 — the lowerer never reads them from memory. */
    int *needs_slot = calloc((size_t)f->n_vregs, sizeof(int));
    if (!needs_slot && f->n_vregs > 0) {
        fputs("ir_lower: out of memory in ir_assign_slots\n", stderr);
        abort();
    }
    for (int v = 0; v < f->n_vregs; v++) {
        needs_slot[v] = (f->vreg_to_phys
                         && f->vreg_to_phys[v] != IR_PR_SPILL) ? 0 : 1;
        /* Read-only param: lives in the caller's pushed-arg slot;
           no local frame slot needed. slot_off returns the caller
           offset directly. */
        if (f->vregs[v].flags & IR_VREG_PARAM_RO)
            needs_slot[v] = 0;
    }

    /* ---- Spill-slot coalescing (Phase 3A, per-op interference) --------

       Build a per-vreg interference bitmap by walking each BB backwards
       from live_out, tracking the live set just AFTER each op. Each def
       interferes with every vreg in the after-op live set (the def's
       value coexists with those). Then update live = (after - {def}) ∪
       {uses} for the next iteration. This catches non-overlap within
       a single BB — necessary for big-BB workloads like MD5Transform.

       Conservative cuts: params and addr-taken vregs keep their own
       slots — params because the prologue depends on a fixed location,
       addr-taken because escaped addresses can outlive the IR-visible
       lifetime. Same-width coalescing only. */
    const int n_vregs = f->n_vregs;
    const int row_words = (n_vregs + 31) / 32;
    uint32_t *interf = NULL;
    if (n_vregs > 0 && row_words > 0) {
        interf = calloc((size_t)n_vregs * row_words, sizeof(uint32_t));
        if (!interf) {
            fputs("ir_lower: out of memory (interf)\n", stderr);
            abort();
        }
    }
    #define INTERF_ROW(v)         (&interf[(v) * row_words])
    #define INTERF_SET(v1, v2)    do {                                       \
        if ((v1) != (v2)) {                                                  \
            INTERF_ROW(v1)[(v2) >> 5] |= (uint32_t)1 << ((v2) & 31);         \
            INTERF_ROW(v2)[(v1) >> 5] |= (uint32_t)1 << ((v1) & 31);         \
        }                                                                    \
    } while (0)

    /* Scratch live-set bitmap, one row of size n_vregs bits. */
    uint32_t *live = NULL;
    if (n_vregs > 0) {
        live = calloc((size_t)row_words, sizeof(uint32_t));
        if (!live) {
            fputs("ir_lower: out of memory (live)\n", stderr);
            abort();
        }
    }
    #define LIVE_GET(v)   ((live[(v) >> 5] >> ((v) & 31)) & 1)
    #define LIVE_SET(v)   (live[(v) >> 5] |=  (uint32_t)1 << ((v) & 31))
    #define LIVE_CLEAR(v) (live[(v) >> 5] &= ~((uint32_t)1 << ((v) & 31)))

    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        /* Initialise live = live_out. */
        memset(live, 0, (size_t)row_words * sizeof(uint32_t));
        if (bb->live_out) {
            for (int v = 0; v < n_vregs; v++) {
                if (ir_bitset_get((const BitSet *)bb->live_out, v))
                    LIVE_SET(v);
            }
        }
        /* Walk ops in reverse. At each op, `live` is the set of vregs
           live just AFTER the op. Each def conflicts with every vreg in
           the live set. Then update: live = (live - {defs}) ∪ {uses}. */
        for (int j = bb->n_ops - 1; j >= 0; j--) {
            Op *op = &bb->ops[j];
            int defs[2]; int nd = ir_op_defs(op, defs, 2);
            for (int k = 0; k < nd; k++) {
                int d = defs[k];
                if (d < 0 || d >= n_vregs) continue;
                /* Conflict d with every currently-live vreg. */
                uint32_t *drow = INTERF_ROW(d);
                for (int w = 0; w < row_words; w++) {
                    uint32_t live_w = live[w];
                    if (!live_w) continue;
                    drow[w] |= live_w;
                    /* Reflect: each set bit in live_w points to a vreg
                       v2; mark v2 → d. Walk bits in live_w. */
                    while (live_w) {
                        int bit = __builtin_ctz(live_w);
                        int v2 = w * 32 + bit;
                        if (v2 != d)
                            INTERF_ROW(v2)[d >> 5] |=
                                (uint32_t)1 << (d & 31);
                        live_w &= live_w - 1;
                    }
                }
                LIVE_CLEAR(d);
            }
            int uses[16]; int nu = ir_op_uses(op, uses, 16);
            for (int k = 0; k < nu; k++) {
                int u = uses[k];
                if (u >= 0 && u < n_vregs) LIVE_SET(u);
            }
        }
    }
    free(live);
    #undef LIVE_GET
    #undef LIVE_SET
    #undef LIVE_CLEAR

    /* Greedy slot allocator. slot_members[s] = bitmap of vregs in slot s.
       slot_width[s] = byte width. A new vreg can join slot s iff it
       doesn't interfere with any current member of s. */
    uint32_t *slot_members = NULL;
    int      *slot_width   = NULL;
    int       slot_cap     = 0;
    int       slot_n       = 0;
    int       offset       = 0;
    #define SLOT_ROW(s) (&slot_members[(s) * row_words])

    /* Pass 0: params and addr-taken — own slot each, vreg-id order.
       Pass 1: others — first-fit across existing same-width slots. */
    for (int pass = 0; pass < 2; pass++) {
        for (int v = 0; v < n_vregs; v++) {
            if (!needs_slot[v]) {
                if (pass == 0) f->vreg_spill_slot[v] = -1;
                continue;
            }
            VReg *vr = &f->vregs[v];
            int is_pinned = (vr->flags & IR_VREG_PARAM)
                         || (vr->flags & IR_VREG_ADDR_TAKEN);
            if ((pass == 0) != is_pinned) continue;

            int width = (vr->width > 0) ? vr->width : 2;
            int chosen = -1;

            if (pass == 1 && row_words > 0) {
                /* First-fit across same-width slots. A slot is compatible
                   if no member of the slot interferes with v. */
                uint32_t *vrow = INTERF_ROW(v);
                for (int s = 0; s < slot_n; s++) {
                    if (slot_width[s] != width) continue;
                    uint32_t *srow = SLOT_ROW(s);
                    int conflict = 0;
                    for (int w = 0; w < row_words; w++) {
                        if (srow[w] & vrow[w]) { conflict = 1; break; }
                    }
                    if (!conflict) { chosen = s; break; }
                }
            }

            if (chosen < 0) {
                if (slot_n == slot_cap) {
                    slot_cap = slot_cap ? slot_cap * 2 : 16;
                    slot_members = realloc(slot_members,
                        (size_t)slot_cap * row_words * sizeof(uint32_t));
                    slot_width   = realloc(slot_width,
                        (size_t)slot_cap * sizeof(int));
                    if ((!slot_members && row_words > 0) || !slot_width) {
                        fputs("ir_lower: out of memory (slot tables)\n",
                              stderr);
                        abort();
                    }
                    if (row_words > 0)
                        memset(SLOT_ROW(slot_n), 0,
                               (size_t)(slot_cap - slot_n) * row_words
                               * sizeof(uint32_t));
                }
                chosen = slot_n++;
                slot_width[chosen] = width;
                if (row_words > 0)
                    memset(SLOT_ROW(chosen), 0,
                           (size_t)row_words * sizeof(uint32_t));
                f->vreg_spill_slot[v] = offset;
                offset += width;
            } else {
                int off_acc = 0;
                for (int s = 0; s < chosen; s++) off_acc += slot_width[s];
                f->vreg_spill_slot[v] = off_acc;
            }
            /* Add v itself to slot membership (so future candidates check
               v's interference row). */
            SLOT_ROW(chosen)[v >> 5] |= (uint32_t)1 << (v & 31);
        }
    }
    f->frame_size = offset;

    #undef SLOT_ROW
    #undef INTERF_ROW
    #undef INTERF_SET
    free(slot_members);
    free(slot_width);
    free(interf);
    free(needs_slot);
}

/* ----- Tiny emit helpers ------------------------------------------------ */

static void emit(FILE *out, const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    fputc('\t', out);
    vfprintf(out, fmt, ap);
    va_end(ap);
    fputc('\n', out);
}

/* Monotonic counter, bumped on every ir_lower_func() entry. Used to
   prefix per-function labels so they don't collide across functions in
   the same module (`L_bb_0` would otherwise duplicate). */
static int func_emit_idx;

static void emit_bb_label(FILE *out, int bb_id)
{
    fprintf(out, "L_f%d_bb_%d:\n", func_emit_idx, bb_id);
}

/* Per-function counter for compare-overflow correction labels. Reset at
   the start of each ir_lower_func() call. */
static int cmp_label_counter;

/* Lazy HL caching (Phase 2.0): tracks which vreg, if any, currently
   holds its value in HL. Reset to -1 at each BB boundary and across
   any op that clobbers HL in a way the cache can't reason about
   (calls, branches, shifts that loop on HL, etc.). When the next op
   reads cur_hl_vreg as src[0], we skip the load and use load_to_de_
   preserve_hl for src[1]. */
static int cur_hl_vreg;

/* DE value cache (Phase 3, Stage 4-lite). Tracks which vreg, if any,
   currently holds its value in DE. Designed to survive emits that
   preserve DE (load_to_hl, add/sbc hl,de, byte ops, etc.) and be
   invalidated only at sites where DE is actually written:
   load_to_dehl, ld de,K, ex de,hl, pop de, calls, the trailing ex
   de,hl in spill_and_swap_unless_dead, etc.

   Used by load_to_de to skip the slot reload when DE already holds
   the wanted vreg, and by load_binop_operands to recognise more
   cache-hit shapes for src[0]/src[1]. */
static int cur_de_vreg;

/* Long-DEHL cache (Phase 3, Stage 4-lite, for long-heavy code).
   Tracks which long vreg, if any, has its halves split across DE
   (high) and BC (low). Both load_to_dehl and store_dehl leave the
   registers in this state (load explicitly, store via its internal
   `pop bc` after `push hl`). Cache holds while DE *and* BC are
   preserved — load_to_hl, byte ops, ex de,hl-then-back, and
   address-arithmetic-via-HL all keep it valid.

   On hit, `load_to_dehl_adj(v, _)` emits just `ld l,c; ld h,b`
   (2 inst, ~12 T-states) instead of the full 9-instruction slot
   load. The big win is md5 Transform where each compound `a +=
   <expr>; a = (a<<7)|(a>>25); a += b` reads `a` immediately after
   the previous store_dehl(a). */
static int cur_dehl_vreg;

/* Slot accessor — given a vreg id, return its sp-relative byte offset.
   The "sp" here is the post-prologue SP; the lowerer's load/store ops
   use `(sp+N)` syntax which z80asm translates to the byte-pair `ld hl,N;
   add hl,sp; ld e,(hl)...` sequence on plain z80 (or native on Rabbit /
   KC160). The current sccz80 codegen emits this same form. */
/* For read-only PARAM vregs, return the caller-pushed-arg offset
   (positive, above sp post-prologue). Smallc convention: leftmost
   param pushed first → highest offset. retaddr is at frame_size+0;
   args sit above it. */
/* Framepointer mode predicates.

   `fp_active(f)` returns 1 iff the function should use IX/IY as a
   frame pointer. Gated globally by -frameix / -frameiy (which set
   `c_framepointer_is_ix` to 1 / 0 respectively; -1 means off) and
   per-function by __naked. Mirrors the walker's gate.

   `fp_offset_fits(off)` returns 1 iff `off` is in the signed 8-bit
   range that `(ix±d)` addressing supports.

   `frame_reg()` returns "ix" or "iy" matching the user's choice. */
static int fp_active(const Func *f)
{
    if (!f) return 0;
    if (c_framepointer_is_ix == -1) return 0;
    if (f->is_naked) return 0;
    return 1;
}

static int fp_offset_fits(int off)
{
    return off >= -128 && off <= 127;
}

static const char *frame_reg(void)
{
    return c_framepointer_is_ix == 1 ? "ix" : "iy";
}

static int param_ro_caller_off(const Func *f, int vreg_id)
{
    int args_total = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        const VReg *v = &f->vregs[i];
        if (v->flags & IR_VREG_PARAM) {
            int w = (v->width > 0) ? v->width : 2;
            if (w == 1) w = 2;       /* char promoted to int at call site */
            args_total += w;
        }
    }
    /* Body-sp-relative offset of the top of the caller's arg block.
       Layout from body sp upward:
         [body sp] locals (frame_size bytes)
         [body sp + frame_size]      <- (FP active: saved IX, 2 bytes)
         [body sp + frame_size + 2]  return addr (no FP)
         [body sp + frame_size + 4]  caller args (no FP)
       With FP active, everything above the locals shifts up by 2 to
       make room for the saved IX. So caller_off becomes
       frame_size + 4 + args_total instead of frame_size + 2 + args_total. */
    int retaddr_off = f->frame_size + (fp_active(f) ? 4 : 2);
    int caller_off = retaddr_off + args_total;
    for (int i = 0; i < f->n_vregs; i++) {
        const VReg *v = &f->vregs[i];
        if (!(v->flags & IR_VREG_PARAM)) continue;
        int width = (v->width > 0) ? v->width : 2;
        int caller_w = (width == 1) ? 2 : width;
        caller_off -= caller_w;
        if (v->id == vreg_id) {
            /* For byte params, caller's slot is the low byte of an
               int — same sp offset. */
            return caller_off;
        }
    }
    return -1;  /* shouldn't happen — caller verified PARAM flag */
}

static int slot_off(const Func *f, int vreg_id)
{
    if (f->vregs[vreg_id].flags & IR_VREG_PARAM_RO)
        return param_ro_caller_off(f, vreg_id);
    return f->vreg_spill_slot[vreg_id];
}

/* IX-relative offset for a vreg's slot, valid when fp_active(f).
   IX = body_sp + frame_size, so a sp-relative offset K maps to
   ix-relative K - frame_size. Locals come out negative (below IX);
   PARAM_IN_PLACE slots come out positive (above IX). */
static int slot_ix_off(const Func *f, int vreg_id)
{
    return slot_off(f, vreg_id) - f->frame_size;
}

/* Forward declarations for BC/DE cache helpers used by load_to_hl_adj
   and load_to_de. Definitions are with the rest of the cache state
   later in the file (kept together for readability). */
static int  bc_has(int v);
static int  hl_has(int v);
static void cache_de(int v);
static void cache_bc(int v);
static void invalidate_hl_cache(void);

/* Phase D — see the full comment near cur_dst_dead / cur_dehl_dst_dead_safe.
   Defined here (not later as a forward decl) because load_to_hl /
   load_to_de / load_to_dehl wrappers right below depend on it. */
static int cur_sp_adjust;

/* One-shot flag forward decls (definitions further down with the
   rest of the lookahead state). Need to be visible to
   load_to_dehl_adj / store_dehl which sit above the cache helpers. */
static int cur_load_to_dehl_no_hl;
static int cur_store_dehl_bc_ready;

/* Phase D option B — vreg sitting on top of the data stack from an
   IR_PUSH_DEHL_LONG, waiting to be consumed by a long-binop consumer
   (OR/AND/XOR/ADD/SUB) via its stack-resident variant. -1 when no
   value is staged. Reset at BB boundaries. Cleared by the consumer
   that absorbs it OR by an explicit IR_POP_DEHL_LONG (for non-binop
   consumers — ST_MEM, NOT/NEG, SHL/SHR — that the pass still wraps
   in PUSH+POP because their lowering needs the value in DEHL). */
static int cur_stack_long_top;

/* Load a PR_BC vreg's slot value into BC. Used both by the prologue
   (function entry) and by on-demand reload sites — when a PR_BC vreg
   is read but `cur_bc_vreg` holds a different occupant, the reader
   fires this to swap BC's contents. Caller is responsible for calling
   `cache_bc(vreg_id)` after; we don't do it here because the prologue
   wants the cache set, the on-demand path wants it set before the
   ld l,c / ld e,c emit. */
static void emit_bc_reload(FILE *out, const Func *f, int vreg_id)
{
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            emit(out, "ld\tbc,(%s%+d)", frame_reg(), ix_off);
            cache_bc(vreg_id);
            return;
        }
    }
    int off = slot_off(f, vreg_id) + cur_sp_adjust;
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\tc,(hl)");
    emit(out, "inc\thl");
    emit(out, "ld\tb,(hl)");
    cache_bc(vreg_id);
    invalidate_hl_cache();
}

/* Predicate: vreg_id is allocated to PR_BC. Used by load_to_* to
   decide between a cache hit, an on-demand reload, or the regular
   slot read. */
static int vreg_in_pr_bc(const Func *f, int vreg_id)
{
    if (!f || !f->vreg_to_phys) return 0;
    if (vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    return f->vreg_to_phys[vreg_id] == IR_PR_BC;
}

/* Predicate: vreg holds a KIND_LONG (or LONGLONG) value — i.e. the
   width-4 (or width-8) byte-arithmetic fastpaths are safe to fire.
   z88dk's float/double also have width 4 (MATHS_Z80 32-bit FP), and
   _Float16 / fix88 have width 2 — those use FP/fixed-point helpers,
   NOT integer byte-wise ops, so width alone isn't enough. Currently
   the ir_build width_for_kind helper returns 0 for FP / fixed
   kinds so they never reach IR, but checking kind here makes the
   contract explicit and forward-safe.

   Numeric KIND values from define.h:
     KIND_CHAR=2, KIND_SHORT=3, KIND_INT=4, KIND_LONG=5,
     KIND_PTR=9, KIND_CPTR=10, KIND_LONGLONG=19
     (FP/fixed: KIND_FLOAT=6, KIND_DOUBLE=7, KIND_FLOAT16=18,
                KIND_ACCUM16=20, KIND_ACCUM32=21 — excluded)
   We avoid including define.h here to keep ir_lower decoupled.    */
static int vreg_kind_is_integer(const Func *f, int vreg_id)
{
    if (!f || vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    int k = (int)f->vregs[vreg_id].kind;
    return k == 2 || k == 3 || k == 4 || k == 5
        || k == 9 || k == 10 || k == 19;
}

/* Load a vreg's frame-slot value into HL with optional sp adjustment,
   zero-extending byte-width vregs to 16 bits. `sp_adj` compensates for
   pushes that shifted sp since the canonical slot offsets were set;
   pass 0 if sp is at its frame-entry position. */
static void load_to_hl_adj(FILE *out, const Func *f, int vreg_id, int sp_adj)
{
    /* HL cache hit: HL already holds the wanted vreg. No-op. Most
       callers guard with `if (!hl_has(...))` themselves, but a few
       (e.g. IR_ST_MEM's MEM_VREG path for width-2 stores) call us
       unconditionally — and for PR_HL vregs (cacheable, no slot
       allocated), the slot read at the bottom would land at sp-1
       (slot_off returns -1) and silently read garbage. Without this
       check, `*p = x + 1` miscompiled: the IR_ADD's PR_HL result
       was overwritten by `ld hl,-1; add hl,sp; <byte load>` reading
       below the stack frame. */
    if (hl_has(vreg_id) && sp_adj == 0) return;
    /* PR_BC hit: skip the slot reload and copy from BC. 2 instructions
       vs the 6 the slot-read path emits. Only fires for width-2 vregs;
       ir_alloc enforces width=2 for PR_BC, but guard width anyway in
       case any caller passes a different vreg id. */
    if (bc_has(vreg_id) && f->vregs[vreg_id].width == 2) {
        emit(out, "ld\tl,c");
        emit(out, "ld\th,b");
        cur_hl_vreg = vreg_id;
        return;
    }
    /* PR_BC miss with PR_BC allocation: another PR_BC tenant currently
       occupies BC. Reload this vreg's value from its slot, then take
       the cache-hit path. Cost ≤ the regular slot read (the FP-active
       case is a single `ld bc,(ix+d)` synthetic), and unlocks the
       cheap `ld l,c; ld h,b` recovery. */
    if (vreg_in_pr_bc(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        emit_bc_reload(out, f, vreg_id);
        emit(out, "ld\tl,c");
        emit(out, "ld\th,b");
        cur_hl_vreg = vreg_id;
        return;
    }
    int off = slot_off(f, vreg_id) + sp_adj + cur_sp_adjust;
    int width = f->vregs[vreg_id].width;
    /* FP-relative fast path. IX captures sp at function entry, so its
       offset to any slot is invariant under push/pop activity — sp_adj
       is irrelevant for IX addressing. */
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (width == 1 && fp_offset_fits(ix_off)) {
            emit(out, "ld\tl,(%s%+d)", frame_reg(), ix_off);
            emit(out, "ld\th,0");
            cur_hl_vreg = vreg_id;
            return;
        }
        if (width == 2 && fp_offset_fits(ix_off)
            && fp_offset_fits(ix_off + 1)) {
            emit(out, "ld\thl,(%s%+d)", frame_reg(), ix_off);
            cur_hl_vreg = vreg_id;
            return;
        }
    }
    if (width == 1) {
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\ta,(hl)");
        emit(out, "ld\tl,a");
        emit(out, "ld\th,0");
        cur_hl_vreg = vreg_id;
        return;
    }
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\ta,(hl)");
    emit(out, "inc\thl");
    emit(out, "ld\th,(hl)");
    emit(out, "ld\tl,a");
    cur_hl_vreg = vreg_id;
}

static void load_to_hl(FILE *out, const Func *f, int vreg_id)
{
    /* Phase D: outstanding stack-saved longs shift sp; the depth
       lives in cur_sp_adjust. load_to_hl_adj's internal slot-read
       path already adds cur_sp_adjust, so callers pass only their
       LOCAL (within-op) sp_adj — here 0. */
    load_to_hl_adj(out, f, vreg_id, 0);
}

/* Load 16-bit value into DE (used for binop second operand).
   Cache-aware: if DE already holds the wanted vreg, no-op. Else if
   HL holds it, `ex de,hl` is a single-instruction shortcut. Else
   load via HL then ex de,hl. After: cur_de_vreg = vreg_id; HL
   holds whatever DE was (junk to the caller). */
static void load_to_de(FILE *out, const Func *f, int vreg_id)
{
    if (cur_de_vreg == vreg_id && vreg_id >= 0) return;
    /* PR_BC hit: copy DE from BC directly. 2 instructions, doesn't
       disturb HL — better than load-via-HL-then-swap. */
    if (bc_has(vreg_id) && f->vregs[vreg_id].width == 2) {
        emit(out, "ld\te,c");
        emit(out, "ld\td,b");
        cache_de(vreg_id);
        return;
    }
    /* PR_BC miss with PR_BC allocation: reload BC then take the BC→DE
       cache-hit path. Doesn't touch HL. */
    if (vreg_in_pr_bc(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        emit_bc_reload(out, f, vreg_id);
        emit(out, "ld\te,c");
        emit(out, "ld\td,b");
        cache_de(vreg_id);
        return;
    }
    /* FP-relative direct-to-DE: 6 bytes (synthetic `ld de,(ix+d)`)
       but preserves HL — the cached value in HL stays valid across
       the load. In FP mode with HL holding another vreg, the
       preservation is worth the 1-byte difference vs the byte-walk
       form (which clobbers HL and invalidates downstream cache hits). */
    if (fp_active(f) && f->vregs[vreg_id].width == 2) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            emit(out, "ld\tde,(%s%+d)", frame_reg(), ix_off);
            cache_de(vreg_id);
            return;
        }
    }
    if (cur_hl_vreg == vreg_id && vreg_id >= 0) {
        emit(out, "ex\tde,hl");
        /* HL ↔ DE swap: caches swap too. cur_hl now has what DE held
           (the old cur_de_vreg or -1); cur_de gets what HL held. */
        int t = cur_hl_vreg; cur_hl_vreg = cur_de_vreg; cur_de_vreg = t;
        return;
    }
    /* sp-rel direct-to-DE byte walk for width=2. Writes E,D directly
       through (hl) without the trailing `ld l,a` that load_to_hl
       needs to assemble HL from a temp byte. Saves 1 byte vs
       load_to_hl + ex de,hl. HL is clobbered (same as the ex de,hl
       form when DE held junk — common). */
    if (f->vregs[vreg_id].width == 2) {
        int off = slot_off(f, vreg_id) + cur_sp_adjust;
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\te,(hl)");
        emit(out, "inc\thl");
        emit(out, "ld\td,(hl)");
        cur_hl_vreg = -1;
        cache_de(vreg_id);
        return;
    }
    load_to_hl(out, f, vreg_id);
    emit(out, "ex\tde,hl");
    int t = cur_hl_vreg; cur_hl_vreg = cur_de_vreg; cur_de_vreg = t;
}

/* Same as load_to_de but preserves the value already in HL by
   wrapping the sp-relative load in push/pop. Costs 2 extra bytes
   (push hl + pop hl) and a few extra cycles, but lets the caller
   keep a cached value in HL across the load. */
static void load_to_de_preserve_hl(FILE *out, const Func *f, int vreg_id)
{
    if (cur_de_vreg == vreg_id && vreg_id >= 0) return;
    /* PR_BC hit: BC→DE doesn't touch HL, so the push/pop is pointless. */
    if (bc_has(vreg_id) && f->vregs[vreg_id].width == 2) {
        emit(out, "ld\te,c");
        emit(out, "ld\td,b");
        cache_de(vreg_id);
        return;
    }
    /* PR_BC miss with PR_BC allocation: reload BC (doesn't disturb HL
       when FP is active, but otherwise uses HL — fall through to the
       push/pop path in that case). */
    if (vreg_in_pr_bc(f, vreg_id) && f->vregs[vreg_id].width == 2
        && fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            emit_bc_reload(out, f, vreg_id);
            emit(out, "ld\te,c");
            emit(out, "ld\td,b");
            cache_de(vreg_id);
            return;
        }
    }
    emit(out, "push\thl");
    cur_sp_adjust += 2;
    load_to_de(out, f, vreg_id);
    cur_sp_adjust -= 2;
    emit(out, "pop\thl");
    /* HL is restored to its prior value — cache stands. */
}

/* Store HL to a vreg's frame slot. */
static void store_hl(FILE *out, const Func *f, int vreg_id)
{
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            /* Preserve the sp-rel store_hl contract: after this
               returns, DE holds the stored value and HL is junk.
               Many sites end with `store_hl; ex de,hl` expecting
               that swap to restore HL. */
            emit(out, "ld\t(%s%+d),hl", frame_reg(), ix_off);
            emit(out, "ex\tde,hl");
            return;
        }
    }
    int off = slot_off(f, vreg_id) + cur_sp_adjust;
    emit(out, "ex\tde,hl");        /* DE = value */
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e");
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),d");
}

static int a_has(int v);

/* Load 8-bit value from a vreg's frame slot into A. Cache-aware:
   if A already holds the wanted vreg (set by a prior IR_LD_MEM_VREG
   width=1 dead-skip or similar), skip the slot read entirely. */
static void load_byte_to_a(FILE *out, const Func *f, int vreg_id)
{
    if (a_has(vreg_id)) return;
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off)) {
            emit(out, "ld\ta,(%s%+d)", frame_reg(), ix_off);
            return;
        }
    }
    int off = slot_off(f, vreg_id) + cur_sp_adjust;
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\ta,(hl)");
    /* HL just got clobbered with the slot address — clear HL's
       cache entry only (DE/DEHL/BC unaffected by this routine) so
       a follow-up `load_to_hl(some_vreg)` doesn't see a stale hit
       and skip the reload. Caused intbench's init_data to write
       only the first byte (subsequent stores landed at the byte
       slot address instead of buffer[i]). */
    cur_hl_vreg = -1;
}

/* Store A to a vreg's 8-bit frame slot. Clobbers HL+E. */
static void store_a_byte(FILE *out, const Func *f, int vreg_id)
{
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off)) {
            emit(out, "ld\t(%s%+d),a", frame_reg(), ix_off);
            return;
        }
    }
    int off = slot_off(f, vreg_id) + cur_sp_adjust;
    emit(out, "ld\te,a");          /* stash value across sp+off load */
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e");
}

/* Load 4-byte (long) value from a vreg's frame slot into DEHL.
   Convention: DE = high half, HL = low half. Slot layout little-
   endian: slot+0..1 = low half, slot+2..3 = high half. Clobbers
   BC (used as scratch for the low half during the load).
   `sp_adj` compensates for caller pushes since the slot offset
   was last canonical (e.g. pushed args during a runtime-helper
   call setup). Pass 0 if sp is at its frame-entry position. */
static int dehl_has(int v);
static void cache_dehl(int v);
static void invalidate_hl_cache(void);

/* Partial load of a width-4 source for long IR_SHR with byte_shift ≥ 1.
   Reads only the source bytes that survive the shift directly into
   their final target positions (no separate byte-shuffle step needed),
   plus zeros the wiped-off high bytes. Skips the un-needed low bytes
   entirely. After this, DEHL holds the shifted-by-(byte_shift*8) value
   of the source, ready for the bit_shift remainder loop.

   byte_shift=1: target L=byte1 H=byte2 E=byte3 D=0
   byte_shift=2: target L=byte2 H=byte3 E=0 D=0
   byte_shift=3: target L=byte3 H=0 E=0 D=0 */
static void partial_load_long_shr(FILE *out, const Func *f, int v,
                                   int byte_shift)
{
    if (fp_active(f)) {
        int ix = slot_ix_off(f, v);
        switch (byte_shift) {
        case 1:
            if (fp_offset_fits(ix + 1) && fp_offset_fits(ix + 3)) {
                emit(out, "ld\tl,(%s%+d)", frame_reg(), ix + 1);
                emit(out, "ld\th,(%s%+d)", frame_reg(), ix + 2);
                emit(out, "ld\te,(%s%+d)", frame_reg(), ix + 3);
                emit(out, "ld\td,0");
                return;
            }
            break;
        case 2:
            if (fp_offset_fits(ix + 2) && fp_offset_fits(ix + 3)) {
                emit(out, "ld\tl,(%s%+d)", frame_reg(), ix + 2);
                emit(out, "ld\th,(%s%+d)", frame_reg(), ix + 3);
                emit(out, "ld\te,0");
                emit(out, "ld\td,e");
                return;
            }
            break;
        case 3:
            if (fp_offset_fits(ix + 3)) {
                emit(out, "ld\tl,(%s%+d)", frame_reg(), ix + 3);
                emit(out, "ld\th,0");
                emit(out, "ld\te,h");
                emit(out, "ld\td,e");
                return;
            }
            break;
        }
        /* FP-offset out of range — fall through to sp-rel. */
    }
    int off = slot_off(f, v) + cur_sp_adjust;
    switch (byte_shift) {
    case 1:
        /* Reads 3 bytes (1, 2, 3) into target L, H, E. We can't write
           H mid-sequence because the running address lives in HL and
           is still being incremented — clobbering H breaks subsequent
           `inc hl; ld _,(hl)` steps. Stage through BC, then transfer. */
        emit(out, "ld\thl,%d", off + 1);
        emit(out, "add\thl,sp");
        emit(out, "ld\tc,(hl)");        /* C = byte 1 */
        emit(out, "inc\thl");
        emit(out, "ld\tb,(hl)");        /* B = byte 2 */
        emit(out, "inc\thl");
        emit(out, "ld\te,(hl)");        /* E = byte 3 */
        emit(out, "ld\tl,c");           /* L = byte 1 */
        emit(out, "ld\th,b");           /* H = byte 2 */
        emit(out, "ld\td,0");
        return;
    case 2:
        emit(out, "ld\thl,%d", off + 2);
        emit(out, "add\thl,sp");
        emit(out, "ld\ta,(hl)");        /* A = byte 2 */
        emit(out, "inc\thl");
        emit(out, "ld\th,(hl)");        /* H = byte 3 */
        emit(out, "ld\tl,a");           /* L = byte 2 */
        emit(out, "ld\te,0");
        emit(out, "ld\td,e");
        return;
    case 3:
        emit(out, "ld\thl,%d", off + 3);
        emit(out, "add\thl,sp");
        emit(out, "ld\tl,(hl)");        /* L = byte 3 */
        emit(out, "ld\th,0");
        emit(out, "ld\te,h");
        emit(out, "ld\td,e");
        return;
    }
}

/* Mirror of partial_load_long_shr for SHL: byte_shift ≥ 1 means the
   high bytes of the source are discarded.

   byte_shift=1: target D=byte2 E=byte1 H=byte0 L=0
   byte_shift=2: target D=byte1 E=byte0 H=0 L=0
   byte_shift=3: target D=byte0 E=0 H=0 L=0 */
static void partial_load_long_shl(FILE *out, const Func *f, int v,
                                   int byte_shift)
{
    if (fp_active(f)) {
        int ix = slot_ix_off(f, v);
        switch (byte_shift) {
        case 1:
            if (fp_offset_fits(ix) && fp_offset_fits(ix + 2)) {
                emit(out, "ld\th,(%s%+d)", frame_reg(), ix + 0);
                emit(out, "ld\te,(%s%+d)", frame_reg(), ix + 1);
                emit(out, "ld\td,(%s%+d)", frame_reg(), ix + 2);
                emit(out, "ld\tl,0");
                return;
            }
            break;
        case 2:
            if (fp_offset_fits(ix) && fp_offset_fits(ix + 1)) {
                emit(out, "ld\te,(%s%+d)", frame_reg(), ix + 0);
                emit(out, "ld\td,(%s%+d)", frame_reg(), ix + 1);
                emit(out, "ld\th,0");
                emit(out, "ld\tl,h");
                return;
            }
            break;
        case 3:
            if (fp_offset_fits(ix)) {
                emit(out, "ld\td,(%s%+d)", frame_reg(), ix + 0);
                emit(out, "ld\te,0");
                emit(out, "ld\th,e");
                emit(out, "ld\tl,h");
                return;
            }
            break;
        }
    }
    int off = slot_off(f, v) + cur_sp_adjust;
    switch (byte_shift) {
    case 1:
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\ta,(hl)");        /* A = byte 0 */
        emit(out, "inc\thl");
        emit(out, "ld\te,(hl)");        /* E = byte 1 */
        emit(out, "inc\thl");
        emit(out, "ld\td,(hl)");        /* D = byte 2 */
        emit(out, "ld\th,a");           /* H = byte 0 */
        emit(out, "ld\tl,0");
        return;
    case 2:
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\te,(hl)");        /* E = byte 0 */
        emit(out, "inc\thl");
        emit(out, "ld\td,(hl)");        /* D = byte 1 */
        emit(out, "ld\th,0");
        emit(out, "ld\tl,h");
        return;
    case 3:
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\td,(hl)");        /* D = byte 0 */
        emit(out, "ld\te,0");
        emit(out, "ld\th,e");
        emit(out, "ld\tl,h");
        return;
    }
}

static void load_to_dehl_adj(FILE *out, const Func *f, int vreg_id, int sp_adj)
{
    int no_hl = cur_load_to_dehl_no_hl;
    cur_load_to_dehl_no_hl = 0;
    if (dehl_has(vreg_id)) {
        /* Cache hit: DE still has high half, BC has low half. Recover
           HL with 2 instructions (~12 T-states) vs ~120 for a full
           slot read. sp_adj is irrelevant — data is in registers.
           Skip the recovery when no_hl flag is set (caller is about
           to overwrite HL) OR when cur_hl_vreg == vreg_id (HL already
           holds the low half from a previous cache_dehl_no_spill that
           preserved HL). */
        if (!no_hl && cur_hl_vreg != vreg_id) {
            emit(out, "ld\tl,c");
            emit(out, "ld\th,b");
        }
        if (!no_hl) cur_hl_vreg = vreg_id;
        return;
    }
    /* FP-relative long load. sp_adj irrelevant for IX addressing. */
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 3)) {
            emit(out, "ld\thl,(%s%+d)", frame_reg(), ix_off);
            emit(out, "ld\tde,(%s%+d)", frame_reg(), ix_off + 2);
            /* BC is untouched — set it to HL (low) so the DEHL cache
               invariant (BC = low half when cur_dehl_vreg is set) holds.
               Then publish the cache: subsequent load_to_dehl(v) hits
               and emits `ld l,c; ld h,b` with correct BC. */
            emit(out, "ld\tb,h");
            emit(out, "ld\tc,l");
            cache_dehl(vreg_id);
            return;
        }
    }
    int off = slot_off(f, vreg_id) + sp_adj + cur_sp_adjust;
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\tc,(hl)");        /* C = byte 0 */
    emit(out, "inc\thl");
    emit(out, "ld\tb,(hl)");        /* B = byte 1 — BC = low half */
    emit(out, "inc\thl");
    emit(out, "ld\te,(hl)");        /* E = byte 2 */
    emit(out, "inc\thl");
    emit(out, "ld\td,(hl)");        /* D = byte 3 — DE = high half */
    if (!no_hl) {
        emit(out, "ld\tl,c");
        emit(out, "ld\th,b");       /* HL = BC = low half */
    }
    cache_dehl(vreg_id);
}

static void load_to_dehl(FILE *out, const Func *f, int vreg_id)
{
    load_to_dehl_adj(out, f, vreg_id, 0);
}

/* Store 4-byte (long) value DEHL to a vreg's frame slot. Preserves
   DEHL (the value is left in DEHL after the store). Stashes the low
   half via the stack to free HL for slot addressing; the high half
   stays in DE throughout. Clobbers BC. */
/* One-shot flag: when set, store_dehl skips the leading `ld b,h;
   ld c,l` prelude that copies HL→BC. Callers set this when they
   guarantee BC already holds the low half (B=byte1, C=byte0).
   Cleared by store_dehl after use. The fused IR_ADD/SUB fastpaths
   set BC directly during byte assembly (see `ld b,a` for byte1,
   `ld c,a` for byte0); without the flag we'd waste 4 bytes per op
   on a redundant `ld l,c; ld h,b; ld b,h; ld c,l` round trip. */
static int cur_store_dehl_bc_ready;

/* One-shot flag: when set, load_to_dehl_adj skips the trailing
   `ld l,c; ld h,b` (which restores HL = low half from BC). Callers
   set this when they don't need HL set after the load — typically
   because the next instruction overwrites HL (e.g. `pop hl`,
   `ld hl,K`). After: BC = low half, DE = high half, HL = junk. */
static int cur_load_to_dehl_no_hl;

static void store_dehl(FILE *out, const Func *f, int vreg_id)
{
    int bc_ready = cur_store_dehl_bc_ready;
    cur_store_dehl_bc_ready = 0;
    /* FP-relative long store. Preserves HL+DE entirely — no BC stash
       needed. PR_BC vregs survive across long stores when FP is on. */
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 3)) {
            emit(out, "ld\t(%s%+d),hl", frame_reg(), ix_off);
            emit(out, "ld\t(%s%+d),de", frame_reg(), ix_off + 2);
            /* DEHL cache contract: BC = low half after store_dehl.
               Subsequent load_to_dehl_adj on a cache hit recovers HL
               via `ld l,c; ld h,b` — needs BC. Skipped when bc_ready
               (caller guarantees BC=low half). */
            if (!bc_ready) {
                emit(out, "ld\tb,h");
                emit(out, "ld\tc,l");
            }
            return;
        }
    }
    int off = slot_off(f, vreg_id) + cur_sp_adjust;
    /* Stash low half (HL) into BC so HL is free for slot addressing.
       The store_dehl contract already declares BC clobbered, so this
       is the cheapest path (8 T-states for ld b,h + ld c,l versus 21
       for the equivalent push hl ... pop bc round trip). Skipped when
       bc_ready — the caller (typically a fused-byte fastpath) has
       already placed the low half in BC. Saves 2 bytes. */
    if (!bc_ready) {
        emit(out, "ld\tb,h");
        emit(out, "ld\tc,l");        /* BC = low (B=hi byte, C=lo byte) */
    }
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");         /* HL = &slot+0 */
    emit(out, "ld\t(hl),c");
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),b");
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),e");
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),d");
    /* HL now points one past slot+3 — junk. Caller wanting HL=low
       must reload via ld l,c; ld h,b before we clobber BC. For
       simplicity store_dehl leaves HL invalid; callers that need
       it cached are responsible for staging. */
}

/* The store_dehl + invalidate_hl_cache pattern at every long-result op
   site, plus the DEHL cache wire-up. After store_dehl: HL is junk; DE
   still holds high half; BC holds low half. We invalidate HL/DE/DEHL
   (HL clobbered, DE+BC tracking reset to a clean slate), then re-cache
   DEHL = vreg to let a follow-on load_to_dehl(vreg) recover via 2-inst
   `ld l,c; ld h,b`. md5 Transform's `a += ...; a = rotl(a, k); a +=
   b;` chain hits this cache on every `a` re-read. */
static void store_dehl_cached(FILE *out, const Func *f, int vreg_id)
{
    store_dehl(out, f, vreg_id);
    invalidate_hl_cache();
    cache_dehl(vreg_id);
}

/* Dead-dst long result: caller is the lowerer for IR_ADD/SUB/AND/OR/
   XOR/SHL/SHR/NEG/NOT/LNEG with cur_dst_dead set AND the immediately-
   following op known to consume dst as its first DEHL load. We skip
   the 11-instruction slot write entirely; instead just stash the low
   half into BC (it's already in HL) so the DEHL cache invariant holds
   and the next op's load_to_dehl(dst) hits via `ld l,c; ld h,b`. After:
   DE = high half (intact), HL = low half (intact), BC = low half (set),
   cache_dehl(dst). HL cache is NOT advertised — its content is half of
   a long, not an int-class value. */
static void cache_dehl_no_spill(FILE *out, int vreg_id)
{
    /* Same cur_store_dehl_bc_ready handling as store_dehl: if the
       caller has already placed the low half in BC (e.g. via the
       fused IR_ADD/SUB byte chain), skip the `ld b,h; ld c,l` that
       would otherwise re-derive it from HL (which may be junk). */
    if (!cur_store_dehl_bc_ready) {
        emit(out, "ld\tb,h");
        emit(out, "ld\tc,l");
    }
    cur_store_dehl_bc_ready = 0;
    /* HL still holds the long's low half (precondition of this
       function — caller's compute left HL = low). Advertise it via
       cur_hl_vreg so the next load_to_dehl on cache hit can skip
       its `ld l,c; ld h,b` recovery (saves 2 bytes per chained
       long-binop in MD5's `a += ...` rounds). */
    cur_hl_vreg = vreg_id;
    cur_de_vreg = -1;
    cur_dehl_vreg = vreg_id;
}

/* Forward decl: cur_dehl_dst_dead_safe lives with the other lookahead
   flags further down. lower_func sets it before each op. */
static int cur_dehl_dst_dead_safe;

/* Dispatch wrapper for the 19+ "compute long; spill to dst's slot;
   publish cache" sites in lower_op. When the lookahead in lower_func
   has determined that the slot write would be dead (cur_dehl_dst_dead
   _safe), we emit the 2-instruction `ld b,h; ld c,l + cache` shape
   instead of the full 11-instruction store_dehl. */
static void store_dehl_finalize(FILE *out, const Func *f, int vreg_id)
{
    if (cur_dehl_dst_dead_safe) cache_dehl_no_spill(out, vreg_id);
    else                        store_dehl_cached(out, f, vreg_id);
}

/* Load 16-bit value from a raw sp-relative offset into HL.
   Used by the param-init prologue to read caller-pushed args from
   above the local frame. */
static void load_sp_off_to_hl(FILE *out, int sp_off)
{
    emit(out, "ld\thl,%d", sp_off);
    emit(out, "add\thl,sp");
    emit(out, "ld\ta,(hl)");
    emit(out, "inc\thl");
    emit(out, "ld\th,(hl)");
    emit(out, "ld\tl,a");
}

/* ----- Op dispatch ------------------------------------------------------ */

/* Returns 1 if cur_hl_vreg matches `v` (and v >= 0). The caller uses
   this to skip a redundant load_to_hl. */
static int hl_has(int v)
{
    return v >= 0 && cur_hl_vreg == v;
}

static int de_has(int v)
{
    return v >= 0 && cur_de_vreg == v;
}

/* Any DE change invalidates the long-DEHL cache (DE holds the high
   half — clobbering it breaks the cache). */
static void cache_de(int v) { cur_de_vreg = v; cur_dehl_vreg = -1; }
static void invalidate_de_cache(void) { cur_de_vreg = -1; cur_dehl_vreg = -1; }

static int dehl_has(int v) { return v >= 0 && cur_dehl_vreg == v; }
static void cache_dehl(int v) { cur_dehl_vreg = v; }

/* BC cache (Phase 3, Stage 5). Tracks which vreg, if any, lives in BC
   across the function body. Unlike HL/DE/DEHL, BC is loaded once at
   the prologue (after frame alloc) for a single PARAM that ir_alloc
   marked PR_BC, and then never written by body emits — the allocator
   only marks a vreg PR_BC when the function meets a narrow safety
   envelope (no IR_CALL / IR_HCALL / width-4 vregs anywhere). In that
   envelope every body emit path preserves BC, so the cache is
   function-lifetime and never needs invalidation by ordinary ops.
   load_to_hl / load_to_de check this on each request and short-circuit
   the slot reload with `ld l,c; ld h,b` (HL) or `ld e,c; ld d,b` (DE). */
static int cur_bc_vreg;
static int bc_has(int v) { return v >= 0 && cur_bc_vreg == v; }
static void cache_bc(int v) { cur_bc_vreg = v; }
static void invalidate_bc_cache(void) { cur_bc_vreg = -1; }

/* Byte (A) value cache. Tracks which width-1 vreg the accumulator
   currently holds. Set by IR_LD_MEM_VREG width=1 when the byte spill
   is dead-skipped (the byte stays in A). Consumed by the CONV_ZX /
   CONV_SX / CONV_BYTE_TO_HIGH 1→2 lowerers — they skip the
   `load_byte_to_a` slot read when A already has src[0]. Heavily
   invalidated: every `ld a,*` clobbers it, every byte op clobbers it.
   Most lowerer paths conservatively invalidate via invalidate_hl_cache
   (which now also clears A). */
static int cur_a_vreg;
static int a_has(int v) { return v >= 0 && cur_a_vreg == v; }
static void cache_a(int v) { cur_a_vreg = v; }
static void invalidate_a_cache(void) { cur_a_vreg = -1; }

/* Load src[0]→HL and src[1]→DE in the order that doesn't clobber HL.
   Caller can then emit a binary op on HL,DE.

   Four cases:
   1. src[1] == -1: literal-fold — RHS is op->imm. Emit `ld de, K`
      (no slot load, doesn't touch HL). Load src[0] to HL if needed.
   2. cache hit on src[0]: use preserve-HL load for src[1]'s slot.
   3. cache hit on src[1] (and not src[0]): swap into DE with `ex de,hl`
      (1 instr) then frame-load src[0] into HL. Saves the 6-instruction
      frame load that load_to_de would have done. Common case: a
      previous binop's result (in HL via cache) becomes the RHS of the
      next binop — e.g. `crc ^= shifted` where `shifted` was just
      computed.
   4. default: load_to_de(src[1]) (clobbers HL), then load_to_hl(src[0]).
*/
static void load_binop_operands(FILE *out, const Func *f, const Op *op)
{
    if (op->src[1] < 0) {
        /* Literal RHS — emit directly. Doesn't touch HL. */
        if (!hl_has(op->src[0])) load_to_hl(out, f, op->src[0]);
        emit(out, "ld\tde,%lld", (long long)op->imm);
        invalidate_de_cache();
        return;
    }
    if (hl_has(op->src[0])) {
        /* HL still holds src[0] from the previous op. Preserve it. */
        load_to_de_preserve_hl(out, f, op->src[1]);
        cache_de(op->src[1]);
        return;
    }
    if (hl_has(op->src[1])) {
        /* HL holds src[1] (the would-be DE-operand). Swap into DE.
           Cache: HL ↔ DE swap. After: DE has src[1], HL has whatever
           DE held — invalidate HL since the caller wants src[0] there. */
        emit(out, "ex\tde,hl");
        int t = cur_hl_vreg; cur_hl_vreg = cur_de_vreg; cur_de_vreg = t;
        load_to_hl(out, f, op->src[0]);
        return;
    }
    if (de_has(op->src[1])) {
        /* DE-cache hit: just load src[0] into HL. */
        load_to_hl(out, f, op->src[0]);
        return;
    }
    if (de_has(op->src[0])) {
        /* DE has src[0] but we want it in HL. ex de,hl moves it; then
           we need src[1] loaded into DE. After ex de,hl: HL has src[0]
           (good), DE has whatever HL had (junk, but we're about to
           overwrite). load_to_de uses HL as scratch — will clobber HL.
           So we need to preserve HL via the push/pop variant. */
        emit(out, "ex\tde,hl");
        int t = cur_hl_vreg; cur_hl_vreg = cur_de_vreg; cur_de_vreg = t;
        load_to_de_preserve_hl(out, f, op->src[1]);
        cache_de(op->src[1]);
        return;
    }
    load_to_de(out, f, op->src[1]);  /* DE = src[1]; trashes HL */
    cache_de(op->src[1]);
    load_to_hl(out, f, op->src[0]);  /* HL = src[0]; preserves DE */
}

/* Call after an op that defines a vreg and leaves the value in HL.
   The next op can use the cache if its src[0] matches. */
static void cache_hl(int vreg)
{
    cur_hl_vreg = vreg;
}

/* Invalidate the HL cache. Use before/after any op that clobbers HL
   in a way the cache can't reason about: calls, ret, branches, the
   variable shift loop, indirect mem loads through HL, etc.

   Also invalidates the DE cache by default — almost every HL-
   invalidating emit also writes DE (long arith stages through DE,
   literal-fold's `ld de,K`, calls clobber both). Specific sites
   that *do* preserve DE (CMP fastpaths, etc.) save+restore
   cur_de_vreg around this call. */
static void invalidate_hl_cache(void)
{
    cur_hl_vreg = -1;
    cur_de_vreg = -1;
    cur_dehl_vreg = -1;
    cur_a_vreg = -1;
}

/* Dead-store elimination: set per-op by lower_func before calling
   lower_op. When 1, the dst's value won't be re-read from its frame
   slot (no live-out, no later in-BB use), so the spill can be skipped.
   The cache_hl flag is still set so adjacent cache-served reads work,
   though if dst really has no users that doesn't matter. */
static int cur_dst_dead;

/* cur_dehl_dst_dead_safe forward-declared earlier (used by
   store_dehl_finalize); the actual definition lives there. Documented
   here near cur_dst_dead because it's the same family of lookahead
   state set per-op by lower_func.

   Stronger variant for width-4 dsts: cur_dst_dead is true AND the very
   next op's emit pattern is known to load dst via load_to_dehl as its
   first DEHL-touching step, with no prior load_to_dehl(other_vreg)
   that would reset the DEHL cache before the dst hit. The long-binop
   lowerer uses this to skip store_dehl entirely and just publish the
   DEHL cache (DE=high, BC=low, cache_dehl(dst)) — saves ~11 inst per
   dead-dst long result. */

/* If the op being lowered has its dst consumed by an immediately-
   following IR_BR_ZERO or IR_BR_COND in the same BB (and dst is
   dead-after-branch), `cur_branch_test_kind` is set to the branch
   op kind and `cur_branch_test_label` to its target. When the lowerer
   fastpaths the combined op, it sets `cur_skip_next_op = 1` so the
   dispatcher skips the now-consumed branch. */
static int cur_branch_test_kind;   /* 0 = none, IR_BR_ZERO, or IR_BR_COND */
static int cur_branch_test_label;
static int cur_skip_next_op;

/* Phase D — RPN-style long stack preservation. The Z80 data stack acts
   as an operand stack, DEHL is the implicit top register. When a long
   value's live range crosses DEHL-clobbering ops, ir_opt inserts
   IR_PUSH_DEHL_LONG / IR_POP_DEHL_LONG markers — the lowerer emits the
   actual `push de; push hl` / `pop hl; pop de` pairs and tracks the
   running stack depth via cur_sp_adjust (defined earlier near the
   forward decls so the slot-read wrappers can see it).

   cur_sp_adjust accumulates the byte delta from outstanding pushes
   (each long push = +4). All sp-relative slot reads/stores between a
   push and its matching pop add cur_sp_adjust to their slot offsets so
   they continue addressing the right frame slot. Reset to 0 at every
   BB boundary (with an assertion: stack should rebalance per BB).

   Stack-consuming helpers — the sccz80 `l_long_or` / `l_long_add`
   family that pops its secondary operand off the stack — pair with
   an outstanding push WITHOUT a separate IR_POP_DEHL_LONG: the call
   itself consumes the 4 bytes. The IR_HCALL lowerer notes
   stack-consuming helpers (via a HelperInfo flag) and decrements
   cur_sp_adjust on emit. */

/* Predicate consulted by the spill_*_unless_dead helpers below. Returns
   1 iff the allocator has assigned `v` to a real phys register pool
   that the lowerer will read from directly — no frame slot will ever
   be touched for this vreg. Stage 3 populates IR_PR_HL; Stage 4 adds
   IR_PR_DE; Stage 5 adds IR_PR_BC; Stage 6 adds IR_PR_DEHL. */
static int vreg_in_register_pool(const Func *f, int v)
{
    if (v < 0 || !f || !f->vreg_to_phys) return 0;
    PhysReg pr = f->vreg_to_phys[v];
    return pr == IR_PR_HL || pr == IR_PR_DE
        || pr == IR_PR_BC || pr == IR_PR_DEHL;
}

/* True if vreg `v` is allocator-pinned to DE (Stage 4 PR_DE pool).
   Binop / computed-producer sites read this to redirect the final
   write into D/E instead of H/L, then publish via cache_de(v). */
static int vreg_is_pr_de(const Func *f, int v)
{
    return v >= 0 && f && f->vreg_to_phys
        && f->vreg_to_phys[v] == IR_PR_DE;
}

/* Skip store_hl + the trailing `ex de,hl` (swap value back from DE
   to HL after spill) when the dst is dead. Used by the binop / LD_IMM
   pattern: `<compute leaves value in HL>; store_hl; ex de,hl; cache_hl`.
   On dead-dst we emit nothing and HL already holds the value.

   Non-dead path: the two `ex de,hl` operations (one inside store_hl,
   one trailing) end with DE = junk (final ex puts old-DE into HL and
   the previous mem addr into DE). DE cache is invalidated. Dead path:
   DE was preserved through the binop's `add hl,de` etc, so cache
   survives.

   The skip also fires for statically-pooled vregs (allocator-assigned
   PR_HL/PR_DE/PR_BC/PR_DEHL) — for Stage 3 this is exactly the
   cur_dst_dead set, so adding the gate is a no-op. Future stages
   widen the static set, which is where the perf wins come from. */
static void spill_and_swap_unless_dead(FILE *out, const Func *f, int vreg)
{
    if (cur_dst_dead) return;
    /* Statically-pooled vreg: value lives in a phys register, not a
       slot. For PR_HL the caller's `cache_hl(dst)` makes HL the home.
       For PR_BC LOCAL (#318), we still have to copy HL→BC so the BC
       cache reflects the value — subsequent reads via load_to_hl/de
       hit the BC short-circuit. The narrow-no-call envelope means
       nothing else clobbers BC. */
    if (vreg_in_register_pool(f, vreg)) {
        if (f->vreg_to_phys[vreg] == IR_PR_BC) {
            emit(out, "ld\tc,l");
            emit(out, "ld\tb,h");
            cache_bc(vreg);
        }
        return;
    }
    store_hl(out, f, vreg);
    emit(out, "ex\tde,hl");
    invalidate_de_cache();
}

/* DE-staged spill: value is already in DE, write it to vreg's frame
   slot and leave HL holding the value (via ex de,hl). Used by the
   IR_LD_IMM `ld de,K` fastpath: skips the initial `ex de,hl` in
   store_hl by staging the value directly in DE up front, saving 1
   byte / 4 T-states vs `ld hl,K + store_hl + ex de,hl`. */
static void spill_de_unless_dead(FILE *out, const Func *f, int vreg)
{
    if (cur_dst_dead || vreg_in_register_pool(f, vreg)) {
        emit(out, "ex\tde,hl");
        invalidate_de_cache();
        return;
    }
    int off = slot_off(f, vreg);
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e");
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),d");
    emit(out, "ex\tde,hl");
    invalidate_de_cache();
}

/* Skip store_hl only — for ops that leave the value in HL and don't
   need a swap-back. The caller is responsible for the cache_hl(dst)
   advertisement (the dead-dst cache check on op[i+1] needs it). */
static void spill_unless_dead(FILE *out, const Func *f, int vreg)
{
    if (cur_dst_dead || vreg_in_register_pool(f, vreg)) return;
    store_hl(out, f, vreg);
    /* store_hl's internal `ex de,hl` puts the spilled value into DE
       (then walks HL through memory). DE now has dst's value; the
       caller advertises that via cache_de if it cares. Conservatively
       invalidate — most callers don't care, and a stale cache here
       would mismatch the slot. */
    invalidate_de_cache();
}


/* Materialise carry flag to HL = 0 or 1. `polarity_nc` chooses whether
   HL=1 means carry-clear (true) or carry-set (true). After this, HL is
   the boolean result. */
static void carry_to_bool(FILE *out, int hl_one_when_carry)
{
    emit(out, "ld\thl,0");
    emit(out, "jr\t%s,ASMPC+3",
         hl_one_when_carry ? "nc" : "c");
    emit(out, "inc\tl");
}

/* After `sbc hl,de` for a signed compare: HL holds (src0-src1) and
   bit 7 of H plus the V flag together encode the signed-ordered result.
   This helper rotates the *correct* sign bit into the carry flag so
   carry_to_bool() can materialise 0/1.
   Pattern: PO (no overflow) → sign bit of H is correct.
            PE (overflow) → sign bit of H is inverted; XOR 0x80.
   Then RLA moves bit 7 into CF. */
static void signed_result_to_carry(FILE *out)
{
    int n = cmp_label_counter++;
    emit(out, "ld\ta,h");
    emit(out, "jp\tpo,L_f%d_cmp_ok_%d", func_emit_idx, n);
    emit(out, "xor\t0x80");
    fprintf(out, "L_f%d_cmp_ok_%d:\n", func_emit_idx, n);
    emit(out, "rla");           /* CF = bit 7 of A (correct sign bit) */
    /* CF=1 means src0-src1 < 0 (signed) → src0 < src1. */
}

static int lower_op(FILE *out, Func *f, const Op *op)
{
    switch (op->kind) {

    case IR_NOP:
        return 0;

    case IR_LD_IMM: {
        int dst_w = (op->dst >= 0) ? f->vregs[op->dst].width : 2;
        if (dst_w == 4) {
            /* Long literal: load DEHL = K, then spill 4 bytes. */
            uint32_t k = (uint32_t)op->imm;
            emit(out, "ld\thl,%u", (unsigned)(k & 0xffff));
            emit(out, "ld\tde,%u", (unsigned)((k >> 16) & 0xffff));
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* PR_DE dst (Stage 4): value lives in DE for its single
           use as the next op's src[1]. Emit `ld de,K` directly —
           no HL detour, no spill, no swap. The consumer's
           load_binop_operands case 4 (de_has src[1]) hits cleanly. */
        if (op->dst >= 0 && f->vreg_to_phys
            && f->vreg_to_phys[op->dst] == IR_PR_DE) {
            emit(out, "ld\tde,%lld", (long long)op->imm);
            cache_de(op->dst);
            return 0;
        }
        /* Stage in DE when we're going to spill: skips the initial
           `ex de,hl` of store_hl. On dead-dst, falls back to the
           plain HL load (we need HL=K for any cache-served consumer). */
        if (cur_dst_dead) {
            emit(out, "ld\thl,%lld", (long long)op->imm);
        } else {
            emit(out, "ld\tde,%lld", (long long)op->imm);
            spill_de_unless_dead(out, f, op->dst);
        }
        cache_hl(op->dst);
        return 0;
    }

    case IR_LD_SYM:
        /* dst ← &sym + offset. Address-of: just an immediate-load. */
        if (op->mem.sym == NULL) {
            fputs("ir_lower: IR_LD_SYM with NULL sym\n", stderr);
            return -1;
        }
        if (op->mem.offset)
            emit(out, "ld\thl,_%s+%d", ir_sym_name(op->mem.sym), op->mem.offset);
        else
            emit(out, "ld\thl,_%s", ir_sym_name(op->mem.sym));
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    case IR_LD_STR:
        /* dst ← &literal_queue + imm. The per-TU label `i_<litlab>` is
           the start of the queue; `op->imm` is the byte offset of the
           string within it. */
        emit(out, "ld\thl,i_%d+%lld", litlab, (long long)op->imm);
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    case IR_LEA:
        /* dst ← address of src[0]'s frame slot. With FP active and the
           offset fitting, emit `lea hl,ix+d` on ez80 (3 bytes) or the
           `push ix; pop hl; ld de,d; add hl,de` chain elsewhere — but
           the simplest universal sp-relative `ld hl,N; add hl,sp` works
           everywhere and the FP teardown computes IX-relative naturally
           via slot_off (FP-aware when fp_active). */
        if (op->src[0] < 0) {
            fputs("ir_lower: IR_LEA with no src\n", stderr);
            return -1;
        }
        emit(out, "ld\thl,%d", slot_off(f, op->src[0]));
        emit(out, "add\thl,sp");
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    case IR_LD_MEM:
        if (op->mem.kind == IR_MEM_SYM) {
            int dst_w = (op->dst >= 0)
                      ? f->vregs[op->dst].width : 2;
            if (getenv("IR_LDMEM_TRACE"))
                fprintf(stderr, "LD_MEM SYM dst=v%d width=%d\n",
                        op->dst, dst_w);
            if (dst_w == 4) {
                /* Long load from a global. Mirror of the long-store
                   path: `ld hl,(_sym)` for the low half, `ld de,(_sym+2)`
                   for the high half. Without this, long globals are
                   silently truncated to int on read — the matching
                   bug to the long-store path. */
                int off = op->mem.offset;
                if (off)
                    emit(out, "ld\thl,(_%s+%d)",
                         ir_sym_name(op->mem.sym), off);
                else
                    emit(out, "ld\thl,(_%s)", ir_sym_name(op->mem.sym));
                emit(out, "ld\tde,(_%s+%d)",
                     ir_sym_name(op->mem.sym), off + 2);
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            if (dst_w == 1) {
                /* Byte load from a global. Zero-extends to int in HL
                   so subsequent int-context users see a well-formed
                   value (matches sccz80's `ld a,(sym); ld l,a; ld h,0`). */
                if (op->mem.offset)
                    emit(out, "ld\ta,(_%s+%d)",
                         ir_sym_name(op->mem.sym), op->mem.offset);
                else
                    emit(out, "ld\ta,(_%s)", ir_sym_name(op->mem.sym));
                emit(out, "ld\tl,a");
                emit(out, "ld\th,0");
                spill_and_swap_unless_dead(out, f, op->dst);
                cache_hl(op->dst);
                return 0;
            }
            /* PR_DE dst (Stage 4): load directly into DE, no spill.
               `ld de,(nn)` is 20 T-states (vs 16 for `ld hl,(nn)`),
               but skipping the 51-T store_hl is a clear net win when
               the value's only consumer reads it via the DE cache. */
            if (op->dst >= 0 && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_DE) {
                if (op->mem.offset)
                    emit(out, "ld\tde,(_%s+%d)",
                         ir_sym_name(op->mem.sym), op->mem.offset);
                else
                    emit(out, "ld\tde,(_%s)", ir_sym_name(op->mem.sym));
                cache_de(op->dst);
                return 0;
            }
            if (op->mem.offset)
                emit(out, "ld\thl,(_%s+%d)",
                     ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\thl,(_%s)", ir_sym_name(op->mem.sym));
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        if (op->mem.kind == IR_MEM_VREG) {
            /* Fused (long)*p++ fastpath (#334): when the load is a
               byte-to-long zero-extend with a post-inc on the base
               pointer (and we have an sp-rel local for p), emit the
               walker-style in-place increment using `inc (hl)` on the
               pointer's slot. Skips the 3-op sequence's byte spill +
               reload across IR_INC, and avoids loading p into HL
               twice. Hot pattern in crcbench's crc32. */
            /* post_step is only set by the OP_CAST char→long fastpath in
               ir_build.c, so dst_w==4 + post_step!=0 implies the byte
               load is going to a long zero-extend. No need to compare
               op->mem.elem against KIND_CHAR (which would require
               including define.h for the enum). */
            int _dst_w = f->vregs[op->dst].width;
            /* Fastpath needs the pointer addressable via sp+K — i.e.,
               not in a register pool like PR_BC (where there's no
               memory slot to inc). PARAM_RO ("PARAM_IN_PLACE") is OK:
               slot_off() returns the caller's pushed-arg offset for
               those vregs. */
            if (_dst_w == 4
                && op->mem.post_step == 1
                && op->mem.base >= 0
                && !vreg_in_pr_bc(f, op->mem.base)) {
                /* sp-relative byte-walk works in FP mode too — sp is
                   still valid, cur_sp_adjust tracks pushes. The
                   `ld hl,N; add hl,sp; inc (hl)` sequence is the
                   same; only the value of `N` differs (sp vs ix
                   offset to the same memory location). */
                int p_off = slot_off(f, op->mem.base);
                emit(out, "ld\thl,%d", p_off);
                emit(out, "add\thl,sp");          /* HL = &p */
                emit(out, "inc\t(hl)");            /* ++p.byte0 */
                emit(out, "ld\ta,(hl)");            /* A = new byte0 */
                emit(out, "inc\thl");              /* HL = &p.byte1 */
                emit(out, "jr\tnz,ASMPC+3");       /* no carry → skip */
                emit(out, "inc\t(hl)");            /* propagate carry */
                emit(out, "ld\th,(hl)");            /* H = new byte1 */
                emit(out, "ld\tl,a");               /* HL = new p */
                emit(out, "dec\thl");               /* HL = old p */
                emit(out, "ld\tl,(hl)");            /* L = *old_p */
                emit(out, "ld\th,0");
                emit(out, "ld\te,h");
                emit(out, "ld\td,e");               /* DEHL = (long)*old_p */
                /* p's value changed (now p+1); invalidate any cached
                   claim on p_vreg. HL holds (0, byte), not a vreg. */
                invalidate_hl_cache();
                invalidate_bc_cache();
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* Indirect: base vreg holds the address; load through it.
               Cache-aware: if HL already holds the base, skip the load.
               Common after a post-inc save (`old = data`, then deref). */
            if (!hl_has(op->mem.base))
                load_to_hl(out, f, op->mem.base);
            int dst_w = f->vregs[op->dst].width;
            if (op->mem.offset) {
                /* For width 4 we can't clobber DE here (DE is needed
                   for the high half); use BC instead. For widths 1/2
                   DE is free and we keep the existing sequence. */
                if (dst_w == 4) {
                    emit(out, "ld\tbc,%d", op->mem.offset);
                    emit(out, "add\thl,bc");
                } else {
                    emit(out, "ld\tde,%d", op->mem.offset);
                    emit(out, "add\thl,de");
                }
            }
            if (dst_w == 1) {
                /* Byte load into A. If dst is dead-after-next (the
                   common `b = *p; foo((int)b)` shape via CONV), keep
                   the byte in A and let the CONV's load_byte_to_a
                   become a cache hit. cache_a is set; invalidate
                   HL/DE since the address load clobbered them. */
                emit(out, "ld\ta,(hl)");
                invalidate_hl_cache();
                if (cur_dst_dead || vreg_in_register_pool(f, op->dst)) {
                    cache_a(op->dst);
                } else {
                    store_a_byte(out, f, op->dst);
                }
            } else if (dst_w == 4) {
                /* Long load: 4 bytes from (hl) into DEHL. */
                emit(out, "ld\te,(hl)");        /* E = byte 0 */
                emit(out, "inc\thl");
                emit(out, "ld\td,(hl)");        /* D = byte 1 */
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)");        /* A = byte 2 */
                emit(out, "inc\thl");
                emit(out, "ld\th,(hl)");        /* H = byte 3 */
                emit(out, "ld\tl,a");           /* HL = bytes 2,3 = HIGH */
                emit(out, "ex\tde,hl");         /* DEHL: DE=HIGH, HL=LOW */
                store_dehl_finalize(out, f, op->dst);
            } else {
                /* PR_DE dst (Stage 4): load directly into DE, no spill.
                   Same byte sequence as the HL path but writes E/D
                   instead of L/H. HL becomes scratch (slot+1, no
                   tracked vreg). */
                if (op->dst >= 0 && f->vreg_to_phys
                    && f->vreg_to_phys[op->dst] == IR_PR_DE) {
                    emit(out, "ld\ta,(hl)");
                    emit(out, "inc\thl");
                    emit(out, "ld\td,(hl)");
                    emit(out, "ld\te,a");
                    invalidate_hl_cache();
                    cache_de(op->dst);
                    return 0;
                }
                emit(out, "ld\ta,(hl)");
                emit(out, "inc\thl");
                emit(out, "ld\th,(hl)");
                emit(out, "ld\tl,a");
                /* HL holds loaded value. Use spill_and_swap_unless_dead
                   to optionally skip the frame write. */
                spill_and_swap_unless_dead(out, f, op->dst);
                cache_hl(op->dst);
            }
            return 0;
        }
        fprintf(stderr, "ir_lower: IR_LD_MEM kind %d not yet supported\n",
                (int)op->mem.kind);
        return -1;

    case IR_ST_MEM:
        if (op->mem.kind == IR_MEM_SYM) {
            int src_w = (op->src[0] >= 0)
                      ? f->vregs[op->src[0]].width : 2;
            if (src_w == 4) {
                /* Long store to a global. `ld (_sym),hl` writes the
                   low half; `ld (_sym+2),de` writes the high half.
                   Without the high-half write, long-typed globals get
                   silently truncated to int — the bug that turned
                   `g = shr1(0xffffffaa)` into g = 0x0000ffd5 and made
                   crcbench's XOR-chain end at the wrong digest. */
                load_to_dehl(out, f, op->src[0]);
                int off = op->mem.offset;
                if (off)
                    emit(out, "ld\t(_%s+%d),hl",
                         ir_sym_name(op->mem.sym), off);
                else
                    emit(out, "ld\t(_%s),hl", ir_sym_name(op->mem.sym));
                emit(out, "ld\t(_%s+%d),de",
                     ir_sym_name(op->mem.sym), off + 2);
                return 0;
            }
            if (src_w == 1) {
                /* Byte store to a global. `ld a,r; ld (sym),a`. */
                load_byte_to_a(out, f, op->src[0]);
                if (op->mem.offset)
                    emit(out, "ld\t(_%s+%d),a",
                         ir_sym_name(op->mem.sym), op->mem.offset);
                else
                    emit(out, "ld\t(_%s),a", ir_sym_name(op->mem.sym));
                return 0;
            }
            load_to_hl(out, f, op->src[0]);
            if (op->mem.offset)
                emit(out, "ld\t(_%s+%d),hl",
                     ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\t(_%s),hl", ir_sym_name(op->mem.sym));
            return 0;
        }
        if (op->mem.kind == IR_MEM_VREG) {
            /* Indirect store: load value (DE), load address (HL), store. */
            int src_w = f->vregs[op->src[0]].width;
            if (src_w == 1) {
                load_byte_to_a(out, f, op->src[0]);
                emit(out, "ld\te,a");           /* stash byte across HL load */
                load_to_hl(out, f, op->mem.base);
                if (op->mem.offset) {
                    emit(out, "ld\tbc,%d", op->mem.offset);
                    emit(out, "add\thl,bc");
                }
                emit(out, "ld\t(hl),e");
            } else if (src_w == 4) {
                /* Long indirect store. Stage value on the stack so we
                   can free DEHL to compute the address. sp shifts by 4
                   after the two pushes — load_to_hl_adj compensates the
                   mem.base slot offset. */
                load_to_dehl(out, f, op->src[0]);
                emit(out, "push\tde");          /* save HIGH half */
                emit(out, "push\thl");          /* save LOW half */
                load_to_hl_adj(out, f, op->mem.base, 4);
                if (op->mem.offset) {
                    emit(out, "ld\tbc,%d", op->mem.offset);
                    emit(out, "add\thl,bc");
                }
                emit(out, "pop\tbc");           /* BC = LOW (C=byte0, B=byte1) */
                emit(out, "ld\t(hl),c");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),b");
                emit(out, "inc\thl");
                emit(out, "pop\tbc");           /* BC = HIGH (C=byte2, B=byte3) */
                emit(out, "ld\t(hl),c");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),b");
                invalidate_hl_cache();
            } else {
                load_to_hl(out, f, op->src[0]);
                emit(out, "ex\tde,hl");         /* DE = value */
                load_to_hl(out, f, op->mem.base);
                if (op->mem.offset) {
                    emit(out, "ld\tbc,%d", op->mem.offset);
                    emit(out, "add\thl,bc");
                }
                emit(out, "ld\t(hl),e");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),d");
            }
            return 0;
        }
        fprintf(stderr, "ir_lower: IR_ST_MEM kind %d not yet supported\n",
                (int)op->mem.kind);
        return -1;

    case IR_MOV: {
        int dst_w = (op->dst >= 0) ? f->vregs[op->dst].width : 2;
        if (dst_w == 4) {
            /* Long slot-to-slot copy. load_to_dehl always leaves BC =
               src low half (both the byte-walk path explicitly via
               `ld c,(hl); inc hl; ld b,(hl); ...` and the synthetic
               FP path via the trailing `ld b,h; ld c,l`). So BC is
               already correct for store_dehl's cache invariant —
               skip its prelude. */
            load_to_dehl(out, f, op->src[0]);
            cur_store_dehl_bc_ready = 1;
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* PR_DE dst: route src into DE directly. load_to_de handles
           the cache-hit / ex-de-hl / frame-load cases internally. */
        if (vreg_is_pr_de(f, op->dst)) {
            load_to_de(out, f, op->src[0]);
            cache_de(op->dst);
            return 0;
        }
        /* Cache-aware: if src is already in HL, skip the load. */
        if (cur_hl_vreg != op->src[0] || cur_hl_vreg < 0)
            load_to_hl(out, f, op->src[0]);
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }

    case IR_ADD:
        if (op->dst >= 0 && f->vregs[op->dst].width == 4
            && vreg_kind_is_integer(f, op->dst)) {
            /* Long add. Operand b pushed (HIGH then LOW), then DEHL = a.
               Inline the helper body directly — calling l_long_add would
               clobber IX (helper uses `pop ix` to stash retaddr), which
               breaks frame-pointer mode. */
            if (op->src[1] == -1) {
                /* In-place const ADD on sp-rel slot (#338). When
                   dst == src[0] and the vreg lives in a stack slot,
                   add K's bytes directly into the slot through A
                   instead of going DEHL-load → const ADD → store.
                   Saves the full load+store roundtrip (~18 inst /
                   ~120T) — replaces 32 inst with 14. Gated off when
                   the result is dead. sp-rel byte-walk works in FP
                   mode too (sp valid + cur_sp_adjust tracks pushes). */
                uint32_t k = (uint32_t)op->imm;
                if (op->dst == op->src[0]
                    && !cur_dst_dead
                    && !vreg_in_pr_bc(f, op->dst)
                    && f->vreg_to_phys
                    && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
                    int off = slot_off(f, op->dst);
                    uint8_t k0 = (uint8_t)(k & 0xff);
                    uint8_t k1 = (uint8_t)((k >> 8) & 0xff);
                    uint8_t k2 = (uint8_t)((k >> 16) & 0xff);
                    uint8_t k3 = (uint8_t)((k >> 24) & 0xff);
                    emit(out, "ld\thl,%d", off);
                    emit(out, "add\thl,sp");        /* HL = &slot */
                    emit(out, "ld\ta,(hl)");
                    emit(out, "add\ta,%u", (unsigned)k0);
                    emit(out, "ld\t(hl),a");
                    emit(out, "inc\thl");
                    emit(out, "ld\ta,(hl)");
                    emit(out, "adc\ta,%u", (unsigned)k1);
                    emit(out, "ld\t(hl),a");
                    emit(out, "inc\thl");
                    emit(out, "ld\ta,(hl)");
                    emit(out, "adc\ta,%u", (unsigned)k2);
                    emit(out, "ld\t(hl),a");
                    emit(out, "inc\thl");
                    emit(out, "ld\ta,(hl)");
                    emit(out, "adc\ta,%u", (unsigned)k3);
                    emit(out, "ld\t(hl),a");
                    /* The slot is now current; DEHL/BC don't hold the
                       new value. Invalidate caches so the next op
                       reloads from slot if it needs the value. */
                    invalidate_hl_cache();
                    invalidate_bc_cache();
                    return 0;
                }
                /* Const-RHS: skip the push/pop dance. Load LHS into
                   DEHL, then materialise each constant half directly
                   into BC at the use site. Saves 4 inst + 42T per
                   long const-ADD vs the push/pop form. */
                load_to_dehl(out, f, op->src[0]);
                /* DEHL = LHS (D=HI hi byte, E=HI lo byte, H=LO hi byte,
                   L=LO lo byte). BC currently holds LHS low half (cache
                   invariant) — about to be overwritten. */
                emit(out, "ld\tbc,%u", (unsigned)(k & 0xffff));
                emit(out, "add\thl,bc");                /* HL = LHS_LOW + K_LOW */
                emit(out, "ex\tde,hl");                 /* DE = result LOW, HL = LHS_HIGH */
                emit(out, "ld\tbc,%u",
                     (unsigned)((k >> 16) & 0xffff));
                emit(out, "adc\thl,bc");                /* HL = LHS_HIGH + K_HIGH + C */
                emit(out, "ex\tde,hl");                 /* DEHL = result */
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* Phase D option B — one operand is on top of the data
               stack from an earlier IR_PUSH_DEHL_LONG. Read its bytes
               directly via (hl) while adding into the other operand
               popped from our save. ADD is commutative so either src
               position works; carry chains naturally through the four
               byte steps because pop / inc hl / ld / ld don't touch
               flags. */
            {
            int optb_dehl_src = -1;
            if (cur_stack_long_top >= 0 && !fp_active(f)) {
                if (cur_stack_long_top == op->src[0]
                    && op->src[1] != cur_stack_long_top)
                    optb_dehl_src = op->src[1];
                else if (cur_stack_long_top == op->src[1]
                    && op->src[0] != cur_stack_long_top)
                    optb_dehl_src = op->src[0];
            }
            if (optb_dehl_src >= 0) {
                load_to_dehl_adj(out, f, optb_dehl_src, 0);
                emit(out, "push\tde");           /* save src[1] high */
                emit(out, "push\thl");           /* save src[1] low */
                cur_sp_adjust += 4;
                emit(out, "ld\thl,4");
                emit(out, "add\thl,sp");          /* HL → src[0].b0 */
                emit(out, "pop\tbc");             /* C=s1.b0, B=s1.b1 */
                cur_sp_adjust -= 2;
                emit(out, "ld\ta,c");
                emit(out, "add\ta,(hl)");
                emit(out, "ld\tc,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,b");
                emit(out, "adc\ta,(hl)");
                emit(out, "ld\tb,a");
                emit(out, "inc\thl");
                emit(out, "pop\tde");             /* E=s1.b2, D=s1.b3 */
                cur_sp_adjust -= 2;
                emit(out, "ld\ta,e");
                emit(out, "adc\ta,(hl)");
                emit(out, "ld\te,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,d");
                emit(out, "adc\ta,(hl)");
                emit(out, "ld\td,a");
                emit(out, "ld\tl,c");             /* HL = result low */
                emit(out, "ld\th,b");
                /* Drop the Phase D frame. */
                emit(out, "pop\tbc");
                emit(out, "pop\tbc");
                cur_sp_adjust -= 4;
                cur_stack_long_top = -1;
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            }
            /* FP-mode byte-direct long ADD fastpath. ADD is
               commutative so either src can come from the DEHL cache
               (BC=low, DE=high) and the other from (ix+d). Mirror of
               the AND/OR/XOR fastpath but with add/adc carry chain.
               ld a,(...) and ld <reg>,a are flag-preserving, so the
               carry chain survives across each byte. */
            if (fp_active(f)
                && op->src[0] >= 0 && op->src[1] >= 0
                && op->dst >= 0) {
                int from_dehl = -1, from_slot = -1;
                if (dehl_has(op->src[0]) && !dehl_has(op->src[1])) {
                    from_dehl = op->src[0]; from_slot = op->src[1];
                } else if (dehl_has(op->src[1])
                           && !dehl_has(op->src[0])) {
                    from_dehl = op->src[1]; from_slot = op->src[0];
                } else if (!dehl_has(op->src[0])
                           && !dehl_has(op->src[1])) {
                    from_slot = op->src[1];
                }
                if (from_slot >= 0) {
                    int s1 = slot_ix_off(f, from_slot);
                    int s0 = (from_dehl < 0)
                           ? slot_ix_off(f, op->src[0]) : 0;
                    int dd = cur_dst_dead
                           ? 0 : slot_ix_off(f, op->dst);
                    int srcs_ok = fp_offset_fits(s1)
                               && fp_offset_fits(s1 + 3)
                               && (from_dehl >= 0
                                   || (fp_offset_fits(s0)
                                       && fp_offset_fits(s0 + 3)));
                    int dst_ok = cur_dst_dead
                        ? 1
                        : (fp_offset_fits(dd)
                           && fp_offset_fits(dd + 3));
                    if (srcs_ok && dst_ok) {
                        static const char *dehl_byte[4] =
                            { "c", "b", "e", "d" };
                        for (int i = 0; i < 4; i++) {
                            if (from_dehl >= 0)
                                emit(out, "ld\ta,%s",
                                     dehl_byte[i]);
                            else
                                emit(out, "ld\ta,(%s%+d)",
                                     frame_reg(), s0 + i);
                            emit(out, "%s\ta,(%s%+d)",
                                 i == 0 ? "add" : "adc",
                                 frame_reg(), s1 + i);
                            if (cur_dst_dead)
                                emit(out, "ld\t%s,a",
                                     dehl_byte[i]);
                            else
                                emit(out, "ld\t(%s%+d),a",
                                     frame_reg(), dd + i);
                        }
                        if (cur_dst_dead) {
                            /* Skip eager `ld l,c; ld h,b` — DEHL cache
                               invariant is BC=low + DE=high + (HL may
                               or may not have low). Downstream
                               load_to_dehl on cache hit emits the
                               recover itself; downstream byte-direct
                               or byte-A ops never need HL. Saves 2B
                               per dead-dst byte-direct binop. */
                            cur_hl_vreg = -1;
                            cur_de_vreg = -1;
                            cur_dehl_vreg = op->dst;
                        } else {
                            invalidate_hl_cache();
                            invalidate_bc_cache();
                        }
                        return 0;
                    }
                }
            }
            /* Fused load+add fastpath (#335): instead of loading RHS
               into DEHL then add/adc through 16-bit add hl,bc, point
               HL at the RHS slot and do `add (hl)`/`adc (hl)` directly
               with LHS bytes read out of D/E (HIGH) and B/C (LOW —
               mirrors HL via the DEHL cache invariant). Skips the
               11-inst RHS load + cache stash, the push/pop dance for
               LHS, and the 4×inc-hl reload. Only fires when RHS is
               sp-rel (FP-mode would need extra ops to compute HL from
               IX) and isn't already in the DEHL cache.

               When src[0] IS cached in DEHL, skip load_to_dehl's
               2-byte HL recovery (`ld l,c; ld h,b`) — we don't read HL
               here, we just overwrite it with the RHS slot address.
               BC and DE are already correct by the cache invariant. */
            if (!fp_active(f) && !dehl_has(op->src[1])) {
                if (!dehl_has(op->src[0]))
                    load_to_dehl(out, f, op->src[0]);
                /* DEHL = LHS, BC mirrors HL = LHS_LOW (B=b1, C=b0). */
                int off = slot_off(f, op->src[1]) + cur_sp_adjust;
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");        /* HL = &RHS, BC keeps LHS_LOW */
                emit(out, "ld\ta,c");           /* A = LHS_b0 */
                emit(out, "add\ta,(hl)");       /* A = result_b0, sets C */
                emit(out, "ld\tc,a");            /* C = result_b0 */
                emit(out, "inc\thl");
                emit(out, "ld\ta,b");           /* A = LHS_b1 */
                emit(out, "adc\ta,(hl)");       /* A = result_b1 */
                emit(out, "ld\tb,a");            /* B = result_b1 */
                emit(out, "inc\thl");
                emit(out, "ld\ta,e");           /* A = LHS_b2 */
                emit(out, "adc\ta,(hl)");       /* A = result_b2 */
                emit(out, "ld\te,a");            /* E = result_b2 */
                emit(out, "inc\thl");
                emit(out, "ld\ta,d");           /* A = LHS_b3 */
                emit(out, "adc\ta,(hl)");       /* A = result_b3 */
                emit(out, "ld\td,a");            /* D = result_b3 */
                /* BC = (B=b1, C=b0) = low half, DE = (D=b3, E=b2) =
                   high half — already correct by construction. Tell
                   store_dehl to skip its `ld b,h; ld c,l` prelude
                   (which would round-trip BC through HL needlessly). */
                cur_store_dehl_bc_ready = 1;
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* Non-fused long ADD: load both srcs through DEHL with a
               stack save in between. Two no-HL tricks:
                 - src[1]'s load: HL is only used to be pushed —
                   push BC instead (BC = src[1].LSW by cache invariant)
                   and skip the load's `ld l,c; ld h,b`.
                 - src[0]'s load: HL is junk-then-popped, so skip its
                   `ld l,c; ld h,b` too.
               Saves 4B per fired site. */
            cur_load_to_dehl_no_hl = 1;
            load_to_dehl(out, f, op->src[1]);
            emit(out, "push\tde");                  /* HIGH */
            emit(out, "push\tbc");                  /* LOW (= b.LSW) */
            cur_load_to_dehl_no_hl = 1;
            load_to_dehl_adj(out, f, op->src[0], 4);  /* BC = a.LSW */
            emit(out, "pop\thl");                       /* HL = b.LSW */
            emit(out, "add\thl,bc");                    /* HL = b.LSW + a.LSW */
            emit(out, "ex\tde,hl");                     /* DE = LOW result */
            emit(out, "pop\tbc");                       /* BC = b.MSW */
            emit(out, "adc\thl,bc");                    /* HL = a.MSW + b.MSW + C */
            emit(out, "ex\tde,hl");                     /* DEHL = result */
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        load_binop_operands(out, f, op);
        emit(out, "add\thl,de");
        /* PR_DE dst: move result HL→DE via ex de,hl (+4 T-states).
           Saves the ~28 T-state spill that would otherwise fire (dst
           is consumed as src[1] of next op, so cur_dst_dead doesn't
           help). HL becomes junk (was src[1], no longer needed). */
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ex\tde,hl");
            invalidate_hl_cache();
            cache_de(op->dst);
            return 0;
        }
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    case IR_SUB:
        if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
            if (op->src[1] == -1) {
                uint32_t k = (uint32_t)op->imm;
                /* In-place const SUB on sp-rel slot (#338, mirrors the
                   IR_ADD form): when dst == src[0] and the vreg lives
                   in a stack slot, subtract K's bytes directly into the
                   slot through A. `sub` clears carry on entry (no `or
                   a` needed); subsequent bytes use `sbc`. sp-rel byte
                   walk works in FP mode too. */
                if (op->dst == op->src[0]
                    && !cur_dst_dead
                    && !vreg_in_pr_bc(f, op->dst)
                    && f->vreg_to_phys
                    && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
                    int off = slot_off(f, op->dst);
                    uint8_t k0 = (uint8_t)(k & 0xff);
                    uint8_t k1 = (uint8_t)((k >> 8) & 0xff);
                    uint8_t k2 = (uint8_t)((k >> 16) & 0xff);
                    uint8_t k3 = (uint8_t)((k >> 24) & 0xff);
                    emit(out, "ld\thl,%d", off);
                    emit(out, "add\thl,sp");
                    emit(out, "ld\ta,(hl)");
                    emit(out, "sub\t%u", (unsigned)k0);
                    emit(out, "ld\t(hl),a");
                    emit(out, "inc\thl");
                    emit(out, "ld\ta,(hl)");
                    emit(out, "sbc\ta,%u", (unsigned)k1);
                    emit(out, "ld\t(hl),a");
                    emit(out, "inc\thl");
                    emit(out, "ld\ta,(hl)");
                    emit(out, "sbc\ta,%u", (unsigned)k2);
                    emit(out, "ld\t(hl),a");
                    emit(out, "inc\thl");
                    emit(out, "ld\ta,(hl)");
                    emit(out, "sbc\ta,%u", (unsigned)k3);
                    emit(out, "ld\t(hl),a");
                    invalidate_hl_cache();
                    invalidate_bc_cache();
                    return 0;
                }
                /* Const-RHS: keep LHS in DEHL and load each K half
                   into BC at the use site. No push/pop needed. */
                load_to_dehl(out, f, op->src[0]);
                /* DEHL = LHS (HL = LOW, DE = HIGH). */
                emit(out, "ld\tbc,%u", (unsigned)(k & 0xffff));
                emit(out, "or\ta");                     /* clear carry */
                emit(out, "sbc\thl,bc");                /* HL = LHS_LOW - K_LOW */
                emit(out, "ex\tde,hl");                 /* DE = result LOW, HL = LHS_HIGH */
                emit(out, "ld\tbc,%u",
                     (unsigned)((k >> 16) & 0xffff));
                emit(out, "sbc\thl,bc");                /* HL = LHS_HIGH - K_HIGH - borrow */
                emit(out, "ex\tde,hl");                 /* DEHL = result */
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* FP-mode byte-direct long SUB fastpath. SUB is NOT
               commutative; we need src[0] - src[1]. Two sub-cases:
                 a) src[0] in DEHL, src[1] in slot →
                    ld a,<dehl byte>; sub/sbc a,(ix+s1+i); ld dst,a
                 b) both in slots →
                    ld a,(ix+s0+i); sub/sbc a,(ix+s1+i); ld dst,a
               src[1]-in-DEHL with src[0] in slot would need
               `ld a,(ix+s0+i); sub <dehl reg>` which works for the
               first byte but `sbc a,<reg>` for the carry chain —
               also works. So we can handle that too. */
            if (fp_active(f)
                && op->src[0] >= 0 && op->src[1] >= 0
                && op->dst >= 0) {
                int swap = 0;  /* if 1, src[1] is in dehl (rare) */
                int from_dehl = -1, from_slot = -1;
                if (dehl_has(op->src[0]) && !dehl_has(op->src[1])) {
                    from_dehl = op->src[0]; from_slot = op->src[1];
                } else if (dehl_has(op->src[1])
                           && !dehl_has(op->src[0])) {
                    /* DEHL has the subtrahend; A holds the minuend
                       from (ix+s0+i), and we subtract the DEHL reg
                       byte. Works the same opcode-wise. */
                    from_dehl = op->src[1]; from_slot = op->src[0];
                    swap = 1;
                } else if (!dehl_has(op->src[0])
                           && !dehl_has(op->src[1])) {
                    from_slot = op->src[1];
                }
                if (from_slot >= 0) {
                    int s_minuend = (swap || from_dehl < 0)
                                  ? slot_ix_off(f, op->src[0]) : 0;
                    int s_subtra = (!swap && from_dehl < 0)
                                 ? slot_ix_off(f, op->src[1])
                                 : (swap ? 0 : 0);
                    /* Walking offset of the (ix+d) operand: that's
                       always the slot src — could be subtrahend or
                       minuend depending on `swap`. Recompute. */
                    int slot_off_ix = slot_ix_off(f, from_slot);
                    int s0 = (from_dehl >= 0 && !swap)
                           ? -1                 /* minuend from DEHL */
                           : (swap ? slot_ix_off(f, op->src[0])
                                   : slot_ix_off(f, op->src[0]));
                    int dd = cur_dst_dead
                           ? 0 : slot_ix_off(f, op->dst);
                    int srcs_ok = fp_offset_fits(slot_off_ix)
                               && fp_offset_fits(slot_off_ix + 3)
                               && (from_dehl >= 0
                                   || (fp_offset_fits(s0)
                                       && fp_offset_fits(s0 + 3)));
                    int dst_ok = cur_dst_dead
                        ? 1
                        : (fp_offset_fits(dd)
                           && fp_offset_fits(dd + 3));
                    /* swap path also needs s_minuend reachable. */
                    if (swap)
                        srcs_ok = srcs_ok
                               && fp_offset_fits(s_minuend)
                               && fp_offset_fits(s_minuend + 3);
                    if (srcs_ok && dst_ok) {
                        static const char *dehl_byte[4] =
                            { "c", "b", "e", "d" };
                        for (int i = 0; i < 4; i++) {
                            /* Load minuend (src[0]) into A. */
                            if (from_dehl >= 0 && !swap)
                                emit(out, "ld\ta,%s",
                                     dehl_byte[i]);
                            else if (swap)
                                emit(out, "ld\ta,(%s%+d)",
                                     frame_reg(), s_minuend + i);
                            else
                                emit(out, "ld\ta,(%s%+d)",
                                     frame_reg(), s0 + i);
                            /* Subtract subtrahend (src[1]). */
                            if (swap) {
                                /* src[1] in DEHL — use reg form. */
                                if (i == 0)
                                    emit(out, "sub\t%s",
                                         dehl_byte[i]);
                                else
                                    emit(out, "sbc\ta,%s",
                                         dehl_byte[i]);
                            } else {
                                int off = slot_off_ix + i;
                                if (i == 0)
                                    emit(out, "sub\t(%s%+d)",
                                         frame_reg(), off);
                                else
                                    emit(out, "sbc\ta,(%s%+d)",
                                         frame_reg(), off);
                            }
                            if (cur_dst_dead)
                                emit(out, "ld\t%s,a",
                                     dehl_byte[i]);
                            else
                                emit(out, "ld\t(%s%+d),a",
                                     frame_reg(), dd + i);
                        }
                        if (cur_dst_dead) {
                            /* Skip eager `ld l,c; ld h,b` — DEHL cache
                               invariant is BC=low + DE=high + (HL may
                               or may not have low). Downstream
                               load_to_dehl on cache hit emits the
                               recover itself; downstream byte-direct
                               or byte-A ops never need HL. Saves 2B
                               per dead-dst byte-direct binop. */
                            cur_hl_vreg = -1;
                            cur_de_vreg = -1;
                            cur_dehl_vreg = op->dst;
                        } else {
                            invalidate_hl_cache();
                            invalidate_bc_cache();
                        }
                        return 0;
                    }
                }
            }
            /* Fused load+sub fastpath (#335): point HL at the RHS slot
               and do `sub (hl)`/`sbc (hl)` byte-wise, reading LHS out
               of D/E/B/C (BC mirrors HL via the DEHL cache invariant).
               `sub` doesn't take carry-in so the first byte sets the
               borrow naturally for the sbc chain. Only fires when RHS
               is sp-rel and not in the DEHL cache. Skip the cached-
               LHS HL recovery (`ld l,c; ld h,b`) since HL is about to
               be overwritten with the RHS slot address. */
            if (!fp_active(f) && !dehl_has(op->src[1])) {
                if (!dehl_has(op->src[0]))
                    load_to_dehl(out, f, op->src[0]);
                int off = slot_off(f, op->src[1]) + cur_sp_adjust;
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");        /* HL = &RHS */
                emit(out, "ld\ta,c");
                emit(out, "sub\t(hl)");         /* A = LHS_b0 - RHS_b0, sets C=borrow */
                emit(out, "ld\tc,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,b");
                emit(out, "sbc\ta,(hl)");
                emit(out, "ld\tb,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,e");
                emit(out, "sbc\ta,(hl)");
                emit(out, "ld\te,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,d");
                emit(out, "sbc\ta,(hl)");
                emit(out, "ld\td,a");
                /* BC = (B=b1, C=b0) low half by construction; DE =
                   (D=b3, E=b2) high half. Skip the round-trip via HL. */
                cur_store_dehl_bc_ready = 1;
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* Long sub. Push a (HIGH then LOW), load b into DEHL, then
               inline the helper body. l_long_sub would clobber IX. */
            /* Non-fused long SUB: load both srcs with no HL recovery
               (the first load's HL just gets pushed — push BC instead;
               the second's HL gets popped). Drop the redundant
               `ld c,l; ld b,h` that would set BC = b.LSW since
               load_to_dehl already left BC = b.LSW via byte walk or
               cache invariant. Saves 6B per fired site. */
            cur_load_to_dehl_no_hl = 1;
            load_to_dehl(out, f, op->src[0]);
            emit(out, "push\tde");
            emit(out, "push\tbc");                      /* LOW (= a.LSW) */
            cur_load_to_dehl_no_hl = 1;
            load_to_dehl_adj(out, f, op->src[1], 4);    /* BC = b.LSW */
            emit(out, "pop\thl");                       /* HL = a.LSW */
            emit(out, "or\ta");                         /* clear carry */
            emit(out, "sbc\thl,bc");                    /* HL = a-b LOW */
            emit(out, "ex\tde,hl");                     /* DE = LOW, HL = b.MSW */
            emit(out, "ld\tc,l");
            emit(out, "ld\tb,h");                       /* BC = b.MSW */
            emit(out, "pop\thl");                       /* HL = a.MSW */
            emit(out, "sbc\thl,bc");                    /* HL = a-b MSW */
            emit(out, "ex\tde,hl");                     /* DEHL = result */
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        load_binop_operands(out, f, op);
        emit(out, "and\ta");
        emit(out, "sbc\thl,de");
        /* PR_DE dst: same swap as IR_ADD. */
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ex\tde,hl");
            invalidate_hl_cache();
            cache_de(op->dst);
            return 0;
        }
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    /* Bitwise ops — z80 only operates on A, so do it byte-by-byte. */
    case IR_AND:
    case IR_OR:
    case IR_XOR: {
        const char *mnem = (op->kind == IR_AND) ? "and"
                         : (op->kind == IR_OR)  ? "or"
                         :                        "xor";

        if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
            /* Long AND-mask + immediately-following BR_ZERO/COND
               fastpath. crcbench's `(crc & 1UL) ? ... : ...` is the
               archetype — 8 bit-tests per byte × 1024 × 63 reps =
               half a million per run. Without this, each test goes
               through the full DEHL load + 4-byte AND + slot spill +
               reload + or h,or l + jp (~40 inst per test). The
               mirror of the width=2 fastpath at line 2231 — when
               the mask hits exactly one of the 4 bytes, just byte-
               AND that byte and branch on Z. */
            if (op->kind == IR_AND
                && op->src[1] == -1
                && cur_branch_test_kind != 0) {
                uint32_t kk = (uint32_t)op->imm;
                uint8_t b4[4];
                b4[0] = (uint8_t)(kk & 0xff);
                b4[1] = (uint8_t)((kk >> 8) & 0xff);
                b4[2] = (uint8_t)((kk >> 16) & 0xff);
                b4[3] = (uint8_t)((kk >> 24) & 0xff);
                int nz_idx = -1, nz_count = 0;
                for (int i = 0; i < 4; i++) {
                    if (b4[i] != 0) { nz_idx = i; nz_count++; }
                }
                if (nz_count == 1) {
                    /* Single non-zero byte. Read it without disturbing
                       the rest of the long. When dehl_has(src), the
                       cache invariant is: BC = low half (B=byte1,
                       C=byte0), DE = high half (D=byte3, E=byte2).
                       HL may or may not be physically valid after a
                       store_dehl (it gets clobbered by slot stores),
                       so always pull byte0/byte1 from BC, not HL.
                       Slot layout: slot+i = byte i. */
                    static const char *dehl_byte_regs[4] =
                        { "c", "b", "e", "d" };
                    int emitted = 0;
                    if (dehl_has(op->src[0])) {
                        emit(out, "ld\ta,%s", dehl_byte_regs[nz_idx]);
                        emitted = 1;
                    } else if (fp_active(f)) {
                        int ix_off = slot_ix_off(f, op->src[0])
                                   + nz_idx;
                        if (fp_offset_fits(ix_off)) {
                            emit(out, "ld\ta,(%s%+d)",
                                 frame_reg(), ix_off);
                            emitted = 1;
                        }
                    } else {
                        int off = slot_off(f, op->src[0])
                                + cur_sp_adjust + nz_idx;
                        emit(out, "ld\thl,%d", off);
                        emit(out, "add\thl,sp");
                        emit(out, "ld\ta,(hl)");
                        cur_hl_vreg = -1;
                        emitted = 1;
                    }
                    if (emitted) {
                        emit(out, "and\t%u",
                             (unsigned)b4[nz_idx]);
                        const char *cc =
                            (cur_branch_test_kind == IR_BR_ZERO)
                                ? "z" : "nz";
                        emit(out, "jp\t%s,L_f%d_bb_%d",
                             cc, func_emit_idx,
                             cur_branch_test_label);
                        cur_skip_next_op = 1;
                        return 0;
                    }
                }
            }
            /* Long bitwise — byte-wise through A. Literal-RHS variant
               can skip identity bytes (0xff for AND, 0x00 for OR/XOR)
               and zero-store for AND-with-0. Variable-RHS variant
               saves src[0] DEHL on stack, loads src[1] DEHL, then
               combines byte by byte while popping the saved src[0]. */
            if (op->src[1] == -1) {
                uint32_t kk = (uint32_t)op->imm;
                uint8_t b[4];
                b[0] = (uint8_t)(kk & 0xff);
                b[1] = (uint8_t)((kk >> 8) & 0xff);
                b[2] = (uint8_t)((kk >> 16) & 0xff);
                b[3] = (uint8_t)((kk >> 24) & 0xff);
                uint8_t identity = (op->kind == IR_AND) ? 0xff : 0x00;
                static const char *regs[4] = { "l", "h", "e", "d" };
                load_to_dehl(out, f, op->src[0]);
                for (int i = 0; i < 4; i++) {
                    if (b[i] == identity) continue;
                    if (op->kind == IR_AND && b[i] == 0) {
                        emit(out, "ld\t%s,0", regs[i]);
                        continue;
                    }
                    /* #337 single-bit set/res shortcut. OR with a single
                       bit set → `set n,r` (8T + 2 byte) vs the `ld a,r;
                       or K; ld r,a` triple (~18T + 4 byte). AND with a
                       single bit clear (i.e., ~b[i] is a single bit) →
                       `res n,r`. XOR doesn't reduce — z80 has no
                       toggle-bit instruction. */
                    uint8_t v = b[i];
                    uint8_t bit_mask = (op->kind == IR_AND)
                                     ? (uint8_t)(~v & 0xff)
                                     : v;
                    if (op->kind != IR_XOR &&
                        bit_mask != 0 &&
                        (bit_mask & (bit_mask - 1)) == 0) {
                        int bit = 0;
                        while ((bit_mask >> bit) != 1) bit++;
                        emit(out, "%s\t%d,%s",
                             (op->kind == IR_AND) ? "res" : "set",
                             bit, regs[i]);
                        continue;
                    }
                    emit(out, "ld\ta,%s", regs[i]);
                    emit(out, "%s\t%u", mnem, (unsigned)b[i]);
                    emit(out, "ld\t%s,a", regs[i]);
                }
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* Phase D option B — src[0] is currently parked on top of
               the data stack from an earlier IR_PUSH_DEHL_LONG. We
               read its bytes directly via (hl) on the stack, ORing
               (or AND/XOR-ing) against src[1] bytes popped from our
               own save. This elides the POP+reload+re-push compensation
               that the generic Phase D path would otherwise force when
               an intermediate op (the producer of src[1]) leaves its
               result in DEHL right when we need it. */
            /* Determine the in-DEHL operand: the consumer's src that
               is NOT the stack-resident vreg. AND/OR/XOR are
               commutative, so either src position is fine; the
               lower_func commutative-swap may already have shuffled
               things to favour the DEHL cache. */
            int optb_dehl_src = -1;
            if (cur_stack_long_top >= 0 && !fp_active(f)) {
                if (cur_stack_long_top == op->src[0]
                    && op->src[1] != cur_stack_long_top)
                    optb_dehl_src = op->src[1];
                else if (cur_stack_long_top == op->src[1]
                    && op->src[0] != cur_stack_long_top)
                    optb_dehl_src = op->src[0];
            }
            if (optb_dehl_src >= 0) {
                load_to_dehl_adj(out, f, optb_dehl_src, 0);
                emit(out, "push\tde");           /* save src[1] high */
                emit(out, "push\thl");           /* save src[1] low */
                cur_sp_adjust += 4;
                /* Stack low→high: [s1.b0, s1.b1, s1.b2, s1.b3,
                                    s0.b0, s0.b1, s0.b2, s0.b3]
                   Address src[0].b0 at sp+4. */
                emit(out, "ld\thl,4");
                emit(out, "add\thl,sp");
                emit(out, "pop\tbc");            /* C=s1.b0, B=s1.b1 */
                cur_sp_adjust -= 2;
                emit(out, "ld\ta,c");
                emit(out, "%s\t(hl)", mnem);
                emit(out, "ld\te,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,b");
                emit(out, "%s\t(hl)", mnem);
                emit(out, "inc\thl");
                emit(out, "ld\td,a");
                emit(out, "pop\tbc");            /* C=s1.b2, B=s1.b3 */
                cur_sp_adjust -= 2;
                emit(out, "ld\ta,c");
                emit(out, "%s\t(hl)", mnem);
                emit(out, "inc\thl");
                emit(out, "ld\tc,a");
                emit(out, "ld\ta,b");
                emit(out, "%s\t(hl)", mnem);
                emit(out, "ld\th,a");
                emit(out, "ld\tl,c");
                emit(out, "ex\tde,hl");           /* DEHL = result */
                /* Drop the Phase D frame. */
                emit(out, "pop\tbc");
                emit(out, "pop\tbc");
                cur_sp_adjust -= 4;
                cur_stack_long_top = -1;
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* FP-mode byte-direct fastpath. When fp is active and
               the srcs can be reached via (ix+d) or the DEHL cache,
               walk the bytes through A using (ix+d) / dehl registers
               directly:
                 ld a,(ix+s0+i)   OR   ld a,<reg from dehl>
                 <op> a,(ix+s1+i) OR   <op> a,<reg from dehl>
                 ld <dest>,a      (dest = (ix+d+i) live / dehl reg dead)
               Mirror of sdcc's pattern. AND/OR/XOR are commutative
               so either src can occupy the DEHL cache; for the
               chained MD5 pattern the previous op's result is
               already in BC=low, DE=high, so we read src[0] (or
               src[1]) out of those registers and walk the other
               src via (ix+d). */
            if (fp_active(f)
                && (op->kind == IR_AND || op->kind == IR_OR
                    || op->kind == IR_XOR)
                && op->src[0] >= 0 && op->src[1] >= 0
                && op->dst >= 0) {
                /* Pick which src to source from DEHL cache (if any)
                   and which to walk via (ix+d). */
                int from_dehl = -1, from_slot = -1;
                if (dehl_has(op->src[0]) && !dehl_has(op->src[1])) {
                    from_dehl = op->src[0]; from_slot = op->src[1];
                } else if (dehl_has(op->src[1])
                           && !dehl_has(op->src[0])) {
                    from_dehl = op->src[1]; from_slot = op->src[0];
                } else if (!dehl_has(op->src[0])
                           && !dehl_has(op->src[1])) {
                    from_slot = op->src[1];  /* both in slot — pick
                                                 src[1] for ix walk;
                                                 src[0] also via ix */
                }
                if (from_slot >= 0) {
                    int s1 = slot_ix_off(f, from_slot);
                    int s0 = (from_dehl < 0)
                           ? slot_ix_off(f, op->src[0]) : 0;
                    int dd = cur_dst_dead
                           ? 0 : slot_ix_off(f, op->dst);
                    int srcs_ok = fp_offset_fits(s1)
                               && fp_offset_fits(s1 + 3)
                               && (from_dehl >= 0
                                   || (fp_offset_fits(s0)
                                       && fp_offset_fits(s0 + 3)));
                    int dst_ok = cur_dst_dead
                        ? 1
                        : (fp_offset_fits(dd)
                           && fp_offset_fits(dd + 3));
                    if (srcs_ok && dst_ok) {
                        static const char *dehl_byte[4] =
                            { "c", "b", "e", "d" };
                        for (int i = 0; i < 4; i++) {
                            if (from_dehl >= 0)
                                emit(out, "ld\ta,%s",
                                     dehl_byte[i]);
                            else
                                emit(out, "ld\ta,(%s%+d)",
                                     frame_reg(), s0 + i);
                            emit(out, "%s\ta,(%s%+d)",
                                 mnem, frame_reg(), s1 + i);
                            if (cur_dst_dead)
                                emit(out, "ld\t%s,a",
                                     dehl_byte[i]);
                            else
                                emit(out, "ld\t(%s%+d),a",
                                     frame_reg(), dd + i);
                        }
                        if (cur_dst_dead) {
                            /* Skip eager `ld l,c; ld h,b` — DEHL cache
                               invariant is BC=low + DE=high + (HL may
                               or may not have low). Downstream
                               load_to_dehl on cache hit emits the
                               recover itself; downstream byte-direct
                               or byte-A ops never need HL. Saves 2B
                               per dead-dst byte-direct binop. */
                            cur_hl_vreg = -1;
                            cur_de_vreg = -1;
                            cur_dehl_vreg = op->dst;
                        } else {
                            invalidate_hl_cache();
                            invalidate_bc_cache();
                        }
                        return 0;
                    }
                }
            }
            /* Variable RHS. The cache-hit path (dehl_has(src[0]))
               can skip load_to_dehl entirely — BC = src[0].LSW by
               cache invariant. The non-cached path can skip the
               byte-walk's trailing `ld l,c; ld h,b` (no_hl flag) and
               push BC (which the byte walk just set to src[0].LSW)
               instead of HL. Either way: push BC, no HL recovery.
               Saves 2B per fired site. */
            cur_load_to_dehl_no_hl = 1;
            load_to_dehl(out, f, op->src[0]);
            emit(out, "push\tde");
            emit(out, "push\tbc");                       /* LOW (= src[0].LSW) */
            /* Fused load+op fastpath: instead of loading RHS into DEHL
               then byte-op through A, point HL at the RHS slot and do
               `<op> (hl)` directly with LHS bytes popped off the stack.
               Saves the full DEHL load (4 byte reads + cache stash =
               11 inst) by fusing it into the byte-op chain. Only fires
               when the RHS lives sp-rel (FP-mode would need extra ops
               to compute HL from IX — not a win) and isn't already in
               the DEHL cache. */
            if (!fp_active(f) && !dehl_has(op->src[1])) {
                int off = slot_off(f, op->src[1]) + 4 + cur_sp_adjust;
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");
                emit(out, "pop\tbc");          /* BC = LHS low (B=byte1, C=byte0) */
                emit(out, "ld\ta,c");
                emit(out, "%s\t(hl)", mnem);   /* A = byte0 result */
                emit(out, "ld\te,a");           /* stash byte0 in E */
                emit(out, "inc\thl");
                emit(out, "ld\ta,b");
                emit(out, "%s\t(hl)", mnem);   /* A = byte1 result */
                emit(out, "inc\thl");
                emit(out, "ld\td,a");           /* stash byte1 in D */
                emit(out, "pop\tbc");          /* BC = LHS high (B=byte3, C=byte2) */
                emit(out, "ld\ta,c");
                emit(out, "%s\t(hl)", mnem);   /* A = byte2 result */
                emit(out, "inc\thl");
                emit(out, "ld\tc,a");           /* stash byte2 in C */
                emit(out, "ld\ta,b");
                emit(out, "%s\t(hl)", mnem);   /* A = byte3 result */
                emit(out, "ld\th,a");           /* H = byte3 */
                emit(out, "ld\tl,c");           /* L = byte2 */
                emit(out, "ex\tde,hl");        /* DEHL: D=b3 E=b2 H=b1 L=b0 */
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            load_to_dehl_adj(out, f, op->src[1], 4);
            emit(out, "pop\tbc");          /* BC = src[0] LOW (C=b0, B=b1) */
            emit(out, "ld\ta,c");
            emit(out, "%s\tl", mnem);
            emit(out, "ld\tl,a");
            emit(out, "ld\ta,b");
            emit(out, "%s\th", mnem);
            emit(out, "ld\th,a");
            emit(out, "pop\tbc");          /* BC = src[0] HIGH */
            emit(out, "ld\ta,c");
            emit(out, "%s\te", mnem);
            emit(out, "ld\te,a");
            emit(out, "ld\ta,b");
            emit(out, "%s\td", mnem);
            emit(out, "ld\td,a");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }

        /* AND-mask + immediately-following BR_ZERO/COND fastpath.
           `crc & 0x8000U` followed by `if (cond) {...}` is the
           archetype in CRC inner loops. Skip computing the full
           AND result; just byte-AND and branch on the Z flag.
           Conditions:
             - op is IR_AND
             - literal-fold (src[1] == -1) with imm that fits in
               either the low or high byte alone (other byte is 0)
             - dst dead after BR — implied by cur_branch_test_kind
               being set (lower_func only publishes the branch info
               when cur_dst_dead is true)                              */
        if (op->kind == IR_AND
            && op->src[1] == -1
            && cur_branch_test_kind != 0) {
            uint16_t k = (uint16_t)op->imm;
            uint8_t hi = (uint8_t)(k >> 8);
            uint8_t lo = (uint8_t)(k & 0xff);
            if ((hi == 0) != (lo == 0)) {
                /* Single-byte mask. Load src[0] into HL if not cached. */
                if (!hl_has(op->src[0]))
                    load_to_hl(out, f, op->src[0]);
                const char *reg = (hi != 0) ? "h" : "l";
                uint8_t mask  = (hi != 0) ? hi : lo;
                emit(out, "ld\ta,%s", reg);
                emit(out, "and\t%u", (unsigned)mask);
                const char *cc =
                    (cur_branch_test_kind == IR_BR_ZERO) ? "z" : "nz";
                emit(out, "jp\t%s,L_f%d_bb_%d",
                     cc, func_emit_idx, cur_branch_test_label);
                /* HL still holds src[0] (`and` only touched A and F).
                   Advertise it explicitly — load_to_hl above does not
                   update cur_hl_vreg, so a cache miss followed by a
                   non-cached load would leave the global var stale. */
                cache_hl(op->src[0]);
                /* Mark cur_skip_next_op so the dispatcher skips the
                   now-consumed branch op. */
                cur_skip_next_op = 1;
                return 0;
            }
        }

        /* Literal-fold value-context fastpath. Skip the `ld de,K`
           and use immediate-form `and/or/xor K` per byte. When a
           byte of K is the identity for the op (0 for OR/XOR, 0xFF
           for AND), skip that byte entirely. When a byte is the
           absorber (0 for AND), zero it without going through A. */
        if (op->src[1] == -1) {
            uint16_t k = (uint16_t)op->imm;
            uint8_t lo = (uint8_t)(k & 0xff);
            uint8_t hi = (uint8_t)(k >> 8);
            uint8_t identity = (op->kind == IR_AND) ? 0xff : 0x00;
            int lo_skip = (lo == identity);
            int hi_skip = (hi == identity);
            int lo_zero = (op->kind == IR_AND && lo == 0);
            int hi_zero = (op->kind == IR_AND && hi == 0);
            if (!hl_has(op->src[0]))
                load_to_hl(out, f, op->src[0]);
            /* PR_DE dst: route the byte writes into E/D instead of
               L/H. HL preserves src[0] (we never touch it during the
               op-with-A dance), so cur_hl_vreg = src[0] stays valid. */
            if (vreg_is_pr_de(f, op->dst)) {
                const char *low_dst  = "e";
                const char *high_dst = "d";
                if (lo_zero) {
                    emit(out, "ld\t%s,0", low_dst);
                } else if (lo_skip) {
                    emit(out, "ld\t%s,l", low_dst);
                } else {
                    emit(out, "ld\ta,l");
                    emit(out, "%s\t%u", mnem, (unsigned)lo);
                    emit(out, "ld\t%s,a", low_dst);
                }
                if (hi_zero) {
                    emit(out, "ld\t%s,0", high_dst);
                } else if (hi_skip) {
                    emit(out, "ld\t%s,h", high_dst);
                } else {
                    emit(out, "ld\ta,h");
                    emit(out, "%s\t%u", mnem, (unsigned)hi);
                    emit(out, "ld\t%s,a", high_dst);
                }
                cache_de(op->dst);
                /* HL still holds src[0] — cache_hl(src[0]) preserved. */
                return 0;
            }
            /* #337 single-bit set/res shortcut (int in-place variant).
               For each non-identity byte, if K (OR) or ~K (AND) is a
               single bit, emit set/res instead of the ld a/op/ld
               triple. XOR has no toggle-bit instruction so it's
               excluded. */
            uint8_t lo_bm = (op->kind == IR_AND)
                          ? (uint8_t)(~lo & 0xff) : lo;
            uint8_t hi_bm = (op->kind == IR_AND)
                          ? (uint8_t)(~hi & 0xff) : hi;
            int lo_single = (op->kind != IR_XOR && lo_bm != 0 &&
                             (lo_bm & (lo_bm - 1)) == 0);
            int hi_single = (op->kind != IR_XOR && hi_bm != 0 &&
                             (hi_bm & (hi_bm - 1)) == 0);
            const char *setres = (op->kind == IR_AND) ? "res" : "set";
            if (lo_zero) {
                emit(out, "ld\tl,0");
            } else if (lo_single) {
                int bit = 0; while ((lo_bm >> bit) != 1) bit++;
                emit(out, "%s\t%d,l", setres, bit);
            } else if (!lo_skip) {
                emit(out, "ld\ta,l");
                emit(out, "%s\t%u", mnem, (unsigned)lo);
                emit(out, "ld\tl,a");
            }
            if (hi_zero) {
                emit(out, "ld\th,0");
            } else if (hi_single) {
                int bit = 0; while ((hi_bm >> bit) != 1) bit++;
                emit(out, "%s\t%d,h", setres, bit);
            } else if (!hi_skip) {
                emit(out, "ld\ta,h");
                emit(out, "%s\t%u", mnem, (unsigned)hi);
                emit(out, "ld\th,a");
            }
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }

        load_binop_operands(out, f, op);
        /* PR_DE dst (variable RHS): write result bytes into E/D
           directly. HL = src[0] is preserved through the A-staged
           byte ops, so cache_hl(src[0]) survives. */
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ld\ta,l");
            emit(out, "%s\te", mnem);
            emit(out, "ld\te,a");
            emit(out, "ld\ta,h");
            emit(out, "%s\td", mnem);
            emit(out, "ld\td,a");
            cache_de(op->dst);
            /* cur_hl_vreg = src[0] unchanged. */
            return 0;
        }
        emit(out, "ld\ta,l");
        emit(out, "%s\te", mnem);
        emit(out, "ld\tl,a");
        emit(out, "ld\ta,h");
        emit(out, "%s\td", mnem);
        emit(out, "ld\th,a");
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }

    case IR_INC:
        if (!hl_has(op->src[0]))
            load_to_hl(out, f, op->src[0]);
        emit(out, "inc\thl");
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    case IR_DEC:
        if (!hl_has(op->src[0]))
            load_to_hl(out, f, op->src[0]);
        emit(out, "dec\thl");
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    case IR_NEG:
        if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
            /* Long NEG: DEHL = 0 - src[0]. Done as ~x + 1 byte-wise to
               avoid running through l_long_sub for a trivial constant
               LHS. Algorithm: complement DEHL then increment as long.
               Cheap inc: stage carry through `or a; ld a,l; cpl; inc a;
               ld l,a; ld a,h; cpl; adc a,0; ld h,a; ld a,e; cpl;
               adc a,0; ld e,a; ld a,d; cpl; adc a,0; ld d,a`. */
            load_to_dehl(out, f, op->src[0]);
            emit(out, "ld\ta,l"); emit(out, "cpl");
            emit(out, "add\ta,1");        /* + 1, sets carry if a was 0xff */
            emit(out, "ld\tl,a");
            emit(out, "ld\ta,h"); emit(out, "cpl");
            emit(out, "adc\ta,0");
            emit(out, "ld\th,a");
            emit(out, "ld\ta,e"); emit(out, "cpl");
            emit(out, "adc\ta,0");
            emit(out, "ld\te,a");
            emit(out, "ld\ta,d"); emit(out, "cpl");
            emit(out, "adc\ta,0");
            emit(out, "ld\td,a");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* HL = 0 - src[0]. Load src[0] to DE then sbc HL=0,DE. */
        load_to_de(out, f, op->src[0]);
        emit(out, "ld\thl,0");
        emit(out, "or\ta");
        emit(out, "sbc\thl,de");
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    case IR_NOT:
        if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
            /* Fused load+cpl: walk HL through the source slot reading
               each byte into A, complement, write into the target
               register. Avoids the separate full DEHL load + 4× byte
               cpl chain (~16T saved per occurrence). Gated on a slot
               read (no DEHL cache hit, no FP mode). */
            if (!fp_active(f) && !dehl_has(op->src[0])) {
                int off = slot_off(f, op->src[0]) + cur_sp_adjust;
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");
                emit(out, "ld\ta,(hl)"); emit(out, "cpl");
                emit(out, "ld\tc,a");           /* C = ~byte0 */
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)"); emit(out, "cpl");
                emit(out, "ld\tb,a");           /* B = ~byte1 */
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)"); emit(out, "cpl");
                emit(out, "ld\te,a");           /* E = ~byte2 */
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)"); emit(out, "cpl");
                emit(out, "ld\td,a");           /* D = ~byte3 */
                /* BC = (~b1, ~b0) = low half, DE = (~b3, ~b2) = high
                   half already correct by construction. Skip the
                   round trip through HL: don't emit `ld l,c; ld h,b`
                   here, and tell store_dehl to skip its symmetric
                   `ld b,h; ld c,l` prelude. */
                cur_store_dehl_bc_ready = 1;
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* Long ~: cpl each byte of DEHL. */
            load_to_dehl(out, f, op->src[0]);
            emit(out, "ld\ta,l"); emit(out, "cpl"); emit(out, "ld\tl,a");
            emit(out, "ld\ta,h"); emit(out, "cpl"); emit(out, "ld\th,a");
            emit(out, "ld\ta,e"); emit(out, "cpl"); emit(out, "ld\te,a");
            emit(out, "ld\ta,d"); emit(out, "cpl"); emit(out, "ld\td,a");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Bitwise complement: HL = ~src[0]. */
        if (!hl_has(op->src[0]))
            load_to_hl(out, f, op->src[0]);
        emit(out, "ld\ta,h");
        emit(out, "cpl");
        emit(out, "ld\th,a");
        emit(out, "ld\ta,l");
        emit(out, "cpl");
        emit(out, "ld\tl,a");
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;

    /* Unsigned/signed ordered compares — `sbc hl,de` puts the
       ordering into CF (signed needs the overflow correction).
       When the next op is BR_ZERO/COND on this compare's dst,
       skip the carry-to-bool materialisation and branch on the
       flag directly. */
    case IR_CMP_ULT: case IR_CMP_UGE:
    case IR_CMP_LT:  case IR_CMP_GE: {
        int is_signed = (op->kind == IR_CMP_LT || op->kind == IR_CMP_GE);
        int cf_true_long = (op->kind == IR_CMP_ULT || op->kind == IR_CMP_LT);
        /* Long ordered compare (#341): byte-wise sub/sbc chain. Final
           sbc leaves CF = unsigned borrow (a<b) and A = high byte of
           result. For signed, apply the S^V correction inline (`jp po
           ok; xor 0x80; ok: rla`) — same shape as signed_result_to_
           carry but without the `ld a,h` since A already holds the
           high byte. */
        int src0w_lt = (op->src[0] >= 0) ? f->vregs[op->src[0]].width : 0;
        if (src0w_lt == 4) {
            if (op->src[1] == -1) {
                uint32_t k = (uint32_t)op->imm;
                load_to_dehl(out, f, op->src[0]);
                emit(out, "ld\ta,l");
                emit(out, "sub\t%u", (unsigned)(k & 0xff));
                emit(out, "ld\ta,h");
                emit(out, "sbc\ta,%u", (unsigned)((k >> 8) & 0xff));
                emit(out, "ld\ta,e");
                emit(out, "sbc\ta,%u", (unsigned)((k >> 16) & 0xff));
                emit(out, "ld\ta,d");
                emit(out, "sbc\ta,%u", (unsigned)((k >> 24) & 0xff));
            } else if (!fp_active(f) && !dehl_has(op->src[1])) {
                load_to_dehl(out, f, op->src[0]);
                int off = slot_off(f, op->src[1]);
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");
                emit(out, "ld\ta,c");        /* LHS b0 via BC mirror */
                emit(out, "sub\t(hl)");
                emit(out, "inc\thl");
                emit(out, "ld\ta,b");
                emit(out, "sbc\ta,(hl)");
                emit(out, "inc\thl");
                emit(out, "ld\ta,e");
                emit(out, "sbc\ta,(hl)");
                emit(out, "inc\thl");
                emit(out, "ld\ta,d");
                emit(out, "sbc\ta,(hl)");
            } else {
                /* Fallback: stage both via push/pop. */
                load_to_dehl(out, f, op->src[1]);
                emit(out, "push\tde");
                emit(out, "push\thl");
                load_to_dehl_adj(out, f, op->src[0], 4);
                emit(out, "pop\tbc");        /* BC = RHS low */
                emit(out, "ld\ta,l");
                emit(out, "sub\tc");
                emit(out, "ld\ta,h");
                emit(out, "sbc\ta,b");
                emit(out, "pop\tbc");        /* BC = RHS high */
                emit(out, "ld\ta,e");
                emit(out, "sbc\ta,c");
                emit(out, "ld\ta,d");
                emit(out, "sbc\ta,b");
            }
            if (is_signed) {
                /* A holds high byte of result; CF set iff borrow. Apply
                   the S^V correction so CF ends up = signed-LT. */
                int n = cmp_label_counter++;
                emit(out, "jp\tpo,L_f%d_cmp_ok_%d", func_emit_idx, n);
                emit(out, "xor\t0x80");
                fprintf(out, "L_f%d_cmp_ok_%d:\n", func_emit_idx, n);
                emit(out, "rla");
            }
            invalidate_hl_cache();
            invalidate_bc_cache();
            if (cur_branch_test_kind != 0) {
                int br_true = (cur_branch_test_kind == IR_BR_COND);
                int want_carry = (cf_true_long == br_true);
                const char *cc = want_carry ? "c" : "nc";
                emit(out, "jp\t%s,L_f%d_bb_%d",
                     cc, func_emit_idx, cur_branch_test_label);
                cur_skip_next_op = 1;
                return 0;
            }
            carry_to_bool(out, cf_true_long);
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        load_binop_operands(out, f, op);
        emit(out, "and\ta");
        emit(out, "sbc\thl,de");
        if (is_signed) signed_result_to_carry(out);
        int cf_true = cf_true_long;
        if (cur_branch_test_kind != 0) {
            const char *cc;
            int br_true = (cur_branch_test_kind == IR_BR_COND);
            int want_carry = (cf_true == br_true);
            cc = want_carry ? "c" : "nc";
            emit(out, "jp\t%s,L_f%d_bb_%d",
                 cc, func_emit_idx, cur_branch_test_label);
            /* `sbc hl,de` clobbered HL but preserved DE — keep cache. */
            int saved_de = cur_de_vreg;
            invalidate_hl_cache();
            cur_de_vreg = saved_de;
            cur_skip_next_op = 1;
            return 0;
        }
        carry_to_bool(out, cf_true);
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }

    case IR_CMP_UGT: case IR_CMP_ULE:
    case IR_CMP_GT:  case IR_CMP_LE: {
        int is_signed = (op->kind == IR_CMP_GT || op->kind == IR_CMP_LE);
        /* After swap-load, CF=true means swapped operand src1 < src0
           = original src0 > src1 → GT/UGT. */
        int cf_true_gt = (op->kind == IR_CMP_UGT || op->kind == IR_CMP_GT);
        /* Long ordered compare (#341 GT/LE variant): subtract src[0]
           from src[1] byte-wise — the swap means CF=borrow iff src1<src0
           iff src0>src1. Const-RHS not folded for GT/LE (less common in
           practice; swap to LT/GE via the IR_build path if needed). */
        int src0w_gt = (op->src[0] >= 0) ? f->vregs[op->src[0]].width : 0;
        if (src0w_gt == 4) {
            if (op->src[1] == -1) {
                /* `a > K` ≡ `a >= K+1`. The const-RHS handler for LT/GE
                   is in the case above; ast_opt usually folds GT/LE
                   const-RHS into LT/GE before reaching IR. Bail to the
                   slow path here — rare case. */
                return -1;
            }
            if (!fp_active(f) && !dehl_has(op->src[0])) {
                /* Load src[1] (the "left" of the swapped subtraction) into
                   DEHL, point HL at &src[0], subtract through (hl). */
                load_to_dehl(out, f, op->src[1]);
                int off = slot_off(f, op->src[0]);
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");
                emit(out, "ld\ta,c");
                emit(out, "sub\t(hl)");
                emit(out, "inc\thl");
                emit(out, "ld\ta,b");
                emit(out, "sbc\ta,(hl)");
                emit(out, "inc\thl");
                emit(out, "ld\ta,e");
                emit(out, "sbc\ta,(hl)");
                emit(out, "inc\thl");
                emit(out, "ld\ta,d");
                emit(out, "sbc\ta,(hl)");
            } else {
                load_to_dehl(out, f, op->src[0]);
                emit(out, "push\tde");
                emit(out, "push\thl");
                load_to_dehl_adj(out, f, op->src[1], 4);
                emit(out, "pop\tbc");
                emit(out, "ld\ta,l");
                emit(out, "sub\tc");
                emit(out, "ld\ta,h");
                emit(out, "sbc\ta,b");
                emit(out, "pop\tbc");
                emit(out, "ld\ta,e");
                emit(out, "sbc\ta,c");
                emit(out, "ld\ta,d");
                emit(out, "sbc\ta,b");
            }
            if (is_signed) {
                int n = cmp_label_counter++;
                emit(out, "jp\tpo,L_f%d_cmp_ok_%d", func_emit_idx, n);
                emit(out, "xor\t0x80");
                fprintf(out, "L_f%d_cmp_ok_%d:\n", func_emit_idx, n);
                emit(out, "rla");
            }
            invalidate_hl_cache();
            invalidate_bc_cache();
            if (cur_branch_test_kind != 0) {
                int br_true = (cur_branch_test_kind == IR_BR_COND);
                int want_carry = (cf_true_gt == br_true);
                const char *cc = want_carry ? "c" : "nc";
                emit(out, "jp\t%s,L_f%d_bb_%d",
                     cc, func_emit_idx, cur_branch_test_label);
                cur_skip_next_op = 1;
                return 0;
            }
            carry_to_bool(out, cf_true_gt);
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        /* Swap operand load to reuse the same ordering arithmetic. */
        load_to_de(out, f, op->src[0]);
        load_to_hl(out, f, op->src[1]);
        emit(out, "and\ta");
        emit(out, "sbc\thl,de");
        if (is_signed) signed_result_to_carry(out);
        int cf_true = cf_true_gt;
        if (cur_branch_test_kind != 0) {
            int br_true = (cur_branch_test_kind == IR_BR_COND);
            int want_carry = (cf_true == br_true);
            const char *cc = want_carry ? "c" : "nc";
            emit(out, "jp\t%s,L_f%d_bb_%d",
                 cc, func_emit_idx, cur_branch_test_label);
            int saved_de = cur_de_vreg;
            invalidate_hl_cache();
            cur_de_vreg = saved_de;
            cur_skip_next_op = 1;
            return 0;
        }
        carry_to_bool(out, cf_true);
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }

    case IR_CMP_EQ: case IR_CMP_NE: {
        /* Long compare (#340): byte-wise XOR-then-OR chain that sets Z
           iff all 4 bytes match. dst is width 2 (the bool result) even
           though the operands are width 4. */
        int src0w = (op->src[0] >= 0) ? f->vregs[op->src[0]].width : 0;
        if (src0w == 4) {
            int z_true_long = (op->kind == IR_CMP_EQ);
            if (op->src[1] == -1) {
                /* Const-RHS: XOR each of DEHL's bytes against the const
                   bytes; OR the 4 results together. Z set iff equal. */
                uint32_t k = (uint32_t)op->imm;
                uint8_t b0 = (uint8_t)(k & 0xff);
                uint8_t b1 = (uint8_t)((k >> 8) & 0xff);
                uint8_t b2 = (uint8_t)((k >> 16) & 0xff);
                uint8_t b3 = (uint8_t)((k >> 24) & 0xff);
                load_to_dehl(out, f, op->src[0]);
                emit(out, "ld\ta,l");
                if (b0) emit(out, "xor\t%u", (unsigned)b0);
                emit(out, "ld\tc,a");
                emit(out, "ld\ta,h");
                if (b1) emit(out, "xor\t%u", (unsigned)b1);
                emit(out, "or\tc");
                emit(out, "ld\tc,a");
                emit(out, "ld\ta,e");
                if (b2) emit(out, "xor\t%u", (unsigned)b2);
                emit(out, "or\tc");
                emit(out, "ld\tc,a");
                emit(out, "ld\ta,d");
                if (b3) emit(out, "xor\t%u", (unsigned)b3);
                emit(out, "or\tc");
            } else if (!fp_active(f) && !dehl_has(op->src[1])) {
                /* Var-RHS sp-rel: point HL at &RHS, XOR through (hl).
                   BC mirrors LHS low half via DEHL cache invariant. */
                load_to_dehl(out, f, op->src[0]);
                int off = slot_off(f, op->src[1]);
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");
                emit(out, "ld\ta,c");
                emit(out, "xor\t(hl)");
                emit(out, "ld\tc,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,b");
                emit(out, "xor\t(hl)");
                emit(out, "or\tc");
                emit(out, "ld\tc,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,e");
                emit(out, "xor\t(hl)");
                emit(out, "or\tc");
                emit(out, "ld\tc,a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,d");
                emit(out, "xor\t(hl)");
                emit(out, "or\tc");
            } else {
                /* RHS already in DEHL cache or FP-mode: load both and
                   XOR through registers. Less common. */
                load_to_dehl(out, f, op->src[1]);
                emit(out, "push\tde");
                emit(out, "push\thl");
                load_to_dehl_adj(out, f, op->src[0], 4);
                emit(out, "pop\tbc");          /* BC = RHS low */
                emit(out, "ld\ta,l");
                emit(out, "xor\tc");
                emit(out, "ld\tc,a");
                emit(out, "ld\ta,h");
                emit(out, "xor\tb");
                emit(out, "or\tc");
                emit(out, "ld\tc,a");
                emit(out, "pop\thl");          /* HL = RHS high */
                emit(out, "ld\ta,e");
                emit(out, "xor\tl");
                emit(out, "or\tc");
                emit(out, "ld\tc,a");
                emit(out, "ld\ta,d");
                emit(out, "xor\th");
                emit(out, "or\tc");
            }
            invalidate_hl_cache();
            invalidate_bc_cache();
            if (cur_branch_test_kind != 0) {
                int br_true = (cur_branch_test_kind == IR_BR_COND);
                int want_z = (z_true_long == br_true);
                const char *cc = want_z ? "z" : "nz";
                emit(out, "jp\t%s,L_f%d_bb_%d",
                     cc, func_emit_idx, cur_branch_test_label);
                cur_skip_next_op = 1;
                return 0;
            }
            emit(out, "ld\thl,0");
            emit(out, "jr\t%s,ASMPC+3", z_true_long ? "nz" : "z");
            emit(out, "inc\tl");
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        /* Equality is sign-independent. `or a; sbc hl,de` → Z = equal. */
        load_binop_operands(out, f, op);
        emit(out, "or\ta");
        emit(out, "sbc\thl,de");
        int z_true = (op->kind == IR_CMP_EQ);
        if (cur_branch_test_kind != 0) {
            int br_true = (cur_branch_test_kind == IR_BR_COND);
            int want_z = (z_true == br_true);
            const char *cc = want_z ? "z" : "nz";
            emit(out, "jp\t%s,L_f%d_bb_%d",
                 cc, func_emit_idx, cur_branch_test_label);
            int saved_de = cur_de_vreg;
            invalidate_hl_cache();
            cur_de_vreg = saved_de;
            cur_skip_next_op = 1;
            return 0;
        }
        emit(out, "ld\thl,0");
        emit(out, "jr\t%s,ASMPC+3", z_true ? "nz" : "z");
        emit(out, "inc\tl");
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }

    case IR_CONV_ZX: {
        int src_w = f->vregs[op->src[0]].width;
        int dst_w = f->vregs[op->dst].width;
        if (src_w == 1 && dst_w == 2) {
            load_byte_to_a(out, f, op->src[0]);
            /* PR_DE: write into E,D directly. Same instruction count
               as L,H but no spill follows. */
            if (vreg_is_pr_de(f, op->dst)) {
                emit(out, "ld\te,a");
                emit(out, "ld\td,0");
                cache_de(op->dst);
                return 0;
            }
            emit(out, "ld\tl,a");
            emit(out, "ld\th,0");
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        if (src_w == 1 && dst_w == 4) {
            /* Char → long zero-extend: A into L, clear H/E/D. */
            load_byte_to_a(out, f, op->src[0]);
            emit(out, "ld\tl,a");
            emit(out, "ld\th,0");
            emit(out, "ld\tde,0");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        if (src_w == 2 && dst_w == 4) {
            /* Int → long zero-extend: load HL, clear DE. */
            load_to_hl(out, f, op->src[0]);
            emit(out, "ld\tde,0");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        if (src_w == 2 && dst_w == 2) {     /* identity */
            load_to_hl(out, f, op->src[0]);
            store_hl(out, f, op->dst);
            return 0;
        }
        fprintf(stderr, "ir_lower: CONV_ZX %d→%d not supported\n", src_w, dst_w);
        return -1;
    }

    case IR_CONV_SX: {
        int src_w = f->vregs[op->src[0]].width;
        int dst_w = f->vregs[op->dst].width;
        if (src_w == 1 && dst_w == 2) {
            load_byte_to_a(out, f, op->src[0]);
            /* PR_DE: write into E,D. The rlca/sbc-a-a sign-extend
               trick is unchanged — it leaves the extended byte in A,
               we just store to D instead of H. */
            if (vreg_is_pr_de(f, op->dst)) {
                emit(out, "ld\te,a");
                emit(out, "rlca");
                emit(out, "sbc\ta,a");
                emit(out, "ld\td,a");
                cache_de(op->dst);
                return 0;
            }
            emit(out, "ld\tl,a");
            /* Sign-extend A into H via the rlca/sbc-a-a trick:
               rlca rotates bit 7 into CF; sbc a,a fills A with 0 or -1. */
            emit(out, "rlca");
            emit(out, "sbc\ta,a");
            emit(out, "ld\th,a");
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        if (src_w == 1 && dst_w == 4) {
            /* Char → long sign-extend: A's bit 7 fills H, E, D. */
            load_byte_to_a(out, f, op->src[0]);
            emit(out, "ld\tl,a");
            emit(out, "rlca");
            emit(out, "sbc\ta,a");           /* A = 0 or 0xff */
            emit(out, "ld\th,a");
            emit(out, "ld\te,a");
            emit(out, "ld\td,a");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        if (src_w == 2 && dst_w == 4) {
            /* Int → long sign-extend: H's bit 7 fills DE. */
            load_to_hl(out, f, op->src[0]);
            emit(out, "ld\ta,h");
            emit(out, "rlca");
            emit(out, "sbc\ta,a");
            emit(out, "ld\te,a");
            emit(out, "ld\td,a");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        if (src_w == 2 && dst_w == 2) {
            load_to_hl(out, f, op->src[0]);
            store_hl(out, f, op->dst);
            return 0;
        }
        fprintf(stderr, "ir_lower: CONV_SX %d→%d not supported\n", src_w, dst_w);
        return -1;
    }

    case IR_CONV_TRUNC: {
        int src_w = f->vregs[op->src[0]].width;
        int dst_w = f->vregs[op->dst].width;
        if (src_w == 2 && dst_w == 1) {
            load_to_hl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
            store_a_byte(out, f, op->dst);
            return 0;
        }
        if (src_w == 2 && dst_w == 2) {
            load_to_hl(out, f, op->src[0]);
            store_hl(out, f, op->dst);
            return 0;
        }
        if (src_w == 4 && dst_w == 2) {
            /* Long → int: just take the low half (HL of DEHL). */
            load_to_dehl(out, f, op->src[0]);
            store_hl(out, f, op->dst);
            invalidate_hl_cache();
            return 0;
        }
        if (src_w == 4 && dst_w == 1) {
            /* Long → char: take low byte of low half. */
            load_to_dehl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
            store_a_byte(out, f, op->dst);
            invalidate_hl_cache();
            return 0;
        }
        fprintf(stderr, "ir_lower: CONV_TRUNC %d→%d not supported\n", src_w, dst_w);
        return -1;
    }

    case IR_CONV_BYTE_TO_HIGH: {
        int src_w = f->vregs[op->src[0]].width;
        int dst_w = f->vregs[op->dst].width;
        if (src_w == 1 && dst_w == 2) {
            load_byte_to_a(out, f, op->src[0]);
            if (vreg_is_pr_de(f, op->dst)) {
                emit(out, "ld\td,a");
                emit(out, "ld\te,0");
                cache_de(op->dst);
                return 0;
            }
            emit(out, "ld\th,a");
            emit(out, "ld\tl,0");
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        fprintf(stderr, "ir_lower: CONV_BYTE_TO_HIGH %d→%d not supported\n",
                src_w, dst_w);
        return -1;
    }

    /* Variable shifts — inline loop on z80; the allocator+helper path
       comes later. Note: IR_SHR here is LOGICAL (srl/rr). Signed shifts
       would need to dispatch on src kind; the IR design lets the AST
       builder emit an SX-then-SHR pair for arithmetic semantics. */
    case IR_SHL: {
        if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
            if (op->src[1] >= 0) {
                /* Variable-count long shift → l_lsl_dehl helper.
                   Convention: DEHL = value, A = count. Result in DEHL.
                   Helper clobbers AF, B, DE, HL (preserves IX, BC',
                   shadow set — IX-clean by design).

                   Stage count into HL, copy low byte to A, then load
                   value into DEHL. load_to_dehl_adj uses BC/DE/HL for
                   byte staging — it does NOT touch A — so the count
                   in A survives the DEHL load. */
                if (!hl_has(op->src[1]))
                    load_to_hl(out, f, op->src[1]);
                emit(out, "ld\ta,l");
                load_to_dehl(out, f, op->src[0]);
                emit(out, "call\tl_lsl_dehl");
                invalidate_hl_cache();
                invalidate_bc_cache();
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            int count = (int)op->imm & 0x1f;
            /* In-place long << 1 on sp-rel slot (#339). When
               dst == src[0] and the vreg lives in a stack slot,
               shift the 4 bytes in place via `sla (hl); rl (hl);
               rl (hl); rl (hl)` from LSB up. Saves ~50T vs the
               DEHL-load + shift-loop + store roundtrip. Hot in
               crcbench's unrolled `crc >>= 1` chain (well, SHR
               variant). Skipped if dst is dead-after — existing
               path may already skip the slot write.

               sp-rel addressing works in FP mode too — sp is still
               valid and the byte-walk via `ld hl,N; add hl,sp;
               sla (hl); inc hl; rl (hl); ...` is more compact than
               4 × (3B `sla (ix+d)`) in either case. */
            if (count == 1
                && op->dst == op->src[0]
                && !cur_dst_dead
                && !vreg_in_pr_bc(f, op->dst)
                && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
                int off = slot_off(f, op->dst);
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");        /* HL = &slot[0] (LSB) */
                emit(out, "sla\t(hl)");          /* byte0: low bit=0, hi→C */
                emit(out, "inc\thl");
                emit(out, "rl\t(hl)");           /* byte1: C in low, hi→C */
                emit(out, "inc\thl");
                emit(out, "rl\t(hl)");           /* byte2 */
                emit(out, "inc\thl");
                emit(out, "rl\t(hl)");           /* byte3 */
                invalidate_hl_cache();
                invalidate_bc_cache();
                return 0;
            }
            if (count == 0) {
                load_to_dehl(out, f, op->src[0]);
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            if (count >= 32) {
                emit(out, "ld\thl,0");
                emit(out, "ld\tde,0");
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            int byte_shift = count / 8;
            int bit_shift  = count % 8;
            /* Partial-load fastpath: for byte_shift ≥ 1 the high bytes
               of the source are discarded. Skip them at load time and
               write the surviving source bytes directly into their
               final target positions. Only fires on a slot read — if
               DEHL is already cached we keep the existing 2-inst cache
               hit + strength-reduced byte shuffle path. */
            if (byte_shift >= 1 && !dehl_has(op->src[0])) {
                partial_load_long_shl(out, f, op->src[0], byte_shift);
                /* DEHL no longer reflects src[0] as a whole; clear the
                   caches so a subsequent op can't mistake the shifted
                   bytes for the original source. */
                invalidate_hl_cache();
                goto shl_long_bit_shift;
            }
            load_to_dehl(out, f, op->src[0]);
            /* Byte shift left, strength-reduced to a single 4-instruction
               sequence that targets the final byte positions directly.
               Source layout: D=byte3 E=byte2 H=byte1 L=byte0.
               Target after shifting left by `byte_shift` bytes: each
               source byte moves up by `byte_shift`; the lowest
               `byte_shift` bytes become zero. The loop form did this
               iteratively (4 inst × byte_shift); the direct form is
               always 4 inst. */
            switch (byte_shift) {
            case 0: break;
            case 1: /* D=E E=H H=L L=0 */
                emit(out, "ld\td,e");
                emit(out, "ld\te,h");
                emit(out, "ld\th,l");
                emit(out, "ld\tl,0");
                break;
            case 2: /* D=H E=L H=0 L=0; chain the zero through r,r */
                emit(out, "ld\td,h");
                emit(out, "ld\te,l");
                emit(out, "ld\th,0");
                emit(out, "ld\tl,h");
                break;
            case 3: /* D=L E=0 H=0 L=0; chain the zeros */
                emit(out, "ld\td,l");
                emit(out, "ld\te,0");
                emit(out, "ld\th,e");
                emit(out, "ld\tl,h");
                break;
            default: break; /* count<32 ensures byte_shift∈[0,3] */
            }
        shl_long_bit_shift:
            /* Bit shift left through carry. After a partial load,
               the low `byte_shift` bytes are zero — shifting them
               just rotates 0 through the chain. Trim to the bytes
               that actually hold data. Each skipped inst saves 8T
               (sla/rl) per bit_shift iteration.

               For larger bit_shift counts, wrap the body in a
               djnz loop instead of unrolling — small T-state cost
               (~13T per loop trip) for a meaningful byte saving on
               MD5's rotate-heavy hot path. The formula
               `bit_shift * body_sz > body_sz + 4` is the exact
               size break-even (djnz adds ld b,N + djnz = 4 fixed
               bytes). Use the strict form so we never grow code. */
            {
            static const int body_sz_shl[4] = { 5, 6, 4, 2 };
            int body_sz = body_sz_shl[byte_shift];
            int use_djnz = (bit_shift * body_sz > body_sz + 4);
            int iters = use_djnz ? 1 : bit_shift;
            int loop_label = 0;
            if (use_djnz) {
                loop_label = cmp_label_counter++;
                emit(out, "ld\tb,%d", bit_shift);
                fprintf(out, "L_f%d_shl_loop_%d:\n",
                        func_emit_idx, loop_label);
            }
            for (int i = 0; i < iters; i++) {
                switch (byte_shift) {
                case 0: /* all 4 bytes have data */
                    emit(out, "add\thl,hl");
                    emit(out, "rl\te");
                    emit(out, "rl\td");
                    break;
                case 1: /* L=0; H,E,D have data */
                    emit(out, "sla\th");
                    emit(out, "rl\te");
                    emit(out, "rl\td");
                    break;
                case 2: /* L=H=0; only D,E have data */
                    emit(out, "sla\te");
                    emit(out, "rl\td");
                    break;
                case 3: /* L=H=E=0; only D has data */
                    emit(out, "sla\td");
                    break;
                }
            }
            if (use_djnz) {
                emit(out, "djnz\tL_f%d_shl_loop_%d",
                     func_emit_idx, loop_label);
                invalidate_bc_cache();
            }
            }
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Imm count: unroll. Variable count: loop. */
        if (op->src[1] < 0) {
            int count = (int)op->imm & 0x1f;
            /* Shifts of 16+ produce zero — short-circuit before
               touching src[0]. */
            if (count >= 16) {
                if (vreg_is_pr_de(f, op->dst)) {
                    emit(out, "ld\tde,0");
                    cache_de(op->dst);
                    return 0;
                }
                emit(out, "ld\thl,0");
                spill_and_swap_unless_dead(out, f, op->dst);
                cache_hl(op->dst);
                return 0;
            }
            /* Partial-load fastpath for int SHL ≥ 8: only the low
               byte of the source survives, and goes into H of the
               result. Read it directly; skip the high byte. Only
               fires on a slot read. */
            if (count >= 8 && !hl_has(op->src[0])) {
                if (fp_active(f)) {
                    int ix = slot_ix_off(f, op->src[0]);
                    if (fp_offset_fits(ix)) {
                        emit(out, "ld\th,(%s%+d)", frame_reg(), ix);
                        emit(out, "ld\tl,0");
                        goto shl_int_bit_remainder;
                    }
                }
                int off = slot_off(f, op->src[0]);
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");
                emit(out, "ld\th,(hl)");        /* H = byte 0 */
                emit(out, "ld\tl,0");
                goto shl_int_bit_remainder;
            }
            if (!hl_has(op->src[0])) load_to_hl(out, f, op->src[0]);
            /* Strength reduction for shifts of 8+: the high byte of
               the input is shifted out entirely, so the result has
               input's low byte in H and 0 in L. Then any extra shifts
               above 8 are normal `add hl,hl` steps. Saves 8 instructions
               vs the straight unroll for count==8 (the common
               `byte << 8` zero-extend-and-promote pattern). */
            if (count >= 8) {
                emit(out, "ld\th,l");
                emit(out, "ld\tl,0");
            shl_int_bit_remainder:
                for (int k = 8; k < count; k++) emit(out, "add\thl,hl");
            } else {
                for (int k = 0; k < count; k++) emit(out, "add\thl,hl");
            }
            /* PR_DE dst: wrap with ex de,hl. +4 T-states; saves the
               ~28-T spill. HL becomes junk (old DE). */
            if (vreg_is_pr_de(f, op->dst)) {
                emit(out, "ex\tde,hl");
                invalidate_hl_cache();
                cache_de(op->dst);
                return 0;
            }
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        int n = cmp_label_counter++;
        load_binop_operands(out, f, op);    /* HL=src[0], DE=src[1] */
        emit(out, "ld\ta,e");               /* count into A */
        emit(out, "or\ta");
        emit(out, "jr\tz,L_f%d_shift_end_%d", func_emit_idx, n);
        fprintf(out, "L_f%d_shift_loop_%d:\n", func_emit_idx, n);
        emit(out, "add\thl,hl");
        emit(out, "dec\ta");
        emit(out, "jr\tnz,L_f%d_shift_loop_%d", func_emit_idx, n);
        fprintf(out, "L_f%d_shift_end_%d:\n", func_emit_idx, n);
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ex\tde,hl");
            invalidate_hl_cache();
            cache_de(op->dst);
            return 0;
        }
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }

    case IR_SHR: {
        if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
            if (op->src[1] >= 0) {
                /* Variable-count long shift → l_lsr_dehl helper
                   (logical/unsigned — matches IR_SHR semantics; the
                   #289 limitation that IR_SHR is always logical
                   carries through to the variable-count path).
                   Same staging convention as IR_SHL above. */
                if (!hl_has(op->src[1]))
                    load_to_hl(out, f, op->src[1]);
                emit(out, "ld\ta,l");
                load_to_dehl(out, f, op->src[0]);
                emit(out, "call\tl_lsr_dehl");
                invalidate_hl_cache();
                invalidate_bc_cache();
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            int count = (int)op->imm & 0x1f;
            if (count == 0) {
                load_to_dehl(out, f, op->src[0]);
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            if (count >= 32) {
                emit(out, "ld\thl,0");
                emit(out, "ld\tde,0");
                store_dehl_finalize(out, f, op->dst);
                return 0;
            }
            /* In-place long >> 1 on sp-rel slot (#339). When
               dst == src[0] and the vreg lives in a stack slot,
               shift the 4 bytes in place via `srl (hl); rr (hl);
               rr (hl); rr (hl)` from MSB down. Treats the result
               as unsigned (#289 limitation — IR_SHR is logical).
               Hot in crcbench's unrolled `crc >>= 1` per-bit chain.
               Saves ~50T vs the DEHL roundtrip. sp-rel byte-walk
               works in FP mode too. */
            if (count == 1
                && op->dst == op->src[0]
                && !cur_dst_dead
                && !vreg_in_pr_bc(f, op->dst)
                && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
                int off = slot_off(f, op->dst);
                emit(out, "ld\thl,%d", off + 3);
                emit(out, "add\thl,sp");        /* HL = &slot[3] (MSB) */
                emit(out, "srl\t(hl)");          /* byte3: high=0, low→C */
                emit(out, "dec\thl");
                emit(out, "rr\t(hl)");           /* byte2: C→high, low→C */
                emit(out, "dec\thl");
                emit(out, "rr\t(hl)");           /* byte1 */
                emit(out, "dec\thl");
                emit(out, "rr\t(hl)");           /* byte0 */
                invalidate_hl_cache();
                invalidate_bc_cache();
                return 0;
            }
            int byte_shift = count / 8;
            int bit_shift  = count % 8;
            /* Partial-load fastpath: for byte_shift ≥ 1 the low bytes
               of the source are discarded. Skip them at load time. */
            if (byte_shift >= 1 && !dehl_has(op->src[0])) {
                partial_load_long_shr(out, f, op->src[0], byte_shift);
                invalidate_hl_cache();
                goto shr_long_bit_shift;
            }
            load_to_dehl(out, f, op->src[0]);
            /* Byte shift right, strength-reduced. Source layout
               D=byte3 E=byte2 H=byte1 L=byte0; after shifting right by
               `byte_shift` bytes each source byte moves down by that
               many, and the top `byte_shift` bytes become zero. The
               loop form did this iteratively; the direct form is one
               4-instruction sequence regardless of byte_shift. */
            switch (byte_shift) {
            case 0: break;
            case 1: /* L=H H=E E=D D=0 */
                emit(out, "ld\tl,h");
                emit(out, "ld\th,e");
                emit(out, "ld\te,d");
                emit(out, "ld\td,0");
                break;
            case 2: /* L=E H=D E=0 D=0; chain the zero through r,r */
                emit(out, "ld\tl,e");
                emit(out, "ld\th,d");
                emit(out, "ld\te,0");
                emit(out, "ld\td,e");
                break;
            case 3: /* L=D H=0 E=0 D=0; chain the zeros */
                emit(out, "ld\tl,d");
                emit(out, "ld\th,0");
                emit(out, "ld\te,h");
                emit(out, "ld\td,e");
                break;
            default: break;
            }
        shr_long_bit_shift:
            /* After a partial load, the high `byte_shift` bytes are
               zero — shifting them just rotates 0 through the chain.
               Trim to the bytes that actually hold data. Wrap in a
               djnz loop when it strictly saves bytes (mirror of the
               SHL fastpath above). */
            {
            static const int body_sz_shr[4] = { 8, 6, 4, 2 };
            int body_sz = body_sz_shr[byte_shift];
            int use_djnz = (bit_shift * body_sz > body_sz + 4);
            int iters = use_djnz ? 1 : bit_shift;
            int loop_label = 0;
            if (use_djnz) {
                loop_label = cmp_label_counter++;
                emit(out, "ld\tb,%d", bit_shift);
                fprintf(out, "L_f%d_shr_loop_%d:\n",
                        func_emit_idx, loop_label);
            }
            for (int i = 0; i < iters; i++) {
                switch (byte_shift) {
                case 0: /* all 4 bytes have data */
                    emit(out, "srl\td");
                    emit(out, "rr\te");
                    emit(out, "rr\th");
                    emit(out, "rr\tl");
                    break;
                case 1: /* D=0; E,H,L have data */
                    emit(out, "srl\te");
                    emit(out, "rr\th");
                    emit(out, "rr\tl");
                    break;
                case 2: /* D=E=0; only H,L have data */
                    emit(out, "srl\th");
                    emit(out, "rr\tl");
                    break;
                case 3: /* D=E=H=0; only L has data */
                    emit(out, "srl\tl");
                    break;
                }
            }
            if (use_djnz) {
                emit(out, "djnz\tL_f%d_shr_loop_%d",
                     func_emit_idx, loop_label);
                invalidate_bc_cache();
            }
            }
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        if (op->src[1] < 0) {
            int count = (int)op->imm & 0x1f;
            if (count >= 16) {
                if (vreg_is_pr_de(f, op->dst)) {
                    emit(out, "ld\tde,0");
                    cache_de(op->dst);
                    return 0;
                }
                emit(out, "ld\thl,0");
                spill_and_swap_unless_dead(out, f, op->dst);
                cache_hl(op->dst);
                return 0;
            }
            /* Partial-load fastpath for int SHR ≥ 8: only the high
               byte of the source survives, and goes into L of the
               result. Read it directly; skip the low byte. Only fires
               on a slot read (HL cache hit takes the existing path). */
            if (count >= 8 && !hl_has(op->src[0])) {
                if (fp_active(f)) {
                    int ix = slot_ix_off(f, op->src[0]);
                    if (fp_offset_fits(ix + 1)) {
                        emit(out, "ld\tl,(%s%+d)", frame_reg(), ix + 1);
                        emit(out, "ld\th,0");
                        goto shr_int_bit_remainder;
                    }
                }
                int off = slot_off(f, op->src[0]);
                emit(out, "ld\thl,%d", off + 1);
                emit(out, "add\thl,sp");
                emit(out, "ld\tl,(hl)");        /* L = byte 1 */
                emit(out, "ld\th,0");
                goto shr_int_bit_remainder;
            }
            if (!hl_has(op->src[0])) load_to_hl(out, f, op->src[0]);
            /* Mirror of the SHL ≥8 strength reduction: shift right by
               8 just moves H→L and zeros H. Extra `srl l` cycles cover
               the remainder above 8. */
            if (count >= 8) {
                emit(out, "ld\tl,h");
                emit(out, "ld\th,0");
            shr_int_bit_remainder:
                for (int k = 8; k < count; k++)
                    emit(out, "srl\tl");
            } else {
                for (int k = 0; k < count; k++) {
                    emit(out, "srl\th");
                    emit(out, "rr\tl");
                }
            }
            if (vreg_is_pr_de(f, op->dst)) {
                emit(out, "ex\tde,hl");
                invalidate_hl_cache();
                cache_de(op->dst);
                return 0;
            }
            spill_and_swap_unless_dead(out, f, op->dst);
            cache_hl(op->dst);
            return 0;
        }
        int n = cmp_label_counter++;
        load_binop_operands(out, f, op);
        emit(out, "ld\ta,e");
        emit(out, "or\ta");
        emit(out, "jr\tz,L_f%d_shift_end_%d", func_emit_idx, n);
        fprintf(out, "L_f%d_shift_loop_%d:\n", func_emit_idx, n);
        emit(out, "srl\th");
        emit(out, "rr\tl");
        emit(out, "dec\ta");
        emit(out, "jr\tnz,L_f%d_shift_loop_%d", func_emit_idx, n);
        fprintf(out, "L_f%d_shift_end_%d:\n", func_emit_idx, n);
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ex\tde,hl");
            invalidate_hl_cache();
            cache_de(op->dst);
            return 0;
        }
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }

    case IR_BR:
        /* HL state at the destination is captured by bb_hl_out in
           lower_func — no need to invalidate here. */
        emit(out, "jp\tL_f%d_bb_%d", func_emit_idx, op->label);
        return 0;

    case IR_BR_ZERO:
        if (!hl_has(op->src[0])) load_to_hl(out, f, op->src[0]);
        emit(out, "ld\ta,h");
        emit(out, "or\tl");
        emit(out, "jp\tz,L_f%d_bb_%d", func_emit_idx, op->label);
        /* Cache could survive — HL still holds the tested value
           since `or l` is non-destructive of HL. But on the taken
           branch the destination BB invalidates anyway, so we
           preserve here. cur_hl_vreg stays valid. */
        return 0;

    case IR_BR_COND:
        if (!hl_has(op->src[0])) load_to_hl(out, f, op->src[0]);
        emit(out, "ld\ta,h");
        emit(out, "or\tl");
        emit(out, "jp\tnz,L_f%d_bb_%d", func_emit_idx, op->label);
        return 0;

    case IR_RET:
        /* Handled by lower_ret() from the caller's dispatch. */
        fputs("ir_lower: IR_RET dispatched through lower_op\n", stderr);
        return -1;

    case IR_CALL: {
        CallInfo *ci = op->call;
        if (!ci) {
            fputs("ir_lower: IR_CALL with NULL CallInfo\n", stderr);
            return -1;
        }
        if (ci->target == NULL) {
            /* Indirect (function-pointer) call — deferred. */
            fputs("ir_lower: indirect IR_CALL not yet supported\n", stderr);
            return -1;
        }
        if (ci->is_critical)
            emit(out, "di");

        /* PR_BC across calls (#319): callees clobber BC. If the
           function has any PR_BC vreg, save BC around the call. The
           push bc shifts sp by 2; arg-slot offsets pick it up via
           the sp_adj_extra term below; the matching pop bc balances
           after cleanup. Conservative for now — we save unconditionally
           if any PR_BC exists rather than checking per-op liveness. */
        int bc_saved = 0;
        for (int i = 0; i < f->n_vregs; i++) {
            if (f->vreg_to_phys[i] == IR_PR_BC) { bc_saved = 1; break; }
        }
        if (bc_saved) {
            emit(out, "push\tbc");
            /* BC is on the stack — invalidate the cache so reads after
               the call don't think BC still holds the cached vreg. The
               pop bc at the end re-establishes it. cache_bc is re-set
               at function-entry by the prologue (or demand-reloaded). */
        }
        int sp_adj_extra = bc_saved ? 2 : 0;

        /* Push args. SMALLC: left-to-right (matches typical z88dk).
           STDC: right-to-left. CALLEE: same as SMALLC at push time;
           callee just cleans the stack after ret instead of us.
           Width: 16-bit only in this phase.

           Crucial: each `push hl` shifts sp by 2, but our slot loads
           use `add hl,sp`. So before pushing arg #k, sp has moved by
           2*k from its position at IR_CALL entry. We could re-emit
           load_to_hl with an offset bump, but it's simpler to load
           each arg into a 4-byte scratch sequence: load to HL, then
           push immediately. The trick: we adjust the slot offset by
           2*(args already pushed) so the `add hl,sp` lands on the
           original slot. */
        int pushed_bytes = 0;
        int push_step = (ci->abi == IR_ABI_STDC) ? -1 : 1;
        int start    = (ci->abi == IR_ABI_STDC) ? (ci->n_args - 1) : 0;
        for (int k = 0; k < ci->n_args; k++) {
            int i = start + k * push_step;
            int slot = slot_off(f, ci->args[i]);
            int adj  = slot + pushed_bytes + sp_adj_extra;
            int width = f->vregs[ci->args[i]].width;
            if (width == 4) {
                /* Long arg: load via load_to_dehl_adj (DEHL = value),
                   then `push de; push hl` so sp[0]=low, sp[2]=high
                   matching the z88dk lpush() convention. */
                load_to_dehl_adj(out, f, ci->args[i],
                                 pushed_bytes + sp_adj_extra);
                emit(out, "push\tde");
                emit(out, "push\thl");
                pushed_bytes += 4;
            } else if (width == 1) {
                emit(out, "ld\thl,%d", adj);
                emit(out, "add\thl,sp");
                emit(out, "ld\ta,(hl)");
                emit(out, "ld\tl,a");
                emit(out, "ld\th,0");
                emit(out, "push\thl");
                pushed_bytes += 2;
            } else {
                /* Width-2 arg: go through load_to_hl_adj so PR_BC cache
                   hits (`ld l,c; ld h,b`) and FP-relative loads fire. The
                   sp adjustment passed in covers both the bc-save (if any)
                   and prior arg pushes — keeps slot offsets correct
                   relative to the current sp. */
                load_to_hl_adj(out, f, ci->args[i],
                               pushed_bytes + sp_adj_extra);
                emit(out, "push\thl");
                pushed_bytes += 2;
            }
        }

        /* SMALLC variadic ABI: emit `ld a,bytes/2` (or `xor a` if 0)
           immediately before the call. Stdc and fastcall don't need it. */
        if (ci->is_variadic && ci->abi == IR_ABI_SMALLC) {
            int n = pushed_bytes / 2;
            if (n == 0) emit(out, "xor\ta");
            else        emit(out, "ld\ta,%d", n);
        }

        emit(out, "call\t%s%s",
             ir_sym_prefix(ci->target), ir_sym_name(ci->target));

        /* Caller-cleanup for SMALLC and STDC. CALLEE cleans its own.
           Use repeated `pop bc` — preserves DEHL (where long returns
           live) and HL (int returns); each pop is 10T / 1 byte. For
           the int-return case the historic ex/add/ld dance is ~50T
           total which beats N/2 × pop bc only when N >= 10. We
           prefer correctness over the small cycle save and stick
           with pop bc unconditionally; the int-return shape isn't
           hot enough for the dance to matter. */
        if (ci->abi != IR_ABI_CALLEE && pushed_bytes > 0) {
            for (int n = pushed_bytes; n > 0; n -= 2)
                emit(out, "pop\tbc");
        }

        if (ci->is_critical)
            emit(out, "ei");

        /* Restore the BC we pushed before the call. Caches set by the
            prologue PR_BC load are still valid against the popped value
            (the same vreg is in BC again), so no cache_bc/invalidate
            churn needed. */
        if (bc_saved)
            emit(out, "pop\tbc");

        /* Callee clobbers caller-saved registers (HL, DE, BC, A
           and friends). The HL/DE/A caches refer to those clobbered
           regs, so invalidate them. BC needs special handling: when
           we pushed BC via the bc_saved path, the matching pop_bc
           below restores BC's previous contents — the cache stays
           accurate. When we did NOT push BC (no PR_BC vregs), the
           cache may have been advertising HL-mirror contents that
           the call has destroyed; invalidate then. Without this,
           code after a printf call would emit a cache-hit copy
           (`ld l,c; ld h,b`) for a previously-cached vreg, but BC
           actually holds whatever printf left — silently passing
           garbage to the next function. */
        invalidate_hl_cache();
        if (!bc_saved)
            invalidate_bc_cache();
        /* Return value lands in HL (width ≤ 2) or DEHL (width 4) per
           z88dk's smallc/stdc convention. Pick the correct store
           routine from the ret vreg's width — using store_hl for a
           width-4 vreg silently dropped the high half (the bug behind
           crcbench's wrong crc and lglob's missing g.hi). */
        if (ci->ret_vreg >= 0) {
            int ret_w = f->vregs[ci->ret_vreg].width;
            if (ret_w == 4)
                store_dehl_cached(out, f, ci->ret_vreg);
            else
                store_hl(out, f, ci->ret_vreg);
        }
        return 0;
    }

    case IR_HCALL: {
        HelperInfo *hi = op->hcall;
        if (!hi || !hi->name) {
            fputs("ir_lower: IR_HCALL missing HelperInfo\n", stderr);
            return -1;
        }
        if (hi->n_args > 2) {
            fprintf(stderr,
                "ir_lower: IR_HCALL %s with %d args (max 2 in this phase)\n",
                hi->name, hi->n_args);
            return -1;
        }
        /* Z80 runtime convention: helpers take 1st arg in HL, 2nd in DE.
           Return in HL. Use the load_to_hl / load_to_de helpers — they
           handle PARAM_RO (caller-stack offset), PR_BC (BC reload),
           PR_HL (cache hit), and slot reads uniformly. The previous
           inline byte-load path read `f->vreg_spill_slot[v]` directly,
           which returns -1 for non-spilled vregs (PARAM_RO, PR_*) and
           would emit `ld hl,-1; add hl,sp` reading below the frame
           (same bug class as #346's load_to_hl_adj fix).

           Argument order: load v1 → DE first, then v0 → HL. load_to_de
           may clobber HL but load_to_hl doesn't touch DE, so the
           reverse order would lose v1. */
        /* PR_BC across helper calls: runtime helpers like l_mult /
           l_div advertise "alters: af, bc, de, hl" in their headers,
           so BC is clobbered unconditionally. PR_BC LOCAL vregs live
           exclusively in BC (no slot to reload from), so they have
           to be saved across the call. Mirror IR_CALL's save/restore;
           bump cur_sp_adjust by 2 so subsequent slot reads compensate
           for the push. */
        int hc_bc_saved = 0;
        for (int i = 0; i < f->n_vregs; i++) {
            if (f->vreg_to_phys[i] == IR_PR_BC) { hc_bc_saved = 1; break; }
        }
        if (hc_bc_saved) {
            emit(out, "push\tbc");
            cur_sp_adjust += 2;
        }
        if (hi->n_args == 2) {
            load_to_de(out, f, hi->args[1]);
        }
        if (hi->n_args >= 1) {
            load_to_hl(out, f, hi->args[0]);
        }
        emit(out, "call\t%s", hi->name);
        if (hc_bc_saved) {
            emit(out, "pop\tbc");
            cur_sp_adjust -= 2;
        }
        /* Most runtime helpers clobber HL (and often DE/BC). Invalidate
           caches conservatively — store_hl below will re-cache HL as
           the ret vreg if there is one. BC's cache stays valid when
           we saved+restored; otherwise invalidate. */
        invalidate_hl_cache();
        if (!hc_bc_saved)
            invalidate_bc_cache();
        if (hi->ret_vreg >= 0) {
            store_hl(out, f, hi->ret_vreg);
        }
        return 0;
    }

    case IR_CRITICAL_ENTER:
        emit(out, "di");
        return 0;

    case IR_CRITICAL_LEAVE:
        emit(out, "ei");
        return 0;

    case IR_PUSH_DEHL_LONG: {
        /* The long value to save must currently be in DEHL — ir_opt
           inserts the PUSH immediately after a long-producing op so
           DEHL is hot. We rely on the cache: if dehl_has(src[0]) we
           skip the load (free push); otherwise we load it first. */
        if (op->src[0] < 0) {
            fputs("ir_lower: IR_PUSH_DEHL_LONG with no src vreg\n", stderr);
            return -1;
        }
        if (!dehl_has(op->src[0])) {
            load_to_dehl(out, f, op->src[0]);
        }
        emit(out, "push\tde");           /* high half */
        emit(out, "push\thl");           /* low half — popped first */
        cur_sp_adjust += 4;
        /* Option B: advertise the vreg as stack-resident so a later
           long-binop consumer (OR/AND/XOR/ADD/SUB) can absorb it
           directly via its stack-resident fastpath, eliding both the
           POP and a fresh slot spill of the intermediate result. */
        cur_stack_long_top = op->src[0];
        /* After the push, the stack saves the value. DEHL still holds
           it (push doesn't modify registers); the next op may consume
           it or clobber it. */
        return 0;
    }

    case IR_POP_DEHL_LONG: {
        /* Restore the saved long into DEHL. Must be paired with a
           matching IR_PUSH_DEHL_LONG; the stack frame at this point
           must have the saved value on top. */
        if (cur_sp_adjust < 4) {
            fprintf(stderr,
                "ir_lower: IR_POP_DEHL_LONG with insufficient stack "
                "(cur_sp_adjust=%d)\n", cur_sp_adjust);
            return -1;
        }
        emit(out, "pop\thl");            /* low half (pushed last) */
        emit(out, "pop\tde");            /* high half */
        cur_sp_adjust -= 4;
        /* Option B bookkeeping: the staged stack value has been
           materialized back into DEHL, so it's no longer on the
           stack — clear the marker. (For binop consumers ir_opt
           skips the POP entirely; the marker is then consumed by
           the absorbing fastpath. This branch fires for non-binop
           consumers — ST_MEM/NOT/NEG/SHL/SHR — which need DEHL.) */
        if (cur_stack_long_top == op->src[0])
            cur_stack_long_top = -1;
        /* src[0] is the vreg that's now in DEHL — register it for
           the cache so subsequent ops can use it via cache hit. */
        if (op->src[0] >= 0) {
            /* The DEHL cache invariant wants BC = low half. Mirror
               HL → BC so the cache state is consistent. */
            emit(out, "ld\tb,h");
            emit(out, "ld\tc,l");
            cache_dehl(op->src[0]);
        } else {
            invalidate_hl_cache();
            invalidate_bc_cache();
        }
        return 0;
    }

    case IR_ASM:
        if (op->asm_text) {
            /* Raw passthrough — text is one or more newline-separated lines
               that the user wrote inside __asm{}. Emit verbatim. */
            fputs(op->asm_text, out);
            if (op->asm_text[0] && op->asm_text[strlen(op->asm_text) - 1] != '\n')
                fputc('\n', out);
        }
        return 0;

    default:
        fprintf(stderr, "ir_lower: unsupported op %s (kind=%d)\n",
                ir_op_name(op->kind), (int)op->kind);
        return -1;
    }
}

/* The RET case above has a bug — sp restore clobbers HL after the
   return-value load. Rewrite it cleanly here. */
static int lower_ret(FILE *out, Func *f, const Op *op)
{
    int width = 0;
    if (op->src[0] >= 0) {
        width = f->vregs[op->src[0]].width;
        if (width == 4) {
            load_to_dehl(out, f, op->src[0]);
        } else {
            if (!hl_has(op->src[0]))
                load_to_hl(out, f, op->src[0]);
        }
    }
    if (fp_active(f)) {
        /* FP teardown: IX still holds (frame_top) — saved IX address.
           `ld sp,ix` drops the locals in one go, then `pop ix` restores
           caller's IX. Both ops preserve DEHL (and HL alone), so the
           int-return and long-return paths converge here. The legacy
           BC stash / `ex de,hl` dance the sp-relative path needed is
           moot — IX-as-scratch is the cleaner restore. */
        const char *fr = frame_reg();
        emit(out, "ld\tsp,%s", fr);
        emit(out, "pop\t%s", fr);
    } else if (f->frame_size > 0) {
        if (width == 4) {
            /* Long return: DE holds high half (preserved naturally by
               the sp-adjust). HL holds low half — stash in BC across
               the modstk, then restore. Mirrors sccz80's c_notaltreg
               path with usebc=YES. */
            emit(out, "ld\tb,h");
            emit(out, "ld\tc,l");
            emit(out, "ld\thl,%d", f->frame_size);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");
            emit(out, "ld\th,b");
            emit(out, "ld\tl,c");
        } else {
            /* Preserve HL across the sp restore (int return). */
            emit(out, "ex\tde,hl");
            emit(out, "ld\thl,%d", f->frame_size);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");
            emit(out, "ex\tde,hl");
        }
    }
    emit(out, "ret");
    return 0;
}

/* ----- Function entry --------------------------------------------------- */

/* Count IR_VREG_PARAM vregs and return their total caller-stack width.
   Note: char params are passed as int (2 bytes) by the smallc ABI even
   though the local vreg holds a 1-byte value. */
static int param_stack_width(const Func *f)
{
    int total = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        const VReg *v = &f->vregs[i];
        if (v->flags & IR_VREG_PARAM) {
            int w = (v->width > 0) ? v->width : 2;
            if (w == 1) w = 2;       /* char promoted to int at call site */
            total += w;
        }
    }
    return total;
}

static void emit_prologue(FILE *out, Func *f)
{
    /* FRAMEPTR setup. The walker scaffolding (declparse.c →
       gen_push_frame) already emitted `push ix` to preserve caller's
       IX, but walker FP addressing is disabled so it does NOT load
       `ld ix,0; add ix,sp` — that's our responsibility now. IX must
       be set BEFORE the frame alloc so it captures sp at function
       entry (between locals and caller's frame) for full [-128,+127]
       reach per slot. Teardown is OUR responsibility too because IR
       emits `ret` directly and gen_pop_frame doesn't fire. */
    if (fp_active(f)) {
        const char *fr = frame_reg();
        emit(out, "ld\t%s,0", fr);
        emit(out, "add\t%s,sp", fr);
    }
    /* Allocate the frame. */
    if (f->frame_size > 0) {
        emit(out, "ld\thl,-%d", f->frame_size);
        emit(out, "add\thl,sp");
        emit(out, "ld\tsp,hl");
    }

    /* Copy caller-pushed args into our local frame slots so the rest of
       the lowerer can treat params identically to other vregs. SMALLC
       convention (z88dk default): args pushed left-to-right, so the
       leftmost param sits at the highest sp offset. */
    int args_total = param_stack_width(f);
    int retaddr_off = f->frame_size;       /* return addr sits just above */
    int caller_off = retaddr_off + 2 + args_total; /* top of pushed args */

    /* Walk PARAM vregs in declaration order (creation order). */
    int param_count = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        VReg *v = &f->vregs[i];
        if (!(v->flags & IR_VREG_PARAM)) continue;
        param_count++;
        int width = (v->width > 0) ? v->width : 2;
        /* Char params are pushed as int (2 bytes) by smallc; consume
           2 caller-bytes but only store the low byte into the vreg. */
        int caller_w = (width == 1) ? 2 : width;
        caller_off -= caller_w;
        /* Read-only params live in place on the caller's stack — no
           copy-in. slot_off() returns their caller offset directly so
           later loads/stores in the body walk into the caller frame. */
        if (v->flags & IR_VREG_PARAM_RO) continue;
        if (width == 1) {
            /* Caller pushed a 2-byte int; take its low byte. */
            emit(out, "ld\thl,%d", caller_off);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,(hl)");
            store_a_byte(out, f, v->id);
        } else if (width == 2) {
            load_sp_off_to_hl(out, caller_off);
            store_hl(out, f, v->id);
        } else if (width == 4) {
            /* Long param: read 4 bytes from caller stack into DEHL,
               then store_dehl to the local slot. */
            emit(out, "ld\thl,%d", caller_off);
            emit(out, "add\thl,sp");
            emit(out, "ld\tc,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\tb,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\te,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\td,(hl)");
            emit(out, "ld\tl,c");
            emit(out, "ld\th,b");
            store_dehl(out, f, v->id);
        } else {
            fprintf(stderr,
                "ir_lower: param vreg %d width %d not supported in prologue\n",
                v->id, width);
            continue;
        }
    }
    (void)param_count;

    /* PR_BC pool init (Phase 3 Stage 5 / task #316): emit a prologue
       load for ONE PR_BC vreg — the one whose first use comes earliest
       in body order. Others are loaded on demand at first use via
       emit_bc_reload (called from load_to_hl_adj / load_to_de). When
       there's only one PR_BC vreg (the #310 case), this matches the
       original behaviour exactly.

       PARAM_RO vregs only — LOCAL PR_BC (write-once locals from #318)
       gets its BC stamp at the producer op, not at function entry.
       The producer hasn't executed yet at prologue time; LOCAL vregs
       have no slot allocated (needs_slot=0 because PR_BC) so
       emit_bc_reload's slot read would land at sp-1 (slot_off returns
       -1 for unallocated slots), reading garbage. */
    int prologue_v = -1;
    int prologue_first = -1;
    for (int i = 0; i < f->n_vregs; i++) {
        if (f->vreg_to_phys[i] != IR_PR_BC) continue;
        if (!(f->vregs[i].flags & IR_VREG_PARAM_RO)) continue;
        const LiveRange *lr = ir_live_range(f, i);
        int first = lr ? lr->start : 0;
        if (prologue_v < 0 || (first >= 0 && first < prologue_first)) {
            prologue_v = i;
            prologue_first = first;
        }
    }
    if (prologue_v >= 0)
        emit_bc_reload(out, f, prologue_v);
}

/* Which src position the next op's lowerer loads to DEHL first, for
   the width-4 cache-hit / dead-safe lookahead.

   Returns 0 (src[0] is loaded first), 1 (src[1] is loaded first), or
   -1 (op does not begin with a DEHL load — no recognised pattern).

   The asymmetry vs intuition: long IR_ADD pushes the RHS first (so it
   can pop into BC after computing the LSW), so variable-RHS ADD's
   first load is src[1]. Every other long binop loads src[0] first.
   Const-RHS variants (src[1] == -1) always load src[0] first because
   the literal contributes via immediates, not a DEHL load. */
static int nxt_first_dehl_src(const Op *nxt)
{
    switch (nxt->kind) {
    case IR_ADD:
        return (nxt->src[1] >= 0) ? 1 : 0;
    case IR_SUB:
    case IR_AND: case IR_OR:  case IR_XOR:
    case IR_SHL: case IR_SHR:
    case IR_NEG: case IR_NOT:
    case IR_ST_MEM:
        return 0;
    case IR_PUSH_DEHL_LONG:
        /* Phase D: reads src[0] from DEHL. Matching producer's
           store_dehl_finalize skips its slot spill via the existing
           cur_dehl_dst_dead_safe machinery — the push captures the
           value directly from DEHL with no intermediate slot write. */
        return 0;
    default:
        return -1;
    }
}

/* Is `kind` a commutative long binop where swapping src[0] and src[1]
   preserves semantics? Used by the lookahead to rotate dst into the
   first-loaded src position so the DEHL cache hits. */
static int op_is_commutative(OpKind kind)
{
    return kind == IR_ADD || kind == IR_AND
        || kind == IR_OR  || kind == IR_XOR;
}

int ir_lower_func(FILE *out, Func *f)
{
    if (!f) {
        fputs("ir_lower: null Func\n", stderr);
        return -1;
    }

    /* Liveness must be computed BEFORE ir_alloc / ir_assign_slots —
       both passes use it. ir_alloc populates f->vreg_to_phys; Stage 2
       sets every vreg to IR_PR_SPILL so the rest of the lowerer behaves
       exactly as before. Real assignment is staged in Phase 3 stages
       3-7 (see .tmp/PHASE3_ALLOC_PLAN.md). Stage 1 also runs per-op
       liveness so future allocator stages can read it; the data is
       computed but not yet consumed (zero behavior change). */
    /* IR-level optimisations that mutate the IR shape — must run before
       liveness, since they change which vregs are read where. LICM
       runs first so hoisted ops are visible to the per-BB st2ld / CSE
       passes (which run within the pre-header where the hoisted op
       lands). Returns the number of ops changed (telemetry via
       IR_OPT_VERBOSE). */
    {
        int hoisted = ir_opt_licm(f);
        /* MOV fusion runs BEFORE st2ld: st2ld's load-forwarding
           creates fresh MOVs that consume the same vregs the prologue
           binds to locals (e.g. MD5 Transform's end-of-function
           `buf[i] += a/b/c/d` LD_MEMs get forwarded from the prologue's
           `UINT4 a = buf[0]` load, multiplying v_a's use count).
           Running fuse_mov first eliminates the prologue's MOV before
           st2ld adds those extra uses. */
        int fuse    = ir_opt_fuse_mov(f);
        int fwd     = ir_opt_st2ld(f);
        int symoff  = ir_opt_sym_offset_fold(f);
        int incmhl  = ir_opt_long_inc_mhl(f);
        int cse     = ir_opt_cse(f);
        /* Phase D push/pop insertion runs last — it expects the
           IR to be in its final shape (other passes may delete or
           rewrite ops that would otherwise be candidates). Gated
           behind IR_PHASE_D=1 because option B's win on md5 (-0.9%)
           comes from a specific shape (long-binop consumer absorbs
           the stack value via byte-wise (hl) walk), and we want a
           kill switch while extending coverage to more shapes. */
        int pushes  = (getenv("IR_PHASE_D") != NULL)
                    ? ir_opt_insert_long_pushes(f) : 0;
        if ((hoisted > 0 || fwd > 0 || symoff > 0 || incmhl > 0
             || cse > 0 || fuse > 0 || pushes > 0)
            && getenv("IR_OPT_VERBOSE"))
            fprintf(stderr,
                    "ir_opt: %d licm, %d st2ld, %d symoff, %d incmhl, "
                    "%d cse, %d fuse, %d pushes in func\n",
                    hoisted, fwd, symoff, incmhl, cse, fuse, pushes);
    }

    ir_compute_liveness(f);
    ir_compute_op_liveness(f);
    ir_compute_live_ranges(f);
    ir_alloc(f);
    ir_assign_slots(f);
    /* IR_DUMP_ALLOC=1 in env prints the IR with phys-reg assignments
       and live ranges. Distinct from IR_DUMP (pre-lower) — this fires
       after ir_alloc has populated vreg_to_phys[] and live ranges are
       computed, so the dump reflects the allocator's view. */
    if (getenv("IR_DUMP_ALLOC"))
        ir_dump_func(stderr, f);
    cmp_label_counter = 0;
    func_emit_idx++;
    invalidate_hl_cache();
    invalidate_bc_cache();
    cur_sp_adjust = 0;
    cur_stack_long_top = -1;

    /* No function label here — the surrounding legacy scaffolding
       (declparse.c + codegen.c) already emits `._<name>`. The lowerer
       just emits the prologue + body inside that label. */

    emit_prologue(out, f);

    /* Per-BB hl_out: which vreg HL holds at the end of the BB's
       emission, or -1 if unknown. Used to carry the cache across
       BB boundaries when all already-lowered predecessors agree
       on the HL state. */
    int *bb_hl_out = malloc((size_t)f->n_bbs * sizeof(int));
    int *bb_lowered = calloc((size_t)f->n_bbs, sizeof(int));
    /* Predecessor table: bb_preds[bb] = list of pred bb ids,
       bb_pred_cnt[bb] = length. Derived from succ[] of every BB. */
    int *bb_pred_cnt = calloc((size_t)f->n_bbs, sizeof(int));
    int **bb_preds = calloc((size_t)f->n_bbs, sizeof(int *));
    for (int i = 0; i < f->n_bbs; i++) {
        bb_hl_out[i] = -1;
        for (int s = 0; s < 2; s++) {
            int sb = f->bbs[i].succ[s];
            if (sb >= 0 && sb < f->n_bbs) bb_pred_cnt[sb]++;
        }
    }
    for (int i = 0; i < f->n_bbs; i++) {
        if (bb_pred_cnt[i] > 0)
            bb_preds[i] = malloc(bb_pred_cnt[i] * sizeof(int));
    }
    {
        int *fill = calloc((size_t)f->n_bbs, sizeof(int));
        for (int i = 0; i < f->n_bbs; i++) {
            for (int s = 0; s < 2; s++) {
                int sb = f->bbs[i].succ[s];
                if (sb >= 0 && sb < f->n_bbs)
                    bb_preds[sb][fill[sb]++] = i;
            }
        }
        free(fill);
    }

    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        emit_bb_label(out, bb->id);
        /* Phase D — RPN stack is per-BB. Any outstanding push/pop
           imbalance at BB boundary is a bug: pushes that escape the
           BB would shift sp for unrelated code. Reset cur_sp_adjust
           and assert balance via a debug check (skipped in release —
           assertion left as future hardening). */
        cur_sp_adjust = 0;
        cur_stack_long_top = -1;
        /* Carry the HL cache across the BB boundary when ALL
           predecessors have already been lowered AND agree on
           hl_out, AND that vreg is live-in here. This handles both
           single-pred fall-through and if-else merge points where
           both arms end with the same vreg in HL (typical for
           assigning the same local in both arms of a ternary). */
        int carry = -2; /* -2 = unset, -1 = disagree, >=0 = candidate */
        for (int p = 0; p < bb_pred_cnt[bb->id]; p++) {
            int pid = bb_preds[bb->id][p];
            if (!bb_lowered[pid]) { carry = -1; break; }
            int v = bb_hl_out[pid];
            if (v < 0) { carry = -1; break; }
            if (carry == -2) carry = v;
            else if (carry != v) { carry = -1; break; }
        }
        if (carry >= 0
            && bb->live_in
            && ir_bitset_get((const BitSet *)bb->live_in, carry)) {
            cur_hl_vreg = carry;
            /* DE / DEHL caches don't survive BB boundaries yet (no
               bb_de_out tracking). Reset them here even when HL
               carries — invalidate_hl_cache would clear cur_hl_vreg
               which we just set. */
            cur_de_vreg = -1;
            cur_dehl_vreg = -1;
        } else {
            invalidate_hl_cache();
        }
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            int rc;

            /* Commutative-swap: if the next op is a commutative long
               binop with dst sitting in the non-first-loaded src slot,
               rotate dst into the first slot so the dead-safe lookahead
               + DEHL cache can fire. Two cases:
                 - IR_ADD var-RHS loads src[1] first. dst-in-src[0] swap.
                 - IR_AND/OR/XOR (any RHS) load src[0] first.
                   dst-in-src[1] swap.
               Gated on width-4 dst, both srcs distinct vregs (no self-
               double-use which would still need the slot), and dst not
               live-out / no other in-BB use (otherwise the slot is
               needed regardless). */
            if (op->dst >= 0
                && f->vregs[op->dst].width == 4
                && j + 1 < bb->n_ops) {
                Op *nxt_m = &bb->ops[j + 1];
                if (op_is_commutative(nxt_m->kind)
                    && nxt_m->src[1] >= 0
                    && nxt_m->src[0] != nxt_m->src[1]) {
                    int first = nxt_first_dehl_src(nxt_m);
                    int other = 1 - first;
                    if (nxt_m->src[other] == op->dst
                        && nxt_m->src[first] != op->dst) {
                        /* Verify no later use of dst would still need
                           the slot (i.e. dst dies at this op). */
                        int dies_here = 1;
                        if (bb->live_out
                            && ir_bitset_get((const BitSet *)bb->live_out, op->dst))
                            dies_here = 0;
                        for (int k = j + 2; k < bb->n_ops && dies_here; k++) {
                            int uses[16];
                            int nu = ir_op_uses(&bb->ops[k], uses,
                                                (int)(sizeof uses / sizeof uses[0]));
                            for (int u = 0; u < nu; u++)
                                if (uses[u] == op->dst) { dies_here = 0; break; }
                        }
                        if (dies_here) {
                            int t = nxt_m->src[0];
                            nxt_m->src[0] = nxt_m->src[1];
                            nxt_m->src[1] = t;
                        }
                    }
                }
            }

            /* Compute dst-dead: the spill of op->dst to its frame slot
               can be skipped because dst's value won't be re-read from
               memory.
               Conditions: dst >= 0, not in bb->live_out, every later
               in-BB use of dst is satisfied by the HL/DEHL cache (which
               does NOT touch the frame). The cache-served pattern is:
               dst is read as the first cache-loaded src of the very
               next op, and that op doesn't also read dst in the other
               src slot. Any other use disqualifies.

               For most ops the first cache-loaded src is src[0] (HL
               cache for ints; DEHL cache for longs). The exception is
               variable-RHS long IR_ADD which loads src[1] first.
               nxt_first_dehl_src() returns the actual first slot for
               recognised long-DEHL ops; we fall back to 0 otherwise so
               int / unrecognised ops keep the original src[0] semantics. */
            cur_dst_dead = 0;
            if (op->dst >= 0) {
                int live_out_dst = bb->live_out
                    && ir_bitset_get((const BitSet *)bb->live_out, op->dst);
                if (!live_out_dst) {
                    int safe = 1;
                    int allow_cache_hit = 1; /* one cache-hit use OK */
                    int cache_pos = 0;
                    if (j + 1 < bb->n_ops
                        && f->vregs[op->dst].width == 4) {
                        int p = nxt_first_dehl_src(&bb->ops[j + 1]);
                        if (p >= 0) cache_pos = p;
                    }
                    for (int k = j + 1; k < bb->n_ops && safe; k++) {
                        int uses[16];
                        int nu = ir_op_uses(&bb->ops[k], uses,
                                            (int)(sizeof uses / sizeof uses[0]));
                        for (int u = 0; u < nu; u++) {
                            if (uses[u] != op->dst) continue;
                            int cache_served =
                                allow_cache_hit &&
                                k == j + 1 &&
                                bb->ops[k].src[cache_pos] == op->dst &&
                                bb->ops[k].src[1 - cache_pos] != op->dst;
                            if (!cache_served) { safe = 0; break; }
                            allow_cache_hit = 0;
                        }
                        /* Phase D redef-stop: if this op redefines our
                           dst (e.g. IR_POP_DEHL_LONG dst=v_a after an
                           earlier IR_PUSH_DEHL_LONG src=v_a), subsequent
                           uses pair with the redef, not the producer's
                           original def. Stop walking — the producer's
                           "is this dst dead" question is settled by the
                           uses up to and including the redef-defining
                           op. (The redef itself may consume v_a — that
                           was handled by the cache_served check above.) */
                        if (!safe) break;
                        /* Phase D option B — an IR_PUSH_DEHL_LONG consuming
                           our dst as src[0] is also a lifetime-ender: the
                           value is now on the data stack, and the
                           downstream consumer either pops it (option A,
                           POP redefines v_a — handled by the redef check
                           below) or absorbs it directly off the stack
                           (option B, no POP — the IR-level use in the
                           consumer is satisfied by the stack frame, not
                           by a slot reload). Either way, no slot reload
                           of v_a happens past this PUSH. */
                        if (bb->ops[k].kind == IR_PUSH_DEHL_LONG
                            && bb->ops[k].src[0] == op->dst)
                            break;
                        int defs[2];
                        int nd = ir_op_defs(&bb->ops[k], defs, 2);
                        int redef = 0;
                        for (int d = 0; d < nd; d++) {
                            if (defs[d] == op->dst) { redef = 1; break; }
                        }
                        if (redef) break;
                    }
                    if (safe) cur_dst_dead = 1;
                }
            }

            /* Branch-test lookahead: if op[i+1] is BR_ZERO/COND
               reading op->dst (and dst is dead — guaranteed when
               cur_dst_dead is set, since that requires the next op's
               src[0]==dst pattern), publish the branch info for the
               op's fastpath to consume. */
            cur_branch_test_kind = 0;
            cur_branch_test_label = -1;
            cur_skip_next_op = 0;
            if (cur_dst_dead && j + 1 < bb->n_ops) {
                const Op *nxt = &bb->ops[j + 1];
                if ((nxt->kind == IR_BR_ZERO || nxt->kind == IR_BR_COND)
                    && nxt->src[0] == op->dst) {
                    cur_branch_test_kind = nxt->kind;
                    cur_branch_test_label = nxt->label;
                }
            }

            /* DEHL-cache dead-safety lookahead: for width-4 dsts, work
               out whether we can skip store_dehl entirely. Safe iff the
               next op's emit consumes dst via load_to_dehl(dst) as its
               first DEHL-touching action.

               nxt_first_dehl_src() tells us which src position (0 or 1)
               the next op loads to DEHL first. Variable-RHS long IR_ADD
               returns 1 (RHS pushed first); every other recognised long
               op returns 0. When dst sits in that position, the next
               op's load_to_dehl emits the 2-instruction cache-hit path
               (`ld l,c; ld h,b`) — no slot read, no register clobber. */
            cur_dehl_dst_dead_safe = 0;
            if (cur_dst_dead && op->dst >= 0
                && f->vregs[op->dst].width == 4
                && j + 1 < bb->n_ops) {
                const Op *nxt = &bb->ops[j + 1];
                int pos = nxt_first_dehl_src(nxt);
                if (pos >= 0 && nxt->src[pos] == op->dst) {
                    switch (nxt->kind) {
                    case IR_ST_MEM:
                    case IR_NEG: case IR_NOT:
                    case IR_PUSH_DEHL_LONG:
                        cur_dehl_dst_dead_safe = 1;
                        break;
                    case IR_ADD:
                    case IR_SUB:
                    case IR_AND: case IR_OR:  case IR_XOR:
                        /* Both const-RHS (pos=0, no DEHL load of src[1])
                           and variable-RHS (pos matches first load)
                           are safe — load_to_dehl(dst) hits the cache. */
                        cur_dehl_dst_dead_safe = 1;
                        break;
                    case IR_SHL: case IR_SHR:
                        /* Both const-count and var-count fire — A.1
                           added the var-count path (l_lsl/lsr_dehl
                           helpers, DEHL = value). load_to_dehl(dst)
                           on the helper side hits the cache when dst
                           is already there. */
                        cur_dehl_dst_dead_safe = 1;
                        break;
                    default: break;
                    }
                }
            }

            /* `jp` to the immediately-following BB is dead — the
               label is the next instruction. Elide when this is an
               unconditional IR_BR at end of BB targeting the next
               BB in lowering order. */
            if (op->kind == IR_BR
                && j == bb->n_ops - 1
                && i + 1 < f->n_bbs
                && op->label == f->bbs[i + 1].id) {
                /* HL state unchanged — bb_hl_out captures cur_hl_vreg. */
                continue;
            }

            if (op->kind == IR_RET) {
                rc = lower_ret(out, f, op);
            } else {
                rc = lower_op(out, f, op);
            }
            if (rc != 0) goto cleanup_err;
            if (cur_skip_next_op) {
                j++;  /* the fastpath consumed op[i+1] (the branch) */
            }
        }
        bb_hl_out[bb->id] = cur_hl_vreg;
        bb_lowered[bb->id] = 1;
    }

    free(bb_hl_out);
    free(bb_lowered);
    free(bb_pred_cnt);
    for (int i = 0; i < f->n_bbs; i++) free(bb_preds[i]);
    free(bb_preds);
    ir_free_liveness(f);
    return 0;

cleanup_err:
    free(bb_hl_out);
    free(bb_lowered);
    free(bb_pred_cnt);
    for (int i = 0; i < f->n_bbs; i++) free(bb_preds[i]);
    free(bb_preds);
    ir_free_liveness(f);
    return -1;
}
