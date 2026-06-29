/*
 * ir_lower.c — IR → z80 assembly lowerer.
 *
 * lower_op dispatches each IR op to a gen_<opcode> function. Register
 * caches (HL/DE/BC/A/DEHL) track which vreg currently lives where so
 * a producer's result can be consumed in-register without spilling.
 * ir_alloc populates f->vreg_to_phys with pool assignments (PR_HL,
 * PR_DE, PR_BC, PR_DEHL, PR_SPILL); the lowerer honours those and
 * otherwise falls back to frame slots.
 *
 * z80 only — other CPUs abort at lower_unit.
 */

#include "ccdefs.h"     /* real KIND_* / function-modifier flags / c_banked_style
                           — sets DEFINE_H so ir.h uses the actual enum */
#include "ir_lower.h"
#include "ir_analysis.h"
#include "ir_alloc.h"
#include "ir_opt.h"
#include "ir_match.h"

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

/* Debug-info flags. -cc emits a `; "file":line: source` comment + a
   C_LINE directive per source line transition; -gcline (debug-defc)
   emits the C_LINE only. Owned by data.c; both default off.
   IMPORTANT: when either is on, the `;` comments and C_LINE directives
   interleaved with code stop copt rules matching across them, so debug
   builds give up most post-emit peephole wins — the standard tradeoff
   for line info. Production builds (default) are unaffected. */
extern int c_intermix_ccode;
extern int c_cline_directive;

/* Walker helpers we reuse so the C_LINE / comment format matches
   walker output exactly. gen_emit_line consults globals (Filename /
   currfn); gen_comment consults lineno. Both are walker-time
   cursors — by lowerer time they sit at EOF, so we save/restore
   around the emit. */
extern void  gen_emit_line(int line);
extern void  gen_comment(const char *message);
extern const char *get_source_line(const char *filename, int n);
extern int   lineno;

/* Track the (file, line) of the last C_LINE we emitted so we can
   suppress duplicates within a contiguous run on the same line.
   Reset at the start of every ir_lower_func. */
static const char *cur_emitted_file;
static int         cur_emitted_line;

static void emit_op_cline(const Op *op)
{
    if (!c_intermix_ccode && !c_cline_directive) return;
    if (!op || op->line <= 0) return;
    if (op->line == cur_emitted_line && op->file == cur_emitted_file)
        return;
    int saved_lineno = lineno;
    lineno = op->line;
    if (c_intermix_ccode && op->file) {
        const char *src = get_source_line(op->file, op->line);
        if (src) gen_comment(src);
    }
    gen_emit_line(op->line);
    lineno = saved_lineno;
    cur_emitted_line = op->line;
    cur_emitted_file = op->file;
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

/* HL value cache. Reset at each BB boundary and at any op that
   clobbers HL the cache can't reason about (calls, branches, shifts
   that loop on HL). When the next op reads cur_hl_vreg as src[0] we
   skip the load and use load_to_de_preserve_hl for src[1]. */
static int cur_hl_vreg;

/* Wide-accumulator (FA / __i64_acc) residency cache: the vreg whose
   value currently sits in the accumulator, or -1. Set by gen_acc_binop
   (its result is left in the accumulator); cleared by invalidate_hl_cache
   (so any call / HL-clobbering op drops it). Lets lower_ret skip the
   store+reload round-trip that would otherwise corrupt the math48 FA
   (alt-register set) — and is the wide analog of the HL/DEHL cache. */
static int cur_fa_vreg = -1;

/* Lazy spill (store-on-clobber) — LAZY_SPILL_PLAN.md §11. Behind the
   IR_LAZY_SPILL env gate; the deferral itself is wired in a later step,
   so while `pending_spill_v < 0` (always, until then) every hook below
   is a no-op and codegen is byte-identical regardless of the flag.
   `pending_spill_v` is the width-2 vreg whose slot store has been
   deferred (it rides in HL, I1: pending_spill_v >= 0 ⇒ cur_hl_vreg ==
   pending_spill_v); -1 = nothing pending. `cur_lazy_out`/`cur_lazy_func`
   /`cur_op_idx` give the choke-point flush the emit stream + the
   per-op liveness context (ir_op_live_in) it needs. */
static int          lazy_spill_on;
static int          pending_spill_v = -1;
static FILE        *cur_lazy_out;
static const Func  *cur_lazy_func;
static int          cur_op_idx;

/* DE value cache. Tracks which vreg currently lives in DE; survives
   emits that preserve DE (load_to_hl, add/sbc hl,de, byte ops),
   invalidated where DE is written (load_to_dehl, ex de,hl, pop de,
   calls). */
static int cur_de_vreg;

/* Long-DEHL cache. Tracks which long vreg has its halves split across
   DE (high) and BC (low) — the layout load_to_dehl / store_dehl leave
   behind. Holds while DE *and* BC are preserved. On hit,
   load_to_dehl_adj emits just `ld l,c; ld h,b` instead of the full
   slot load. Hot in md5 Transform's compound `a = (a<<7)|(a>>25); a
   += b` chains. */
static int cur_dehl_vreg;

/* Framepointer mode predicates.

   `fp_active(f)` returns 1 iff the function should use IX/IY as a
   frame pointer. Gated globally by -frameix / -frameiy (which set
   `c_framepointer_is_ix` to 1 / 0 respectively; -1 means off) and
   per-function by __naked. Mirrors the walker's gate.

   `fp_offset_fits(off)` returns 1 iff `off` is in the signed 8-bit
   range that `(ix±d)` addressing supports.

   `frame_reg()` returns "ix" or "iy" matching the user's choice. */
/* True iff entry emitted a `push ix` (gen_push_frame) — i.e. -frameix is on
   for a non-naked function. The saved IX then occupies 2 bytes between the
   locals and the return address on the stack, regardless of whether IX is
   actually used as a frame pointer. */
static int frame_has_saved_fp(const Func *f)
{
    if (!f) return 0;
    if (c_framepointer_is_ix == -1) return 0;
    if (f->is_naked) return 0;
    return 1;
}

static int fp_active(const Func *f)
{
    if (!frame_has_saved_fp(f)) return 0;
    /* Wide-accumulator functions can't keep their frame pointer in IX: the
       acc helpers clobber it. They save/restore IX but address sp-relative. */
    if (f->uses_acc) return 0;
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

static int fastcall_arg_vreg(const Func *f);

static int param_caller_off(const Func *f, int vreg_id)
{
    int fc = fastcall_arg_vreg(f);   /* in HL, not on the caller stack */
    int args_total = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        const VReg *v = &f->vregs[i];
        if ((v->flags & IR_VREG_PARAM) && v->id != fc) {
            int w = (v->width > 0) ? v->width : 2;
            if (w == 1 && !(f->flags & SDCCDECL)) w = 2; /* char→int (smallc) / 1B (sdccdecl) */
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
    int retaddr_off = f->frame_size + (frame_has_saved_fp(f) ? 4 : 2)
                    + (f->returns_longlong ? 2 : 0)
                    /* interrupt push-all (12) / critical l_push_di (2) sit
                       between the locals and the return address. */
                    + (f->is_interrupt ? 12 : ((f->flags & CRITICAL) ? 2 : 0));
    /* Push order sets the layout: SMALLC/CALLEE L→R (param0 highest), STDC
       / __z88dk_sdccdecl R→L (param0 lowest — just above the return addr).
       Must match emit_prologue. */
    int rl_layout = !(f->flags & SMALLC) && !(f->flags & CALLEE)
                  && !(f->flags & FASTCALL);
    int base = retaddr_off + f->params_offset;
    int caller_off = rl_layout ? base : (base + args_total);
    for (int i = 0; i < f->n_vregs; i++) {
        const VReg *v = &f->vregs[i];
        if (!(v->flags & IR_VREG_PARAM)) continue;
        if (v->id == fc) continue;   /* fastcall arg: in a slot, not caller-pushed */
        int width = (v->width > 0) ? v->width : 2;
        int caller_w = (width == 1) ? ((f->flags & SDCCDECL) ? 1 : 2) : width;
        /* For byte params, the caller's slot is the low byte of the
           pushed int — same sp offset. */
        if (rl_layout) {
            if (v->id == vreg_id) return caller_off;
            caller_off += caller_w;
        } else {
            caller_off -= caller_w;
            if (v->id == vreg_id) return caller_off;
        }
    }
    return -1;  /* shouldn't happen — caller verified PARAM flag */
}

/* Sp-relative byte offset of a vreg's slot (post-prologue SP). The
   lowerer addresses slots via the `ld hl,N; add hl,sp; ld _,(hl)...`
   byte-pair sequence. PARAM_IN_PLACE vregs return their caller-pushed-arg
   offset directly. */
static int slot_off(const Func *f, int vreg_id)
{
    if (f->vregs[vreg_id].flags & IR_VREG_PARAM_IN_PLACE)
        return param_caller_off(f, vreg_id);
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
static int  de_has(int v);
static int  a_has(int v);
static int  dehl_has(int v);
static void cache_de(int v);
static void cache_bc(int v);
static void cache_dehl(int v);
static void invalidate_hl_cache(void);
static void invalidate_de_cache(void);

/* The single choke point through which HL's logical tenant changes.
   `hl_about_to_change(v_new)` is called immediately before HL is loaded
   or clobbered: v_new is the vreg that will newly occupy HL, or -1 when
   HL becomes junk. Every clobber/load write of cur_hl_vreg routes
   through here so the lazy-spill machinery (later stage) has exactly one
   place to flush a pending slot store before the value leaves HL. In
   this stage the body is a pure setter — no emit — so codegen is
   unchanged.

   `swap_hl_de_caches()` is the sibling choke point for `ex de,hl`: the
   HL tenant MOVES to DE (it is not clobbered), so swaps route here
   rather than through hl_about_to_change. */
static void hl_about_to_change(int v_new);
static void swap_hl_de_caches(void);

/* Lazy-spill choke-point helpers (LAZY_SPILL_PLAN.md §11). Defined
   below, after cur_bb / store_hl / the cache helpers are all visible.
   `pending_spill_resolve` is called from hl_about_to_change when HL is
   about to be clobbered with a different tenant: it flushes the pending
   store (if the value is still live) or discards it (if dead/redefined). */
static void pending_spill_flush(void);
static void pending_spill_resolve(void);

/* Static lazy-spill recording hooks (defined below, after the cache
   helpers). Called from the slot-read/write emitters above their
   definitions. */
static void ss_note_reload(const Func *f, int v);
static void ss_note_store(const Func *f, int v);
static void ss_note_cache_read(const Func *f, int v);
static int  ss_store_dead_here(void);

/* One lowering pass of a function: prologue + the per-BB emit loop.
   Run once for the flag-off (single-pass) path, twice for the lazy-spill
   two-pass path (pass 1 deferral-off to a scratch stream to populate the
   complete bb_hl_out HL-tenant map, pass 2 for real with deferral on and
   the cross-BB defer decision consulting bb_hl_out_p1). func_emit_idx is
   NOT bumped here — both passes share the same labels. See
   LAZY_SPILL_PLAN.md §11.6 / the two-pass design. */
static int lower_func_render(FILE *out, Func *f, int lazy,
                             const int *bb_hl_out_p1,
                             int *bb_hl_out, int *bb_lowered,
                             int *bb_pending_out,
                             const int *bb_pred_cnt, int *const *bb_preds,
                             const int *bb_alias);

/* Data-stack sp adjustment — see comment at cur_stack_long_top below.
   Forward-defined here because the load_to_* wrappers depend on it. */
static int cur_sp_adjust;

/* Materialize the ADDRESS of a vreg's frame slot into HL — for the
   wide-accumulator helpers (dload/dstore/dldpsh take the address in HL).
   sp-mode: `ld hl,off+adj; add hl,sp`. fp-mode: `HL = frame_reg + ix_off`
   (no `add hl,ix`, so push/pop the frame reg then add the offset via DE;
   `adj` — the prior-push sp shift — does NOT apply since IX is fixed).
   Clobbers DE in fp-mode (acc callers invalidate DE around the call). */
static void emit_acc_slot_addr(FILE *out, const Func *f, int vreg, int adj)
{
    if (fp_active(f)) {
        int ixoff = slot_ix_off(f, vreg);
        emit(out, "push\t%s", frame_reg());
        emit(out, "pop\thl");
        if (ixoff) {
            emit(out, "ld\tde,%d", ixoff);
            emit(out, "add\thl,de");
        }
    } else {
        emit(out, "ld\thl,%d", slot_off(f, vreg) + cur_sp_adjust + adj);
        emit(out, "add\thl,sp");
    }
}

/* Wide memory-accumulator primitive name for `vreg`, dispatched on its
   KIND. A width-8 vreg can be either a `long long` (`__i64_acc` / fixed
   `l_i64_*` set) or an 8-byte `double` (mbf64), and both may be live in
   one function — so the family can't be a Func-global; it keys off the
   vreg. Non-long-long wide kinds use the maths-mode names ir_build stored
   on the Func. `which` is "load"/"store"/"push"/"loadpush"; returns NULL
   for the (absent) i64 loadpush so the caller falls back to load+push. */
static const char *acc_prim(const Func *f, int vreg, const char *which)
{
    if (vreg >= 0 && f->vregs[vreg].kind == KIND_LONGLONG) {
        if (!strcmp(which, "load"))  return "l_i64_load";
        if (!strcmp(which, "store")) return "l_i64_store";
        if (!strcmp(which, "push"))  return "l_i64_push";
        return NULL;                 /* no combined loadpush for i64 */
    }
    if (!strcmp(which, "load"))     return f->acc_load;
    if (!strcmp(which, "store"))    return f->acc_store;
    if (!strcmp(which, "push"))     return f->acc_push;
    if (!strcmp(which, "loadpush")) return f->acc_loadpush;
    return NULL;
}

/* Emit the accumulator store for `vreg` given its destination address in
   HL. The float d* / l_f64_ store takes the address in HL; l_i64_store
   wants it in BC (the acc_store_bc convention), so move it first for the
   long long family. */
static void emit_acc_store_hl(FILE *out, const Func *f, int vreg)
{
    if (vreg >= 0 && f->vregs[vreg].kind == KIND_LONGLONG) {
        emit(out, "ld\tb,h");
        emit(out, "ld\tc,l");
    }
    emit(out, "call\t%s", acc_prim(f, vreg, "store"));
}

/* __addressmod (named address spaces). A namespaced symbol's bank must be
   paged into the address window (a call to the page-in function) before a
   direct access. The page function preserves HL/DE (the value registers)
   and IX/IY but may CLOBBER AF/BC (the MSX mapper page fn does `ld c,n;
   ld a,(hl)`). So we conservatively bracket the call with push/pop bc to
   protect a BC-resident vreg and invalidate the A cache; HL/DE survive by
   contract, so the access value (in HL/DEHL) is intact. (When __preserve_regs
   is modelled on the page fn's Type, the push/pop bc can be elided if BC is
   declared preserved.) `cur_bank_fn` dedups consecutive same-space accesses;
   it resets at each BB boundary and after any call. Used for DIRECT (MEM_SYM)
   access; indirect array/pointer access still bails (the namespace is lost
   in the address computation). */
static void invalidate_a_cache(void);
static const SYMBOL *cur_bank_fn;
static void emit_ns_switch(FILE *out, const SYMBOL *bf)
{
    if (!bf || bf == cur_bank_fn) return;
    emit(out, "push\tbc");
    emit(out, "call\t%s%s", ir_sym_prefix(bf), ir_sym_name(bf));
    emit(out, "pop\tbc");
    invalidate_a_cache();
    cur_bank_fn = bf;
}
/* The page-in fn for a memory access. Indirect (array/pointer) access
   carries it on MemOp.bank_fn (ir_build recovered it from the pointee/
   element type); the symoff matcher fold preserves that field when it
   rewrites such a load into MEM_SYM (`arr[2]` → `_arr+4`). Direct scalar
   MEM_SYM access leaves bank_fn NULL and resolves it from the symbol. */
static const SYMBOL *mem_bank_fn(const MemOp *m)
{
    if (m->bank_fn) return m->bank_fn;
    if (m->kind == IR_MEM_SYM) return ir_sym_bank_fn(m->sym);
    return NULL;
}
/* Taking the ADDRESS of a namespaced scalar (IR_LD_SYM) still bails — the
   namespace escapes into a plain pointer the deref site can't recover.
   (Indirect load/store IS handled: it carries MemOp.bank_fn.) */
static int ns_sym_bails(const SYMBOL *sym)
{
    return sym && ir_sym_bank_fn(sym) != NULL;
}

/* One-shot flag forward decls (definitions further down with the
   rest of the lookahead state). Need to be visible to
   load_to_dehl_adj / store_dehl which sit above the cache helpers. */
static int cur_load_to_dehl_no_hl;
static int cur_load_to_dehl_no_bc;

/* vreg sitting on top of the data stack from an IR_PUSH_DEHL_LONG,
   waiting to be consumed by a long-binop with its stack-resident
   variant (ADD/SUB/AND/OR/XOR). -1 when nothing staged. Reset at BB
   boundaries. Cleared by the consumer that absorbs it OR by an
   explicit IR_POP_DEHL_LONG (for consumers — ST_MEM/NOT/NEG/SHL/SHR —
   whose lowering needs the value in DEHL). */
static int cur_stack_long_top;

/* Chain-OR accumulate: when a SPILL long intermediate has a single
   in-BB consumer at distance >1 that is a long OR/AND/XOR, push the
   value to the data stack (3 instr) instead of writing to a frame slot
   (10 instr). The consumer's gen_bitop fused-(hl) path absorbs it
   directly using off=4. One slot at a time; cleared when consumed or
   at BB boundaries. */
static int cur_dehl_inline_push;         /* vreg pushed inline, -1=none */
static int cur_dehl_inline_push_base_sp; /* cur_sp_adjust at push time */
static int cur_dehl_push_to_stack;       /* one-shot flag: set by lookahead */

/* Load a PR_BC vreg's slot value into BC. Used both by the prologue
   (function entry) and by on-demand reload sites — when a PR_BC vreg
   is read but `cur_bc_vreg` holds a different occupant, the reader
   fires this to swap BC's contents. Caller is responsible for calling
   `cache_bc(vreg_id)` after; we don't do it here because the prologue
   wants the cache set, the on-demand path wants it set before the
   ld l,c / ld e,c emit. */
static void emit_bc_reload(FILE *out, const Func *f, int vreg_id, int sp_adj)
{
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            emit(out, "ld\tbc,(%s%+d)", frame_reg(), ix_off);
            cache_bc(vreg_id);
            return;
        }
    }
    int off = slot_off(f, vreg_id) + cur_sp_adjust + sp_adj;
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

/* Width-4 byte-arithmetic fastpath gate. True for KIND_LONG,
   KIND_LONGLONG, KIND_ACCUM32 (ADD/SUB bit-identical to integer);
   false for float/double which need FP helpers. Numeric KIND
   uses the real KIND_* enum (ir_lower includes ccdefs.h). */
static int vreg_kind_is_integer(const Func *f, int vreg_id)
{
    if (!f || vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    Kind k = f->vregs[vreg_id].kind;
    return k == KIND_CHAR || k == KIND_SHORT || k == KIND_INT
        || k == KIND_LONG || k == KIND_PTR || k == KIND_CPTR
        || k == KIND_LONGLONG || k == KIND_ACCUM32;
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
    if (hl_has(vreg_id) && sp_adj == 0) { ss_note_cache_read(f, vreg_id); return; }
    /* Every path below clobbers HL (with vreg_id, or with a slot
       address). If a width-2 spill is pending in HL, flush/discard it
       here, while HL still holds it (LAZY_SPILL_PLAN.md §11). Dormant
       until the deferral step sets pending_spill_v. */
    pending_spill_resolve();
    /* PR_BC hit: skip the slot reload and copy from BC. 2 instructions
       vs the 6 the slot-read path emits. Only fires for width-2 vregs;
       ir_alloc enforces width=2 for PR_BC, but guard width anyway in
       case any caller passes a different vreg id. */
    if (bc_has(vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit(out, "ld\thl,bc");
        hl_about_to_change(vreg_id);
        return;
    }
    /* PR_BC miss with PR_BC allocation: another PR_BC tenant currently
       occupies BC. Reload this vreg's value from its slot, then take
       the cache-hit path. Cost ≤ the regular slot read (the FP-active
       case is a single `ld bc,(ix+d)` synthetic), and unlocks the
       cheap `ld hl,bc` recovery. */
    if (vreg_in_pr_bc(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        emit_bc_reload(out, f, vreg_id, sp_adj);
        emit(out, "ld\thl,bc");
        hl_about_to_change(vreg_id);
        return;
    }
    int width = f->vregs[vreg_id].width;
    /* A-cache hit for byte vregs: a dead-skipped byte producer left
       the value ONLY in A (cache_a, no slot store) — the slot read
       below would return garbage. Serves any consumer that widens
       through this path (compares, binop operands). */
    if (width == 1 && a_has(vreg_id)) {
        emit(out, "ld\tl,a");
        emit(out, "ld\th,0");
        hl_about_to_change(vreg_id);
        return;
    }
    /* Past every register-cache hit: a real slot read follows on every
       remaining path → record it for the dead-store analysis. */
    ss_note_reload(f, vreg_id);
    int off = slot_off(f, vreg_id) + sp_adj + cur_sp_adjust;
    /* FP-relative fast path. IX captures sp at function entry, so its
       offset to any slot is invariant under push/pop activity — sp_adj
       is irrelevant for IX addressing. */
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (width == 1 && fp_offset_fits(ix_off)) {
            emit(out, "ld\tl,(%s%+d)", frame_reg(), ix_off);
            emit(out, "ld\th,0");
            hl_about_to_change(vreg_id);
            return;
        }
        if (width == 2 && fp_offset_fits(ix_off)
            && fp_offset_fits(ix_off + 1)) {
            emit(out, "ld\thl,(%s%+d)", frame_reg(), ix_off);
            hl_about_to_change(vreg_id);
            return;
        }
    }
    if (width == 1) {
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\ta,(hl)");
        emit(out, "ld\tl,a");
        emit(out, "ld\th,0");
        hl_about_to_change(vreg_id);
        return;
    }
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\ta,(hl)");
    emit(out, "inc\thl");
    emit(out, "ld\th,(hl)");
    emit(out, "ld\tl,a");
    hl_about_to_change(vreg_id);
}

static void load_to_hl(FILE *out, const Func *f, int vreg_id)
{
    /* sp_adj here is the caller's LOCAL adjustment;
       cur_sp_adjust (outstanding stack-saved longs) is added inside
       load_to_hl_adj's slot-read path. */
    load_to_hl_adj(out, f, vreg_id, 0);
}

/* Load 16-bit value into DE (used for binop second operand).
   Cache-aware: if DE already holds the wanted vreg, no-op. Else if
   HL holds it, `ex de,hl` is a single-instruction shortcut. Else
   load via HL then ex de,hl. After: cur_de_vreg = vreg_id; HL
   holds whatever DE was (junk to the caller). */
static void load_to_de(FILE *out, const Func *f, int vreg_id)
{
    if (cur_de_vreg == vreg_id && vreg_id >= 0) {
        ss_note_cache_read(f, vreg_id);
        return;
    }
    /* PR_BC hit: copy DE from BC directly. 2 instructions, doesn't
       disturb HL — better than load-via-HL-then-swap. */
    if (bc_has(vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit(out, "ld\te,c");
        emit(out, "ld\td,b");
        cache_de(vreg_id);
        return;
    }
    /* PR_BC miss with PR_BC allocation: reload BC then take the BC→DE
       cache-hit path. Doesn't touch HL. */
    if (vreg_in_pr_bc(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        emit_bc_reload(out, f, vreg_id, 0);
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
            ss_note_reload(f, vreg_id);
            emit(out, "ld\tde,(%s%+d)", frame_reg(), ix_off);
            cache_de(vreg_id);
            return;
        }
    }
    if (cur_hl_vreg == vreg_id && vreg_id >= 0) {
        /* Served from HL (no slot read) — record the cache hit. */
        ss_note_cache_read(f, vreg_id);
        /* The wanted value is in HL. If it is the pending spill (I1:
           pending_spill_v == cur_hl_vreg == vreg_id), flushing it writes
           the slot AND leaves it in DE (store_hl's internal `ex de,hl`)
           — the swap's exact result — so resolve instead of swapping
           (LAZY_SPILL_PLAN.md §11). Dormant until the deferral step. */
        if (lazy_spill_on && pending_spill_v == vreg_id) {
            pending_spill_flush();   /* DE := vreg_id, slot written */
            cache_de(vreg_id);
            return;
        }
        emit(out, "ex\tde,hl");
        /* HL ↔ DE swap: caches swap too. cur_hl now has what DE held
           (the old cur_de_vreg or -1); cur_de gets what HL held. */
        swap_hl_de_caches();
        return;
    }
    /* sp-rel direct-to-DE byte walk for width=2. Writes E,D directly
       through (hl) without the trailing `ld l,a` that load_to_hl
       needs to assemble HL from a temp byte. Saves 1 byte vs
       load_to_hl + ex de,hl. HL is clobbered (same as the ex de,hl
       form when DE held junk — common). */
    if (f->vregs[vreg_id].width == 2) {
        /* sp-rel byte walk clobbers HL with the slot address — flush a
           pending spill first (here vreg_id != pending_spill_v; the
           equal case was handled by the swap path above). Dormant. */
        pending_spill_resolve();
        ss_note_reload(f, vreg_id);
        int off = slot_off(f, vreg_id) + cur_sp_adjust;
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\te,(hl)");
        emit(out, "inc\thl");
        emit(out, "ld\td,(hl)");
        hl_about_to_change(-1);
        cache_de(vreg_id);
        return;
    }
    load_to_hl(out, f, vreg_id);
    emit(out, "ex\tde,hl");
    swap_hl_de_caches();
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
            emit_bc_reload(out, f, vreg_id, 0);
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

/* Load 8-bit value from a vreg's frame slot into A. Cache-aware:
   if A already holds the wanted vreg (set by a prior IR_LD_MEM_VREG
   width=1 dead-skip or similar), skip the slot read entirely. */
static void load_byte_to_a(FILE *out, const Func *f, int vreg_id)
{
    if (a_has(vreg_id)) return;
    /* Byte values held in HL/DE keep the meaningful byte in the low
       register (L / E) — z80 little-endian. Honour those caches so
       a producer that left the byte in HL via the cur_dst_dead path
       (no spill) is still readable. */
    if (hl_has(vreg_id)) { ss_note_cache_read(f, vreg_id); emit(out, "ld\ta,l"); return; }
    if (de_has(vreg_id)) { ss_note_cache_read(f, vreg_id); emit(out, "ld\ta,e"); return; }
    /* Past the register-cache hits: a slot read follows (fp or sp). For a
       width-2 deferrable vreg this is a partial reload of its slot. */
    ss_note_reload(f, vreg_id);
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off)) {
            emit(out, "ld\ta,(%s%+d)", frame_reg(), ix_off);
            return;
        }
    }
    /* The sp-rel slot read clobbers HL with the slot address — flush a
       pending spill first (LAZY_SPILL_PLAN.md §11; dormant for now). */
    pending_spill_resolve();
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
    hl_about_to_change(-1);
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
    /* The sp-rel path clobbers HL (the slot address). Flush a pending
       spill first, while HL still holds it and before `ld e,a` stashes
       the byte into E (the flush's `ex de,hl` would otherwise trash it).
       LAZY_SPILL_PLAN.md §11; dormant for now. */
    pending_spill_resolve();
    int off = slot_off(f, vreg_id) + cur_sp_adjust;
    emit(out, "ld\te,a");          /* stash value across sp+off load */
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e");
    /* The sp-rel path clobbers HL (and E): drop stale cache claims —
       a caller may have cached the deref base in HL just before. */
    invalidate_hl_cache();
    invalidate_de_cache();
}

/* Load 4-byte (long) value from a vreg's frame slot into DEHL.
   Convention: DE = high half, HL = low half. Slot layout little-
   endian: slot+0..1 = low half, slot+2..3 = high half. Clobbers
   BC (used as scratch for the low half during the load).
   `sp_adj` compensates for caller pushes since the slot offset
   was last canonical (e.g. pushed args during a runtime-helper
   call setup). Pass 0 if sp is at its frame-entry position. */

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
        emit(out, "ld\thl,bc");         /* HL = (byte 2, byte 1) */
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
    /* The long-load emits below (`ld hl,bc` cache recover, `ld hl,(ix)`,
       the sp-rel slot walk) all clobber HL. Flush a pending width-2
       spill first (LAZY_SPILL_PLAN.md §11; dormant for now). The
       no-emit returns are safe: the no_hl cache-hit means the caller
       overwrites HL itself, and the cur_hl_vreg==vreg_id hit can't
       coincide with a width-2 pending (different widths). */
    pending_spill_resolve();
    if (dehl_has(vreg_id)) {
        /* Cache hit: DE still has high half, BC has low half. Recover
           HL with 2 instructions (~12 T-states) vs ~120 for a full
           slot read. sp_adj is irrelevant — data is in registers.
           Skip the recovery when no_hl flag is set (caller is about
           to overwrite HL) OR when cur_hl_vreg == vreg_id (HL already
           holds the low half from a previous cache_dehl_no_spill that
           preserved HL). */
        if (!no_hl && cur_hl_vreg != vreg_id) {
            emit(out, "ld\thl,bc");
        }
        if (!no_hl) hl_about_to_change(vreg_id);
        return;
    }
    /* FP-relative long load. sp_adj irrelevant for IX addressing. */
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 3)) {
            ss_note_reload(f, vreg_id);   /* defensive: width-2 never here */
            emit(out, "ld\thl,(%s%+d)", frame_reg(), ix_off);
            emit(out, "ld\tde,(%s%+d)", frame_reg(), ix_off + 2);
            /* BC is untouched — set it to HL (low) so the DEHL cache
               invariant (BC = low half when cur_dehl_vreg is set) holds.
               Then publish the cache: subsequent load_to_dehl(v) hits
               and emits `ld hl,bc` with correct BC. Skip the stash
               when the caller signals it won't read BC — typically a
               byte-direct unary chain (IR_NOT/IR_NEG) that walks
               H/L/E/D through A. */
            if (!cur_load_to_dehl_no_bc)
                emit(out, "ld\tbc,hl");
            cur_load_to_dehl_no_bc = 0;
            /* HL really does hold the low half here — advertise it
               so downstream byte-direct chains can read from L/H
               directly instead of going through BC. */
            hl_about_to_change(vreg_id);
            cache_dehl(vreg_id);
            return;
        }
    }
    ss_note_reload(f, vreg_id);       /* defensive: width-2 never here */
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
        emit(out, "ld\thl,bc");     /* HL = BC = low half */
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
/* One-shot flag: when set, load_to_dehl_adj skips the trailing
   `ld l,c; ld h,b` (which restores HL = low half from BC). Callers
   set this when they don't need HL set after the load — typically
   because the next instruction overwrites HL (e.g. `pop hl`,
   `ld hl,K`). After: BC = low half, DE = high half, HL = junk.
   (The cur_store_dehl_bc_ready flag is gone — copt 285d catches
   the round trip post-emit instead.) */
static int cur_load_to_dehl_no_hl;

static void store_dehl(FILE *out, const Func *f, int vreg_id)
{
    /* FP-relative long store. Preserves HL+DE entirely — no BC stash
       needed. PR_BC vregs survive across long stores when FP is on. */
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 3)) {
            emit(out, "ld\t(%s%+d),hl", frame_reg(), ix_off);
            emit(out, "ld\t(%s%+d),de", frame_reg(), ix_off + 2);
            /* DEHL cache contract: BC = low half after store_dehl.
               Subsequent load_to_dehl_adj on a cache hit recovers HL
               via `ld hl,bc` — needs BC. */
            emit(out, "ld\tbc,hl");
            return;
        }
    }
    int off = slot_off(f, vreg_id) + cur_sp_adjust;
    /* Stash low half (HL) into BC so HL is free for slot addressing.
       The store_dehl contract already declares BC clobbered, so this
       is the cheapest path (8 T-states for ld bc,hl versus 21
       for the equivalent push hl ... pop bc round trip). */
    emit(out, "ld\tbc,hl");          /* BC = low (B=hi byte, C=lo byte) */
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

/* Forward decl: defined with the rest of the per-op lookahead state.
   Read by cache_dehl_no_spill (just below) to skip the BC stash when
   the next op is the FP byte-direct binop chain. */
static int cur_dehl_dst_no_bc_stash;

/* Forward decl: same family. Read by load_to_dehl_adj's FP-mode path
   to skip the BC stash when the caller doesn't read BC — typically
   a byte-direct unary chain reading H/L/E/D through A. */
static int cur_load_to_dehl_no_bc;

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
    /* The `ld bc,hl` stash is wasted when the next consumer is the
       FP-mode byte-direct binop chain — that chain reads from H/L
       directly (using the cur_hl_vreg advertise below). Skip the
       stash; chained byte-direct binops write BC themselves at
       the chain's tail, so subsequent ops still see BC = low. */
    if (!cur_dehl_dst_no_bc_stash)
        emit(out, "ld\tbc,hl");
    cur_dehl_dst_no_bc_stash = 0;
    /* HL still holds the long's low half (precondition of this
       function — caller's compute left HL = low). Advertise it via
       cur_hl_vreg so the next load_to_dehl on cache hit can skip
       its `ld hl,bc` recovery (saves 2 bytes per chained
       long-binop in MD5's `a += ...` rounds). */
    hl_about_to_change(vreg_id);
    cur_de_vreg = -1;
    cur_dehl_vreg = vreg_id;
}

/* Forward decl: cur_dehl_dst_dead_safe lives with the other lookahead
   flags further down. lower_func sets it before each op. */
static int cur_dehl_dst_dead_safe;

/* Forward decl: defined with the other vreg_is_pr_* helpers below. */
static int vreg_is_pr_dehl(const Func *f, int v);

/* Dispatch wrapper for the 19+ "compute long; spill to dst's slot;
   publish cache" sites in lower_op. When the lookahead in lower_func
   has determined that the slot write would be dead (cur_dehl_dst_dead
   _safe), we emit the 2-instruction `ld b,h; ld c,l + cache` shape
   instead of the full 11-instruction store_dehl. */
static void store_dehl_finalize(FILE *out, const Func *f, int vreg_id)
{
    if (cur_dehl_dst_dead_safe || vreg_is_pr_dehl(f, vreg_id)) {
        cache_dehl_no_spill(out, vreg_id);
    } else if (cur_dehl_push_to_stack
               && cur_dehl_inline_push < 0
               && cur_stack_long_top < 0) {
        /* Push to data stack instead of writing to frame slot.
           Result is in DEHL (D=b3, E=b2, H=b1, L=b0).
           ld bc,hl stashes the low half into BC so the DEHL cache
           invariant (BC=low) holds after cache_dehl. */
        emit(out, "ld\tbc,hl");
        emit(out, "push\tde");
        emit(out, "push\tbc");
        cur_sp_adjust += 4;
        cur_dehl_inline_push = vreg_id;
        cur_dehl_inline_push_base_sp = cur_sp_adjust;
        /* HL was consumed producing the value (e.g. the long
           indirect-load byte walk ran the BASE pointer through HL) —
           any prior tenant claim is stale. HL now holds OUR low
           half; claim it, else the next op's hl_has(base) hit
           operates on the value as an address (r7: ADD base+4
           computed value+4 after this push staging). */
        invalidate_hl_cache();
        hl_about_to_change(vreg_id);
        cache_dehl(vreg_id);
    } else {
        store_dehl_cached(out, f, vreg_id);
    }
    cur_dehl_push_to_stack = 0;
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

/* BC cache. Function-lifetime: ir_alloc marks at most one PARAM as
   PR_BC and only in a narrow safety envelope (no CALL/HCALL, no
   width-4 vregs). Within that envelope BC is loaded by the prologue
   and never overwritten by body emits. load_to_hl / load_to_de
   short-circuit slot reads with `ld l,c; ld h,b` / `ld e,c; ld d,b`. */
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
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
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
        /* HL holds src[1] (the would-be DE-operand). If it is the
           pending spill, flush it — store_hl writes the slot AND leaves
           it in DE, the swap's intent (LAZY_SPILL_PLAN.md §11). */
        if (lazy_spill_on && pending_spill_v == op->src[1]) {
            pending_spill_flush();   /* DE := src1, slot written, HL junk */
            cache_de(op->src[1]);
            load_to_hl(out, f, op->src[0]);
            return;
        }
        /* Swap into DE. Cache: HL ↔ DE swap. After: DE has src[1], HL
           has whatever DE held — invalidate HL since the caller wants
           src[0] there. */
        emit(out, "ex\tde,hl");
        swap_hl_de_caches();
        load_to_hl(out, f, op->src[0]);
        return;
    }
    if (de_has(op->src[1])) {
        /* DE-cache hit: just load src[0] into HL. */
        load_to_hl(out, f, op->src[0]);
        return;
    }
    if (de_has(op->src[0])) {
        /* HL here holds neither src — if a spill is pending it is an
           UNRELATED vreg, and store_hl's `ex de,hl` would clobber DE
           (=src0). Resolve it (flush/discard), then rebuild both
           operands from scratch since the src0 DE-cache may be gone
           (LAZY_SPILL_PLAN.md §11). */
        if (lazy_spill_on && pending_spill_v >= 0) {
            pending_spill_resolve();
            invalidate_de_cache();
            load_to_de(out, f, op->src[1]);
            cache_de(op->src[1]);
            load_to_hl(out, f, op->src[0]);
            return;
        }
        /* DE has src[0] but we want it in HL. ex de,hl moves it; then
           we need src[1] loaded into DE. After ex de,hl: HL has src[0]
           (good), DE has whatever HL had (junk, but we're about to
           overwrite). load_to_de uses HL as scratch — will clobber HL.
           So we need to preserve HL via the push/pop variant. */
        emit(out, "ex\tde,hl");
        swap_hl_de_caches();
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
    hl_about_to_change(vreg);
}

/* Sole choke point for an HL clobber/load: see the forward-decl comment
   near the cache-helper forward declarations. When a width-2 spill is
   pending in HL and HL is about to take a different tenant, resolve it
   (flush if still live, discard if dead) BEFORE the physical clobber.
   The `!= v_new` guard lets a def re-advertise its own dst (cache_hl) or
   a carry re-assert the same vreg without spuriously flushing. */
static void hl_about_to_change(int v_new)
{
    if (lazy_spill_on && pending_spill_v >= 0 && pending_spill_v != v_new)
        pending_spill_resolve();
    cur_hl_vreg = v_new;
}

/* Sole choke point for the `ex de,hl` cache swap: HL and DE trade
   tenants. The value leaving HL survives in DE, so this is distinct
   from hl_about_to_change (a clobber). Callers emit the `ex de,hl`
   themselves, then call this to keep the caches in sync. */
static void swap_hl_de_caches(void)
{
    int tmp = cur_hl_vreg;
    cur_hl_vreg = cur_de_vreg;
    cur_de_vreg = tmp;
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
    hl_about_to_change(-1);
    cur_de_vreg = -1;
    cur_dehl_vreg = -1;
    cur_a_vreg = -1;
    cur_fa_vreg = -1;
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

/* Current BB being lowered (the per-BB loop in lower_func sets this
   before each op). Read by the AND-mask + shift-test peephole to
   inspect successor BBs' first ops. */
static const BB *cur_bb;

/* ---- Lazy spill (store-on-clobber) helpers — LAZY_SPILL_PLAN.md §11 --
   Dormant until the deferral step wires `pending_spill_v` at the
   spill sites; `pending_spill_v` is -1 here, so flush/resolve never run
   and codegen is unchanged. Defined here (not at the cache helpers)
   because the flush needs store_hl, the de-cache invalidator, cur_bb
   and the per-op liveness — all visible by this point. */

/* Is the pending vreg still live entering the op currently being
   lowered? Conservative default (assume live → flush) when liveness
   context is unavailable, so an unknown state never drops a live store. */
static int pending_spill_live(void)
{
    if (pending_spill_v < 0) return 0;
    if (!cur_bb) return 1;
    const BitSet *li = ir_op_live_in(cur_bb, cur_op_idx);
    if (!li) return 1;
    return ir_bitset_get(li, pending_spill_v);
}

/* Emit the deferred slot store. Precondition (I1): HL physically holds
   pending_spill_v. After: slot written, HL is junk (store_hl clobbers
   it), DE cache dropped, nothing pending. Clears `pending_spill_v`
   before emitting so a re-entrant choke-point call can't double-flush
   (store_hl itself emits no cache-mutating calls). */
static void pending_spill_flush(void)
{
    if (pending_spill_v < 0) return;
    int v = pending_spill_v;
    pending_spill_v = -1;
    store_hl(cur_lazy_out, cur_lazy_func, v);
    cur_hl_vreg = -1;
    invalidate_de_cache();
}

/* Resolve a pending spill at a point where HL is about to be clobbered:
   flush it if the value is still live (needed from a later slot read),
   else discard it (dead or about to be redefined → the store was dead). */
static void pending_spill_resolve(void)
{
    if (pending_spill_v < 0) return;
    if (pending_spill_live())
        pending_spill_flush();
    else
        pending_spill_v = -1;
}

/* Skip-and-cache list for the AND 0x8000 + BR + SHL-in-both-succs
   fastpath. When the fastpath fires, both succs' leading IR_SHL ops
   would re-shift a value the fused `add hl,hl` already produced.
   Record their (bb_id, op_idx) here; the per-op loop checks before
   emitting and elides the SHL while advertising cur_hl_vreg to the
   SHL's dst vreg. Per-function; small cap (the unrolled CRC loop has
   2 entries per iter × 8 = 16 max). */
#define SHL_SKIP_CAP 32
static struct { int bb_id, op_idx, cache_vreg; } shl_skip[SHL_SKIP_CAP];
static int shl_skip_n;

/* When set before IR_SHL imm=N is lowered, the int-SHL fastpath drops
   the first `add hl,hl` emit (HL already holds the shifted value
   produced by a fused fastpath such as the shift+test peephole).
   The spill / cache_hl tail still runs so the dst's slot and HL
   cache are correctly published. Cleared by the SHL lowerer. */
static int cur_skip_shl_add_hl;

/* Per-op lookahead: when the producer's dst is consumed by an
   FP-mode byte-direct binop next (the consumer reads bytes via
   the (ix+d) chain from H/L/E/D rather than from B/C/E/D), the
   producer's `ld bc,hl` stash in cache_dehl_no_spill is wasted —
   the chain doesn't read BC. Set by lower_func's lookahead; read
   by cache_dehl_no_spill to skip the stash. The chain itself
   checks `cur_hl_vreg == from_dehl` to know when to read from
   H/L instead of C/B. */
static int cur_dehl_dst_no_bc_stash;

/* Caller-side one-shot: when set before a load_to_dehl call, the
   load's FP-mode `ld bc,hl` stash is skipped. The caller must not
   read BC between this load and the next BC stamp. Cleared by
   load_to_dehl_adj after use. */
static int cur_load_to_dehl_no_bc;

/* Long data-stack: the z80 stack doubles as an operand stack with DEHL
   as the implicit top register. When a long's live range crosses
   DEHL-clobbering ops, ir_opt inserts IR_PUSH_DEHL_LONG /
   IR_POP_DEHL_LONG markers and the lowerer emits the `push de; push
   hl` / `pop hl; pop de` pairs. cur_sp_adjust tracks outstanding push
   depth (each long push = +4) so sp-relative slot reads compensate;
   reset at each BB boundary (stack must rebalance per BB).

   Stack-consuming helpers (sccz80's `l_long_or` / `l_long_add` family)
   pop their RHS without a separate IR_POP_DEHL_LONG. gen_hcall reads
   the flag on HelperInfo and decrements cur_sp_adjust on emit. */

/* True iff v is allocator-pinned to a register pool (PR_HL/DE/BC/DEHL)
   — no frame slot is ever touched. */
static int vreg_in_register_pool(const Func *f, int v)
{
    if (v < 0 || !f || !f->vreg_to_phys) return 0;
    PhysReg pr = f->vreg_to_phys[v];
    return pr == IR_PR_HL || pr == IR_PR_DE
        || pr == IR_PR_BC || pr == IR_PR_DEHL;
}

/* ---- Static lazy spill — reaching-reloads dead-store elimination -------
   LAZY_SPILL_PLAN.md §11 / §11.4 ("the two-pass static model made
   faithful"). Behind IR_LAZY_SPILL. Pass 1 (record) lowers eagerly and
   observes, per op, the deferrable-vreg slot accesses the lowerer makes —
   ground truth, since deferral changes only stores, never which loads
   cache-hit. A backward slot-liveness dataflow then marks a spill store
   DEAD iff no reload of its slot is reachable before the next store. Pass
   2 (elide) skips the dead stores; the value rides to its readers in HL
   via the existing bb_hl_out carry. Keys on the lowerer's OWN behaviour,
   not an IR-level deadness guess, so it survives the §2 fused-add-hl-hl
   artifact.

   SOUND-BY-CONSTRUCTION reload model: the per-op reload (GEN) set is
   computed in ss_compute_dead as

       { deferrable v in uses(op) : v NOT proven cache-served } ∪ explicit

   i.e. EVERY deferrable source vreg is assumed reloaded from its slot
   UNLESS pass 1 recorded a genuine register-cache hit for it (ss_op_cacheread,
   set only at the loaders' cache-hit returns). So a MISSED hook can only
   leave a store un-elided (lost optimization) — never elide a live store
   (miscompile). Discipline is therefore INVERTED between the two arrays:
     - cacheread MUST be precise (only at true cache hits) — over-recording
       it is the unsafe direction (would hide a real reload);
     - reload/store hooks may be incomplete — they are a belt-and-suspenders
       backstop (e.g. the rare cache-hit-then-slot-reload of the same vreg
       within one op), not the safety mechanism.
   uses(op) comes from the IR (ir_op_uses), which is reliable. */
static int                ss_phase;       /* 0 off, 1 record, 2 elide */
static int               *ss_op_store;    /* [total_ops]   stored vreg / -1 */
static int               *ss_op_reload;   /* [2*ops] explicit slot reloads   */
static int               *ss_op_cacheread;/* [2*ops] proven register-served  */
static const signed char *ss_store_dead;  /* [total_ops]   pass-2 verdict    */
static const int         *ss_op_base;     /* [n_bbs] op-global-index base    */
static int                ss_cur_g;       /* current op global idx, -1 none */
static int                ss_pinned;      /* >2 accesses in an op → no elide */

/* A width-2 local with a real slot whose spill store may be elided
   (I4 exclusions: never ADDR_TAKEN / VOLATILE / PARAM / register-pool). */
static int vreg_slot_deferrable(const Func *f, int v)
{
    if (v < 0) return 0;
    if (f->vregs[v].width != 2) return 0;
    if (f->vregs[v].flags
        & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
        return 0;
    if (vreg_in_register_pool(f, v)) return 0;
    return 1;
}

/* Pass-1 hooks: note a slot reload / store of a deferrable vreg at the
   op currently being lowered. */
static void ss_note_reload(const Func *f, int v)
{
    if (ss_phase != 1 || ss_cur_g < 0 || !vreg_slot_deferrable(f, v)) return;
    int *slot = &ss_op_reload[ss_cur_g * 2];
    if (slot[0] == v || slot[1] == v) return;       /* dedup */
    if (slot[0] < 0) { slot[0] = v; return; }
    if (slot[1] < 0) { slot[1] = v; return; }
    ss_pinned = 1;          /* >2 distinct reloads in one op — bail safely */
}
static void ss_note_store(const Func *f, int v)
{
    if (ss_phase != 1 || ss_cur_g < 0 || !vreg_slot_deferrable(f, v)) return;
    ss_op_store[ss_cur_g] = v;
}
/* Pass-1 hook at a GENUINE register-cache hit (the loaders' early returns
   that serve v from HL/DE/BC/A with no slot read). MUST be precise — this
   is the proof that a use is NOT a reload, so a false positive would hide
   a real reload. Under-recording only forgoes optimisation. */
static void ss_note_cache_read(const Func *f, int v)
{
    if (ss_phase != 1 || ss_cur_g < 0 || !vreg_slot_deferrable(f, v)) return;
    int *slot = &ss_op_cacheread[ss_cur_g * 2];
    if (slot[0] == v || slot[1] == v) return;       /* dedup */
    if (slot[0] < 0) { slot[0] = v; return; }
    if (slot[1] < 0) { slot[1] = v; return; }
    ss_pinned = 1;          /* >2 cache-served vregs in one op — bail safely */
}
/* Pass-2: is the store at the current op dead (slot never reloaded before
   the next store)? */
static int ss_store_dead_here(void)
{
    return ss_phase == 2 && ss_cur_g >= 0 && ss_store_dead
        && ss_store_dead[ss_cur_g];
}

/* Set the GEN (reload) bits for op (b,j) into `work`. The sound-by-
   construction set: every deferrable source vreg of the op is a reload
   UNLESS pass 1 proved it register-served (in op_cacheread), plus the
   explicit slot reloads as a backstop. Conservative: an unrecorded
   cache-hit just leaves the vreg in GEN (store kept). */
static void ss_gen_op(Func *f, int b, int j, int g, int nv,
                      const int *op_reload, const int *op_cacheread,
                      char *work)
{
    int r0 = op_reload[g * 2], r1 = op_reload[g * 2 + 1];
    if (r0 >= 0 && r0 < nv) work[r0] = 1;
    if (r1 >= 0 && r1 < nv) work[r1] = 1;
    int uses[16];
    int nu = ir_op_uses(&f->bbs[b].ops[j], uses,
                        (int)(sizeof uses / sizeof uses[0]));
    int c0 = op_cacheread[g * 2], c1 = op_cacheread[g * 2 + 1];
    for (int u = 0; u < nu; u++) {
        int uv = uses[u];
        if (uv < 0 || uv >= nv || !vreg_slot_deferrable(f, uv)) continue;
        if (uv == c0 || uv == c1) continue;   /* proven cache-served */
        work[uv] = 1;                         /* assume slot reload */
    }
}

/* Backward slot-liveness over the CFG. Returns a [total_ops] verdict
   array: dead[g]==1 iff the spill store recorded at op g writes a slot
   that no reload reads before the next store overwrites it — so the
   store is dead and the value reaches its readers in HL. Standard
   backward dataflow: per op, the store KILLs its vreg and the GEN set
   (see ss_gen_op) re-adds reloaded vregs; a store is dead iff its vreg is
   not slot-live immediately after. Caller owns the result (free). */
static signed char *ss_compute_dead(Func *f, const int *op_base,
                                    int total_ops, const int *op_store,
                                    const int *op_reload,
                                    const int *op_cacheread)
{
    int sz = total_ops > 0 ? total_ops : 1;
    signed char *dead = calloc((size_t)sz, 1);
    int nv = f->n_vregs > 0 ? f->n_vregs : 1;
    char **lin = calloc((size_t)f->n_bbs, sizeof(char *));
    char *work = malloc((size_t)nv);
    if (!dead || !lin || !work) { free(dead); free(lin); free(work); return NULL; }
    for (int b = 0; b < f->n_bbs; b++) {
        lin[b] = calloc((size_t)nv, 1);
        if (!lin[b]) {
            for (int k = 0; k < b; k++) free(lin[k]);
            free(lin); free(work); free(dead); return NULL;
        }
    }
    /* Fixpoint: slot-live-in grows monotonically, so this converges. */
    int changed = 1;
    while (changed) {
        changed = 0;
        for (int b = f->n_bbs - 1; b >= 0; b--) {
            BB *bb = &f->bbs[b];
            memset(work, 0, (size_t)nv);
            /* All successors, incl. IR_SWITCH's targets + default — NOT the
               raw succ[0..1] pair (which omits them, so a value read only on
               the default arm looks slot-dead and its store gets elided). */
            int ns = ir_bb_n_succ(bb);
            for (int s = 0; s < ns; s++) {
                int sb = ir_bb_succ_at(bb, s);
                if (sb >= 0 && sb < f->n_bbs)
                    for (int v = 0; v < nv; v++) if (lin[sb][v]) work[v] = 1;
            }
            for (int j = bb->n_ops - 1; j >= 0; j--) {
                int g = op_base[b] + j;
                int sv = op_store[g];
                if (sv >= 0 && sv < nv) work[sv] = 0;        /* store kills */
                ss_gen_op(f, b, j, g, nv, op_reload, op_cacheread, work);
            }
            if (memcmp(work, lin[b], (size_t)nv) != 0) {
                memcpy(lin[b], work, (size_t)nv);
                changed = 1;
            }
        }
    }
    /* Final backward sweep: a store is dead iff its slot is not live
       immediately after it (processed before the kill, in op order). */
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        memset(work, 0, (size_t)nv);
        int ns = ir_bb_n_succ(bb);
        for (int s = 0; s < ns; s++) {
            int sb = ir_bb_succ_at(bb, s);
            if (sb >= 0 && sb < f->n_bbs)
                for (int v = 0; v < nv; v++) if (lin[sb][v]) work[v] = 1;
        }
        for (int j = bb->n_ops - 1; j >= 0; j--) {
            int g = op_base[b] + j;
            int sv = op_store[g];
            if (sv >= 0 && sv < nv) { dead[g] = work[sv] ? 0 : 1; work[sv] = 0; }
            ss_gen_op(f, b, j, g, nv, op_reload, op_cacheread, work);
        }
    }
    for (int b = 0; b < f->n_bbs; b++) free(lin[b]);
    free(lin); free(work);
    return dead;
}

/* True if v is allocator-pinned to DE. Producer sites use this to
   redirect the final write into D/E instead of H/L then cache_de(v). */
static int vreg_is_pr_de(const Func *f, int v)
{
    return v >= 0 && f && f->vreg_to_phys
        && f->vreg_to_phys[v] == IR_PR_DE;
}

/* True if v is PR_DEHL — no slot allocated, value lives in the
   DEHL cache between producer and its single immediate consumer. */
static int vreg_is_pr_dehl(const Func *f, int v)
{
    return v >= 0 && f && f->vreg_to_phys
        && f->vreg_to_phys[v] == IR_PR_DEHL;
}

/* Skip store_hl + trailing `ex de,hl` (the swap-back after spill) when
   dst is dead. Used by the binop / LD_IMM pattern
   `<compute leaves value in HL>; store_hl; ex de,hl; cache_hl` — on
   dead-dst we emit nothing and HL already holds the value. Also fires
   for vregs in a register pool: nothing to spill. */
static void spill_and_swap_unless_dead(FILE *out, const Func *f, int vreg)
{
    if (cur_dst_dead) return;
    /* Pooled vreg: value lives in a phys reg, no slot. PR_HL is the
       caller's responsibility (cache_hl(dst) tops it up). PR_BC needs
       an HL→BC copy so subsequent loads hit the BC short-circuit;
       nothing in the no-call envelope clobbers BC. */
    if (vreg_in_register_pool(f, vreg)) {
        if (f->vreg_to_phys[vreg] == IR_PR_BC) {
            emit(out, "ld\tbc,hl");
            cache_bc(vreg);
        }
        return;
    }
    ss_note_store(f, vreg);
    if (ss_store_dead_here()) {
        /* Dead spill (no reload reaches it before the next store): skip
           the store AND the swap-back — HL already holds the value, the
           caller's cache_hl(dst) keeps it advertised, and it reaches its
           readers via the HL carry (folds §10a). */
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
    ss_note_store(f, vreg);
    if (ss_store_dead_here()) {
        /* Dead spill: skip the slot write, just bring the value into HL
           (the value is in DE on entry here). */
        emit(out, "ex\tde,hl");
        invalidate_de_cache();
        return;
    }
    int off = slot_off(f, vreg) + cur_sp_adjust;
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
    ss_note_store(f, vreg);
    if (ss_store_dead_here()) return;   /* dead spill; HL already holds it */
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

/* ---- Per-op gen_* emitters (called from lower_op's dispatch) -----
   Each function corresponds to one IR opcode (or a small fused
   family — IR_AND/OR/XOR share gen_and_or_xor, the comparison
   shapes share their own emitter). They take the same args as
   lower_op (FILE*, Func*, const Op*) and return the same rc.
   Splitting these out keeps lower_op's dispatch readable; the
   bodies are unchanged from the previous inline switch. */

static int gen_nop(FILE *out, Func *f, const Op *op)
{
    (void)out; (void)f; (void)op;
    return 0;
}

static int gen_ld_imm(FILE *out, Func *f, const Op *op)
{
    int dst_w = (op->dst >= 0) ? f->vregs[op->dst].width : 2;
    if (dst_w == 4) {
        /* Long literal: load DEHL = K, then spill 4 bytes. */
        uint32_t k = (uint32_t)op->imm;
        emit(out, "ld\thl,%u", (unsigned)(k & 0xffff));
        emit(out, "ld\tde,%u", (unsigned)((k >> 16) & 0xffff));
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (dst_w == 1) {
        /* Byte literal: load A and spill byte-sized. The generic
           path below stages in DE and writes TWO bytes — into a
           slot ir_assign_slots sized at 1 (BUG_LOG A33's overrun
           class). Consumers hit the A-cache via load_byte_to_a /
           load_to_hl's width-1 path. */
        emit(out, "ld\ta,%d", (int)(op->imm & 0xff));
        if (cur_dst_dead || vreg_in_register_pool(f, op->dst)) {
            cache_a(op->dst);
        } else {
            store_a_byte(out, f, op->dst);
        }
        return 0;
    }
    /* PR_DE dst: emit `ld de,K` directly — no HL detour, spill, or
       swap. The consumer hits load_binop_operands's de_has src[1]. */
    if (op->dst >= 0 && f->vreg_to_phys
        && f->vreg_to_phys[op->dst] == IR_PR_DE) {
        emit(out, "ld\tde,%lld", (long long)op->imm);
        cache_de(op->dst);
        return 0;
    }
    /* PR_BC dst: `ld bc,K` and stamp the cache. Downstream readers
       hit the `ld l,c; ld h,b` short-circuit in load_to_hl/de. */
    if (op->dst >= 0 && f->vreg_to_phys
        && f->vreg_to_phys[op->dst] == IR_PR_BC) {
        emit(out, "ld\tbc,%lld", (long long)op->imm);
        cache_bc(op->dst);
        return 0;
    }
    /* Stage in DE when we're going to spill: skips the initial
       `ex de,hl` of store_hl. On dead-dst, falls back to the plain
       HL load (we need HL=K for any cache-served consumer). */
    if (cur_dst_dead) {
        emit(out, "ld\thl,%lld", (long long)op->imm);
    } else {
        emit(out, "ld\tde,%lld", (long long)op->imm);
        spill_de_unless_dead(out, f, op->dst);
    }
    cache_hl(op->dst);
    return 0;
}

static int gen_ld_sym(FILE *out, Func *f, const Op *op)
{
    /* dst ← &sym + offset. Address-of: just an immediate-load. */
    if (op->mem.sym == NULL) {
        fputs("ir_lower: IR_LD_SYM with NULL sym\n", stderr);
        return -1;
    }
    if (ns_sym_bails(op->mem.sym))
        return -1;   /* __addressmod address-of → walker */
    if (op->mem.offset)
        emit(out, "ld\thl,_%s+%d",
             ir_sym_name(op->mem.sym), op->mem.offset);
    else
        emit(out, "ld\thl,_%s", ir_sym_name(op->mem.sym));
    spill_and_swap_unless_dead(out, f, op->dst);
    cache_hl(op->dst);
    return 0;
}

static int gen_ld_str(FILE *out, Func *f, const Op *op)
{
    /* dst ← &literal_queue + imm. The per-TU label `i_<litlab>` is the
       start of the queue; `op->imm` is the byte offset of the string
       within it. */
    emit(out, "ld\thl,i_%d+%lld", litlab, (long long)op->imm);
    spill_and_swap_unless_dead(out, f, op->dst);
    cache_hl(op->dst);
    return 0;
}

static int gen_lea(FILE *out, Func *f, const Op *op)
{
    if (op->src[0] < 0) {
        fputs("ir_lower: IR_LEA with no src\n", stderr);
        return -1;
    }
    emit_acc_slot_addr(out, f, op->src[0], 0);
    spill_and_swap_unless_dead(out, f, op->dst);
    cache_hl(op->dst);
    return 0;
}

static int gen_mov(FILE *out, Func *f, const Op *op)
{
    int dst_w = (op->dst >= 0) ? f->vregs[op->dst].width : 2;
    if (dst_w > 4) {
        /* Wide (5/6/8-byte) slot-to-slot copy via the accumulator:
           dload(src); dstore(dst). Reuses the FA-residency cache. */
        if (cur_fa_vreg != op->src[0]) {
            emit_acc_slot_addr(out, f, op->src[0], 0);
            emit(out, "call\t%s", acc_prim(f, op->src[0], "load"));
        }
        emit_acc_slot_addr(out, f, op->dst, 0);
        emit_acc_store_hl(out, f, op->dst);
        invalidate_hl_cache(); invalidate_bc_cache();
        cur_fa_vreg = op->dst;
        return 0;
    }
    if (dst_w == 4) {
        /* Long slot-to-slot copy. */
        load_to_dehl(out, f, op->src[0]);
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (dst_w == 1) {
        /* Byte dst: store ONE byte via A. The generic HL path below
           uses store_hl, which always writes TWO bytes and overruns a
           slot ir_assign_slots sized at 1 (BUG_LOG A33 overrun class —
           same fix as gen_ld_imm / gen_conv_trunc). A MOV with a wider
           source (e.g. `c = c ^ x` where c is char: the int-promoted
           XOR is width 2) takes the source's low byte. */
        int src_w = f->vregs[op->src[0]].width;
        if (src_w == 1) {
            load_byte_to_a(out, f, op->src[0]);
        } else if (src_w == 4) {
            load_to_dehl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
            invalidate_hl_cache();
        } else {
            load_to_hl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
        }
        if (cur_dst_dead || vreg_in_register_pool(f, op->dst)) {
            cache_a(op->dst);
        } else {
            store_a_byte(out, f, op->dst);
        }
        return 0;
    }
    if (vreg_is_pr_de(f, op->dst)) {
        load_to_de(out, f, op->src[0]);
        cache_de(op->dst);
        return 0;
    }
    if (cur_hl_vreg != op->src[0] || cur_hl_vreg < 0)
        load_to_hl(out, f, op->src[0]);
    spill_and_swap_unless_dead(out, f, op->dst);
    cache_hl(op->dst);
    return 0;
}

static int gen_inc(FILE *out, Func *f, const Op *op)
{
    if (!hl_has(op->src[0]))
        load_to_hl(out, f, op->src[0]);
    emit(out, "inc\thl");
    spill_and_swap_unless_dead(out, f, op->dst);
    cache_hl(op->dst);
    return 0;
}

static int gen_dec(FILE *out, Func *f, const Op *op)
{
    if (!hl_has(op->src[0]))
        load_to_hl(out, f, op->src[0]);
    emit(out, "dec\thl");
    spill_and_swap_unless_dead(out, f, op->dst);
    cache_hl(op->dst);
    return 0;
}

static int gen_br(FILE *out, Func *f, const Op *op)
{
    (void)f;
    /* HL state at the destination is captured by bb_hl_out in
       lower_func — no need to invalidate here. */
    emit(out, "jp\tL_f%d_bb_%d", func_emit_idx, op->label);
    return 0;
}

static int gen_br_zero(FILE *out, Func *f, const Op *op)
{
    if (!hl_has(op->src[0])) load_to_hl(out, f, op->src[0]);
    emit(out, "ld\ta,h");
    emit(out, "or\tl");
    emit(out, "jp\tz,L_f%d_bb_%d", func_emit_idx, op->label);
    /* HL still holds the tested value — `or l` doesn't touch HL.
       cur_hl_vreg stays valid for the next op. */
    return 0;
}

static int gen_br_cond(FILE *out, Func *f, const Op *op)
{
    if (!hl_has(op->src[0])) load_to_hl(out, f, op->src[0]);
    emit(out, "ld\ta,h");
    emit(out, "or\tl");
    emit(out, "jp\tnz,L_f%d_bb_%d", func_emit_idx, op->label);
    return 0;
}

static int gen_extract_byte(FILE *out, Func *f, const Op *op)
{
    /* dst = byte k of width-4 src[0] (k = imm, 0..3). DEHL cache hit:
       one register copy (L=b0 H=b1 E=b2 D=b3). Slot-resident: one
       byte load from slot+k (little-endian layout). */
    int x = op->src[0];
    int k = (int)op->imm;
    if (dehl_has(x)) {
        /* DEHL-cache invariant: BC = low half, DE = high half; HL
           only holds the low half when cur_hl_vreg advertises it.
           In sp mode the producer's spill walks HL through the slot
           (HL = slot+3 afterwards), so bytes 0/1 MUST come from C/B
           there — reading L/H returned slot-address bytes (dg3:
           digest[ii]/[ii+1] in a loop; fp unaffected since ix-rel
           spills preserve HL). */
        static const char *hl_for_byte[4] = { "l", "h", "e", "d" };
        static const char *bc_for_byte[4] = { "c", "b", "e", "d" };
        const char **rb = (cur_hl_vreg == x) ? hl_for_byte
                                             : bc_for_byte;
        emit(out, "ld\ta,%s", rb[k & 3]);
    } else if (fp_active(f)
               && fp_offset_fits(slot_ix_off(f, x) + k)) {
        emit(out, "ld\ta,(%s%+d)", frame_reg(), slot_ix_off(f, x) + k);
    } else {
        int off = slot_off(f, x) + cur_sp_adjust + k;
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\ta,(hl)");
        invalidate_hl_cache();
    }
    int dw = (op->dst >= 0 && op->dst < f->n_vregs)
           ? f->vregs[op->dst].width : 1;
    if (dw == 2) {
        /* Zero-extended into HL (the table-index shape). */
        emit(out, "ld\tl,a");
        emit(out, "ld\th,0");
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }
    if (cur_dst_dead || vreg_in_register_pool(f, op->dst)) {
        cache_a(op->dst);
    } else {
        store_a_byte(out, f, op->dst);
    }
    return 0;
}

static int gen_rotl(FILE *out, Func *f, const Op *op)
{
    /* Long rotate-left by a constant (ir_opt_fuse_rotl). One
       cache-served read of the source, then a byte permutation of
       D/E/H/L (rot 8 = 5-inst cycle, rot 16 = ex de,hl, rot 24 =
       reverse cycle) plus at most 4 single-bit rotates in whichever
       direction is shorter. Only the live registers move — no count
       loops, no shift-temp spills, no 4-byte OR. */
    int w = (op->dst >= 0 && op->dst < f->n_vregs)
          ? f->vregs[op->dst].width : 2;
    if (w != 4) {
        fprintf(stderr, "ir_lower: IR_ROTL width %d unsupported\n", w);
        return -1;
    }
    int n = (int)(op->imm & 31);
    /* Unconditional: the cache-hit path inside recovers HL from BC
       (the DEHL invariant is BC=low, HL not guaranteed — operating
       the permutation on junk HL was A38's disease). */
    load_to_dehl(out, f, op->src[0]);
    int byte_rot = n >> 3;
    int bits = n & 7;
    int right = 0;
    if (bits > 4) {
        /* e.g. rot 7 = byte-rot 8 then bit-rot RIGHT 1. */
        byte_rot = (byte_rot + 1) & 3;
        right = 8 - bits;
        bits = 0;
    }
    switch (byte_rot) {
    case 1:                              /* (b3 b2 b1 b0) <- rotl8 */
        emit(out, "ld\ta,d");
        emit(out, "ld\td,e");
        emit(out, "ld\te,h");
        emit(out, "ld\th,l");
        emit(out, "ld\tl,a");
        break;
    case 2:                              /* rotl16: swap halves */
        emit(out, "ex\tde,hl");
        break;
    case 3:                              /* rotr8 */
        emit(out, "ld\ta,l");
        emit(out, "ld\tl,h");
        emit(out, "ld\th,e");
        emit(out, "ld\te,d");
        emit(out, "ld\td,a");
        break;
    }
    for (int i = 0; i < bits; i++) {
        /* 32-bit left rotate by 1: shift left, wrap bit31 into bit0
           (L bit0 is 0 after the shift; inc sets it). */
        emit(out, "add\thl,hl");
        emit(out, "rl\te");
        emit(out, "rl\td");
        emit(out, "jr\tnc,ASMPC+3");
        emit(out, "inc\tl");
    }
    for (int i = 0; i < right; i++) {
        /* 32-bit right rotate by 1: shift right, wrap bit0 into
           bit31 (set 7,d is 2 bytes — skip 4). */
        emit(out, "srl\td");
        emit(out, "rr\te");
        emit(out, "rr\th");
        emit(out, "rr\tl");
        emit(out, "jr\tnc,ASMPC+4");
        emit(out, "set\t7,d");
    }
    /* DEHL physically permuted: every prior register claim is stale
       (incl. BC's low-half mirror). Finalize re-advertises dst. */
    invalidate_hl_cache();
    invalidate_bc_cache();
    store_dehl_finalize(out, f, op->dst);
    return 0;
}

/* Inlined const-count memset (IR_MEMSET): src[0] = dst pointer,
   src[1] = fill byte value, imm = count (>0). Loads the fill byte
   into E (load_to_de leaves the low byte there) and the dst pointer into
   HL (load_to_hl preserves DE).

   Small counts (<=8): unroll `ld (hl),e; inc hl`. Uses E (not A, not B)
   so it neither disturbs a byte-cache nor clobbers a PR_BC tenant. HL is
   left junk → invalidate.

   Mid counts (9..255): a `djnz` fill loop (`ld b,N; ld (hl),e; inc hl;
   djnz`). 6 bytes — 3 smaller than the ldir form — at the cost of 5 T/
   byte (26 vs 21), so the size win runs ~42 T at N=9 up to ~1.3k T near
   N=255. Chosen for size, since avoiding the library call is the point.

   Large counts (>=256, B can't hold the count): overlapping-`ldir` fill
   — store the byte once at dst, then `ld d,h; ld e,l; inc de; ld bc,N-1;
   ldir` copies it forward (each step reads the byte just written), a
   constant 9 bytes.

   Both clobber BC/DE/HL: DE is a reload-safe cache (cleared below); a
   live PR_BC tenant is saved/restored around the loop (djnz writes B). */
static int gen_memset(FILE *out, Func *f, const Op *op)
{
    int n = (int)op->imm;
    if (n <= 0) return 0;
    load_to_de(out, f, op->src[1]);   /* DE = fill value; E = low byte */
    load_to_hl(out, f, op->src[0]);   /* HL = dst (preserves DE) */
    if (n <= 8) {
        for (int i = 0; i < n; i++) {
            emit(out, "ld\t(hl),e");
            if (i < n - 1) emit(out, "inc\thl");
        }
        invalidate_hl_cache();
        return 0;
    }
    int bc_live = (cur_bc_vreg >= 0);
    int save_bc = cur_bc_vreg;
    if (bc_live) emit(out, "push\tbc");
    if (n < 256) {
        int lbl = cmp_label_counter++;
        emit(out, "ld\tb,%d", n);
        fprintf(out, "L_f%d_memset_loop_%d:\n", func_emit_idx, lbl);
        emit(out, "ld\t(hl),e");
        emit(out, "inc\thl");
        emit(out, "djnz\tL_f%d_memset_loop_%d", func_emit_idx, lbl);
    } else {
        emit(out, "ld\t(hl),e");      /* dst[0] = fill */
        emit(out, "ld\td,h");
        emit(out, "ld\te,l");
        emit(out, "inc\tde");         /* DE = dst+1, HL = dst */
        emit(out, "ld\tbc,%d", n - 1);
        emit(out, "ldir");
    }
    if (bc_live) emit(out, "pop\tbc");
    invalidate_hl_cache();            /* HL/DE/DEHL/A all junk now */
    if (bc_live) cur_bc_vreg = save_bc; /* pop restored BC */
    return 0;
}

/* Inlined const-count memcpy (IR_MEMCPY): src[0] = dst pointer,
   src[1] = src pointer, imm = count (>0). Loads dst into DE and src into
   HL (load_to_hl preserves DE).

   Tiny counts (<=3): unroll `ld a,(hl); ld (de),a; inc hl; inc de` — no
   BC clobber, so no PR_BC save needed; A is left junk.

   Larger counts: `ld bc,N; ldir` (HL=src → DE=dst). Clobbers BC/DE/HL;
   DE is a reload-safe cache (cleared below); a live PR_BC tenant is
   saved/restored. HL/DE are left junk → invalidate. */
static int gen_memcpy(FILE *out, Func *f, const Op *op)
{
    int n = (int)op->imm;
    if (n <= 0) return 0;
    load_to_de(out, f, op->src[0]);   /* DE = dst */
    load_to_hl(out, f, op->src[1]);   /* HL = src (preserves DE) */
    if (n <= 3) {
        for (int i = 0; i < n; i++) {
            emit(out, "ld\ta,(hl)");
            emit(out, "ld\t(de),a");
            if (i < n - 1) {
                emit(out, "inc\thl");
                emit(out, "inc\tde");
            }
        }
        invalidate_hl_cache();        /* clears HL/DE/A caches */
        return 0;
    }
    int bc_live  = (cur_bc_vreg >= 0);
    int save_bc  = cur_bc_vreg;
    if (bc_live) emit(out, "push\tbc");
    emit(out, "ld\tbc,%d", n);
    emit(out, "ldir");
    if (bc_live) emit(out, "pop\tbc");
    invalidate_hl_cache();
    if (bc_live) cur_bc_vreg = save_bc;
    return 0;
}

/* Inlined __builtin_strcpy (IR_STRCPY): src[0] = dst, src[1] = src.
   DE = dst, HL = src, then a NUL-terminated copy loop:
   `xor a; L: cp (hl); ldi; jr nz,L` — cp sets Z when *src==0 (ldi
   leaves Z untouched, only touching P/V), so the NUL is copied and the
   loop exits. `ldi` decrements BC: a live PR_BC tenant is saved/
   restored. Returns dst (the dst vreg reaches its readers via its slot;
   HL/DE/A left junk → invalidate). */
static int gen_strcpy(FILE *out, Func *f, const Op *op)
{
    int lbl = cmp_label_counter++;
    load_to_de(out, f, op->src[0]);   /* DE = dst */
    load_to_hl(out, f, op->src[1]);   /* HL = src (preserves DE) */
    int bc_live = (cur_bc_vreg >= 0);
    int save_bc = cur_bc_vreg;
    if (bc_live) emit(out, "push\tbc");
    emit(out, "xor\ta");
    fprintf(out, "L_f%d_strcpy_%d:\n", func_emit_idx, lbl);
    emit(out, "cp\t(hl)");
    emit(out, "ldi");
    emit(out, "jr\tnz,L_f%d_strcpy_%d", func_emit_idx, lbl);
    if (bc_live) emit(out, "pop\tbc");
    invalidate_hl_cache();
    if (bc_live) cur_bc_vreg = save_bc;
    return 0;
}

/* Inlined __builtin_strchr (IR_STRCHR): dst = result, src[0] = string,
   src[1] = char vreg (or -1 + imm for a literal char). HL = string,
   E = search char, then a scan loop:
       L: ld a,(hl); cp e; jr z,END   ; match → HL points at it
          and a; inc hl; jr nz,L      ; not NUL → keep scanning
          ld h,a; ld l,h              ; hit NUL (a==0) → HL = NULL
       END:
   Pure read (no memory write); result HL stored to dst. */
static int gen_strchr(FILE *out, Func *f, const Op *op)
{
    int start = cmp_label_counter++;
    int end   = cmp_label_counter++;
    if (op->src[1] >= 0) {
        load_to_de(out, f, op->src[1]);   /* E = search char (low byte) */
        load_to_hl(out, f, op->src[0]);   /* HL = string (preserves DE) */
    } else {
        load_to_hl(out, f, op->src[0]);   /* HL = string */
        emit(out, "ld\te,%d", (int)(op->imm & 0xff));
        invalidate_de_cache();            /* E no longer caches a vreg */
    }
    fprintf(out, "L_f%d_strchr_%d:\n", func_emit_idx, start);
    emit(out, "ld\ta,(hl)");
    emit(out, "cp\te");
    emit(out, "jr\tz,L_f%d_strchr_%d", func_emit_idx, end);
    emit(out, "and\ta");
    emit(out, "inc\thl");
    emit(out, "jr\tnz,L_f%d_strchr_%d", func_emit_idx, start);
    emit(out, "ld\th,a");                 /* a==0 here → HL = 0 (NULL) */
    emit(out, "ld\tl,h");
    fprintf(out, "L_f%d_strchr_%d:\n", func_emit_idx, end);
    /* Result is in HL (cur_hl_vreg still claims the string vreg — stale,
       but the canonical finalize below overwrites it, same as gen_neg).
       The loop clobbered A and (const path) E → drop those claims. */
    cur_a_vreg = -1;
    invalidate_de_cache();
    spill_and_swap_unless_dead(out, f, op->dst);
    cache_hl(op->dst);
    return 0;
}

static int gen_poststep(FILE *out, Func *f, const Op *op)
{
    /* dst = old value of src[0]; src[0] += imm (+1 / -1). The stepped
       var is always slot-resident (the allocator pins POSTSTEP's
       src[0] to a slot). Leaves HL = the OLD value, dst cached. */
    int x  = op->src[0];
    int up = (op->imm > 0);
    if (fp_active(f)
        && fp_offset_fits(slot_ix_off(f, x))
        && fp_offset_fits(slot_ix_off(f, x) + 1)) {
        int d = slot_ix_off(f, x);
        if (!hl_has(x)) {
            ss_note_reload(f, x);
            emit(out, "ld\tl,(%s%+d)", frame_reg(), d);
            emit(out, "ld\th,(%s%+d)", frame_reg(), d + 1);
        }
        emit(out, up ? "inc\thl" : "dec\thl");
        emit(out, "ld\t(%s%+d),l", frame_reg(), d);
        emit(out, "ld\t(%s%+d),h", frame_reg(), d + 1);
        emit(out, up ? "dec\thl" : "inc\thl");   /* HL = old */
    } else {
        /* Arithmetic in DE, single stack calc, no ex-shuffles. When
           DE holds a live cached value, pay push/pop (11+10T) to keep
           the DE / DEHL caches valid — usually cheaper than the
           downstream reload they'd otherwise eat. */
        int de_live = (cur_de_vreg >= 0 || cur_dehl_vreg >= 0);
        int save_de = cur_de_vreg, save_dehl = cur_dehl_vreg;
        if (de_live)
            emit(out, "push\tde");
        ss_note_reload(f, x);
        int off = slot_off(f, x) + cur_sp_adjust + (de_live ? 2 : 0);
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\te,(hl)");
        emit(out, "inc\thl");
        emit(out, "ld\td,(hl)");        /* DE = old, HL = &x.hi */
        emit(out, up ? "inc\tde" : "dec\tde");
        emit(out, "ld\t(hl),d");
        emit(out, "dec\thl");
        emit(out, "ld\t(hl),e");         /* x = new */
        emit(out, up ? "dec\tde" : "inc\tde");
        emit(out, "ex\tde,hl");          /* HL = old */
        if (de_live)
            emit(out, "pop\tde");
        /* x changed; HL claims stale. invalidate_hl also clears the
           DE/DEHL caches — restore them when we preserved DE. */
        invalidate_hl_cache();
        if (de_live) {
            cur_de_vreg   = save_de;
            cur_dehl_vreg = save_dehl;
        }
        spill_and_swap_unless_dead(out, f, op->dst);
        cache_hl(op->dst);
        return 0;
    }
    /* fp path: x changed in memory; any HL/DE claim on x is stale. */
    invalidate_hl_cache();
    spill_and_swap_unless_dead(out, f, op->dst);
    cache_hl(op->dst);
    return 0;
}

static int gen_switch(FILE *out, Func *f, const Op *op)
{
    const SwitchInfo *sw = op->sw;
    if (!sw || sw->n_cases <= 0) {
        emit(out, "jp\tL_f%d_bb_%d", func_emit_idx,
             sw ? sw->default_bb : 0);
        return 0;
    }

    int is_long = (op->src[0] >= 0 && op->src[0] < f->n_vregs
                   && f->vregs[op->src[0]].width == 4);
    int is_ll   = (op->src[0] >= 0 && op->src[0] < f->n_vregs
                   && f->vregs[op->src[0]].width == 8);

    /* long long (8-byte) dispatch: load the scrutinee into __i64_acc, then
       l_i64_case with a `defw target ; <8-byte value>` table (matches the
       walker's l_i64_load / l_i64_case). l_i64_case reads __i64_acc, pops
       its return address as the table pointer, and on no-match continues
       past the defw 0 terminator into the `jp default`. */
    if (is_ll) {
        emit_acc_slot_addr(out, f, op->src[0], 0);
        emit(out, "call\tl_i64_load");
        emit(out, "call\tl_i64_case");
        for (int i = 0; i < sw->n_cases; i++) {
            emit(out, "defw\tL_f%d_bb_%d", func_emit_idx, sw->target_bb[i]);
            emit(out, "defw\t%d", (int)(sw->values[i]        & 0xFFFF));
            emit(out, "defw\t%d", (int)((sw->values[i] >> 16) & 0xFFFF));
            emit(out, "defw\t%d", (int)((sw->values[i] >> 32) & 0xFFFF));
            emit(out, "defw\t%d", (int)((sw->values[i] >> 48) & 0xFFFF));
        }
        emit(out, "defw\t0");
        emit(out, "jp\tL_f%d_bb_%d", func_emit_idx, sw->default_bb);
        return 0;
    }

    if (sw->is_char && !is_long) {
        /* Inline cp chain — cp is cheap and the table's call/terminator
           overhead doesn't pay for byte compares. */
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
        emit(out, "ld\ta,l");
        for (int i = 0; i < sw->n_cases; i++) {
            int k = (int)(sw->values[i] & 0xFF);
            if (k == 0) emit(out, "and\ta");
            else        emit(out, "cp\t%d", k);
            emit(out, "jp\tz,L_f%d_bb_%d", func_emit_idx,
                 sw->target_bb[i]);
        }
        emit(out, "jp\tL_f%d_bb_%d", func_emit_idx, sw->default_bb);
        return 0;
    }

    /* Table dispatch. The helper pops its return address as the table
       pointer, so the defw table MUST immediately follow the call. On
       no-match the helper jumps to the byte after the defw 0
       terminator — the `jp default` continuation. Entry layout:
         l_case:      defw target ; defw value
         l_long_case: defw target ; defw value_lo ; defw value_hi */
    if (is_long) {
        load_to_dehl(out, f, op->src[0]);
        emit(out, "call\tl_long_case");
        for (int i = 0; i < sw->n_cases; i++) {
            emit(out, "defw\tL_f%d_bb_%d", func_emit_idx,
                 sw->target_bb[i]);
            emit(out, "defw\t%d", (int)(sw->values[i] & 0xFFFF));
            emit(out, "defw\t%d", (int)((sw->values[i] >> 16) & 0xFFFF));
        }
    } else {
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
        emit(out, "call\tl_case");
        for (int i = 0; i < sw->n_cases; i++) {
            emit(out, "defw\tL_f%d_bb_%d", func_emit_idx,
                 sw->target_bb[i]);
            emit(out, "defw\t%d", (int)(sw->values[i] & 0xFFFF));
        }
    }
    emit(out, "defw\t0");
    emit(out, "jp\tL_f%d_bb_%d", func_emit_idx, sw->default_bb);
    return 0;
}

static int gen_ret_misdispatched(FILE *out, Func *f, const Op *op)
{
    (void)out; (void)f; (void)op;
    /* lower_func dispatches IR_RET directly to lower_ret(); seeing it
       here is a programmer error. */
    fputs("ir_lower: IR_RET dispatched through lower_op\n", stderr);
    return -1;
}

static int gen_critical_enter(FILE *out, Func *f, const Op *op)
{
    (void)f; (void)op;
    emit(out, "di");
    return 0;
}

static int gen_critical_leave(FILE *out, Func *f, const Op *op)
{
    (void)f; (void)op;
    emit(out, "ei");
    return 0;
}

/* BC tenant saved below a pre-pushed arg block (op->imm==1 on the
   call's first IR_PUSH_ARG). Stack of saved cur_bc_vreg values —
   nested calls pair LIFO with their gen_call pops. */
#define BC_ARGS_SAVE_MAX 8
static int bc_args_save_stack[BC_ARGS_SAVE_MAX];
static int bc_args_save_depth;

static int func_has_pr_bc(const Func *f)
{
    if (!f->vreg_to_phys) return 0;
    for (int i = 0; i < f->n_vregs; i++)
        if (f->vreg_to_phys[i] == IR_PR_BC) return 1;
    return 0;
}

static int gen_push_arg(FILE *out, Func *f, const Op *op)
{
    /* Call-arg push at the producer. ir_build emits this right after
       the arg's producing op, so the HL / DEHL cache is hot — for
       PR_HL / PR_DEHL arg temps (no slot) the cache hit is the ONLY
       way to reach the value. cur_sp_adjust keeps intervening slot
       loads (and the next pushes') offsets correct; gen_call's
       cleanup rebalances it. */
    if (op->imm == 1 && func_has_pr_bc(f)
        && bc_args_save_depth < BC_ARGS_SAVE_MAX) {
        /* First push of this call: save the PR_BC tenant BELOW the
           arg block (a save in gen_call would land above the args).
           gen_call's matching pop restores it after the cleanup. */
        emit(out, "push\tbc");
        bc_args_save_stack[bc_args_save_depth++] = cur_bc_vreg;
        cur_sp_adjust += 2;
    }
    int v = op->src[0];
    int w = (v >= 0 && v < f->n_vregs) ? f->vregs[v].width : 2;
    if (w == 4) {
        load_to_dehl(out, f, v);
        emit(out, "push\tde");
        emit(out, "push\thl");
        cur_sp_adjust += 4;
    } else {
        if (!hl_has(v)) load_to_hl(out, f, v);
        emit(out, "push\thl");
        cur_sp_adjust += 2;
    }
    return 0;
}

static int gen_push_dehl_long(FILE *out, Func *f, const Op *op)
{
    /* The long value to save must currently be in DEHL — ir_opt
       inserts the PUSH immediately after a long-producing op so DEHL
       is hot. We rely on the cache: if dehl_has(src[0]) we skip the
       load (free push); otherwise we load it first. */
    if (op->src[0] < 0) {
        fputs("ir_lower: IR_PUSH_DEHL_LONG with no src vreg\n", stderr);
        return -1;
    }
    if (!dehl_has(op->src[0])) {
        load_to_dehl(out, f, op->src[0]);
        emit(out, "push\tde");       /* high half */
        emit(out, "push\thl");       /* low half — popped first */
    } else {
        /* DEHL-cache hit. The invariant is BC = low half; HL only
           holds the low half when cur_hl_vreg advertises it (e.g.
           after cache_dehl_no_spill). The fp byte-direct dead-dst
           binop path caches with BC=low and HL=junk — pushing HL
           there pushed garbage as the low half (r10: gi^(gi>>16)
           lost the first operand under IR_LONG_PUSHES). */
        emit(out, "push\tde");       /* high half */
        emit(out, "push\t%s",
             (cur_hl_vreg == op->src[0]) ? "hl" : "bc");
    }
    cur_sp_adjust += 4;
    /* Option B: advertise the vreg as stack-resident so a later
       long-binop consumer (OR/AND/XOR/ADD/SUB) can absorb it directly
       via its stack-resident fastpath, eliding both the POP and a
       fresh slot spill of the intermediate result. */
    cur_stack_long_top = op->src[0];
    return 0;
}

static int gen_pop_dehl_long(FILE *out, Func *f, const Op *op)
{
    /* Restore the saved long into DEHL. Must be paired with a matching
       IR_PUSH_DEHL_LONG; the stack frame at this point must have the
       saved value on top. */
    if (cur_sp_adjust < 4) {
        fprintf(stderr,
            "ir_lower: IR_POP_DEHL_LONG with insufficient stack "
            "(cur_sp_adjust=%d)\n", cur_sp_adjust);
        return -1;
    }
    emit(out, "pop\thl");            /* low half (pushed last) */
    emit(out, "pop\tde");            /* high half */
    cur_sp_adjust -= 4;
    if (cur_stack_long_top == op->src[0])
        cur_stack_long_top = -1;
    if (op->src[0] >= 0) {
        /* The DEHL cache invariant wants BC = low half. Mirror
           HL → BC so the cache state is consistent.
           The pops physically clobbered HL and DE — drop any stale
           tenant claims BEFORE re-advertising DEHL (matches the
           store_dehl_cached convention). Without this, a consumer
           like gen_st_mem's DEHL-hit path stale-hits hl_has(base)
           and stores the value through itself as the address
           (md5 MD5Update miscompile under IR_LONG_PUSHES). */
        emit(out, "ld\tbc,hl");
        invalidate_hl_cache();
        cache_dehl(op->src[0]);
    } else {
        invalidate_hl_cache();
        invalidate_bc_cache();
    }
    return 0;
}

static int gen_asm(FILE *out, Func *f, const Op *op)
{
    (void)f;
    if (op->asm_text) {
        /* Raw passthrough — text is one or more newline-separated
           lines the user wrote inside __asm{}. Emit verbatim. */
        fputs(op->asm_text, out);
        if (op->asm_text[0]
            && op->asm_text[strlen(op->asm_text) - 1] != '\n')
            fputc('\n', out);
    }
    /* Inline asm is opaque — assume full register/cache clobber. */
    invalidate_hl_cache();
    invalidate_bc_cache();
    return 0;
}

static int gen_neg(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        /* Long NEG: DEHL = 0 - src[0], done as ~x + 1 byte-wise to
           avoid l_long_sub for a trivial constant LHS. */
        load_to_dehl(out, f, op->src[0]);
        emit(out, "ld\ta,l"); emit(out, "cpl");
        emit(out, "add\ta,1");        /* +1, sets carry if a was 0xff */
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
}

static int gen_not(FILE *out, Func *f, const Op *op)
{
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
            emit(out, "ld\thl,bc");         /* HL = low half */
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Long ~: cpl each byte of DEHL. The chain reads H/L/E/D
           only — no BC use. Tell load_to_dehl's FP path to skip
           its BC stash (saves 2B). store_dehl_finalize at the
           tail handles re-publishing BC for the new dst. */
        cur_load_to_dehl_no_bc = 1;
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
}

static int gen_conv_zx(FILE *out, Func *f, const Op *op)
{
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

static int gen_conv_sx(FILE *out, Func *f, const Op *op)
{
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

static int gen_conv_trunc(FILE *out, Func *f, const Op *op)
{
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

static int gen_conv_byte_to_high(FILE *out, Func *f, const Op *op)
{
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

static int gen_shl(FILE *out, Func *f, const Op *op)
{
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
        /* In-place long << 1 on a stack slot. Walks the 4 bytes
           via `sla (hl); rl (hl); rl (hl); rl (hl)` from LSB up,
           skipping the DEHL roundtrip. Smaller than 4 × `sla
           (ix+d)`; works in FP mode (sp still valid). */
        if (count == 1
            && op->dst == op->src[0]
            && !cur_dst_dead
            && !vreg_in_pr_bc(f, op->dst)
            && f->vreg_to_phys
            && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
            int off = slot_off(f, op->dst) + cur_sp_adjust;
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
            ss_note_reload(f, op->src[0]);
            if (fp_active(f)) {
                int ix = slot_ix_off(f, op->src[0]);
                if (fp_offset_fits(ix)) {
                    emit(out, "ld\th,(%s%+d)", frame_reg(), ix);
                    emit(out, "ld\tl,0");
                    goto shl_int_bit_remainder;
                }
            }
            int off = slot_off(f, op->src[0]) + cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
            emit(out, "ld\th,(hl)");        /* H = byte 0 */
            emit(out, "ld\tl,0");
            goto shl_int_bit_remainder;
        }
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
        /* Strength reduction for shifts of 8+: the high byte of
           the input is shifted out entirely, so the result has
           input's low byte in H and 0 in L. Then any extra shifts
           above 8 are normal `add hl,hl` steps. Saves 8 instructions
           vs the straight unroll for count==8 (the common
           `byte << 8` zero-extend-and-promote pattern). */
        int skip = cur_skip_shl_add_hl;
        cur_skip_shl_add_hl = 0;
        if (count >= 8) {
            emit(out, "ld\th,l");
            emit(out, "ld\tl,0");
        shl_int_bit_remainder:
            for (int k = 8; k < count; k++) emit(out, "add\thl,hl");
        } else {
            for (int k = skip; k < count; k++) emit(out, "add\thl,hl");
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

/* Add a small constant to HL. |off| <= 3 uses inc/dec hl (1 byte /
   6T each); larger offsets load the scratch pair (BC when DE must be
   preserved, e.g. long loads). */
static void emit_hl_add_offset(FILE *out, int off, int use_bc)
{
    if (off == 0) return;
    if (off > 0 && off <= 3) {
        for (int i = 0; i < off; i++) emit(out, "inc\thl");
        return;
    }
    if (off < 0 && off >= -3) {
        for (int i = 0; i < -off; i++) emit(out, "dec\thl");
        return;
    }
    emit(out, "ld\t%s,%d", use_bc ? "bc" : "de", off);
    emit(out, "add\thl,%s", use_bc ? "bc" : "de");
}

static int gen_ld_mem(FILE *out, Func *f, const Op *op)
{
    emit_ns_switch(out, mem_bank_fn(&op->mem));   /* __addressmod: page in */
    if (op->dst >= 0 && f->vregs[op->dst].width > 4) {
        /* Wide load: address into HL, acc_load→accumulator, store→dst slot. */
        if (op->mem.kind == IR_MEM_POOL) {
            /* Big-constant literal pool: `i_<litlab>` (const.c bigconst). */
            emit(out, "ld\thl,i_%d", op->mem.offset);
        } else if (op->mem.kind == IR_MEM_SYM) {
            if (op->mem.offset)
                emit(out, "ld\thl,_%s+%d", ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\thl,_%s", ir_sym_name(op->mem.sym));
        } else {
            load_to_hl(out, f, op->mem.base);
        }
        emit(out, "call\t%s", acc_prim(f, op->dst, "load"));
        emit_acc_slot_addr(out, f, op->dst, 0);
        emit_acc_store_hl(out, f, op->dst);
        invalidate_hl_cache(); invalidate_bc_cache();
        cur_fa_vreg = op->dst;
        return 0;
    }
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
            /* __far pointer VALUE is 3 bytes in memory: the 4th byte read
               by `ld de,(sym+2)` is garbage (it's sym+3). Zero D to keep
               the DEHL far-ptr invariant (D=0, E=bank, HL=offset). */
            if (op->mem.elem == KIND_CPTR)
                emit(out, "ld\td,0");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        if (dst_w == 1) {
            /* Byte load from a global. Value stays in A; consumers
               widen via load_to_hl's width-1 path / load_byte_to_a
               (both A-cache aware). The spill MUST be byte-sized —
               store_a_byte, not store_hl — the slot is allocated
               from vreg width (1), so a word spill into a trailing
               byte slot writes one past the frame and clobbers the
               return address (byte_shl8_promotes). */
            if (op->mem.offset)
                emit(out, "ld\ta,(_%s+%d)",
                     ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\ta,(_%s)", ir_sym_name(op->mem.sym));
            if (cur_dst_dead || vreg_in_register_pool(f, op->dst)) {
                cache_a(op->dst);
            } else {
                store_a_byte(out, f, op->dst);
            }
            return 0;
        }
        /* PR_DE dst: load into DE directly, no spill. */
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
        /* Fused (long)*p++ fastpath. When the load is a byte-to-long
           zero-extend with a post-inc on the base pointer (set only
           by the OP_CAST char→long path in ir_build), increment p's
           slot in place via `inc (hl)` and read the byte directly —
           skips the byte spill + reload across IR_INC. Needs p
           addressable via sp+K, which excludes PR_BC. */
        int _dst_w = f->vregs[op->dst].width;
        if (_dst_w == 4
            && op->mem.post_step == 1
            && op->mem.base >= 0
            && !vreg_in_pr_bc(f, op->mem.base)) {
            int p_off = slot_off(f, op->mem.base) + cur_sp_adjust;
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
        /* Width 4 can't clobber DE (needed for the high half) —
           scratch through BC; widths 1/2 use DE. Small offsets
           become inc/dec hl chains. */
        emit_hl_add_offset(out, op->mem.offset, dst_w == 4);
        if (dst_w == 1) {
            /* Byte load into A. If dst is dead-after-next (the
               common `b = *p; foo((int)b)` shape via CONV), keep
               the byte in A and let the CONV's load_byte_to_a
               become a cache hit. cache_a is set; invalidate
               HL/DE since the address load clobbered them. */
            emit(out, "ld\ta,(hl)");
            /* NOTE: caching the base here (HL is intact when offset==0)
               looked like a free win for the following p++ but
               regressed crc16 fp +1.4% through a cache-interaction
               chain (the INC hit changes what spill staging leaves in
               DE for the next CONV). Needs a lookahead-gated version;
               keep the plain invalidate for now. */
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
            /* PR_DE dst: same byte sequence but writes E/D, no
               spill. HL becomes scratch (slot+1, untracked). */
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
}

static int gen_st_mem(FILE *out, Func *f, const Op *op)
{
    emit_ns_switch(out, mem_bank_fn(&op->mem));   /* __addressmod: page in */
    if (op->src[0] >= 0 && f->vregs[op->src[0]].width > 4) {
        /* Wide double store: dload(src)→FA, address into HL, dstore. */
        if (cur_fa_vreg != op->src[0]) {
            emit_acc_slot_addr(out, f, op->src[0], 0);
            emit(out, "call\t%s", acc_prim(f, op->src[0], "load"));
        }
        if (op->mem.kind == IR_MEM_SYM) {
            if (op->mem.offset)
                emit(out, "ld\thl,_%s+%d", ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\thl,_%s", ir_sym_name(op->mem.sym));
        } else {
            load_to_hl(out, f, op->mem.base);
        }
        emit_acc_store_hl(out, f, op->src[0]);
        invalidate_hl_cache(); invalidate_bc_cache();
        cur_fa_vreg = -1;
        return 0;
    }
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
            if (op->mem.elem == KIND_CPTR) {
                /* __far pointer VALUE is 3 bytes in memory: write the
                   bank byte (E) only, never the 4th DEHL byte (D) — that
                   would clobber the adjacent global (sym+3). */
                emit(out, "ld\ta,e");
                emit(out, "ld\t(_%s+%d),a", ir_sym_name(op->mem.sym), off + 2);
                invalidate_a_cache();
                return 0;
            }
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
            emit_hl_add_offset(out, op->mem.offset, 1);
            emit(out, "ld\t(hl),e");
            /* HL walked to base+offset — the cache claim on base is
               stale for offset != 0 (a following [base+k] store would
               inc-walk from the wrong position). */
            if (op->mem.offset != 0)
                invalidate_hl_cache();
        } else if (src_w == 4) {
            int small_off = (op->mem.offset >= -3 && op->mem.offset <= 3);
            int src_slotted = f->vreg_to_phys
                && (f->vreg_to_phys[op->src[0]] == IR_PR_SPILL
                    || (f->vregs[op->src[0]].flags & IR_VREG_PARAM));
            if (dehl_has(op->src[0]) && small_off
                && !vreg_in_pr_bc(f, op->mem.base)) {
                /* DEHL cache hit: DE = high half, BC = low half — HL
                   is free for the address. Zero stack traffic. (PR_BC
                   bases excluded: their reload would clobber the low
                   half in BC. Small offsets only — a scratch-pair add
                   would clobber DE or BC.) */
                if (!hl_has(op->mem.base))
                    load_to_hl(out, f, op->mem.base);
                emit_hl_add_offset(out, op->mem.offset, 0); /* inc/dec only */
                emit(out, "ld\t(hl),c");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),b");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),e");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),d");
                invalidate_hl_cache();
                /* DE/BC untouched — the DEHL cache stays valid. */
            } else if (src_slotted && small_off) {
                /* Value lives in its slot: address into DE, then walk
                   the value bytes through A. No DEHL round-trip, no
                   stack staging. */
                load_to_de(out, f, op->mem.base);
                for (int i = 0; i < op->mem.offset; i++)
                    emit(out, "inc\tde");
                for (int i = 0; i > op->mem.offset; i--)
                    emit(out, "dec\tde");
                if (fp_active(f)
                    && fp_offset_fits(slot_ix_off(f, op->src[0]))
                    && fp_offset_fits(slot_ix_off(f, op->src[0]) + 3)) {
                    int vx = slot_ix_off(f, op->src[0]);
                    for (int i = 0; i < 4; i++) {
                        emit(out, "ld\ta,(%s%+d)", frame_reg(), vx + i);
                        emit(out, "ld\t(de),a");
                        if (i < 3) emit(out, "inc\tde");
                    }
                } else {
                    int voff = slot_off(f, op->src[0]) + cur_sp_adjust;
                    emit(out, "ld\thl,%d", voff);
                    emit(out, "add\thl,sp");
                    for (int i = 0; i < 4; i++) {
                        emit(out, "ld\ta,(hl)");
                        emit(out, "ld\t(de),a");
                        if (i < 3) {
                            emit(out, "inc\thl");
                            emit(out, "inc\tde");
                        }
                    }
                    invalidate_hl_cache();
                }
                invalidate_de_cache();
            } else {
                /* Fallback (large offset / cache-miss PR_DEHL): stage
                   the value on the stack to free DEHL for the address.
                   sp shifts by 4 after the pushes — load_to_hl_adj
                   compensates the mem.base slot offset. */
                load_to_dehl(out, f, op->src[0]);
                emit(out, "push\tde");          /* save HIGH half */
                emit(out, "push\thl");          /* save LOW half */
                load_to_hl_adj(out, f, op->mem.base, 4);
                emit_hl_add_offset(out, op->mem.offset, 1);
                emit(out, "pop\tbc");           /* BC = LOW */
                emit(out, "ld\t(hl),c");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),b");
                emit(out, "inc\thl");
                emit(out, "pop\tbc");           /* BC = HIGH */
                emit(out, "ld\t(hl),c");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),b");
                invalidate_hl_cache();
                invalidate_bc_cache();
            }
        } else {
            load_to_hl(out, f, op->src[0]);
            emit(out, "ex\tde,hl");         /* DE = value */
            load_to_hl(out, f, op->mem.base);
            emit_hl_add_offset(out, op->mem.offset, 1);
            emit(out, "ld\t(hl),e");
            emit(out, "inc\thl");
            emit(out, "ld\t(hl),d");
            /* HL = base+offset+1 — always past the cached base. */
            invalidate_hl_cache();
        }
        return 0;
    }
    fprintf(stderr, "ir_lower: IR_ST_MEM kind %d not yet supported\n",
            (int)op->mem.kind);
    return -1;
}

static int gen_add(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 4
        && vreg_kind_is_integer(f, op->dst)) {
        /* Long add. Operand b pushed (HIGH then LOW), then DEHL = a.
           Inline the helper body directly — calling l_long_add would
           clobber IX (helper uses `pop ix` to stash retaddr), which
           breaks frame-pointer mode. */
        if (op->src[1] == -1) {
            /* In-place const ADD on a stack slot: add K's bytes
               directly through A. Skips the DEHL load+store round
               trip. Gated off when dst is dead. */
            uint32_t k = (uint32_t)op->imm;
            if (op->dst == op->src[0]
                && !cur_dst_dead
                && !dehl_has(op->src[0])
                && cur_stack_long_top != op->src[0]
                && !vreg_in_pr_bc(f, op->dst)
                && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
                /* dehl_has / stack-top exclusions: the producer may
                   have skipped the slot spill (cache_dehl_no_spill,
                   IR_PUSH_DEHL_LONG) — the slot is then STALE and
                   this in-place RMW would add K to garbage (t12:
                   ROTATE_LEFT result never landed in the slot). The
                   const-RHS DEHL path below serves the cached case. */
                int off = slot_off(f, op->dst) + cur_sp_adjust;
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
        /* Stack-resident LHS: one src sits on the data stack from
           an earlier IR_PUSH_DEHL_LONG. Read its bytes via (hl)
           while adding the other src from our local save. ADD is
           commutative; carry chains naturally because pop / inc hl
           / ld don't touch flags.
           Valid in FP mode too — the reads are sp-relative and sp
           is live alongside IX. MUST come before the fp byte-direct
           path: that path reads the operand's (ix+d) slot, which the
           PUSH elided the write to (md5 MD5Update miscompile under
           IR_LONG_PUSHES). */
        {
        int optb_dehl_src = -1;
        if (cur_stack_long_top >= 0) {
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
            emit(out, "ld\thl,bc");           /* HL = result low */
            /* Drop the data-stack frame. */
            emit(out, "pop\tbc");
            emit(out, "pop\tbc");
            cur_sp_adjust -= 4;
            cur_stack_long_top = -1;
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        }
        /* FP-mode byte-direct long ADD. One src comes from the DEHL
           cache (BC=low, DE=high), the other from (ix+d). add/adc
           via A; ld a,(...) and ld <reg>,a preserve flags so the
           carry chain survives across bytes. */
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
                    /* Prefer H/L for the low half when HL is
                       advertised as holding from_dehl (the
                       producer's cache_dehl_no_spill set
                       cur_hl_vreg). The `ld bc,hl` stash in the
                       producer is then dead and was skipped via
                       cur_dehl_dst_no_bc_stash. Falls back to
                       B/C for mid-chain consumers where
                       cur_hl_vreg got reset by the previous
                       byte-direct emit. */
                    int use_hl = (from_dehl >= 0
                                  && cur_hl_vreg == from_dehl);
                    static const char *bc_byte[4] =
                        { "c", "b", "e", "d" };
                    static const char *hl_byte[4] =
                        { "l", "h", "e", "d" };
                    const char **sb = use_hl ? hl_byte : bc_byte;
                    for (int i = 0; i < 4; i++) {
                        if (from_dehl >= 0)
                            emit(out, "ld\ta,%s", sb[i]);
                        else
                            emit(out, "ld\ta,(%s%+d)",
                                 frame_reg(), s0 + i);
                        emit(out, "%s\ta,(%s%+d)",
                             i == 0 ? "add" : "adc",
                             frame_reg(), s1 + i);
                        if (cur_dst_dead)
                            emit(out, "ld\t%s,a",
                                 bc_byte[i]);
                        else
                            emit(out, "ld\t(%s%+d),a",
                                 frame_reg(), dd + i);
                    }
                    if (cur_dst_dead) {
                        /* Skip eager `ld hl,bc` — DEHL cache
                           invariant is BC=low + DE=high + (HL may
                           or may not have low). Downstream
                           load_to_dehl on cache hit emits the
                           recover itself; downstream byte-direct
                           or byte-A ops never need HL. */
                        hl_about_to_change(-1);
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
        /* Fused load+add: point HL at the RHS slot, do `add (hl)` /
           `adc (hl)` byte-wise with LHS bytes read from D/E (HIGH)
           and B/C (LOW, the DEHL-cache mirror). Only fires when RHS
           is sp-rel and not in the DEHL cache. */
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
            emit(out, "ld\thl,bc");          /* DEHL = result */
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Non-fused long ADD: stage both srcs through DEHL with a
           stack save in between. src[0]'s load skips its trailing
           `ld l,c; ld h,b` — we pop HL from b.LSW next anyway. */
        load_to_dehl(out, f, op->src[1]);
        emit(out, "push\tde");                  /* HIGH */
        emit(out, "push\thl");                  /* LOW */
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
}

static int gen_sub(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        if (op->src[1] == -1) {
            uint32_t k = (uint32_t)op->imm;
            /* In-place const SUB on a stack slot (mirror of the ADD
               form). `sub` clears carry on entry; later bytes sbc. */
            if (op->dst == op->src[0]
                && !cur_dst_dead
                && !vreg_in_pr_bc(f, op->dst)
                && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
                int off = slot_off(f, op->dst) + cur_sp_adjust;
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
                (void)s_subtra;
                if (srcs_ok && dst_ok) {
                    /* See ADD fastpath: prefer H/L for low half
                       when cur_hl_vreg matches from_dehl. Saves
                       the producer's ld bc,hl when paired with
                       the cur_dehl_dst_no_bc_stash lookahead. */
                    int use_hl = (from_dehl >= 0
                                  && cur_hl_vreg == from_dehl);
                    static const char *bc_byte[4] =
                        { "c", "b", "e", "d" };
                    static const char *hl_byte[4] =
                        { "l", "h", "e", "d" };
                    const char **sb = use_hl ? hl_byte : bc_byte;
                    for (int i = 0; i < 4; i++) {
                        /* Load minuend (src[0]) into A. */
                        if (from_dehl >= 0 && !swap)
                            emit(out, "ld\ta,%s", sb[i]);
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
                                emit(out, "sub\t%s", sb[i]);
                            else
                                emit(out, "sbc\ta,%s", sb[i]);
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
                                 bc_byte[i]);
                        else
                            emit(out, "ld\t(%s%+d),a",
                                 frame_reg(), dd + i);
                    }
                    if (cur_dst_dead) {
                        /* See ADD fastpath comment on the cache
                           state we leave behind. */
                        hl_about_to_change(-1);
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
        /* Fused load+sub: HL points at RHS slot, byte-wise sub/sbc
           through (hl) with LHS bytes from D/E/B/C. `sub` has no
           carry-in so the first byte sets borrow for the sbc chain. */
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
            emit(out, "ld\thl,bc");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Non-fused long SUB: push a (HIGH/LOW), load b into DEHL,
           inline the helper body. l_long_sub would clobber IX.
           b's load skips HL recovery — we pop HL from a.LSW next. */
        load_to_dehl(out, f, op->src[0]);
        emit(out, "push\tde");
        emit(out, "push\thl");
        cur_load_to_dehl_no_hl = 1;
        load_to_dehl_adj(out, f, op->src[1], 4);    /* BC = b.LSW */
        emit(out, "pop\thl");                       /* HL = a.LSW */
        emit(out, "or\ta");                         /* clear carry */
        emit(out, "sbc\thl,bc");                    /* HL = a-b LOW */
        emit(out, "ex\tde,hl");                     /* DE = LOW, HL = b.MSW */
        emit(out, "ld\tbc,hl");                     /* BC = b.MSW */
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
}

/* Bitwise ops — z80 only operates on A, so do it byte-by-byte. */
static int gen_bitop(FILE *out, Func *f, const Op *op)
{
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
                    hl_about_to_change(-1);
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
                /* Single-bit shortcut: OR with one bit → `set n,r`,
                   AND with one bit clear → `res n,r`. XOR has no
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
        /* Stack-resident LHS variant: one src sits on the data
           stack from an earlier IR_PUSH_DEHL_LONG. Read its bytes
           via (hl) on the stack while the other src (from DEHL)
           goes through A. Skips the POP+reload+re-push the generic
           path would otherwise force.
           Valid in FP mode too (sp-relative reads) — and must come
           before the fp byte-direct path, which would read the
           stale (ix+d) slot the PUSH elided the write to. */
        int optb_dehl_src = -1;
        if (cur_stack_long_top >= 0) {
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
            /* Drop the data-stack frame. */
            emit(out, "pop\tbc");
            emit(out, "pop\tbc");
            cur_sp_adjust -= 4;
            cur_stack_long_top = -1;
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* FP-mode byte-direct: walk bytes through A using either
           (ix+d) or DEHL registers:
             ld a,(ix+s0+i)   OR   ld a,<reg from dehl>
             <op> a,(ix+s1+i) OR   <op> a,<reg from dehl>
             ld <dest>,a      (dest = (ix+d+i) live / dehl reg dead)
           AND/OR/XOR are commutative — either src can occupy DEHL,
           the other walks via (ix+d). */
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
                    /* See ADD fastpath: prefer H/L for low half
                       when cur_hl_vreg matches from_dehl. */
                    int use_hl = (from_dehl >= 0
                                  && cur_hl_vreg == from_dehl);
                    static const char *bc_byte[4] =
                        { "c", "b", "e", "d" };
                    static const char *hl_byte[4] =
                        { "l", "h", "e", "d" };
                    const char **sb = use_hl ? hl_byte : bc_byte;
                    for (int i = 0; i < 4; i++) {
                        if (from_dehl >= 0)
                            emit(out, "ld\ta,%s", sb[i]);
                        else
                            emit(out, "ld\ta,(%s%+d)",
                                 frame_reg(), s0 + i);
                        emit(out, "%s\ta,(%s%+d)",
                             mnem, frame_reg(), s1 + i);
                        if (cur_dst_dead)
                            emit(out, "ld\t%s,a",
                                 bc_byte[i]);
                        else
                            emit(out, "ld\t(%s%+d),a",
                                 frame_reg(), dd + i);
                    }
                    if (cur_dst_dead) {
                        hl_about_to_change(-1);
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
           can skip load_to_dehl's HL recovery if we stage the
           low-half push from BC (which the cache invariant
           guarantees holds src[0].low) — saves 2 bytes vs the
           recovered HL + push hl form.
           Commutative swap FIRST: if only src[1] is DEHL-cached,
           consume it as the staged operand — loading the uncached
           src[0] first clobbers the cache, and src[1]'s SLOT may be
           stale (an explicit IR_POP materialises registers only;
           the matching PUSH elided the spill). vw6: r ^ popped
           (gl>>16) read garbage from the never-written slot. */
        int bsrc0 = op->src[0], bsrc1 = op->src[1];
        if (!dehl_has(bsrc0) && dehl_has(bsrc1)) {
            int t = bsrc0; bsrc0 = bsrc1; bsrc1 = t;
        }
        int src0_cached = dehl_has(bsrc0);
        if (!src0_cached)
            load_to_dehl(out, f, bsrc0);
        emit(out, "push\tde");
        if (src0_cached)
            emit(out, "push\tbc");
        else
            emit(out, "push\thl");
        /* Fused load+op fastpath: instead of loading RHS into DEHL
           then byte-op through A, point HL at the RHS slot and do
           `<op> (hl)` directly with LHS bytes popped off the stack.
           Saves the full DEHL load (4 byte reads + cache stash =
           11 inst) by fusing it into the byte-op chain. Only fires
           when the RHS lives sp-rel (FP-mode would need extra ops
           to compute HL from IX — not a win) and isn't already in
           the DEHL cache. */
        /* Inline-push fast path: src[1] was pushed to the data stack
           by store_dehl_finalize (chain-OR accumulate). It sits at
           sp+4 after the two computation pushes above (push de + push
           bc/hl = 4 bytes).  Must pop it BEFORE store_dehl_finalize
           so a chained push for dst lands cleanly at sp+0. */
        int src1_inline_pushed = (!fp_active(f)
                                  && cur_dehl_inline_push == bsrc1
                                  && cur_sp_adjust == cur_dehl_inline_push_base_sp);
        if (!fp_active(f) && (!dehl_has(bsrc1) || src1_inline_pushed)) {
            int off = src1_inline_pushed ? 4
                    : slot_off(f, bsrc1) + 4 + cur_sp_adjust;
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
            if (src1_inline_pushed) {
                emit(out, "pop\tbc");
                emit(out, "pop\tbc");
                cur_sp_adjust -= 4;
                cur_dehl_inline_push = -1;
            }
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        load_to_dehl_adj(out, f, bsrc1, 4);
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
        /* Shift-and-test fused fastpath (CRC inner loop archetype):
             if (v & 0x8000) v = (v << 1) ^ P; else v <<= 1;
           lowers to AND mask 0x8000 + BR_ZERO + (SHL by 1 in both
           succs). `add hl,hl` does the shift AND sets CF = old
           bit 15, so we can fold the test into it and elide the
           two SHL ops. Saves 2-3 instructions per fire × 8 unrolled
           iterations × hot loop = significant tick reduction.

           Conditions:
             - mask is exactly 0x8000
             - the AND's dst is dead at the BR (already checked
               via cur_branch_test_kind being set)
             - both BB succs' first non-PHI op is IR_SHL of
               op->src[0] by 1
             - the SHL dst in BB_skip is op->src[0] itself
               (in-place "v <<= 1") so HL-tracking lines up */
        if (k == 0x8000 && cur_bb != NULL
            && cur_bb->succ[0] >= 0 && cur_bb->succ[1] >= 0
            && shl_skip_n + 2 <= SHL_SKIP_CAP) {
            /* cur_bb->succ[0] is the conditional-branch target
               (the BR_ZERO/COND label), succ[1] the fall-through.
               IR convention: BR_ZERO branches to succ[0] when
               v==0; the IR is laid out so succ[0] = "skip" path
               (no XOR), succ[1] = "poly" path (XOR). The skip BB
               does `v <<= 1` (in-place SHL writing to src[0]);
               the poly BB does `t = v << 1; v ^= P; ...` (SHL
               to a fresh vreg, then XOR-in-place). */
            int skip_id = cur_branch_test_label;
            int poly_id = (cur_bb->succ[0] == skip_id)
                          ? cur_bb->succ[1] : cur_bb->succ[0];
            const BB *bb_skip = NULL, *bb_poly = NULL;
            for (int bi = 0; bi < f->n_bbs; bi++) {
                if (f->bbs[bi].id == skip_id) bb_skip = &f->bbs[bi];
                if (f->bbs[bi].id == poly_id) bb_poly = &f->bbs[bi];
            }
            int ok = (bb_skip && bb_poly
                && bb_skip->n_ops > 0 && bb_poly->n_ops > 0
                && bb_skip->ops[0].kind == IR_SHL
                && bb_skip->ops[0].src[0] == op->src[0]
                && bb_skip->ops[0].src[1] == -1
                && bb_skip->ops[0].imm == 1
                && bb_skip->ops[0].dst == op->src[0]
                && bb_poly->ops[0].kind == IR_SHL
                && bb_poly->ops[0].src[0] == op->src[0]
                && bb_poly->ops[0].src[1] == -1
                && bb_poly->ops[0].imm == 1);
            if (ok) {
                if (!hl_has(op->src[0]))
                    load_to_hl(out, f, op->src[0]);
                else
                    ss_note_cache_read(f, op->src[0]);  /* served from HL */
                emit(out, "add\thl,hl");
                /* CF = old bit 15 of src[0]. BR_ZERO branches when
                   AND result was 0 → old bit 15 was 0 → CF clear. */
                const char *cc =
                    (cur_branch_test_kind == IR_BR_ZERO) ? "nc" : "c";
                emit(out, "jp\t%s,L_f%d_bb_%d",
                     cc, func_emit_idx, skip_id);
                /* HL now holds the shifted value. From the lowerer's
                   cache POV, that's bb_skip's SHL dst (= op->src[0])
                   AND bb_poly's SHL dst (fresh vreg). Record both
                   skips with the cache vreg id to advertise at BB
                   entry. */
                /* cache_vreg is the SHL's src[0] (= op->src[0]
                   for the AND-mask op too). Setting cur_hl_vreg
                   to this makes the SHL handler's `hl_has(src[0])`
                   check return true, so it skips load_to_hl. With
                   cur_skip_shl_add_hl=1 the shift loop is also
                   skipped — the spill + cache_hl(dst) tail then
                   publishes the shifted HL to dst's slot/cache. */
                shl_skip[shl_skip_n].bb_id = bb_skip->id;
                shl_skip[shl_skip_n].op_idx = 0;
                shl_skip[shl_skip_n].cache_vreg = op->src[0];
                shl_skip_n++;
                shl_skip[shl_skip_n].bb_id = bb_poly->id;
                shl_skip[shl_skip_n].op_idx = 0;
                shl_skip[shl_skip_n].cache_vreg = op->src[0];
                shl_skip_n++;
                hl_about_to_change(op->src[0]);
                cur_skip_next_op = 1;
                return 0;
            }
        }
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
        /* Single-bit shortcut (int variant): set/res for AND/OR
           when K or ~K is a single bit. XOR excluded — no
           toggle-bit instruction. */
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

static int gen_call(FILE *out, Func *f, const Op *op)
{
    CallInfo *ci = op->call;
    if (!ci) {
        fputs("ir_lower: IR_CALL with NULL CallInfo\n", stderr);
        return -1;
    }
    int is_indirect = (ci->target == NULL);
    if (is_indirect && ci->fnptr_vreg < 0) {
        fputs("ir_lower: indirect IR_CALL missing fnptr_vreg\n",
              stderr);
        return -1;
    }
    if (ci->is_critical)
        emit(out, "di");

    int pre = (ci->pre_pushed > 0);

    /* PR_BC across calls: callees clobber BC, so save it if the
       function has any PR_BC vreg. Conservative — saved
       unconditionally rather than checked per-op. Pre-pushed calls
       never coexist with PR_BC (a `push bc` here would land ABOVE
       the already-pushed args); ir_alloc disables the PR_BC pool in
       functions containing IR_PUSH_ARG. */
    int bc_saved = 0;
    int bc_vreg_at_call_entry = cur_bc_vreg;
    if (!pre) {
        for (int i = 0; i < f->n_vregs; i++) {
            if (f->vreg_to_phys[i] == IR_PR_BC) { bc_saved = 1; break; }
        }
    }
    if (bc_saved) {
        emit(out, "push\tbc");
    }
    int sp_adj_extra = bc_saved ? 2 : 0;

    /* Push args. SMALLC: left-to-right (matches typical z88dk).
       STDC: right-to-left. CALLEE: same as SMALLC at push time;
       callee just cleans the stack after ret instead of us.

       Each push shifts sp, but slot loads use `add hl,sp`. So we
       bump the slot offset by the bytes already pushed (+ saved BC)
       so each `add hl,sp` still lands on the original slot. */
    /* Fastcall: push n-1 args via the active ABI (SMALLC L→R or
       STDC R→L — same flag isn't applied here, fastcall just
       uses SMALLC order historically), then load the LAST arg
       into HL (or DEHL for width 4) just before the call. The
       `n_args` we iterate over here is n-1 in fastcall mode;
       the last arg's load is emitted further down. */
    int pushed_bytes = 0;
    int is_fastcall = (ci->abi == IR_ABI_FASTCALL);
    int n_to_push   = is_fastcall ? (ci->n_args - 1) : ci->n_args;
    int push_step = (ci->abi == IR_ABI_STDC) ? -1 : 1;
    int start    = (ci->abi == IR_ABI_STDC) ? (n_to_push - 1) : 0;
    if (pre) {
        /* Args already on the stack via IR_PUSH_ARG ops (which bumped
           cur_sp_adjust). Just tally the bytes for the variadic count
           and the cleanup pops. */
        for (int k = 0; k < n_to_push; k++)
            pushed_bytes += (f->vregs[ci->args[k]].width == 4) ? 4 : 2;
        n_to_push = 0;
    }
    for (int k = 0; k < n_to_push; k++) {
        int i = start + k * push_step;
        int slot = slot_off(f, ci->args[i]);
        int adj  = slot + pushed_bytes + sp_adj_extra + cur_sp_adjust;
        int width = f->vregs[ci->args[i]].width;
        if (width > 4) {
            /* Wide double arg: load the slot into the accumulator and push
               it — combined (dldpsh) when the format provides it, else
               load + push. */
            emit_acc_slot_addr(out, f, ci->args[i], pushed_bytes + sp_adj_extra);
            if (acc_prim(f, ci->args[i], "loadpush")) {
                emit(out, "call\t%s", acc_prim(f, ci->args[i], "loadpush"));
            } else {
                emit(out, "call\t%s", acc_prim(f, ci->args[i], "load"));
                emit(out, "call\t%s", acc_prim(f, ci->args[i], "push"));
            }
            pushed_bytes += width;
            invalidate_hl_cache();
        } else if (width == 4) {
            /* Long arg: load via load_to_dehl_adj (DEHL = value),
               then `push de; push hl` so sp[0]=low, sp[2]=high
               matching the z88dk lpush() convention. */
            load_to_dehl_adj(out, f, ci->args[i],
                             pushed_bytes + sp_adj_extra);
            emit(out, "push\tde");
            emit(out, "push\thl");
            pushed_bytes += 4;
        } else if (width == 1 && (ci->flags & SDCCDECL)) {
            /* __z88dk_sdccdecl char arg: push ONE byte. Read the byte from
               its slot (offset adj covers prior pushes), then `push af;
               inc sp` leaves A (the char) at sp+0 and reclaims the F byte
               — no BC clobber (unlike sccz80's `ld b,l; push bc; inc sp`). */
            emit(out, "ld\thl,%d", adj);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,(hl)");
            emit(out, "push\taf");
            emit(out, "inc\tsp");
            pushed_bytes += 1;
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

    /* Fastcall: load the last arg into HL (width 1/2) or DEHL
       (width 4) immediately before the call. The arg's load
       must come AFTER all pushes — earlier pushes shift sp,
       and load_to_hl_adj / load_to_dehl_adj accept an sp_adj
       parameter to compensate. */
    if (is_fastcall && ci->n_args > 0) {
        /* Pre-pushed args already live in cur_sp_adjust, which the
           load helpers add themselves — no extra adj then. */
        int adj = pre ? 0 : pushed_bytes + sp_adj_extra;
        int last = ci->n_args - 1;
        int width = f->vregs[ci->args[last]].width;
        if (width == 4) {
            load_to_dehl_adj(out, f, ci->args[last], adj);
        } else {
            load_to_hl_adj(out, f, ci->args[last], adj);
        }
    }

    /* SMALLC variadic ABI: emit `ld a,bytes/2` (or `xor a` if 0)
       immediately before the call. Stdc and fastcall don't need it. The
       stuffed pointer (pushed below) is not part of the arg count. */
    if (ci->is_variadic && ci->abi == IR_ABI_SMALLC) {
        int n = pushed_bytes / 2;
        if (n == 0) emit(out, "xor\ta");
        else        emit(out, "ld\ta,%d", n);
    }

    /* long long return: push the hidden result-buffer pointer (&__i64_acc)
       last, so it lands just above the return address (callee param offsets
       already account for the +2). The result comes back in __i64_acc; the
       caller-cleanup below pops this with the args. */
    if (ci->ret_longlong) {
        emit(out, "ld\tbc,__i64_acc");
        emit(out, "push\tbc");
        pushed_bytes += 2;
        if (pre) cur_sp_adjust += 2;
    }

    if (is_indirect && ci->far_fnptr) {
        /* __far function pointer: materialize the far address into DEHL
           (EHL = E:bank, HL:offset), set A = arg-word count, and dispatch
           through l_farcall (the banking trampoline pages bank E and calls
           offset HL). Mirrors the walker's gen_farcall register contract;
           l_farcall reads EHL, so — unlike sccz80's calling convention —
           the fnptr need not also sit on the stack. The args are popped by
           the caller-cleanup below. (l_farcall is not yet provided by any
           target lib: this emits a loud link error rather than the silent
           near miscompile l_jphl produced.) */
        load_to_dehl_adj(out, f, ci->fnptr_vreg,
                         pre ? 0 : pushed_bytes + sp_adj_extra);
        int argwords = pushed_bytes / 2;
        if (argwords == 0) emit(out, "xor\ta");
        else               emit(out, "ld\ta,%d", argwords);
        emit(out, "call\tl_farcall");
    } else if (is_indirect) {
        /* Load funcptr into HL then `call l_jphl` (the `jp (hl)`
           thunk). The call pushes the return address; l_jphl
           immediately jumps to HL — the target's `ret` returns
           to our call-site. Offset for the fnptr's slot picks
           up the pushed arg bytes + saved BC (sp_adj_extra);
           pre-pushed args are already in cur_sp_adjust. */
        load_to_hl_adj(out, f, ci->fnptr_vreg,
                       pre ? 0 : pushed_bytes + sp_adj_extra);
        emit(out, "call\tl_jphl");
    } else if ((ci->flags & SHORTCALL) && !(ci->flags & SHORTCALL_HL)) {
        /* __z88dk_shortcall: dispatch via the rst vector, with the value
           as an inline operand (defb if it fits a byte, else defw) that
           the rst handler reads. (long-long return's __i64_acc push was
           already emitted above.) */
        emit(out, "rst\t%d", ci->shortcall_rst);
        emit(out, "%s\t%d",
             ci->shortcall_value < 0x100 ? "defb" : "defw",
             ci->shortcall_value);
    } else if (ci->flags & SHORTCALL_HL) {
        /* __z88dk_shortcall_hl: value passed in HL, no inline operand.
           A fastcall arg already in HL is preserved into BC first. */
        if (ci->abi == IR_ABI_FASTCALL)
            emit(out, "ld\tbc,hl");
        emit(out, "ld\thl,%d", ci->shortcall_value);
        emit(out, "rst\t%d", ci->shortcall_rst);
    } else if (ci->flags & HL_CALL) {
        /* __z88dk_hl_call: module in HL, then a direct call to the fixed
           numeric address. A fastcall arg in HL is preserved into BC. */
        if (ci->abi == IR_ABI_FASTCALL)
            emit(out, "ld\tbc,hl");
        emit(out, "ld\thl,%d", ci->hlcall_module);
        emit(out, "call\t%d", ci->hlcall_addr);
    } else if ((ci->flags & BANKED) && c_banked_style == BANKED_STYLE_TICALC) {
        /* TICALC banked call: BCALL via rst $28, a unique import label
           (patched by appmake) and a defw 0 placeholder. */
        static int banked_label = 0;
        emit(out, "rst\t$28");
        fprintf(out, ".__banked_import_%x%s%s\n", banked_label++,
             ir_sym_prefix(ci->target),
             ci->target_name ? ci->target_name : ir_sym_name(ci->target));
        emit(out, "defw 0");
    } else if (ci->flags & BANKED) {
        /* REGULAR banked call: the banked_call trampoline reads the inline
           4-byte target (defq) after the call, pages it in and jumps. */
        emit(out, "call\tbanked_call");
        emit(out, "defq\t%s%s",
             ir_sym_prefix(ci->target),
             ci->target_name ? ci->target_name : ir_sym_name(ci->target));
    } else {
        emit(out, "call\t%s%s",
             ir_sym_prefix(ci->target),
             ci->target_name ? ci->target_name : ir_sym_name(ci->target));
    }

    /* Caller-cleanup for SMALLC and STDC (CALLEE cleans its own).
       Repeated `pop bc` preserves DEHL (long returns) and HL (int
       returns) at 10T / 1 byte each. The ex/add/ld dance only wins
       for N >= 10 args, which isn't hot enough to bother with. */
    if (ci->abi != IR_ABI_CALLEE && pushed_bytes > 0) {
        int n = pushed_bytes;
        for (; n >= 2; n -= 2)
            emit(out, "pop\tbc");
        if (n == 1)             /* odd byte (a __z88dk_sdccdecl char arg) */
            emit(out, "inc\tsp");
    }
    /* Pre-pushed args bumped cur_sp_adjust at each IR_PUSH_ARG; the
       stack is rebalanced now (our pops, or the callee's cleanup). */
    if (pre)
        cur_sp_adjust -= pushed_bytes;

    if (ci->is_critical)
        emit(out, "ei");

    /* Restore the BC we pushed before the call. The pop restores BC
       to exactly what cur_bc_vreg held at call entry — but arg setup
       may have reloaded BC to a different tenant via emit_bc_reload.
       Restore the cache to reflect what is actually in BC now. */
    if (bc_saved) {
        emit(out, "pop\tbc");
        cur_bc_vreg = bc_vreg_at_call_entry;
    }

    /* Callee clobbers caller-saved registers (HL, DE, BC, A
       and friends). The HL/DE/A caches refer to those clobbered
       regs, so invalidate them. BC needs special handling: when
       we pushed BC via the bc_saved path, the matching pop_bc
       above restores BC's previous contents — the cache stays
       accurate (already fixed). When we did NOT push BC (no PR_BC
       vregs), the cache may have been advertising HL-mirror contents
       that the call has destroyed; invalidate then. */
    invalidate_hl_cache();
    if (!bc_saved)
        invalidate_bc_cache();
    /* The callee may have paged a different __addressmod bank — re-page on
       the next namespaced access. (The page-in call is emitted inline, not
       via gen_call, so it doesn't reach here.) */
    cur_bank_fn = NULL;
    /* Return value lands in HL (width ≤ 2) or DEHL (width 4) per
       z88dk's smallc/stdc convention. Pick the correct store
       routine from the ret vreg's width — using store_hl for a
       width-4 vreg silently dropped the high half (the bug behind
       crcbench's wrong crc and lglob's missing g.hi). */
    if (ci->ret_vreg >= 0) {
        int ret_w = f->vregs[ci->ret_vreg].width;
        if (ret_w > 4) {
            /* Wide return: the callee left it in the accumulator (FA for
               double, __i64_acc for long long); store it to the ret slot. */
            emit_acc_slot_addr(out, f, ci->ret_vreg, 0);
            emit_acc_store_hl(out, f, ci->ret_vreg);
            invalidate_hl_cache();
            cur_fa_vreg = ci->ret_vreg;
        } else if (ret_w == 4)
            store_dehl_cached(out, f, ci->ret_vreg);
        else if (ret_w == 1) {
            /* Byte return: the value is in HL (low byte in L, char-
               widened by the callee). store_hl writes 2 bytes and
               overruns a 1-byte slot — `unsigned char c = f();` (c
               coalesced with the ret vreg) clobbered the next local /
               the return address. Same overrun class as the gen_mov /
               gen_ld_imm byte paths. */
            emit(out, "ld\ta,l");
            if (cur_dst_dead || vreg_in_register_pool(f, ci->ret_vreg))
                cache_a(ci->ret_vreg);
            else
                store_a_byte(out, f, ci->ret_vreg);
        } else
            store_hl(out, f, ci->ret_vreg);
    }

    /* Pre-pushed calls: the BC save (if the function keeps a PR_BC
       tenant) was emitted by this call's FIRST IR_PUSH_ARG, below
       the arg block. Pop it here, after the cleanup, and restore the
       cache to the tenant recorded at save time. Placed after the
       ret store because... actually `pop bc` doesn't touch HL, but
       keep the pairing adjacent to the cleanup pops it follows. */
    if (pre && func_has_pr_bc(f) && bc_args_save_depth > 0) {
        emit(out, "pop\tbc");
        cur_bc_vreg = bc_args_save_stack[--bc_args_save_depth];
        cur_sp_adjust -= 2;
    }
    return 0;
}

/* Wide memory-accumulator binop (IR_ACC_BINOP). Operands and result are
   slot-resident wide vregs (width 6/8); the accumulator (FA / __i64_acc)
   is the working store. Sequence (sp-relative addressing; ir_build gates
   this to !fp_active):
     dload(push_operand); push;        ; one operand to acc, push it
     dload(acc_operand);                ; other operand into acc (last)
     call <binop>                        ; helper consumes the pushed operand
     store(dst)                          ; acc -> result slot
   `acc_holds_lhs` selects which operand is loaded-last vs pushed so
   non-commutative ops (sub/div) get the right order. */
static int gen_acc_binop(FILE *out, Func *f, const Op *op)
{
    HelperInfo *hi = op->hcall;
    if (!hi || !hi->name || hi->n_args != 2 || hi->ret_vreg < 0) {
        fputs("ir_lower: IR_ACC_BINOP malformed\n", stderr);
        return -1;
    }
    int lhs = hi->args[0], rhs = hi->args[1];
    int acc_op  = hi->acc_holds_lhs ? lhs : rhs;   /* loaded into acc last */
    int push_op = hi->acc_holds_lhs ? rhs : lhs;   /* pushed */
    int w = hi->acc_width;

    /* 1. push_op -> acc, then push acc to the stack (combined dldpsh
       when available, else load+push). */
    emit_acc_slot_addr(out, f, push_op, 0);
    if (hi->acc_loadpush) {
        emit(out, "call\t%s", hi->acc_loadpush);
    } else {
        emit(out, "call\t%s", hi->acc_load);
        emit(out, "call\t%s", hi->acc_push);
    }
    cur_sp_adjust += w;
    /* 2. acc_op -> acc (offsets now include the push) */
    emit_acc_slot_addr(out, f, acc_op, 0);
    emit(out, "call\t%s", hi->acc_load);
    /* 3. binop — the helper pops the pushed operand */
    emit(out, "call\t%s", hi->name);
    cur_sp_adjust -= w;
    /* 4. acc -> dst slot */
    emit_acc_slot_addr(out, f, hi->ret_vreg, 0);
    if (hi->acc_store_bc) {        /* l_i64_store wants the address in BC */
        emit(out, "ld\tb,h");
        emit(out, "ld\tc,l");
    }
    emit(out, "call\t%s", hi->acc_store);
    invalidate_hl_cache();
    invalidate_de_cache();
    invalidate_bc_cache();
    invalidate_a_cache();
    /* The result is left in the accumulator (the store above wrote a
       copy to the slot but didn't disturb the accumulator). Advertise
       it so an immediately-following return skips the reload. */
    cur_fa_vreg = hi->ret_vreg;
    return 0;
}

/* Wide memory-accumulator compare (IR_ACC_CMP): same push/load dance as
   the binop, but the helper (dlt/dleq/…) returns an int 0/1 bool in HL,
   stored to the width-2 int dst (no accumulator store). */
static int gen_acc_cmp(FILE *out, Func *f, const Op *op)
{
    HelperInfo *hi = op->hcall;
    if (!hi || !hi->name || hi->n_args != 2 || hi->ret_vreg < 0) {
        fputs("ir_lower: IR_ACC_CMP malformed\n", stderr);
        return -1;
    }
    int acc_op  = hi->acc_holds_lhs ? hi->args[0] : hi->args[1];
    int push_op = hi->acc_holds_lhs ? hi->args[1] : hi->args[0];
    int w = hi->acc_width;
    emit_acc_slot_addr(out, f, push_op, 0);
    if (hi->acc_loadpush) {
        emit(out, "call\t%s", hi->acc_loadpush);
    } else {
        emit(out, "call\t%s", hi->acc_load);
        emit(out, "call\t%s", hi->acc_push);
    }
    cur_sp_adjust += w;
    emit_acc_slot_addr(out, f, acc_op, 0);
    emit(out, "call\t%s", hi->acc_load);
    emit(out, "call\t%s", hi->name);
    cur_sp_adjust -= w;
    invalidate_hl_cache(); invalidate_bc_cache();
    store_hl(out, f, hi->ret_vreg);
    return 0;
}

/* Wide memory-accumulator unary op (IR_ACC_UNOP): int→acc conversion,
   acc→int conversion, or acc→acc move. Reuses the FA-residency cache so
   a value already in the accumulator isn't reloaded. */
static int gen_acc_unop(FILE *out, Func *f, const Op *op)
{
    HelperInfo *hi = op->hcall;
    if (!hi || !hi->name || hi->ret_vreg < 0 || hi->n_args != 1) {
        fputs("ir_lower: IR_ACC_UNOP malformed\n", stderr);
        return -1;
    }
    int src = hi->args[0], dst = hi->ret_vreg;
    if (hi->acc_subkind == ACC_SUB_INT2ACC) {
        /* int → acc: load the int into HL/DEHL, convert (result in the
           accumulator), store the accumulator to the dst slot. */
        if (f->vregs[src].width == 4) load_to_dehl(out, f, src);
        else                          load_to_hl(out, f, src);
        emit(out, "call\t%s", hi->name);
        emit_acc_slot_addr(out, f, dst, 0);
        if (hi->acc_store_bc) { emit(out, "ld\tb,h"); emit(out, "ld\tc,l"); }
        emit(out, "call\t%s", hi->acc_store);
        invalidate_hl_cache(); invalidate_bc_cache();
        cur_fa_vreg = dst;
        return 0;
    }
    if (hi->acc_subkind == ACC_SUB_ACC2INT) {
        /* acc → int: load the accumulator (unless already resident),
           convert (result in HL/DEHL), store to the int dst. */
        if (cur_fa_vreg != src) {
            emit_acc_slot_addr(out, f, src, 0);
            emit(out, "call\t%s", hi->acc_load);
        }
        emit(out, "call\t%s", hi->name);
        invalidate_hl_cache(); invalidate_bc_cache();
        if (f->vregs[dst].width == 4) store_dehl_finalize(out, f, dst);
        else                         store_hl(out, f, dst);
        return 0;
    }
    if (hi->acc_subkind == ACC_SUB_CROSS) {
        /* Cross-family conversion (long long <-> 5/6/8-byte double): load the
           source into its accumulator via the SRC family's load (l_i64_load
           or dload), call the conversion (it reads one accumulator and writes
           the other — __i64_acc / FA), then store from the DST accumulator
           via the DST family's store (dstore or l_i64_store, BC for the
           latter). The two accumulators are distinct memory areas, so no
           FA-residency shortcut on the source. */
        emit_acc_slot_addr(out, f, src, 0);
        emit(out, "call\t%s", hi->acc_load);
        emit(out, "call\t%s", hi->name);
        emit_acc_slot_addr(out, f, dst, 0);
        if (hi->acc_store_bc) { emit(out, "ld\tb,h"); emit(out, "ld\tc,l"); }
        emit(out, "call\t%s", hi->acc_store);
        invalidate_hl_cache(); invalidate_bc_cache();
        cur_fa_vreg = dst;
        return 0;
    }
    if (hi->acc_subkind == ACC_SUB_ACC_UNARY) {
        /* acc → acc in-place unary (float negate): load FA (unless already
           resident), call the in-place helper (minusfa / l_f64_neg), store
           FA to the float dst. */
        if (cur_fa_vreg != src) {
            emit_acc_slot_addr(out, f, src, 0);
            emit(out, "call\t%s", hi->acc_load);
        }
        emit(out, "call\t%s", hi->name);
        emit_acc_slot_addr(out, f, dst, 0);
        emit(out, "call\t%s", hi->acc_store);
        invalidate_hl_cache(); invalidate_bc_cache();
        cur_fa_vreg = dst;
        return 0;
    }
    /* acc → acc move */
    if (cur_fa_vreg != src) {
        emit_acc_slot_addr(out, f, src, 0);
        emit(out, "call\t%s", hi->acc_load);
    }
    emit_acc_slot_addr(out, f, dst, 0);
    if (hi->acc_store_bc) { emit(out, "ld\tb,h"); emit(out, "ld\tc,l"); }
    emit(out, "call\t%s", hi->acc_store);
    invalidate_hl_cache(); invalidate_bc_cache();
    cur_fa_vreg = dst;
    return 0;
}

static int gen_hcall(FILE *out, Func *f, const Op *op)
{
    HelperInfo *hi = op->hcall;
    if (!hi || !hi->name) {
        fputs("ir_lower: IR_HCALL missing HelperInfo\n", stderr);
        return -1;
    }
    int n_stacked = hi->n_stacked;
    int n_regs    = hi->n_args - n_stacked;
    if (n_regs > 2 || n_regs < 0) {
        fprintf(stderr,
            "ir_lower: IR_HCALL %s with %d register args (max 2)\n",
            hi->name, n_regs);
        return -1;
    }
    /* z80 helper convention: stacked args[0..n_stacked-1] are pushed
       before the call (4 bytes via DEHL for long args, 2 via HL
       otherwise). The helper pops its stacked args itself. Register
       args go in HL (width ≤ 2) or DEHL (width 4); when there are two
       int args, args[n_stacked] goes in HL, args[n_stacked+1] in DE.
       Return in HL (default), DE (ret_in_de), or DEHL (ret_vreg
       width 4). Helpers clobber BC, so PR_BC vregs must be saved. */
    int hc_bc_saved = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        if (f->vreg_to_phys[i] == IR_PR_BC) { hc_bc_saved = 1; break; }
    }
    if (hc_bc_saved) {
        emit(out, "push\tbc");
        cur_sp_adjust += 2;
    }
    int popped_bytes = 0;
    for (int i = 0; i < n_stacked; i++) {
        int v = hi->args[i];
        int w = (v >= 0) ? f->vregs[v].width : 2;
        if (w == 4) {
            load_to_dehl(out, f, v);
            emit(out, "push\tde");
            emit(out, "push\thl");
            cur_sp_adjust += 4;
            popped_bytes += 4;
        } else {
            load_to_hl(out, f, v);
            emit(out, "push\thl");
            cur_sp_adjust += 2;
            popped_bytes += 2;
        }
    }
    /* Register args. load_to_de may clobber HL, load_to_hl preserves
       DE, so DE first. A single width-4 register arg goes in DEHL. */
    if (n_regs == 2) load_to_de(out, f, hi->args[n_stacked + 1]);
    if (n_regs >= 1) {
        int v = hi->args[n_stacked];
        int w = (v >= 0) ? f->vregs[v].width : 2;
        if (w == 4) load_to_dehl(out, f, v);
        else        load_to_hl(out, f, v);
    }
    emit(out, "call\t%s", hi->name);
    cur_sp_adjust -= popped_bytes;
    if (hc_bc_saved) {
        emit(out, "pop\tbc");
        cur_sp_adjust -= 2;
    }
    invalidate_hl_cache();
    if (!hc_bc_saved)
        invalidate_bc_cache();
    if (hi->ret_in_de) {
        emit(out, "ex\tde,hl");
        invalidate_de_cache();
    }
    if (hi->ret_vreg >= 0) {
        if (f->vregs[hi->ret_vreg].width == 4)
            store_dehl_finalize(out, f, hi->ret_vreg);
        else
            store_hl(out, f, hi->ret_vreg);
    }
    return 0;
}

/* The lp_* far-access helper for an element kind + width + sign.
   load=1 → lp_g*, load=0 → lp_p*. Dispatch by width with the
   char/cptr/wide-double/longlong special-cases — mirrors
   ir_build.c:far_helper. */
static const char *far_helper_name(Kind elem, int width, int is_unsigned, int load)
{
    if (elem == KIND_CHAR)
        return load ? (is_unsigned ? "lp_guchar" : "lp_gchar") : "lp_pchar";
    if (elem == KIND_CPTR)
        return load ? "lp_gptr" : "lp_pptr";
    if (elem == KIND_LONGLONG)
        return load ? "lp_glonglong" : "lp_i64_load";
    if ((elem == KIND_DOUBLE || elem == KIND_FLOAT) && width >= 5)
        return load ? "lp_gdoub" : "lp_pdoub";
    if (width == 1)
        return load ? (is_unsigned ? "lp_guchar" : "lp_gchar") : "lp_pchar";
    if (width == 2)
        return load ? "lp_gint" : "lp_pint";
    if (width == 4)
        return load ? "lp_glong" : "lp_plong";
    return NULL;
}

/* IR_LD_FAR: dst ← *src[0], where src[0] is a __far pointer (KIND_CPTR)
   held in DEHL (D=0, E=bank, HL=offset). The access routes through an
   lp_g* helper that pages the bank in/out. A far helper is a CALL: it
   clobbers AF/BC/DE + the alt register set, so a PR_BC tenant is saved
   across it and the HL/BC/A/bank caches are invalidated afterwards.
   Result lands in HL (char/int → width-2 promoted) or DEHL (long/cptr). */
static int gen_ld_far(FILE *out, Func *f, const Op *op)
{
    int dst_w = (op->dst >= 0) ? f->vregs[op->dst].width : 2;
    const char *h = far_helper_name((int)op->mem.elem, dst_w, (int)op->imm, 1);
    if (!h) {
        fprintf(stderr, "ir_lower: IR_LD_FAR element kind %d width %d "
                "unsupported\n", (int)op->mem.elem, dst_w);
        return -1;
    }
    int bc_saved = func_has_pr_bc(f);
    if (bc_saved) { emit(out, "push\tbc"); cur_sp_adjust += 2; }
    /* Materialize the far pointer into DEHL = EHL far address (D=0). */
    load_to_dehl(out, f, op->src[0]);
    emit(out, "call\t%s", h);
    if (bc_saved) { emit(out, "pop\tbc"); cur_sp_adjust -= 2; }
    invalidate_hl_cache();
    if (!bc_saved) invalidate_bc_cache();
    invalidate_de_cache();
    invalidate_a_cache();
    cur_bank_fn = NULL;   /* the helper paged a bank; re-page on next access */
    if (op->dst >= 0) {
        if (dst_w > 4) {
            /* Wide: lp_gdoub left the value in FA, lp_glonglong in
               __i64_acc — store the accumulator to the dst slot, exactly
               like gen_ld_mem's wide path. */
            emit_acc_slot_addr(out, f, op->dst, 0);
            emit_acc_store_hl(out, f, op->dst);
            invalidate_hl_cache(); invalidate_bc_cache();
            cur_fa_vreg = op->dst;
        } else if (dst_w == 4)
            store_dehl_finalize(out, f, op->dst);   /* lp_glong/lp_gptr → DEHL */
        else
            store_hl(out, f, op->dst);              /* lp_g{char,uchar,int} → HL */
    }
    return 0;
}

/* IR_ST_FAR: *src[0] ← src[1], src[0] a __far pointer (KIND_CPTR / DEHL),
   src[1] the value. Store helpers (lp_p*) take the address in the ALT
   set (E'H'L') and the value in the PRIMARY set (HL, or DEHL for wide).
   The IR has no model of the alt register file, so the address is moved
   into it via an opaque `exx; pop hl; pop de; exx` over a stack push —
   never a cache-aware load in the alt bank (FAR_IR_PLAN risk #2).

   Order mirrors the walker (gen_far_store): the ADDRESS is materialized
   and pushed FIRST. The far address is typically the freshly-computed
   DEHL value (an IR_ADD result that may be DEHL-resident with no frame
   slot); pushing it before the value's load_to_* clobbers DEHL keeps it
   recoverable. The value is then materialized into the primary set, and
   the opaque exx-pop loads the address into the alt set without
   disturbing it. A far helper is a CALL — full clobber. */
static int gen_st_far(FILE *out, Func *f, const Op *op)
{
    int val   = op->src[1];
    int val_w = (val >= 0) ? f->vregs[val].width : 2;
    const char *h = far_helper_name((int)op->mem.elem, val_w, 0, 0);
    if (!h) {
        fprintf(stderr, "ir_lower: IR_ST_FAR element kind %d width %d "
                "unsupported\n", (int)op->mem.elem, val_w);
        return -1;
    }
    int bc_saved = func_has_pr_bc(f);
    if (bc_saved) { emit(out, "push\tbc"); cur_sp_adjust += 2; }
    /* 1. Address → primary DEHL, then onto the stack. */
    load_to_dehl(out, f, op->src[0]);
    emit(out, "push\tde");
    emit(out, "push\thl");
    cur_sp_adjust += 4;
    /* 2. Value into its delivery register(s): a wide (5/6/8B double / long
          long) value goes into the accumulator (lp_pdoub takes FA,
          lp_i64_load takes __i64_acc) via the maths load primitive; a
          narrow value into the primary set (DEHL for 4B, HL/L otherwise).
          The address is safe on the stack; this may clobber DEHL/BC. */
    if (val_w > 4) {
        if (cur_fa_vreg != val) {
            emit_acc_slot_addr(out, f, val, 0);
            emit(out, "call\t%s", acc_prim(f, val, "load"));
        }
    } else if (val_w == 4) {
        load_to_dehl(out, f, val);
    } else {
        load_to_hl(out, f, val);
    }
    /* 3. Move the address into the alt set (E'H'L') via the opaque
          exx-pop, leaving the value untouched in the primary set (the
          maths accumulator survives — the pops only touch alt HL/DE,
          exactly the walker's gen_far_store sequence). */
    emit(out, "exx");
    emit(out, "pop\thl");          /* alt HL = offset */
    emit(out, "pop\tde");          /* alt DE = (D=0,E=bank) → E'H'L' = addr */
    cur_sp_adjust -= 4;
    emit(out, "exx");
    emit(out, "call\t%s", h);
    if (bc_saved) { emit(out, "pop\tbc"); cur_sp_adjust -= 2; }
    invalidate_hl_cache();
    if (!bc_saved) invalidate_bc_cache();
    invalidate_de_cache();
    invalidate_a_cache();
    if (val_w > 4) cur_fa_vreg = -1;   /* helper clobbered the accumulator */
    cur_bank_fn = NULL;
    return 0;
}

/* IR_LD_FARSYM: dst (KIND_CPTR) ← the far address of a banked (FARACC)
   symbol. The symbol's link-time address encodes the bank in its high
   half; l_far_mapaddr turns the (bank, offset) pair into a logical far
   pointer (EHL, D=0). A CALL — full clobber. (A near symbol cast to far
   reaches the far world via IR_LD_SYM + the near→far widen cast, not
   here.) */
static int gen_ld_farsym(FILE *out, Func *f, const Op *op)
{
    const char *nm = ir_sym_name(op->mem.sym);
    int bc_saved = func_has_pr_bc(f);
    if (bc_saved) { emit(out, "push\tbc"); cur_sp_adjust += 2; }
    emit(out, "ld\thl,+(_%s %% 65536)", nm);
    emit(out, "ld\tde,+(_%s / 65536)", nm);
    emit(out, "call\tl_far_mapaddr");
    if (bc_saved) { emit(out, "pop\tbc"); cur_sp_adjust -= 2; }
    invalidate_hl_cache();
    if (!bc_saved) invalidate_bc_cache();
    invalidate_de_cache();
    invalidate_a_cache();
    cur_bank_fn = NULL;
    if (op->dst >= 0)
        store_dehl_finalize(out, f, op->dst);   /* EHL far ptr → DEHL */
    return 0;
}

static int gen_cmp_lt_ge(FILE *out, Func *f, const Op *op)
{
    int is_signed = (op->kind == IR_CMP_LT || op->kind == IR_CMP_GE);
    int cf_true_long = (op->kind == IR_CMP_ULT || op->kind == IR_CMP_LT);
    /* Long ordered compare: byte-wise sub/sbc chain. Final sbc
       leaves CF = unsigned borrow (a<b) and A = high byte of result.
       Signed gets the S^V correction inline (`jp po ok; xor 0x80;
       ok: rla`) — same shape as signed_result_to_carry but A
       already has the high byte. */
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
            int off = slot_off(f, op->src[1]) + cur_sp_adjust;
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

static int gen_cmp_gt_le(FILE *out, Func *f, const Op *op)
{
    int is_signed = (op->kind == IR_CMP_GT || op->kind == IR_CMP_LE);
    /* After swap-load, CF=true means swapped operand src1 < src0
       = original src0 > src1 → GT/UGT. */
    int cf_true_gt = (op->kind == IR_CMP_UGT || op->kind == IR_CMP_GT);
    /* Long ordered compare, GT/LE variant: subtract src[0] from
       src[1] byte-wise — the swap means CF=borrow iff src1<src0 iff
       src0>src1. Const-RHS not folded (ast_opt rewrites it to
       LT/GE before reaching IR). */
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
            int off = slot_off(f, op->src[0]) + cur_sp_adjust;
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

static int gen_cmp_eq_ne(FILE *out, Func *f, const Op *op)
{
    /* Long compare: byte-wise XOR-then-OR chain that sets Z iff all
       4 bytes match. dst is width 2 (the bool result). */
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
            int off = slot_off(f, op->src[1]) + cur_sp_adjust;
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

static int gen_shr(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        if (op->src[1] >= 0) {
            /* Variable-count long shift → l_lsr_dehl helper
               (logical/unsigned — IR_SHR is always logical here).
               Same staging convention as IR_SHL. */
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
        /* In-place long >> 1 on a stack slot: walk via `srl (hl);
           rr (hl); rr (hl); rr (hl)` from MSB down. Logical shift
           — IR_SHR is always unsigned at this level. */
        if (count == 1
            && op->dst == op->src[0]
            && !cur_dst_dead
            && !vreg_in_pr_bc(f, op->dst)
            && f->vreg_to_phys
            && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
            int off = slot_off(f, op->dst) + cur_sp_adjust;
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
            ss_note_reload(f, op->src[0]);
            if (fp_active(f)) {
                int ix = slot_ix_off(f, op->src[0]);
                if (fp_offset_fits(ix + 1)) {
                    emit(out, "ld\tl,(%s%+d)", frame_reg(), ix + 1);
                    emit(out, "ld\th,0");
                    goto shr_int_bit_remainder;
                }
            }
            int off = slot_off(f, op->src[0]) + cur_sp_adjust;
            emit(out, "ld\thl,%d", off + 1);
            emit(out, "add\thl,sp");
            emit(out, "ld\tl,(hl)");        /* L = byte 1 */
            emit(out, "ld\th,0");
            goto shr_int_bit_remainder;
        }
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
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

static int lower_op(FILE *out, Func *f, const Op *op)
{
    switch (op->kind) {

    case IR_NOP:               return gen_nop(out, f, op);
    case IR_LD_SYM:            return gen_ld_sym(out, f, op);
    case IR_LD_STR:            return gen_ld_str(out, f, op);
    case IR_LEA:               return gen_lea(out, f, op);
    case IR_INC:               return gen_inc(out, f, op);
    case IR_DEC:               return gen_dec(out, f, op);
    case IR_POSTSTEP:          return gen_poststep(out, f, op);
    case IR_ROTL:              return gen_rotl(out, f, op);
    case IR_EXTRACT_BYTE:      return gen_extract_byte(out, f, op);
    case IR_BR:                return gen_br(out, f, op);
    case IR_BR_ZERO:           return gen_br_zero(out, f, op);
    case IR_BR_COND:           return gen_br_cond(out, f, op);
    case IR_SWITCH:            return gen_switch(out, f, op);
    case IR_RET:               return gen_ret_misdispatched(out, f, op);
    case IR_CRITICAL_ENTER:    return gen_critical_enter(out, f, op);
    case IR_CRITICAL_LEAVE:    return gen_critical_leave(out, f, op);
    case IR_PUSH_DEHL_LONG:    return gen_push_dehl_long(out, f, op);
    case IR_POP_DEHL_LONG:     return gen_pop_dehl_long(out, f, op);
    case IR_PUSH_ARG:          return gen_push_arg(out, f, op);
    case IR_ASM:               return gen_asm(out, f, op);
    case IR_MEMSET:            return gen_memset(out, f, op);
    case IR_MEMCPY:            return gen_memcpy(out, f, op);
    case IR_STRCPY:            return gen_strcpy(out, f, op);
    case IR_STRCHR:            return gen_strchr(out, f, op);

    case IR_LD_IMM:            return gen_ld_imm(out, f, op);
    case IR_MOV:               return gen_mov(out, f, op);
    case IR_NEG:               return gen_neg(out, f, op);
    case IR_NOT:               return gen_not(out, f, op);
    case IR_CONV_ZX:           return gen_conv_zx(out, f, op);
    case IR_CONV_SX:           return gen_conv_sx(out, f, op);
    case IR_CONV_TRUNC:        return gen_conv_trunc(out, f, op);
    case IR_CONV_BYTE_TO_HIGH: return gen_conv_byte_to_high(out, f, op);
    case IR_SHL:               return gen_shl(out, f, op);
    case IR_SHR:               return gen_shr(out, f, op);
    case IR_CMP_ULT: case IR_CMP_UGE:
    case IR_CMP_LT:  case IR_CMP_GE:  return gen_cmp_lt_ge(out, f, op);
    case IR_CMP_UGT: case IR_CMP_ULE:
    case IR_CMP_GT:  case IR_CMP_LE:  return gen_cmp_gt_le(out, f, op);
    case IR_CMP_EQ:  case IR_CMP_NE:  return gen_cmp_eq_ne(out, f, op);
    case IR_LD_MEM:                   return gen_ld_mem(out, f, op);
    case IR_ST_MEM:                   return gen_st_mem(out, f, op);
    case IR_LD_FAR:                   return gen_ld_far(out, f, op);
    case IR_ST_FAR:                   return gen_st_far(out, f, op);
    case IR_LD_FARSYM:                return gen_ld_farsym(out, f, op);
    case IR_ADD:                      return gen_add(out, f, op);
    case IR_SUB:                      return gen_sub(out, f, op);
    case IR_AND: case IR_OR: case IR_XOR: return gen_bitop(out, f, op);
    case IR_CALL:                     return gen_call(out, f, op);
    case IR_HCALL:                    return gen_hcall(out, f, op);
    case IR_ACC_BINOP:                return gen_acc_binop(out, f, op);
    case IR_ACC_UNOP:                 return gen_acc_unop(out, f, op);
    case IR_ACC_CMP:                  return gen_acc_cmp(out, f, op);

    default:
        fprintf(stderr, "ir_lower: unsupported op %s (kind=%d)\n",
                ir_op_name(op->kind), (int)op->kind);
        return -1;
    }
}

/* IR_RET is dispatched here directly (not through lower_op) so the
   sp restore can be sequenced after the return-value load without
   clobbering HL. */
static int lower_ret(FILE *out, Func *f, const Op *op)
{
    int width = 0;
    int is_acc = 0;
    if (op->src[0] >= 0) {
        width = f->vregs[op->src[0]].width;
        if (width > 4) {
            /* Wide accumulator return: load the value into the
               accumulator (FA for double); the teardown below preserves
               it (it lives in memory / the alt-reg set, not HL/DEHL). */
            is_acc = 1;
            if (cur_fa_vreg != op->src[0]) {
                emit_acc_slot_addr(out, f, op->src[0], 0);
                emit(out, "call\t%s", acc_prim(f, op->src[0], "load"));
                invalidate_hl_cache();
            }
        } else if (width == 4) {
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
        if (is_acc) {
            /* Result is in the accumulator (memory / alt-regs) — a plain
               sp restore is safe, nothing in HL/DE to preserve. */
            emit(out, "ld\thl,%d", f->frame_size);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");
        } else if (width == 4) {
            /* Long return: DE holds high half (preserved naturally by
               the sp-adjust). HL holds low half — stash in BC across
               the modstk, then restore. Mirrors sccz80's c_notaltreg
               path with usebc=YES. */
            emit(out, "ld\tbc,hl");
            emit(out, "ld\thl,%d", f->frame_size);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");
            emit(out, "ld\thl,bc");
        } else {
            /* Preserve HL across the sp restore (int return). */
            emit(out, "ex\tde,hl");
            emit(out, "ld\thl,%d", f->frame_size);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");
            emit(out, "ex\tde,hl");
        }
    }
    if (!fp_active(f) && frame_has_saved_fp(f)) {
        /* Acc-tier function under -frameix: body addressed sp-relative, but
           entry pushed IX (gen_push_frame). The locals (if any) were dropped
           above, so sp now points at the saved IX — restore the caller's
           frame pointer so `ret` reads the return address. Touches only
           IX/SP, leaving the return value in HL/DEHL/FA intact. */
        emit(out, "pop\t%s", frame_reg());
    }
    if (f->is_interrupt) {
        /* Interrupt epilogue: restore the registers the prologue saved
           (in reverse) and return via reti/retn/ei;reti. Mirrors the
           walker's gen_interrupt_leave; the IR targets z80 only, so the
           ix/iy saves are always present. The return form follows the
           critical / vector combination:
             __interrupt           → reti
             __critical __interrupt → retn
             __interrupt(N) / __critical __interrupt(0) → ei; reti        */
        emit(out, "pop\tiy");
        emit(out, "pop\tix");
        emit(out, "pop\thl");
        emit(out, "pop\tde");
        emit(out, "pop\tbc");
        emit(out, "pop\taf");
        int critical = (f->flags & CRITICAL) != 0;
        if (critical && f->interrupt_irq < 0) {
            emit(out, "retn");
        } else if (!critical && f->interrupt_irq < 0) {
            emit(out, "reti");
        } else {
            emit(out, "ei");
            emit(out, "reti");
        }
        return 0;
    }
    /* Function-level __critical (non-interrupt): the prologue's l_push_di
       is balanced by l_pop_ei here (it pops the saved DI state and re-ei's,
       preserving the return value in HL/DEHL). Mirrors codegen_critical_leave. */
    if (f->flags & CRITICAL)
        emit(out, "call\tl_pop_ei");
    emit(out, "ret");
    return 0;
}

/* ----- Function entry --------------------------------------------------- */

/* Count IR_VREG_PARAM vregs and return their total caller-stack width.
   Note: char params are passed as int (2 bytes) by the smallc ABI even
   though the local vreg holds a 1-byte value. */
/* The vreg holding the __z88dk_fastcall register arg — the last declared
   param, delivered in HL (width 1/2; wider args bail in ir_build) rather
   than on the caller stack. -1 if not a fastcall function. Identified as
   the highest-indexed PARAM vreg (params are created in declaration order
   before any temp). */
static int fastcall_arg_vreg(const Func *f)
{
    if (!(f->flags & FASTCALL)) return -1;
    int last = -1;
    for (int i = 0; i < f->n_vregs; i++)
        if (f->vregs[i].flags & IR_VREG_PARAM)
            last = i;
    return last;
}

static int param_stack_width(const Func *f)
{
    int fc = fastcall_arg_vreg(f);   /* not on the caller stack */
    int total = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        const VReg *v = &f->vregs[i];
        if ((v->flags & IR_VREG_PARAM) && v->id != fc) {
            int w = (v->width > 0) ? v->width : 2;
            /* char promoted to int (2 bytes) at the smallc call site —
               except __z88dk_sdccdecl, where a char arg is 1 byte. */
            if (w == 1 && !(f->flags & SDCCDECL)) w = 2;
            total += w;
        }
    }
    return total;
}

static void emit_prologue(FILE *out, Func *f)
{
    /* Register-save prologue — moved out of declparse's walker scaffolding
       (gen_interrupt_enter / codegen_critical_enter / gen_push_frame); the
       IR owns it under --use-ir. Same order and instructions, z80 only (the
       IR aborts other CPUs). The matching teardown is in lower_ret. */
    if (f->is_interrupt) {
        /* gen_interrupt_enter: ei only for a bare, non-critical __interrupt. */
        if (!(f->flags & CRITICAL) && f->interrupt_irq < 0)
            emit(out, "ei");
        emit(out, "push\taf");
        emit(out, "push\tbc");
        emit(out, "push\tde");
        emit(out, "push\thl");
        emit(out, "push\tix");
        emit(out, "push\tiy");
    } else if (f->flags & CRITICAL) {
        emit(out, "call\tl_push_di");
    }
    if (frame_has_saved_fp(f))      /* gen_push_frame: preserve caller's IX */
        emit(out, "push\t%s", frame_reg());

    /* FRAMEPTR setup. push of IX (above) preserves the caller's frame
       pointer; here we point IX at entry-sp when FP addressing is active.
       IX must be set BEFORE the frame alloc so it captures sp at function
       entry (between locals and caller's frame) for full [-128,+127]
       reach per slot. Teardown is OUR responsibility too because IR
       emits `ret` directly and gen_pop_frame doesn't fire. */
    if (fp_active(f)) {
        const char *fr = frame_reg();
        emit(out, "ld\t%s,0", fr);
        emit(out, "add\t%s,sp", fr);
    }
    /* Fastcall arg arrives in HL (width 1/2), DEHL (width 4), or the
       memory accumulator fa / __i64_acc (width 5/6/8) — not on the caller
       stack. The frame alloc below clobbers HL, so stash the register
       cases across it: width 1/2 → DE (free); width 4 → the low half in BC
       (free at fastcall entry — only DEHL holds the arg), DE keeps the high
       half. A wide acc arg is memory-resident and survives the frame alloc,
       so it needs no stash. Placed into the param's home after the frame. */
    int fc_vreg = fastcall_arg_vreg(f);
    if (fc_vreg >= 0) {
        int w = f->vregs[fc_vreg].width;
        if (w == 4) {
            emit(out, "ld\tb,h");        /* low half → BC */
            emit(out, "ld\tc,l");
        } else if (w <= 2) {
            emit(out, "ex\tde,hl");      /* arg → DE */
        }
        /* w > 4: fa / __i64_acc is in memory, no register stash needed. */
    }

    /* Allocate the frame. */
    if (f->frame_size > 0) {
        emit(out, "ld\thl,-%d", f->frame_size);
        emit(out, "add\thl,sp");
        emit(out, "ld\tsp,hl");
    }

    if (fc_vreg >= 0 && f->vregs[fc_vreg].width > 4) {
        /* wide (acc-tier) arg: still in fa / __i64_acc (memory) — store it
           to the param's slot, like gen_ld_mem's wide path. */
        emit_acc_slot_addr(out, f, fc_vreg, 0);
        emit_acc_store_hl(out, f, fc_vreg);
        invalidate_hl_cache(); invalidate_bc_cache();
        cur_fa_vreg = fc_vreg;
    } else if (fc_vreg >= 0 && f->vregs[fc_vreg].width == 4) {
        /* width-4: reconstruct DEHL (low half from BC, high half survived
           in DE) and place it in the param's home (DEHL register or slot). */
        emit(out, "ld\th,b");
        emit(out, "ld\tl,c");
        store_dehl_finalize(out, f, fc_vreg);
    } else if (fc_vreg >= 0) {
        /* The arg is now in DE (stashed before the frame alloc). Place it
           in the param vreg's allocated home: a register move (FREE when
           the allocator chose PR_DE — the register-residency win) or a
           slot store. */
        if (f->vregs[fc_vreg].width == 1) {
            emit(out, "ld\ta,e");                /* low byte */
            if (vreg_in_register_pool(f, fc_vreg))
                cache_a(fc_vreg);
            else
                store_a_byte(out, f, fc_vreg);
        } else if (vreg_is_pr_de(f, fc_vreg)) {
            cache_de(fc_vreg);                   /* already in DE — no move */
        } else if (vreg_in_pr_bc(f, fc_vreg)) {
            emit(out, "ld\tb,d");
            emit(out, "ld\tc,e");
            cache_bc(fc_vreg);
        } else if (vreg_in_register_pool(f, fc_vreg)) {   /* PR_HL */
            emit(out, "ex\tde,hl");
            cache_hl(fc_vreg);
        } else {                                 /* spill slot */
            emit(out, "ex\tde,hl");
            store_hl(out, f, fc_vreg);
        }
    }

    /* Copy caller-pushed args into our local frame slots so the rest of
       the lowerer can treat params identically to other vregs. Push order
       determines the layout: SMALLC / CALLEE push left-to-right (param0
       deepest → HIGHEST sp offset); STDC (and __z88dk_sdccdecl, which is
       flagged __stdc) pushes right-to-left (param0 on top → LOWEST offset,
       just above the return address). */
    int args_total = param_stack_width(f);
    int rl_layout = !(f->flags & SMALLC) && !(f->flags & CALLEE)
                  && !(f->flags & FASTCALL);
    /* When entry pushed IX (frame_has_saved_fp), the saved IX sits between
       the locals and the return address — args start 2 bytes higher. A
       long long return adds a stuffed pointer just above the return
       address, shifting args up another 2. */
    int retaddr_off = f->frame_size + (frame_has_saved_fp(f) ? 2 : 0)
                    + (f->returns_longlong ? 2 : 0)
                    /* interrupt push-all (12) / critical l_push_di (2). */
                    + (f->is_interrupt ? 12 : ((f->flags & CRITICAL) ? 2 : 0));
    /* R→L: walk up from just above the return address; L→R: walk down
       from the top of the arg block. __z88dk_params_offset(N) (and TICALC
       banked) inserts N extra bytes below the params. */
    int base = retaddr_off + 2 + f->params_offset;
    int caller_off = rl_layout ? base : (base + args_total);

    /* Walk PARAM vregs in declaration order (creation order). */
    int param_count = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        VReg *v = &f->vregs[i];
        if (!(v->flags & IR_VREG_PARAM)) continue;
        if (v->id == fc_vreg) continue;  /* fastcall arg: stored from HL above */
        param_count++;
        int width = (v->width > 0) ? v->width : 2;
        /* Char params are pushed as int (2 bytes) by smallc; consume
           2 caller-bytes but only store the low byte into the vreg.
           __z88dk_sdccdecl pushes a char as 1 byte. */
        int caller_w = (width == 1) ? ((f->flags & SDCCDECL) ? 1 : 2) : width;
        int poff;
        if (rl_layout) { poff = caller_off; caller_off += caller_w; }
        else           { caller_off -= caller_w; poff = caller_off; }
        /* Read-only params live in place on the caller's stack — no
           copy-in. slot_off() returns their caller offset directly so
           later loads/stores in the body walk into the caller frame. */
        if (v->flags & IR_VREG_PARAM_IN_PLACE) continue;
        if (width == 1) {
            /* Caller pushed a 2-byte int; take its low byte. */
            emit(out, "ld\thl,%d", poff);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,(hl)");
            store_a_byte(out, f, v->id);
        } else if (width == 2) {
            load_sp_off_to_hl(out, poff);
            store_hl(out, f, v->id);
        } else if (width == 4) {
            /* Long param: read 4 bytes from caller stack into DEHL,
               then store_dehl to the local slot. */
            emit(out, "ld\thl,%d", poff);
            emit(out, "add\thl,sp");
            emit(out, "ld\tc,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\tb,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\te,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\td,(hl)");
            emit(out, "ld\thl,bc");
            store_dehl(out, f, v->id);
        } else {
            fprintf(stderr,
                "ir_lower: param vreg %d width %d not supported in prologue\n",
                v->id, width);
            continue;
        }
    }
    (void)param_count;

    /* PR_BC prologue init: load the PR_BC vreg whose first use comes
       earliest. Others are loaded on demand via emit_bc_reload
       (called from load_to_hl_adj / load_to_de).

       PARAM_IN_PLACE only — LOCAL PR_BC vregs get their BC stamp at the
       producer op, not at function entry. They have no slot
       allocated, so a prologue reload would read garbage. */
    int prologue_v = -1;
    int prologue_first = -1;
    for (int i = 0; i < f->n_vregs; i++) {
        if (f->vreg_to_phys[i] != IR_PR_BC) continue;
        if (!(f->vregs[i].flags & IR_VREG_PARAM_IN_PLACE)) continue;
        const LiveRange *lr = ir_live_range(f, i);
        int first = lr ? lr->start : 0;
        if (prologue_v < 0 || (first >= 0 && first < prologue_first)) {
            prologue_v = i;
            prologue_first = first;
        }
    }
    if (prologue_v >= 0)
        emit_bc_reload(out, f, prologue_v, 0);
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
    case IR_SHL: case IR_SHR: case IR_ROTL:
    case IR_NEG: case IR_NOT:
    case IR_ST_MEM:
        return 0;
    case IR_PUSH_DEHL_LONG:
        /* Reads src[0] from DEHL. The producer's store_dehl_finalize
           skips its slot spill (cur_dehl_dst_dead_safe machinery) —
           the push captures DEHL directly, no intermediate slot
           write. */
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

    /* __naked: emit the body asm verbatim — no prologue, no epilogue, no
       frame, no BB labels, no trailing `ret` (the asm owns the entire
       body). ir_build has already validated the body is asm-only. */
    if (f->is_naked) {
        func_emit_idx++;
        for (int i = 0; i < f->n_bbs; i++) {
            BB *bb = &f->bbs[i];
            for (int o = 0; o < bb->n_ops; o++)
                if (bb->ops[o].kind == IR_ASM)
                    gen_asm(out, f, &bb->ops[o]);
        }
        return 0;
    }

    /* Liveness runs before ir_alloc / ir_assign_slots — both passes
       consume it. ir_alloc populates f->vreg_to_phys (PR_HL/DE/BC/
       DEHL/SPILL) and per-op liveness for the lowerer. */
    /* IR-level optimisations that mutate the IR shape — must run before
       liveness, since they change which vregs are read where. LICM
       runs first so hoisted ops are visible to the per-BB st2ld / CSE
       passes (which run within the pre-header where the hoisted op
       lands). Returns the number of ops changed (telemetry via
       IR_OPT_VERBOSE). */
    {
        int hoisted = ir_opt_licm(f);
        /* Early matcher phase (poststep, movfuse) runs BEFORE st2ld:
           its load-forwarding creates fresh MOVs that consume the
           same vregs the prologue binds to locals (e.g. MD5
           Transform's end-of-function `buf[i] += a/b/c/d` LD_MEMs get
           forwarded from the prologue's `UINT4 a = buf[0]` load,
           multiplying v_a's use count past movfuse's single-use
           gate). */
        int early   = ir_match_run_early(f);
        int fwd     = ir_opt_st2ld(f);
        /* Table-driven pattern matcher (ir_match.c) — the migrated
           fusion passes run here, in table order, to fixpoint.
           Currently: immconv (ex ir_opt_fold_imm_conv), rotl (ex
           ir_opt_fuse_rotl). Positioned after st2ld (forwarding can
           expose imm→CONV chains), before CSE so identical folded
           constants merge and before the byte/offset folds and the
           long-push inserter. Per-pattern counts print under
           IR_OPT_VERBOSE. */
        int match   = ir_match_run(f);
        int cse     = ir_opt_cse(f);
        /* After cse so duplicate per-lane address ADDs have been
           merged; before the long-push inserter. */
        int packs   = ir_match_run_packbytes(f);
        /* Late matcher phase (the extract-byte family) — after cse
           has deduped duplicate SHR/AND chains (EXTRACT_BYTE itself
           is not CSE-eligible) and after packs. */
        int late    = ir_match_run_late(f);
        int deadret = ir_opt_drop_dead_ret(f);
        int dce     = ir_opt_dce(f);
        /* Long push/pop insertion runs last — it expects the IR in
           its final shape. Default: ON in fp mode (md5 −0.4%/−13B,
           no exposure elsewhere — the option-B/byte-direct paths
           are regression-pinned by dehl_cache's longpush matrix),
           OFF in sp mode where the staging costs slightly more
           than the slot writes it replaces (md5 +0.26%/+40B).
           IR_LONG_PUSHES=0 / =1 force off / on regardless of mode
           (NOTE: this was an existence check once — =0 ENABLED the
           pass; it is a value now). */
        int want_pushes = fp_active(f);
        {
            const char *lp = getenv("IR_LONG_PUSHES");
            if (lp) want_pushes = (atoi(lp) != 0);
        }
        int pushes  = want_pushes ? ir_opt_insert_long_pushes(f) : 0;
        if ((hoisted > 0 || fwd > 0
             || packs > 0 || dce > 0 || early > 0
             || late > 0 || match > 0
             || cse > 0 || pushes > 0 || deadret > 0)
            && getenv("IR_OPT_VERBOSE"))
            fprintf(stderr,
                    "ir_opt: %d licm, %d early, %d st2ld, %d match, "
                    "%d cse, "
                    "%d packs, %d late, %d pushes, %d deadret, "
                    "%d dce in func\n",
                    hoisted, early, fwd, match,
                    cse, packs, late, pushes, deadret, dce);
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
    /* Bumped once per function — both lowering passes (when lazy spill
       does two) share the same func label prefix. */
    func_emit_idx++;
    /* Lazy-spill config (LAZY_SPILL_PLAN.md §11). Read once; the
       per-pass deferral state lives in lower_func_render. Default ON
       (sound-by-construction static reaching-reloads model; validated
       flag-on === flag-off across the suite corpus, intbench −30%);
       IR_NO_LAZY_SPILL opts out (restores the single-pass, byte-
       identical-to-pre-lazy-spill lowering for A/B + bisecting). */
    lazy_spill_on = getenv("IR_NO_LAZY_SPILL") == NULL;
    int want_lazy = lazy_spill_on;

    /* No function label here — the surrounding legacy scaffolding
       (declparse.c + codegen.c) already emits `._<name>`. The render
       helper emits the prologue + body inside that label. */

    /* Per-BB hl_out: which vreg HL holds at the end of the BB's
       emission, or -1 if unknown. Used to carry the cache across
       BB boundaries when all already-lowered predecessors agree
       on the HL state. */
    int *bb_hl_out = malloc((size_t)f->n_bbs * sizeof(int));
    int *bb_lowered = calloc((size_t)f->n_bbs, sizeof(int));
    /* Per-BB pending-spill out: which width-2 vreg (if any) left this BB
       deferred (unstored, riding the HL carry) — the dual of bb_hl_out
       for the lazy-spill cross-BB carry (LAZY_SPILL_PLAN.md §11). -1 =
       none. Plumbing only in this step; the inherit decision and the
       deferral that populates it land with the defer step. */
    int *bb_pending_out = malloc((size_t)f->n_bbs * sizeof(int));
    /* Predecessor table: bb_preds[bb] = list of pred bb ids,
       bb_pred_cnt[bb] = length. Derived from succ[] of every BB. */
    int *bb_pred_cnt = calloc((size_t)f->n_bbs, sizeof(int));
    int **bb_preds = calloc((size_t)f->n_bbs, sizeof(int *));
    for (int i = 0; i < f->n_bbs; i++) {
        bb_hl_out[i] = -1;
        bb_pending_out[i] = -1;
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

    /* Trampoline elision: a BB whose only op is IR_BR emits as a
       `defc L_fN_bb_X = L_fN_bb_Y` label alias instead of label+jp —
       saves 3 bytes and a 10T hop on every path through. Chains are
       chased to the final target; cycles (`while(1);`) and the entry
       BB (the prologue falls through into it) are excluded. z80asm
       resolves forward defc references at link time. */
    int *bb_alias = calloc((size_t)f->n_bbs, sizeof(int));
    if (bb_alias) {
        for (int i = 0; i < f->n_bbs; i++) {
            bb_alias[i] = -1;
            if (i == 0) continue;
            BB *bb = &f->bbs[i];
            if (bb->n_ops == 1 && bb->ops[0].kind == IR_BR)
                bb_alias[i] = bb->ops[0].label;
        }
        for (int i = 0; i < f->n_bbs; i++) {
            if (bb_alias[i] < 0) continue;
            int t = bb_alias[i], hops = 0;
            while (t >= 0 && t < f->n_bbs && bb_alias[t] >= 0
                   && hops < f->n_bbs) {
                t = bb_alias[t];
                hops++;
            }
            if (hops >= f->n_bbs || t < 0 || t >= f->n_bbs || t == i)
                bb_alias[i] = -1;       /* cycle / bogus — emit normally */
            else
                bb_alias[i] = t;
        }
    }

    /* === Pass driver ===
       Flag-off: a single render with deferral off — byte-identical to
       the pre-lazy-spill lowerer (zero master risk). Flag-on: pass 1
       renders deferral-off into a throwaway memstream purely to populate
       the COMPLETE bb_hl_out HL-tenant map (deferral never changes which
       vreg HL holds at a BB end — cache_hl(v) advertises HL=v whether or
       not the store is emitted), then pass 2 renders for real with
       deferral on, its cross-BB defer decision consulting that complete
       map. */
    int rc;
    int *bb_hl_out_p1 = NULL;
    /* Static lazy-spill state — off unless the two-pass path arms it. */
    ss_phase = 0;
    ss_op_base = NULL;
    ss_op_store = NULL;
    ss_op_reload = NULL;
    ss_op_cacheread = NULL;
    ss_store_dead = NULL;
    ss_cur_g = -1;
    ss_pinned = 0;
    if (!want_lazy) {
        rc = lower_func_render(out, f, 0, NULL, bb_hl_out, bb_lowered,
                               bb_pending_out, bb_pred_cnt, bb_preds,
                               bb_alias);
    } else {
        bb_hl_out_p1 = malloc((size_t)f->n_bbs * sizeof(int));
        /* Snapshot the only operands the lowering loop mutates in place
           (the commutative-swap at the DEHL-cache lookahead, ~src[0]<->
           src[1] of the next op). Pass 1 re-applies that swap; without a
           restore, pass 2 would lower already-swapped IR and its
           downstream lookaheads (e.g. the inline-push predictor) would
           diverge from a single pass. */
        int total_ops = 0;
        int *op_base = malloc((size_t)(f->n_bbs > 0 ? f->n_bbs : 1)
                              * sizeof(int));
        for (int b = 0; b < f->n_bbs; b++) {
            if (op_base) op_base[b] = total_ops;
            total_ops += f->bbs[b].n_ops;
        }
        int osz = total_ops > 0 ? total_ops : 1;
        int *op_store = malloc((size_t)osz * sizeof(int));
        int *op_reload = malloc((size_t)osz * 2 * sizeof(int));
        int *op_cacheread = malloc((size_t)osz * 2 * sizeof(int));
        if (op_store) for (int i = 0; i < osz; i++) op_store[i] = -1;
        if (op_reload) for (int i = 0; i < osz * 2; i++) op_reload[i] = -1;
        if (op_cacheread) for (int i = 0; i < osz * 2; i++) op_cacheread[i] = -1;
        int *src_snap = total_ops
            ? malloc((size_t)total_ops * 2 * sizeof(int)) : NULL;
        if (src_snap) {
            int t = 0;
            for (int b = 0; b < f->n_bbs; b++)
                for (int o = 0; o < f->bbs[b].n_ops; o++) {
                    src_snap[t++] = f->bbs[b].ops[o].src[0];
                    src_snap[t++] = f->bbs[b].ops[o].src[1];
                }
        }
        char *sbuf = NULL;
        size_t slen = 0;
        int alloc_ok = bb_hl_out_p1 && op_base && op_store && op_reload
            && op_cacheread && (src_snap || !total_ops);
        FILE *scratch = alloc_ok ? open_memstream(&sbuf, &slen) : NULL;
        if (!scratch) {
            /* Degraded (OOM / no memstream): single deferral-off pass.
               Correct, just forgoes the lazy win. */
            rc = lower_func_render(out, f, 0, NULL, bb_hl_out, bb_lowered,
                                   bb_pending_out, bb_pred_cnt, bb_preds,
                                   bb_alias);
            free(src_snap);
        } else {
            /* Pass 1: record the slot stores/reloads the lowerer emits. */
            ss_op_base = op_base;
            ss_op_store = op_store;
            ss_op_reload = op_reload;
            ss_op_cacheread = op_cacheread;
            ss_store_dead = NULL;
            ss_pinned = 0;
            ss_phase = 1;
            rc = lower_func_render(scratch, f, 0, NULL, bb_hl_out,
                                   bb_lowered, bb_pending_out, bb_pred_cnt,
                                   bb_preds, bb_alias);
            ss_phase = 0;
            fclose(scratch);
            free(sbuf);
            /* Restore the operands pass 1 swapped in place (see snapshot
               above) so pass 2 lowers the same IR a single pass would. */
            if (src_snap) {
                int t = 0;
                for (int b = 0; b < f->n_bbs; b++)
                    for (int o = 0; o < f->bbs[b].n_ops; o++) {
                        f->bbs[b].ops[o].src[0] = src_snap[t++];
                        f->bbs[b].ops[o].src[1] = src_snap[t++];
                    }
            }
            if (rc == 0) {
                /* Backward slot-liveness → which spill stores are dead.
                   ss_pinned (an op with >2 distinct reloads — never seen
                   in practice) bails to no elision, which is correct. */
                signed char *store_dead = ss_pinned ? NULL
                    : ss_compute_dead(f, op_base, total_ops, op_store,
                                      op_reload, op_cacheread);
                /* Pass 2: skip the dead stores. */
                ss_store_dead = store_dead;
                ss_phase = store_dead ? 2 : 0;
                rc = lower_func_render(out, f, 1, bb_hl_out_p1, bb_hl_out,
                                       bb_lowered, bb_pending_out,
                                       bb_pred_cnt, bb_preds, bb_alias);
                ss_phase = 0;
                ss_store_dead = NULL;
                free(store_dead);
            }
            free(src_snap);
        }
        free(op_base);
        free(op_store);
        free(op_reload);
        free(op_cacheread);
        ss_op_base = NULL;
        ss_op_store = NULL;
        ss_op_reload = NULL;
        ss_op_cacheread = NULL;
    }
    free(bb_hl_out_p1);

    free(bb_alias);
    free(bb_hl_out);
    free(bb_pending_out);
    free(bb_lowered);
    free(bb_pred_cnt);
    for (int i = 0; i < f->n_bbs; i++) free(bb_preds[i]);
    free(bb_preds);
    ir_free_liveness(f);
    return rc;
}

static int lower_func_render(FILE *out, Func *f, int lazy,
                             const int *bb_hl_out_p1,
                             int *bb_hl_out, int *bb_lowered,
                             int *bb_pending_out,
                             const int *bb_pred_cnt, int *const *bb_preds,
                             const int *bb_alias)
{
    /* Per-pass state reset (everything that was at function entry except
       func_emit_idx, which the caller bumps once for both passes). */
    cmp_label_counter = 0;
    lazy_spill_on = lazy;
    pending_spill_v = -1;
    cur_lazy_out = out;
    cur_lazy_func = f;
    cur_op_idx = 0;
    invalidate_hl_cache();
    invalidate_bc_cache();
    cur_sp_adjust = 0;
    bc_args_save_depth = 0;
    cur_stack_long_top = -1;
    cur_dehl_inline_push = -1;
    cur_dehl_inline_push_base_sp = 0;
    cur_dehl_push_to_stack = 0;
    cur_emitted_file = NULL;
    cur_emitted_line = 0;
    shl_skip_n = 0;
    cur_bb = NULL;
    cur_bank_fn = NULL;   /* __addressmod: bank unknown at function entry */
    ss_cur_g = -1;   /* no current op during prologue */
    for (int i = 0; i < f->n_bbs; i++) {
        bb_hl_out[i] = -1;
        bb_pending_out[i] = -1;
        bb_lowered[i] = 0;
    }
    (void)bb_hl_out_p1;   /* consulted by the pass-2 defer decision */

    emit_prologue(out, f);

    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        if (bb_alias && bb_alias[i] >= 0) {
            fprintf(out, "defc L_f%d_bb_%d = L_f%d_bb_%d\n",
                    func_emit_idx, bb->id, func_emit_idx, bb_alias[i]);
            /* The trampoline executes nothing, so it passes the HL
               carry straight through: its hl_out is its own carry-in
               (the agreement of its lowered preds). Leaving -1 here
               costs real reloads at loop headers reached via the
               alias. */
            int acarry = -2;
            for (int p = 0; p < bb_pred_cnt[bb->id]; p++) {
                int pid = bb_preds[bb->id][p];
                if (!bb_lowered[pid]) { acarry = -1; break; }
                int v = bb_hl_out[pid];
                if (v < 0) { acarry = -1; break; }
                if (acarry == -2) acarry = v;
                else if (acarry != v) { acarry = -1; break; }
            }
            if (acarry >= 0 && bb->live_in
                && ir_bitset_get((const BitSet *)bb->live_in, acarry))
                bb_hl_out[bb->id] = acarry;
            else
                bb_hl_out[bb->id] = -1;
            bb_lowered[bb->id] = 1;
            continue;
        }
        emit_bb_label(out, bb->id);
        /* The long data-stack is per-BB. Any push/pop imbalance at
           a BB boundary would shift sp for unrelated code. */
        cur_sp_adjust = 0;
        bc_args_save_depth = 0;
        cur_stack_long_top = -1;
        cur_dehl_inline_push = -1;
        cur_dehl_inline_push_base_sp = 0;
        cur_dehl_push_to_stack = 0;
        cur_bank_fn = NULL;   /* __addressmod: bank unknown at a BB merge */
        /* No pending spill crosses into a BB yet — the cross-BB inherit
           lands with the defer step. Clear it so nothing leaks. */
        pending_spill_v = -1;
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
            hl_about_to_change(carry);
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
                           the slot (i.e. dst dies at this op). A
                           redefinition counts: when nxt's dst IS
                           op->dst (`a = ROT(a); a += b;`), every
                           later use reads nxt's value — the swap is
                           equally safe and lets the redef-dead
                           writeback elision below fire. */
                        int dies_here = (nxt_m->dst == op->dst);
                        if (!dies_here) {
                            dies_here = 1;
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
                        /* Redef-stop: if this op redefines our dst
                           (e.g. IR_POP_DEHL_LONG dst=v_a after an
                           earlier IR_PUSH_DEHL_LONG src=v_a), later
                           uses pair with the redef, not the original
                           def. Stop walking. */
                        if (!safe) break;
                        /* IR_PUSH_DEHL_LONG of our dst is a lifetime
                           ender too — the value moves to the data
                           stack and the downstream consumer either
                           pops it or absorbs it directly off the
                           stack. No slot reload of v_a past this. */
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
            cur_dehl_dst_no_bc_stash = 0;
            /* FP byte-direct chain narrow: when the next op is a long
               binop with dst as either src (commutative byte-direct
               chain picks whichever is in the DEHL cache), the chain
               reads from H/L via the cur_hl_vreg advertise — the
               producer's `ld bc,hl` is wasted. Set the no-bc-stash
               flag for cache_dehl_no_spill to skip the stash. Note
               this is broader than dst_dead_safe (which needs pos
               match for the load semantics); the chain doesn't care
               about pos since it reads both srcs. */
            if (fp_active(f) && op->dst >= 0
                && f->vregs[op->dst].width == 4
                && j + 1 < bb->n_ops) {
                const Op *nxt2 = &bb->ops[j + 1];
                if ((nxt2->kind == IR_ADD || nxt2->kind == IR_SUB
                     || nxt2->kind == IR_AND || nxt2->kind == IR_OR
                     || nxt2->kind == IR_XOR)
                    && nxt2->src[0] >= 0 && nxt2->src[1] >= 0
                    && f->vregs[nxt2->src[0]].width == 4
                    && f->vregs[nxt2->src[1]].width == 4
                    && (nxt2->src[0] == op->dst
                        || nxt2->src[1] == op->dst))
                    cur_dehl_dst_no_bc_stash = 1;
            }
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
                    case IR_ROTL:
                        /* gen_rotl consumes src[0] via load_to_dehl
                           first — cache hit, no slot read. */
                        cur_dehl_dst_dead_safe = 1;
                        break;
                    default: break;
                    }
                }
            }
            /* Redefinition-dead slot writeback: dst is LIVE (read in
               later ops/rounds, so cur_dst_dead is false), but the
               immediately-next op BOTH consumes dst via its first
               load_to_dehl (cache hit, no slot read) AND redefines
               dst (nxt->dst == op->dst). Every later read sees nxt's
               value, whose own finalize owns the slot — this def's
               writeback can never be observed. Fires on the md5
               round-carry chain (`a = ROTATE(a); a += b;` — the
               rotate result's spill is dead, ~12B/76T per round).
               Same recognised-consumer set as the dead-dst switch
               above. Excluded: ADDR_TAKEN/PARAM (slot readable
               behind the IR's back) and dst doubling as the other
               src (its second read may take the slot path). */
            if (!cur_dehl_dst_dead_safe
                && op->dst >= 0
                && f->vregs[op->dst].width == 4
                && !(f->vregs[op->dst].flags
                     & (IR_VREG_ADDR_TAKEN | IR_VREG_PARAM))
                && j + 1 < bb->n_ops) {
                const Op *nxt = &bb->ops[j + 1];
                int pos = nxt_first_dehl_src(nxt);
                if (pos >= 0
                    && nxt->src[pos] == op->dst
                    && nxt->dst == op->dst
                    && nxt->src[1 - pos] != op->dst) {
                    switch (nxt->kind) {
                    case IR_NEG: case IR_NOT:
                    case IR_ADD: case IR_SUB:
                    case IR_AND: case IR_OR: case IR_XOR:
                    case IR_SHL: case IR_SHR: case IR_ROTL:
                        cur_dehl_dst_dead_safe = 1;
                        break;
                    default: break;
                    }
                }
            }

            /* Chain-OR accumulate lookahead: if op->dst is a SPILL
               long with a single in-BB use at consumer k>j+1, and
               that consumer is a long OR/AND/XOR where op->dst will
               land in src[1] after commutative swap, flag it for
               inline push instead of slot spill. Saves ~15 instr per
               byte-pack chain element (3 push vs 10 slot write + 2
               pop vs 0 cleanup).
               Guard: src[0] pre-swap == op->dst (swap at k-1 moves
               it to src[1]); other operand (src[1] pre-swap) must be
               produced at k-1 and die at k (guarantees swap fires). */
            cur_dehl_push_to_stack = 0;
            if (!fp_active(f)
                && !cur_dehl_dst_dead_safe
                && !cur_dst_dead
                && op->dst >= 0
                && f->vregs[op->dst].width == 4
                && !vreg_is_pr_dehl(f, op->dst)
                && cur_stack_long_top < 0) {
                /* Note: cur_dehl_inline_push may be non-(-1) here (a
                   chained push is still pending); the runtime check in
                   store_dehl_finalize handles that case — the cleanup in
                   gen_bitop clears it before store_dehl_finalize fires. */
                int consumer = -1;
                int ok = 1;
                if (bb->live_out
                    && ir_bitset_get((const BitSet *)bb->live_out, op->dst))
                    ok = 0;
                for (int k = j + 1; k < bb->n_ops && ok; k++) {
                    const Op *ko = &bb->ops[k];
                    int uses[16];
                    int nu = ir_op_uses(ko, uses,
                                (int)(sizeof uses / sizeof uses[0]));
                    for (int u = 0; u < nu && ok; u++) {
                        if (uses[u] != op->dst) continue;
                        if (consumer >= 0) { ok = 0; break; }
                        consumer = k;
                    }
                    if (ko->kind == IR_CALL
                        || ko->kind == IR_PUSH_DEHL_LONG)
                        ok = 0;
                }
                if (ok && consumer > j + 1) {
                    const Op *ko = &bb->ops[consumer];
                    int is_bitop = (ko->kind == IR_OR
                                    || ko->kind == IR_AND
                                    || ko->kind == IR_XOR);
                    int w4 = (ko->src[0] >= 0 && ko->src[1] >= 0
                              && f->vregs[ko->src[0]].width == 4
                              && f->vregs[ko->src[1]].width == 4);
                    /* op->dst must be ko->src[0] pre-swap. */
                    int dst_in_src0 = (ko->src[0] == op->dst);
                    /* The other operand (ko->src[1] pre-swap) must be
                       produced at consumer-1 and die at consumer (so
                       the commutative swap at consumer-1 fires). */
                    int other_at_km1 = (consumer > 0
                        && bb->ops[consumer - 1].dst >= 0
                        && ko->src[1] == bb->ops[consumer - 1].dst);
                    int other_dies = 0;
                    if (other_at_km1) {
                        int ov = bb->ops[consumer - 1].dst;
                        int od = !(bb->live_out
                            && ir_bitset_get((const BitSet *)bb->live_out, ov));
                        for (int k = consumer + 1; k < bb->n_ops && od; k++) {
                            int uses[16];
                            int nu = ir_op_uses(&bb->ops[k], uses,
                                        (int)(sizeof uses / sizeof uses[0]));
                            for (int u = 0; u < nu; u++)
                                if (uses[u] == ov) { od = 0; break; }
                        }
                        other_dies = od;
                    }
                    if (is_bitop && w4 && dst_in_src0
                        && other_at_km1 && other_dies)
                        cur_dehl_push_to_stack = 1;
                }
            }

            /* `jp` to the immediately-following BB is dead — the
               label is the next instruction. Elide when this is an
               unconditional IR_BR at end of BB targeting the next
               BB in lowering order. */
            if (op->kind == IR_BR && j == bb->n_ops - 1) {
                /* Skip against the next BB that actually EMITS code —
                   alias-elided trampolines produce no bytes, so
                   falling through lands on the BB after them. Resolve
                   the jp target through the alias map too. */
                int next_emitted = -1;
                for (int k = i + 1; k < f->n_bbs; k++) {
                    if (!bb_alias || bb_alias[k] < 0) {
                        next_emitted = k;
                        break;
                    }
                }
                int tgt = op->label;
                if (bb_alias && tgt >= 0 && tgt < f->n_bbs
                    && bb_alias[tgt] >= 0)
                    tgt = bb_alias[tgt];
                if (next_emitted >= 0 && tgt == next_emitted) {
                    /* HL state unchanged — bb_hl_out captures
                       cur_hl_vreg. */
                    continue;
                }
            }

            emit_op_cline(op);
            /* Check the shift-and-test skip list (set by the AND-mask
               + BR + SHL fused fastpath). The leading SHL in each
               target BB already had its `add hl,hl` performed by the
               fused emit; set cur_skip_shl_add_hl so the SHL lowerer
               drops the redundant `add hl,hl` but still runs its
               spill / cache tail to publish HL to the dst vreg. */
            ss_cur_g = ss_op_base ? ss_op_base[bb->id] + j : -1;
            for (int s = 0; s < shl_skip_n; s++) {
                if (shl_skip[s].bb_id == bb->id
                    && shl_skip[s].op_idx == j) {
                    hl_about_to_change(shl_skip[s].cache_vreg);
                    /* The skipped SHL consumes its source from HL (the
                       fused add hl,hl already produced it) — a genuine
                       cache hit with no loader call, so record it so the
                       dead-store analysis doesn't treat it as a reload. */
                    ss_note_cache_read(f, shl_skip[s].cache_vreg);
                    cur_skip_shl_add_hl = 1;
                    break;
                }
            }
            cur_bb = bb;
            cur_op_idx = j;
            /* Static lazy-spill: tag the store/reload hooks with this op's
               global index so pass 1 records against it and pass 2's
               verdict (ss_store_dead) is read for it. */
            ss_cur_g = ss_op_base ? ss_op_base[bb->id] + j : -1;
            if (op->kind == IR_RET) {
                rc = lower_ret(out, f, op);
            } else {
                rc = lower_op(out, f, op);
            }
            ss_cur_g = -1;
            if (rc != 0) goto cleanup_err;
            if (cur_skip_next_op) {
                j++;  /* the fastpath consumed op[i+1] (the branch) */
            }
        }
        bb_hl_out[bb->id] = cur_hl_vreg;
        bb_pending_out[bb->id] = pending_spill_v;
        bb_lowered[bb->id] = 1;
    }

    return 0;

cleanup_err:
    /* Caller (ir_lower_func) owns the bb_* arrays and ir_free_liveness. */
    return -1;
}
