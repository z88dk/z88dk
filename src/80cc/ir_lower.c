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
#include <limits.h>

/* Global FRAMEPTR opt-in: -1 disabled, 1 IX, 0 IY. Owned by the
   compiler (data.c) but consulted directly here so the lowerer stays
   decoupled from ccdefs.h. */
extern int c_framepointer_is_ix;

/* Per-TU string-literal queue label number. String literal addresses
   emit as `ld hl,i_<litlab>+<offset>` (IR_LD_STR). */
extern int litlab;

/* Debug-info flags. -cc emits a `; "file":line: source` comment + a
   C_LINE directive per source line transition; -gcline (debug-defc)
   emits the C_LINE only. Owned by data.c; both default off.
   When either is on, the interleaved comments/C_LINE directives stop
   copt rules matching across them, so debug builds give up most
   post-emit peephole wins — the standard tradeoff for line info. */
extern int c_intermix_ccode;
extern int c_cline_directive;

/* Emit helpers reused for the C_LINE / comment format. gen_emit_line
   consults globals (Filename / currfn); gen_comment consults lineno.
   Both are emit-time cursors — by lowerer time they sit at EOF, so we
   save/restore around the emit. */
extern void  gen_emit_line(int line);
extern void  gen_comment(const char *message);
extern const char *get_source_line(const char *filename, int n);
extern int   lineno;
extern FILE *output;   /* gen_emit_line/gen_comment write here via outfmt */

/* Track the (file, line) of the last C_LINE we emitted so we can
   suppress duplicates within a contiguous run on the same line.
   Reset at the start of every ir_lower_func. */
static const char *cur_emitted_file;
static int         cur_emitted_line;

/* Source location of the op currently being lowered (set in lower_op,
   independent of C_LINE emit mode). Used to annotate lowering aborts. */
static const char *lower_cur_file;
static int         lower_cur_line;

struct RegState {
    int hl;     /* HL value cache */
    int de;     /* DE value cache; survives DE-preserving emits (load_to_hl,
                   add/sbc hl,de, byte ops), dropped on load_to_dehl / ex de,hl
                   / pop de / calls */
    int dehl;   /* long vreg split across DE(high)/BC(low) — the layout
                   load_to_dehl/store_dehl leave; on a hit load_to_dehl_adj
                   recovers HL with just `ld l,c; ld h,b`, not a full slot load */
    int bc;     /* BC value cache */
    int a;      /* byte vreg in A */
    int fa;     /* vreg resident in the float accumulator (FA, math48 alt regs) */
    int i64_acc;/* vreg resident in __i64_acc (long long) — a SEPARATE physical
                   store from FA, so its residency is tracked independently */
};

/* The lowerer's mutable state, grouped into one struct and accessed as
   L.<field> throughout the spine and all #included fragments (one shared
   instance). (bc_args_save[] and the debug-line cursors stay standalone —
   localized, not part of the register-lowering state.) */
typedef struct {
    struct RegState rs;
    /* HL slot-ADDRESS cache (distinct from rs.hl's value cache): the slot
       offset whose address (sp+off) sits in HL, or -1; spadj pins cur_sp_adjust
       so a moved sp misses. Keyed on offset (not vreg) so a coalesced read/
       write of one C var hits. A cached address implies rs.hl==-1 — value and
       address caches are never both live. */
    int cur_hl_addr_off, cur_hl_addr_spadj;
    /* Data-stack depth in bytes from inline long pushes: the z80 stack doubles
       as an operand stack (DEHL = implicit TOS). ir_opt inserts IR_PUSH/
       POP_DEHL_LONG across DEHL-clobbering long live ranges (+4 each); sp-rel
       slot reads add this to compensate. Reset per BB. Stack-consuming helpers
       (l_long_or/add) pop their RHS with no IR_POP — gen_hcall decrements it. */
    int cur_sp_adjust;
    int func_emit_idx, cmp_label_counter, fc_ret_label_counter;
    int cur_func_uses_params;
    int cur_home_is_word, cur_func_whome;
    int cur_byte_home_vreg, cur_byte_home_dirty, cur_func_ehome;
    /* DE-home co-design: the general (non-accumulate) width-2 vreg the
       orchestrator elected to keep in DE across a loop (e.g. searchbench `hi`),
       or -1. Set by the orchestrator's residency decision; while it's live, the
       binop/compare folds keep DE clean (read operands in place, no pair stage)
       and the deref push/pop's DE, so the home survives the whole region. */
    int cur_de_home;
    int cur_home_region_lo, cur_home_region_hi, cur_home_exit_flush_bb;
    int *bb_byte_out;
    /* Parallel to bb_byte_out: was the slot-backed byte home DIRTY (E holds
       the value, slot stale) at this BB's exit? A successor that carries the
       home in must inherit this dirtiness — else its back-edge/merge flush is
       wrongly suppressed and a slot reload reads a stale value. */
    int *bb_byte_out_dirty;
    /* Rematerialization: for a width-2 vreg defined exactly once by LD_IMM or
       LD_SYM (a compile-time constant / static address), remat_def[v] points at
       that defining op. On a cache-miss load the lowerer re-emits `ld rp,<const>`
       instead of a slot reload (cheaper, and the value is loop-invariant so it
       never needs spilling). NULL = not rematerializable. */
    const Op **remat_def;
    int lazy_spill_on, pending_spill_v;
    int ss_phase, *ss_op_store, *ss_op_reload, *ss_op_cacheread;
    const signed char *ss_store_dead; const int *ss_op_base;
    int ss_cur_g, ss_pinned;
    /* "the tower": transient per-op lookahead one-shots — set while lowering
       one op to steer the next emit, then consumed. Grouped so they read as
       one unit (and so a leak past an op boundary is greppable / verifiable).
       Most are same-op transient; cur_skip_next_op and cur_branch_test_* are
       the deliberate op-N→op-N+1 forward signals. */
    struct {
        int cur_load_to_dehl_no_hl, cur_load_to_dehl_no_bc;
        int cur_stack_long_top, cur_dehl_inline_push, cur_dehl_inline_push_base_sp;
        int cur_dehl_push_to_stack, cur_store_dehl_bc_dead, cur_dehl_dst_no_bc_stash;
        int cur_dehl_dst_dead_safe, cur_branch_test_kind, cur_dst_dead;
        int cur_branch_test_label, cur_skip_next_op;
        int shl_skip_n, cur_skip_shl_add_hl, cur_skip_shl_byte;
    } la;
} LowerState;

static LowerState L = {
    .rs = { .fa = -1, .i64_acc = -1 },
    .cur_hl_addr_off = -1, .cur_func_uses_params = 1,
    .cur_func_whome = -1, .cur_byte_home_vreg = -1, .cur_func_ehome = -1,
    .cur_de_home = -1,
    .cur_home_region_lo = -1, .cur_home_region_hi = -1,
    .cur_home_exit_flush_bb = -1, .pending_spill_v = -1,
};



/* Strip the surrounding quotes that op->file carries (from `Filename`). */
static const char *lower_unquote(const char *file, char *buf, size_t n)
{
    if (!file || !*file) return NULL;
    size_t len = strlen(file);
    if (len >= 2 && file[0] == '"' && file[len-1] == '"') { file++; len -= 2; }
    if (len >= n) len = n - 1;
    memcpy(buf, file, len);
    buf[len] = 0;
    return buf;
}

/* Prefix a lowering-abort message with `file:line: ` (when known) and,
   after the message, echo the offending source line. Call as:
     ir_lower_loc(); fprintf(stderr, "ir_lower: ...\n"); ir_lower_src(); */
static void ir_lower_loc(void)
{
    char path[512];
    const char *file = lower_unquote(lower_cur_file, path, sizeof path);
    if (file && lower_cur_line > 0)
        fprintf(stderr, "%s:%d: error: ", file, lower_cur_line);
}
static void ir_lower_src(void)
{
    char path[512];
    const char *file = lower_unquote(lower_cur_file, path, sizeof path);
    if (!file || lower_cur_line <= 0) return;
    FILE *f = fopen(path, "r");
    if (!f) return;
    char buf[512];
    int cur = 0;
    while (fgets(buf, sizeof buf, f)) {
        if (++cur != lower_cur_line) continue;
        size_t len = strlen(buf);
        while (len && (buf[len-1] == '\n' || buf[len-1] == '\r')) buf[--len] = 0;
        const char *p = buf;
        while (*p == ' ' || *p == '\t') p++;
        fprintf(stderr, "    %s\n", p);
        break;
    }
    fclose(f);
}

static void emit_op_cline(FILE *out, const Op *op)
{
    if (!c_intermix_ccode && !c_cline_directive) return;
    if (!op || op->line <= 0) return;
    if (op->line == cur_emitted_line && op->file == cur_emitted_file)
        return;
    int saved_lineno = lineno;
    lineno = op->line;
    /* gen_comment/gen_emit_line write via outfmt to the global `output`.
       Instructions go to the buffered `out` (a memstream flushed at
       function end), so writing the C_LINE/comment straight to `output`
       would dump them all ahead of the code (and the recording pass's
       too). Redirect `output` to `out` so they interleave correctly and
       the discarded pass-1 render swallows its own. */
    FILE *saved_output = output;
    output = out;
    if (c_intermix_ccode && op->file) {
        const char *src = get_source_line(op->file, op->line);
        if (src) gen_comment(src);
    }
    gen_emit_line(op->line);
    output = saved_output;
    lineno = saved_lineno;
    cur_emitted_line = op->line;
    cur_emitted_file = op->file;
}

/* ----- Tiny emit helpers ------------------------------------------------ */

/* Clobber mask for emit_c(): declares which register caches an emitted
   instruction destroys, so the invalidation happens at the emit site and
   can't be forgotten. Each bit maps to the matching invalidate_* routine
   (apply_clobbers below). Bits compose: CLOB_HL|CLOB_BC == invalidate_hl_bc(). */
typedef enum {
    CLOB_NONE = 0,
    CLOB_HL   = 1,   /* invalidate_hl_cache(): HL+DE+DEHL+A+FA, flushes pending HL spill */
    CLOB_BC   = 2,   /* invalidate_bc_cache() */
    CLOB_A    = 4,   /* invalidate_a_cache() */
    CLOB_DE   = 8,   /* invalidate_de_cache(): DE+DEHL */
} Clobber;

static void apply_clobbers(Clobber c);
static int wide_acc_result_dead_in_acc(const Func *f, int v);

static void vemit(FILE *out, const char *fmt, va_list ap)
{
    fputc('\t', out);
    vfprintf(out, fmt, ap);
    fputc('\n', out);
}

static void emit(FILE *out, const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vemit(out, fmt, ap);
    va_end(ap);
}

/* Emit a clobbering instruction: apply the declared register-cache clobbers
   FIRST (so CLOB_HL's hl_about_to_change flush stores the pending value while
   HL still holds it — i.e. before the instruction destroys it), then the
   instruction text. The apply-before order is what makes the lazy-spill flush
   correct-by-construction at every HL-clobbering emit site. */
static void emit_c(FILE *out, Clobber c, const char *fmt, ...)
{
    apply_clobbers(c);
    va_list ap;
    va_start(ap, fmt);
    vemit(out, fmt, ap);
    va_end(ap);
}

/* Prefix per-function labels with func_emit_idx so they don't collide
   across functions in the same module (`L_bb_0` would otherwise duplicate). */

static void emit_bb_label(FILE *out, int bb_id)
{
    fprintf(out, "L_f%d_bb_%d:\n", L.func_emit_idx, bb_id);
}

/* HL value cache. Reset at each BB boundary and at any op that
   clobbers HL the cache can't reason about (calls, branches, shifts
   that loop on HL). When the next op reads rs.hl as src[0] we
   skip the load and use load_to_de_preserve_hl for src[1]. */
/* The wide-accumulator residency cell for `vreg` — __i64_acc for a long long,
   FA for a double. They are distinct stores, so never share a marker. */
static inline int *wide_acc_cell(const Func *f, int vreg)
{
    return (vreg >= 0 && f->vregs[vreg].kind == KIND_LONGLONG)
        ? &L.rs.i64_acc : &L.rs.fa;
}

/* Lazy spill (store-on-clobber). `pending_spill_v` is the width-2 vreg
   whose slot store has been deferred (it rides in HL; I1: pending_spill_v
   >= 0 ⇒ rs.hl == pending_spill_v); -1 = nothing pending. cur_lazy_out/
   cur_lazy_func/cur_op_idx give the choke-point flush the emit stream +
   the per-op liveness context (ir_op_live_in) it needs. */
static FILE        *cur_lazy_out;
static const Func  *cur_lazy_func;
static int          cur_op_idx;

/* Framepointer mode predicates.

   `fp_active(f)` returns 1 iff the function should use IX/IY as a
   frame pointer. Gated globally by -frameix / -frameiy (which set
   `c_framepointer_is_ix` to 1 / 0 respectively; -1 means off) and
   per-function by __naked.

   `fp_offset_fits(off)` returns 1 iff `off` is in the signed 8-bit
   range that `(ix±d)` addressing supports.

   `frame_reg()` returns "ix" or "iy" matching the user's choice. */
static int fastcall_arg_vreg(const Func *f);

/* Does the function read or write any parameter? Used by the frame-pointer
   elision below. O(ops) — frame_has_saved_fp reads the cached
   cur_func_uses_params (set once per function) rather than calling this
   per slot access. */
static int func_uses_params(const Func *f)
{
    int r = 0;
    for (int b = 0; b < f->n_bbs && !r; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops && !r; j++) {
            const Op *o = &bb->ops[j];
            int reg[16];
            int n = ir_op_uses(o, reg, (int)(sizeof reg / sizeof reg[0]));
            for (int k = 0; k < n; k++)
                if (reg[k] >= 0 && reg[k] < f->n_vregs
                    && (f->vregs[reg[k]].flags
                        & (IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE))) { r = 1; break; }
            if (r) break;
            n = ir_op_defs(o, reg, 2);
            for (int k = 0; k < n; k++)
                if (reg[k] >= 0 && reg[k] < f->n_vregs
                    && (f->vregs[reg[k]].flags
                        & (IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE))) { r = 1; break; }
        }
    }
    return r;
}

/* True iff entry emitted a `push ix` (gen_push_frame) — i.e. -frameix is on
   for a non-naked function. The saved IX then occupies 2 bytes between the
   locals and the return address on the stack, regardless of whether IX is
   actually used as a frame pointer.

   Frame-pointer ELISION (Tier A): a function that touches no frame at all —
   no spill/local slots (frame_size==0) AND no parameter access — needs no IX.
   It then emits the plain sp-mode path (already correct) and never references
   IX, so the caller's IX is preserved automatically. Excluded: acc-tier
   functions (the maths helpers clobber IX, so it must be saved), interrupt
   handlers (special framing), and fastcall functions (the entry juggles the
   register arg assuming a frame). */
static int frame_has_saved_fp(const Func *f)
{
    if (!f) return 0;
    if (c_framepointer_is_ix == -1) return 0;
    if (f->is_naked) return 0;
    if (f->frame_size == 0 && !f->uses_acc && !f->is_interrupt
        && fastcall_arg_vreg(f) < 0 && !L.cur_func_uses_params)
        return 0;            /* no frame needed → no IX */
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
                       between the locals and the return address. Rabbit's
                       ipset 3 and gbz80/8080's bare di use no data stack → 0. */
                    + (f->is_interrupt ? 12
                       : ((f->flags & CRITICAL)
                          && !(IS_RABBIT()) && !(IS_GBZ80())
                          && !(IS_8080()) ? 2 : 0));
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
        int caller_w = (width == 1)
                     ? ((f->flags & (SDCCDECL | SDCCCALL1)) ? 1 : 2) : width;
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

/* A vreg read/written through its frame slot MUST have one. A negative
   slot_off means a register-only vreg (PR_HL/DE/BC/DEHL) reached a slot
   access with its register already clobbered and no backing slot to
   reload from — an allocator/lowering bug. `ld hl,-1; add hl,sp` would
   read below the frame and silently miscompile, so fail loudly instead. */
static void require_slot(const Func *f, int vreg_id)
{
    if (slot_off(f, vreg_id) >= 0) return;
    ir_lower_loc();
    fprintf(stderr, "ir_lower: value read with no live register and no stack slot "
            "(v%d, phys %d, width %d). This usually means a variable is read "
            "before it is assigned — undefined behaviour in the source (e.g. a "
            "`for(i==0; ...)` typo, or passing an uninitialised local). If the "
            "variable is definitely set before use, it is a codegen bug. "
            "Aborting rather than emit a below-frame read.\n",
            vreg_id, f->vreg_to_phys ? f->vreg_to_phys[vreg_id] : -1,
            f->vregs[vreg_id].width);
    ir_lower_src();
    exit(1);
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
static void cache_a(int v);
static int  dehl_has(int v);
static void byte_alu_operand(FILE *out, const Func *f,
                             const char *prefix, int m);
static int  finalize_byte_result(FILE *out, Func *f, const Op *op,
                                 int want_flags);
static PhysReg byte_home_phys(const Func *f, int v);
static int  byte_home_slotbacked(PhysReg pr);
static const char *byte_home_reg(PhysReg pr);
static int  byte_home_holds(int v);
static PhysReg idxhalf_phys(const Func *f, int v);
static const char *idxhalf_reg(PhysReg pr);
static void byte_home_note(int v);
static void byte_home_flush(FILE *out, const Func *f);
/* Word (int) DE-home — width-aware siblings of the byte-home helpers; the
   home register is the whole DE pair (a loop-carried accumulator). The
   home_* dispatchers below pick the byte or word variant per cur_home_is_word
   so the shared BB-loop residency logic serves both. */
static void word_home_flush(FILE *out, const Func *f);
static int  rehome_word_home(FILE *out, const Func *f);
static void home_flush(FILE *out, const Func *f);
static void home_clobber(FILE *out, const Func *f);
static int  home_rehome(FILE *out, const Func *f);
static int  home_is_slotbacked(const Func *f, int v);
static const Op *find_unique_def(const Func *f, int v);
static const Op *find_unique_use(const Func *f, int v);
static int  de_home_indexed_add_ok(const Func *f, const Op *o);
static void cache_de(int v);
static void cache_bc(int v);
static void cache_dehl(int v);
static void invalidate_hl_cache(void);
static void invalidate_de_cache(void);
static void invalidate_hl_keep_de(void);
static void invalidate_hl_keep_a(void);
static int  vreg_in_idx2(const Func *f, int v);
static const char *idx2_reg_name(const Func *f);
static void cache_hl_slot_addr(const Func *f, int v);
static void emit_byte_slot_addr(FILE *out, const Func *f, int v);

/* The single choke point through which HL's logical tenant changes.
   `hl_about_to_change(v_new)` is called immediately before HL is loaded
   or clobbered: v_new is the vreg that will newly occupy HL, or -1 when
   HL becomes junk. Every clobber/load write of rs.hl routes through here
   so the lazy-spill machinery has exactly one place to flush a pending
   slot store before the value leaves HL.

   `swap_hl_de_caches()` is the sibling choke point for `ex de,hl`: the
   HL tenant MOVES to DE (it is not clobbered), so swaps route here
   rather than through hl_about_to_change. */
static void hl_about_to_change(int v_new);
static void swap_hl_de_caches(void);

/* Lazy-spill choke-point helpers. Defined
   below, after cur_bb / store_hl / the cache helpers are all visible.
   `pending_spill_resolve` is called from hl_about_to_change when HL is
   about to be clobbered with a different tenant: it flushes the pending
   store (if the value is still live) or discards it (if dead/redefined). */
static void pending_spill_flush(void);
static void pending_spill_resolve(void);

/* Static lazy-spill recording hooks (defined below). Called from the
   slot-read/write emitters. */
static void ss_note_reload(const Func *f, int v);
static void ss_note_store(const Func *f, int v);
static void ss_note_cache_read(const Func *f, int v);
static int  ss_store_dead_here(void);

/* One lowering pass of a function: prologue + the per-BB emit loop.
   Run once for the flag-off (single-pass) path, twice for the lazy-spill
   two-pass path (pass 1 deferral-off to a scratch stream to populate the
   complete bb_hl_out HL-tenant map, pass 2 for real with deferral on and
   the cross-BB defer decision consulting bb_hl_out_p1). func_emit_idx is
   NOT bumped here — both passes share the same labels. */
static int lower_func_render(FILE *out, Func *f, int lazy,
                             const int *bb_hl_out_p1,
                             int *bb_hl_out, int *bb_lowered,
                             int *bb_pending_out,
                             const int *bb_pred_cnt, int *const *bb_preds,
                             const int *bb_alias);

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
        /* ez80: lea hl,ix+d in one op, no DE clobber, vs push/pop + add. */
        if ((IS_EZ80()) && ixoff >= -128 && ixoff <= 127) {
            emit(out, "lea\thl,%s%+d", frame_reg(), ixoff);
            return;
        }
        emit(out, "push\t%s", frame_reg());
        emit(out, "pop\thl");
        if (ixoff) {
            emit(out, "ld\tde,%d", ixoff);
            emit(out, "add\thl,de");
        }
    } else {
        emit(out, "ld\thl,%d", slot_off(f, vreg) + L.cur_sp_adjust + adj);
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
   direct access. The page function preserves HL/DE and IX/IY but may CLOBBER
   AF/BC (the MSX mapper page fn does `ld c,n; ld a,(hl)`), so bracket the
   call with push/pop bc and invalidate the A cache; the access value in
   HL/DEHL survives by contract. `cur_bank_fn` dedups consecutive same-space
   accesses; resets at each BB boundary and after any call. */
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

/* IR_VERIFY: emission-time cache/lookahead-flag tripwire (set in ir_lower_func).
   Distinct from ir_verify_func (structural IR); this asserts the register-cache
   model + one-shot flag discipline hold at each op boundary. */
static int lower_verify_on;

/* vreg sitting on top of the data stack from an IR_PUSH_DEHL_LONG,
   waiting to be consumed by a long-binop with its stack-resident
   variant (ADD/SUB/AND/OR/XOR). -1 when nothing staged. Reset at BB
   boundaries. Cleared by the consumer that absorbs it OR by an
   explicit IR_POP_DEHL_LONG (for consumers — ST_MEM/NOT/NEG/SHL/SHR —
   whose lowering needs the value in DEHL). */

/* Chain-OR accumulate: when a SPILL long intermediate has a single
   in-BB consumer at distance >1 that is a long OR/AND/XOR, push the
   value to the data stack (3 instr) instead of writing to a frame slot
   (10 instr). The consumer's gen_bitop fused-(hl) path absorbs it
   directly using off=4. One slot at a time; cleared when consumed or
   at BB boundaries. */

/* Lever A: push a width-4 call/op result straight to the data stack when
   its sole use is the stacked operand of a later HCALL (l_f32_mul etc.),
   instead of spilling to a frame slot and reloading. Off via
   IR_NO_F32_STACK_ARG. */
static int f32_stack_arg_on;

static int sp_rel_max(const Func *f);

/* Walk a multi-byte slot via (hl), loading/storing one byte and advancing
   to the next — except the final byte (last=1). On gbz80 a non-final byte
   uses the native post-increment `ld a,(hl+)` (12T incl. the A->reg move vs
   16T for `ld r,(hl); inc hl`, same 2 bytes); it is A-only, so it clobbers A
   (invalidate_a_cache). Gated on rs.a < 0: clobbering A is only safe when
   nothing live is cached there. */
static void load_byte_adv(FILE *out, const char *reg, int last)
{
    int is_a = (reg[0] == 'a' && reg[1] == 0);
    /* reg==a needs no guard or move: the post-increment loads straight
       into A (the intended target). reg!=a routes through A, so it both
       clobbers A (guard rs.a < 0) and pays an A->reg move. */
    if (IS_GBZ80() && !last && (is_a || L.rs.a < 0)) {
        emit(out, "ld\ta,(hl+)");
        if (!is_a) emit(out, "ld\t%s,a", reg);
        invalidate_a_cache();
    } else {
        emit(out, "ld\t%s,(hl)", reg);
        if (!last) emit(out, "inc\thl");
    }
}

static void store_byte_adv(FILE *out, const char *reg, int last)
{
    int is_a = (reg[0] == 'a' && reg[1] == 0);
    if (IS_GBZ80() && !last && (is_a || L.rs.a < 0)) {
        if (!is_a) emit(out, "ld\ta,%s", reg);
        emit(out, "ld\t(hl+),a");
        if (!is_a) invalidate_a_cache();
    } else {
        emit(out, "ld\t(hl),%s", reg);
        if (!last) emit(out, "inc\thl");
    }
}

#include "ir_lower_regcache.inc.c"
#include "ir_lower_analysis.inc.c"
#include "ir_lower_ops.inc.c"
#include "ir_lower_call.inc.c"
#include "ir_lower_cmp.inc.c"
static int lower_op(FILE *out, Func *f, const Op *op)
{
    /* Track the op's source location (independent of C_LINE emit mode) so
       a lowering abort can name file:line + echo the source line. */
    lower_cur_file = op->file;
    lower_cur_line = op->line;
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
    case IR_PUSH_STRUCT:       return gen_push_struct(out, f, op);
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
    case IR_RSUB:                     return gen_rsub(out, f, op);
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
static int param_stack_width(const Func *f);   /* defined below */

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
            if (*wide_acc_cell(f, op->src[0]) != op->src[0]) {
                emit_acc_slot_addr(out, f, op->src[0], 0);
                emit_c(out, CLOB_HL, "call\t%s", acc_prim(f, op->src[0], "load"));
            }
        } else if (width == 4) {
            load_to_dehl(out, f, op->src[0]);
        } else {
            if (!hl_has(op->src[0]))
                load_to_hl(out, f, op->src[0]);
        }
    }
    if (fp_active(f)) {
        /* FP teardown: IX holds the saved-IX address (frame_top). `ld sp,ix`
           drops the locals, then `pop ix` restores caller's IX. Both preserve
           DEHL (and HL alone), so int-return and long-return converge here. */
        const char *fr = frame_reg();
        emit(out, "ld\tsp,%s", fr);
        emit(out, "pop\t%s", fr);
    } else if (f->frame_size > 0) {
        if (use_add_sp(f, f->frame_size, is_acc ? 0 : 2)) {
            /* add sp,d preserves HL/DE/BC, so the int/long return-value
               stashes below are unneeded — drop the frame in one chain. */
            emit_add_sp_chain(out, f->frame_size);
        } else if (is_acc) {
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
        /* Interrupt epilogue: restore the prologue-saved registers (in
           reverse) and return. Return form by critical / vector combination:
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
       preserving the return value in HL/DEHL). Mirrors codegen_critical_leave.
       Rabbit restores the IP priority with ipres (no stack). */
    if (f->flags & CRITICAL) {
        if (IS_RABBIT())
            emit(out, "ipres");
        else if (IS_GBZ80() || IS_8080())
            emit(out, "ei");          /* gbz80/8080: bare ei (IFF not readable) */
        else
            emit(out, "call\tl_pop_ei");
    }
    /* __z88dk_callee: the callee strips its own caller-pushed args (the caller
       emits no cleanup — gen_call). The teardown above left sp at the return
       address, args just above it. Remove them while preserving the return
       value (HL / DEHL / FA) and the return address. */
    int callee_args = 0;
    if (f->flags & CALLEE) {
        callee_args = param_stack_width(f);
        /* A long-long returner also receives a hidden result-buffer
           pointer just above the return address (returns_longlong → +2
           in the param-offset layout); the caller counts it as a pushed
           arg, so the callee must strip it too — else the caller's stack
           is left 2 bytes off and the next call reads garbage. */
        if (f->returns_longlong) callee_args += 2;
    } else if ((f->flags & SDCCCALL1) && f->ret_width <= 2) {
        /* __sdcccall(1) cleans the stacked remainder callee-side for a 1-2
           byte return (SDCC isFuncCalleeStackCleanup); a 4-byte/long return
           is caller-cleaned (the call site's IR_ABI_STDC handles it). */
        callee_args = param_stack_width(f);
    }
    if (callee_args > 0) {
        if (is_acc || IS_RABBIT() || IS_GBZ80()) {
            /* Result not in HL/DEHL — a wide (double) return lives in FA
               (memory / the ALT register set, which `exx` would corrupt), so
               HL/DE/BC are free; or gbz80, where `add sp,d` touches no register.
               Either way do the sp math without preserving a register pair. */
            emit(out, "pop\tbc");                 /* BC = return address */
            if (IS_RABBIT() || IS_GBZ80()) {
                int rem = callee_args;            /* gbz80/Rabbit: add sp,d */
                while (rem > 0) { int s = rem > 127 ? 127 : rem;
                                  emit(out, "add\tsp,%d", s); rem -= s; }
            } else {
                emit(out, "ld\thl,%d", callee_args);
                emit(out, "add\thl,sp");
                emit(out, "ld\tsp,hl");           /* drop the args (HL free) */
            }
            emit(out, "push\tbc");
        } else if (!(IS_808x() || IS_GBZ80())) {
            /* int/long result in HL/DEHL: park it + the return address in the
               shadow set across the sp arithmetic (exx preserves DEHL). */
            emit(out, "pop\tbc");                 /* BC = return address */
            emit(out, "exx");
            emit(out, "ld\thl,%d", callee_args);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");               /* drop the args */
            emit(out, "exx");                     /* restore value + retaddr */
            emit(out, "push\tbc");
        } else if (width == 4) {
            /* 8080/8085: no alt regs and no `add sp,d`, so the sp math needs HL
               — which a long result also occupies, with no spare pair (BC holds
               the retaddr). Genuinely unsupported; diagnose, don't miscompile. */
            fprintf(stderr, "ir_lower: __z88dk_callee with a long return is "
                            "unsupported on 8080/8085\n");
            return -1;
        } else {
            /* 8080/8085, int result in HL (≤2B): park it in DE via ex de,hl
               while HL does the sp math and BC holds the return address. */
            emit(out, "ex\tde,hl");               /* DE = result (HL now free) */
            emit(out, "pop\tbc");                 /* BC = return address */
            emit(out, "ld\thl,%d", callee_args);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");               /* drop the args */
            emit(out, "ex\tde,hl");               /* HL = result */
            emit(out, "push\tbc");
        }
    }
    /* __sdcccall(1) return register: the value is in HL after the teardown
       (the ≤2-byte non-acc path). Move it to the ABI register by the
       DECLARED return width — A for 1 byte, DE for 2. */
    if ((f->flags & SDCCCALL1) && op->src[0] >= 0 && !is_acc && width <= 4) {
        if (sdcccall1_ret_reg(f->ret_width) == SC1_A)
            emit(out, "ld\ta,l");          /* 1-byte return -> A */
        else
            emit(out, "ex\tde,hl");        /* 2B -> DE; 4B native DEHL -> sc1 HLDE */
    }
    emit(out, "ret");
    return 0;
}

/* ----- Function entry --------------------------------------------------- */

/* The vreg holding the __z88dk_fastcall register arg — the last declared
   param, delivered in HL (width 1/2; wider args bail in ir_build) rather
   than on the caller stack. -1 if not a fastcall function. Identified as
   the highest-indexed PARAM vreg (params created in declaration order
   before any temp). */
static int fastcall_arg_vreg(const Func *f)
{
    if (!(f->flags & FASTCALL)) return -1;
    int last = -1;
    for (int i = 0; i < f->n_vregs; i++)
        if ((f->vregs[i].flags & IR_VREG_PARAM)
            && f->vregs[i].kind != KIND_STRUCT)  /* a struct can't ride HL */
            last = i;
    return last;
}

/* __sdcccall(1) callee: identify the REGISTER-passed param vregs and their
   registers. p1 = 1st param (A/HL/DEHL); p2 = 2nd param ONLY if it lands in
   DE (else it's part of the stacked remainder and p2 stays -1, so the
   generic copy-in handles it). *ok=0 only if the 1st param isn't
   register-eligible (struct / wide 1st — deferred). >2 params are fine:
   everything past the register slots is stacked (STDC layout). */
static void sdcccall1_params(const Func *f, int *p1, int *p2,
                             Sc1Reg *r1, Sc1Reg *r2, int *ok)
{
    *p1 = *p2 = -1; *r1 = *r2 = SC1_STACK; *ok = 1;
    int idx = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        if (!(f->vregs[i].flags & IR_VREG_PARAM)) continue;
        idx++;
        int w = f->vregs[i].width > 0 ? f->vregs[i].width : 2;
        if (idx == 1) {
            *r1 = sdcccall1_arg_reg(1, w, SC1_STACK);
            if (*r1 != SC1_STACK) *p1 = i; else *ok = 0;   /* 1st must be a reg */
        } else if (idx == 2) {
            Sc1Reg rr = sdcccall1_arg_reg(2, w, *r1);
            if (rr == SC1_DE || rr == SC1_L) { *p2 = i; *r2 = rr; }  /* else: stacked */
        }
        /* idx > 2: stacked remainder (handled by the copy-in loop). */
    }
}

/* Caller-stack width of the params NOT passed in registers: excludes the
   fastcall arg and the __sdcccall(1) register params (1st, and 2nd-if-DE). */
static int param_stack_width(const Func *f)
{
    int fc = fastcall_arg_vreg(f);   /* not on the caller stack */
    int sc1p1 = -1, sc1p2 = -1;
    if (f->flags & SDCCCALL1) {
        Sc1Reg r1, r2; int ok;
        sdcccall1_params(f, &sc1p1, &sc1p2, &r1, &r2, &ok);
    }
    int total = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        const VReg *v = &f->vregs[i];
        if ((v->flags & IR_VREG_PARAM) && v->id != fc
            && v->id != sc1p1 && v->id != sc1p2) {
            int w = (v->width > 0) ? v->width : 2;
            /* char promoted to int (2 bytes) at the smallc call site — except
               __z88dk_sdccdecl / __sdcccall(1), where a stacked char is 1 byte. */
            if (w == 1 && !(f->flags & (SDCCDECL | SDCCCALL1))) w = 2;
            total += w;
        }
    }
    return total;
}

static void emit_prologue(FILE *out, Func *f)
{
    /* Register-save prologue: interrupt enter, critical enter, then frame
       push. Matching teardown in lower_ret. */
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
        /* Rabbit: ipset 3 (no data-stack push); gbz80/8080: bare di — the IFF
           state can't be read back (no asm_cpu_push_di), so leave re-enables
           unconditionally with ei (no stack push, no frame offset); z80 (and
           8085, which expands the z80 form) save DI state on the stack via
           l_push_di (frame offsets account for the 2 bytes). */
        if (IS_RABBIT())
            emit(out, "ipset\t3");
        else if (IS_GBZ80() || IS_8080())
            emit(out, "di");
        else
            emit(out, "call\tl_push_di");
    }
    if (frame_has_saved_fp(f))      /* gen_push_frame: preserve caller's IX */
        emit(out, "push\t%s", frame_reg());

    /* FRAMEPTR setup. Point IX at entry-sp when FP addressing is active;
       must be set BEFORE the frame alloc so it captures sp between locals
       and caller's frame for full [-128,+127] reach per slot. Teardown is
       ours too (IR emits `ret` directly, gen_pop_frame doesn't fire). */
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

    /* __sdcccall(1) args arrive in registers: 1st in A (char) / HL (int),
       2nd in DE. Stash the 1st across the frame alloc — A survives it, but
       HL is clobbered, so move HL→BC (free at entry; DE holds the 2nd). */
    int sc1 = (f->flags & SDCCCALL1) != 0;
    int sc1_p1 = -1, sc1_p2 = -1, sc1_ok = 1;
    Sc1Reg sc1_r1 = SC1_STACK, sc1_r2 = SC1_STACK;
    if (sc1) {
        sdcccall1_params(f, &sc1_p1, &sc1_p2, &sc1_r1, &sc1_r2, &sc1_ok);
        if (sc1_ok && sc1_r1 == SC1_HL) {
            emit(out, "ld\tb,h");        /* 1st (int) → BC across frame alloc */
            emit(out, "ld\tc,l");
        } else if (sc1_ok && sc1_r1 == SC1_DEHL) {
            emit(out, "ex\tde,hl");      /* sc1 HLDE -> native DEHL (HL=lo, DE=hi) */
            emit(out, "ld\tb,h");        /* low half → BC across frame alloc */
            emit(out, "ld\tc,l");
        } else if (sc1_ok && sc1_r2 == SC1_L) {
            emit(out, "ld\tc,l");        /* 2nd char (L) → C across frame alloc
                                            (1st char in A survives) */
        }
    }

    /* Allocate the frame. */
    if (f->frame_size > 0) {
        if (use_add_sp(f, -f->frame_size, 0)) {
            emit_add_sp_chain(out, -f->frame_size);
        } else {
            emit(out, "ld\thl,-%d", f->frame_size);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");
        }
    }

    if (fc_vreg >= 0 && f->vregs[fc_vreg].width > 4) {
        /* wide (acc-tier) arg: still in fa / __i64_acc (memory) — store it
           to the param's slot, like gen_ld_mem's wide path. */
        emit_acc_slot_addr(out, f, fc_vreg, 0);
        emit_acc_store_hl(out, f, fc_vreg);
        invalidate_hl_bc();
        *wide_acc_cell(f, fc_vreg) = fc_vreg;
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

    /* __sdcccall(1) register args → their (forced) spill slots. Place the
       2nd (DE) first: store_hl leaves the value in DE, so doing the 1st
       first would clobber the 2nd. The 1st int was stashed HL→BC above; a
       1st char survives the frame alloc in A. */
    if (sc1 && sc1_ok && sc1_r2 == SC1_L) {
        /* two chars: 1st in A, 2nd stashed in C. Distinct byte slots — order
           free; store 1st (A) then 2nd (via A). */
        if (sc1_p1 >= 0) store_a_byte(out, f, sc1_p1);
        if (sc1_p2 >= 0) { emit(out, "ld\ta,c"); store_a_byte(out, f, sc1_p2); }
        invalidate_hl_bc();
        invalidate_de_cache();
    } else if (sc1 && sc1_ok) {
        if (sc1_p2 >= 0) {                 /* 2nd arg in DE */
            emit(out, "ex\tde,hl");
            store_hl(out, f, sc1_p2);
        }
        if (sc1_p1 >= 0) {
            if (sc1_r1 == SC1_A) {         /* 1st char in A */
                store_a_byte(out, f, sc1_p1);
            } else if (sc1_r1 == SC1_DEHL) { /* 1st long: low in BC, high in DE */
                emit(out, "ld\th,b");      /* native DEHL: HL=low (from BC) */
                emit(out, "ld\tl,c");
                store_dehl_finalize(out, f, sc1_p1);
            } else {                       /* 1st int stashed in BC */
                emit(out, "ld\th,b");
                emit(out, "ld\tl,c");
                store_hl(out, f, sc1_p1);
            }
        }
        invalidate_hl_bc();
        invalidate_de_cache();
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
        if (sc1 && sc1_ok && (v->id == sc1_p1 || v->id == sc1_p2))
            continue;                     /* sc1 register arg: placed above */
        param_count++;
        int width = (v->width > 0) ? v->width : 2;
        /* Char params are pushed as int (2 bytes) by smallc; consume
           2 caller-bytes but only store the low byte into the vreg.
           __z88dk_sdccdecl pushes a char as 1 byte. */
        int caller_w = (width == 1)
                     ? ((f->flags & (SDCCDECL | SDCCCALL1)) ? 1 : 2) : width;
        int poff;
        if (rl_layout) { poff = caller_off; caller_off += caller_w; }
        else           { caller_off -= caller_w; poff = caller_off; }
        /* idx2 resident param: load its value into the spare index
           register once here (read from the caller slot at poff, via HL).
           The body reads it with `push <idx>;pop de`, never touching the
           slot again. */
        if (vreg_in_idx2(f, v->id) && width == 2) {
            load_sp_off_to_hl(out, poff);
            emit(out, "push\thl");
            emit(out, "pop\t%s", idx2_reg_name(f));
            invalidate_hl_cache();
            continue;
        }
        /* Read-only params live in place on the caller's stack — no
           copy-in. slot_off() returns their caller offset directly so
           later loads/stores in the body walk into the caller frame. */
        if (v->flags & IR_VREG_PARAM_IN_PLACE) continue;
        if (width == 1) {
            /* Caller pushed a 2-byte int (or 1-byte sdcccall/sdcccdecl char);
               take its low byte. The raw `ld hl,poff;add hl,sp` clobbers HL
               to the caller-slot address, so invalidate the byte slot-address
               cache — else store_a_byte's inc/dec-from-cached-slot fast path
               would apply a delta to this (now unrelated) HL. */
            emit(out, "ld\thl,%d", poff);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,(hl)");
            invalidate_hl_cache();
            store_a_byte(out, f, v->id);
        } else if (width == 2) {
            load_sp_off_to_hl(out, poff);
            store_hl(out, f, v->id);
        } else if (width == 4) {
            /* Long param: read 4 bytes from caller stack into DEHL,
               then store_dehl to the local slot. */
            emit(out, "ld\thl,%d", poff);
            emit(out, "add\thl,sp");
            load_byte_adv(out, "c", 0);
            load_byte_adv(out, "b", 0);
            load_byte_adv(out, "e", 0);
            load_byte_adv(out, "d", 1);
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
    case IR_MOV:
        /* A width-4 MOV copies src[0] via load_to_dehl (cache hit off the
           producer). When src is dead here, the producer's store is dead —
           the MOV does the single store to its own dst. */
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

/* Promote hot, currently-spilled SINGLE-DEF width-1 vregs to free index-register
   halves (PR_IYL/IYH/IXL/IXH) — a slotless, clobber-free extra byte home. Purely
   additive: only takes vregs the allocator left in a slot (IR_PR_SPILL), so it
   never displaces a register home; a value that can't be placed simply stays in
   its slot. Safe because:
   - SINGLE-DEF ⇒ the def dominates every use (SSA), so the half is always valid
     at a read (no belief/carry machinery needed);
   - NO calls/asm in the function ⇒ the index reg is never clobbered (the operand
     loader never stages there either);
   - index halves only reach BASE-page ops (ld/add/sub/and/or/xor/cp a,iyl) —
     the CB-page in-place shift paths gate on byte_home_phys, which excludes
     index halves, so `sla iyl` (which doesn't exist) is never emitted.
   z80/z80n/ez80 only (index-half ALU). Runs after ir_alloc, before
   ir_assign_slots (so promoted vregs get needs_slot=0).

   OPT-IN (IR_IDXHALF): DISABLED by default. Homing a byte in an index-register
   half CLOBBERS the whole index register (IX/IY), but IY is callee-saved in the
   z88dk ABI — e.g. l_qsort/l_bsearch hold the comparator function pointer in IY
   across every comparator call (l_setiy + asm_l_qsort). A leaf comparator that
   homes a byte in IYL/IYH corrupts that pointer → crash (was: stdlib bsearch
   suite). Making this sound needs the function to push/pop the index register it
   uses (with the matching param/frame-offset compensation across every calling
   convention + teardown path); until that lands, the feature is off by default.
   Set IR_IDXHALF to re-enable for measurement. */
static void assign_idxhalf_homes(Func *f)
{
    if (!getenv("IR_IDXHALF")) return;   /* opt-in: unsound re callee-saved IX/IY */
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || IS_EZ80())) return;
    if (!f || f->n_vregs <= 0 || !f->vreg_to_phys) return;
    /* No calls/asm — else IX/IY would be trashed mid-live-range. */
    for (int b = 0; b < f->n_bbs; b++)
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            OpKind k = f->bbs[b].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return;
        }
    /* Candidate halves — never offer halves of the FRAME register (it's used as
       a pair by every (ix+d)/(iy+d) access, and the frame isn't a vreg so the
       interval check can't see it). The frame reg is fixed globally by the
       -frameix/-frameiy option: c_framepointer_is_ix == 1 → IX is the frame,
       == 0 → IY is the frame, == -1 → sp-mode, neither. (fp_active is per-
       function but unreliable here — frame_size isn't set until ir_assign_slots
       runs after this pass; the global choice is the safe, stable gate.) A
       non-frame index reg's own tenant (an idx2 counter/param) IS a vreg, so its
       half availability is decided per byte by live-interval overlap below. */
    PhysReg halves[4]; int nhalves = 0;
    if (c_framepointer_is_ix != 0) {   /* IY is not the frame */
        halves[nhalves++] = IR_PR_IYL; halves[nhalves++] = IR_PR_IYH;
    }
    if (c_framepointer_is_ix != 1) {   /* IX is not the frame */
        halves[nhalves++] = IR_PR_IXL; halves[nhalves++] = IR_PR_IXH;
    }
    if (nhalves == 0) { return; }
    /* Per-vreg def count, a DEPTH-WEIGHTED use score (a use in a loop body is
       worth far more than a straight-line one — a byte compared each inner
       iteration appears only ONCE statically but runs many times), and a
       conservative live interval [first,last] in linear op order. Params are
       live from entry (first=0). ir_op_defs is used so a self-stepped op
       (defines src[0], not dst) is counted correctly. */
    int nv = f->n_vregs;
    int *ndef = calloc((size_t)nv, sizeof(int));
    long *wuse = calloc((size_t)nv, sizeof(long));   /* depth-weighted use score */
    int *first = malloc((size_t)nv * sizeof(int));
    int *last  = malloc((size_t)nv * sizeof(int));
    if (!ndef || !wuse || !first || !last) {
        free(ndef); free(wuse); free(first); free(last); return;
    }
    for (int v = 0; v < nv; v++) { first[v] = INT_MAX; last[v] = -1; }
    /* Cheap loop-nesting depth per BB (selection ranking only — never affects
       correctness): count the back-edge spans [target..source] (id-based,
       contiguous approximation) each BB falls in. f->bbs[].loop_depth is not
       populated at this stage. */
    int *bdep = calloc((size_t)f->n_bbs, sizeof(int));
    if (bdep)
        for (int i = 0; i < f->n_bbs; i++)
            for (int s = 0; s < ir_bb_n_succ(&f->bbs[i]); s++) {
                int t = ir_bb_succ_at(&f->bbs[i], s);
                if (t < 0 || t > i) continue;             /* back-edge: t <= i */
                for (int b = t; b <= i && b < f->n_bbs; b++) bdep[b]++;
            }
    int g = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        int dep = bdep ? bdep[b] : 0;
        if (dep > 4) dep = 4;
        long w = 1L << (3 * dep);            /* depth 0→1, 1→8, 2→64, … (~8×/level) */
        for (int j = 0; j < f->bbs[b].n_ops; j++, g++) {
            const Op *o = &f->bbs[b].ops[j];
            int d[8], u[16];
            int nd = ir_op_defs(o, d, 8);
            for (int k = 0; k < nd; k++) if (d[k] >= 0 && d[k] < nv) {
                ndef[d[k]]++;
                if (g < first[d[k]]) first[d[k]] = g;
                if (g > last[d[k]])  last[d[k]]  = g;
            }
            int un = ir_op_uses(o, u, 16);
            for (int k = 0; k < un; k++) if (u[k] >= 0 && u[k] < nv) {
                wuse[u[k]] += w;
                if (g < first[u[k]]) first[u[k]] = g;
                if (g > last[u[k]])  last[u[k]]  = g;
            }
        }
    }
    for (int v = 0; v < nv; v++)
        if (f->vregs[v].flags & (IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE))
            first[v] = 0;                                   /* live from entry */
    /* Greedily place the hottest eligible bytes; each into the first candidate
       half free over its interval (no overlapping vreg on the same half or on
       the whole pair). Multiple bytes can share a pair (IYL + IYH) or reuse a
       half's pair across disjoint ranges. */
    for (;;) {
        int best = -1;
        for (int v = 0; v < nv; v++) {
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;   /* additive only */
            if (f->vregs[v].width != 1) continue;
            /* PARAMs are live-in from the caller with NO def op that writes the
               half — the incoming value would never reach a slotless index home
               (and ndef counts only its in-body redefs, hiding this). Exclude. */
            if (f->vregs[v].flags & (IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE))
                continue;
            if (ndef[v] != 1) continue;                        /* SSA dominance */
            if (wuse[v] < 8) continue;                         /* hot: ≥1 loop use */
            if (last[v] < 0) continue;                         /* dead */
            if (f->vregs[v].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                continue;
            if (best < 0 || wuse[v] > wuse[best]) best = v;
        }
        if (best < 0) break;
        int placed = 0;
        for (int h = 0; h < nhalves && !placed; h++) {
            PhysReg H = halves[h];
            PhysReg pair = (H == IR_PR_IYL || H == IR_PR_IYH) ? IR_PR_IY : IR_PR_IX;
            int conflict = 0;
            for (int u = 0; u < nv && !conflict; u++) {
                PhysReg pu = f->vreg_to_phys[u];
                if (pu != H && pu != pair) continue;   /* same half, or full-pair tenant */
                int s = first[best] > first[u] ? first[best] : first[u];
                int e = last[best]  < last[u]  ? last[best]  : last[u];
                if (s <= e) conflict = 1;              /* intervals overlap */
            }
            if (!conflict) { f->vreg_to_phys[best] = H; placed = 1; }
        }
        if (!placed) {
            /* No half free over its range — mark ineligible so the scan
               advances (keep it spilled). */
            ndef[best] = 0;
        }
    }
    free(ndef); free(wuse); free(first); free(last); free(bdep);
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
        L.func_emit_idx++;
        for (int i = 0; i < f->n_bbs; i++) {
            BB *bb = &f->bbs[i];
            for (int o = 0; o < bb->n_ops; o++)
                if (bb->ops[o].kind == IR_ASM)
                    gen_asm(out, f, &bb->ops[o]);
        }
        return 0;
    }

    /* IR-level optimisations that mutate the IR shape — must run before
       liveness, since they change which vregs are read where. LICM
       runs first so hoisted ops are visible to the per-BB st2ld / CSE
       passes (which run within the pre-header where the hoisted op
       lands). Each returns the number of ops changed (IR_OPT_VERBOSE). */
    {
        /* Prune blocks unreachable from the entry first: ir_build leaves
           dead split/forwarding BBs whose ids can forge spurious back-edges,
           corrupting the loop/depth scans LICM and ir_alloc's residency picks
           rely on. Every later pass then sees a clean, contiguously-numbered
           CFG. */
        int pruned  = ir_opt_prune_unreachable(f);
        int hoisted = ir_opt_licm(f);
        /* Strength-reduce indexed-array address recomputes to stepped
           pointers right after LICM (loops found, base invariants
           hoisted) and before the matcher/CSE/DCE that dedup the inits
           and clear the NOPed SHL/ADD. */
        int ivsr    = ir_opt_ivsr(f);
        /* Early matcher phase (poststep, movfuse) runs BEFORE st2ld: its
           load-forwarding would otherwise multiply a MOV's use count past
           movfuse's single-use gate (an end-of-function `buf[i] += …` LD_MEM
           forwarded from the prologue's `UINT4 a = buf[0]` load). */
        int early   = ir_match_run_early(f);   /* incl. derefpp (`*p++`) */
        int fwd     = ir_opt_st2ld(f);
        /* Local const-fold + identity: simplify `x op identity` (e.g. the
           `acc = 0; acc op= …` idiom) to MOV/LD_IMM. After st2ld (which can
           forward a stored constant into a use) and before the matcher/CSE/
           DCE that dedup and clean up the resulting MOVs. */
        int cfold   = ir_opt_const_fold(f);
        /* Table-driven pattern matcher (ir_match.c) — migrated fusion
           passes run here, in table order, to fixpoint. After st2ld
           (forwarding can expose imm→CONV chains), before CSE so identical
           folded constants merge, and before the byte/offset folds and the
           long-push inserter. */
        int match   = ir_match_run(f);
        /* Reassociate a reduction's add-tree into direct accumulates
           (`acc += a+b+c+…` → `acc+=a; acc+=b; …`), interleaving each load
           with its accumulate so the word DE-home can keep the accumulator
           resident — the tree form computes sub-sums through DE and blocks it.
           After ir_match (so field offsets are folded INTO the loads —
           `LD [base+k]`, not a separate live address-add), before CSE/DCE that
           clean the NOPs it leaves. Gated on c_word_resident ⇒ inert
           (byte-identical) when off. */
        int reassoc = ir_opt_reassoc_reduction(f);
        int rcoal   = ir_opt_reduce_coalesce(f);
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
        /* Re-type promoted int ops whose result is only truncated to a
           byte as width-1 — must run after dce (fewer ops to scan, dead
           producers already gone) and before liveness/slots, which size
           frame slots off the (now-narrowed) widths. */
        /* Range-narrow bounded loop counters to a byte before narrow_byte
           and slot sizing (which reads the now-narrowed widths). */
        int ivnarrow = ir_opt_narrow_iv(f);
        int narrow  = ir_opt_narrow_byte(f);
        /* narrow_byte turns promoting CONV_SX|ZX operands into
           byte-identity copies; propagate them away (else they spill to a
           slot) and DCE the now-dead copies. */
        int cprop   = ir_opt_copy_prop(f);
        if (cprop) dce += ir_opt_dce(f);
        /* Fold single-use byte update-chain temps into their copy dst (the
           byte-home accumulator) so the char ternary's arms write the home
           directly — kills the per-arm widen + merge copy and lets the
           E-home carry the value across the diamond. After narrow_byte
           (MOV-narrow makes the temp byte) + copy_prop, before alloc. */
        int coal    = ir_opt_coalesce_copies(f);
        if (coal) dce += ir_opt_dce(f);
        /* Long push/pop insertion runs last — it expects the IR in its
           final shape. Default ON in fp mode (small size win), OFF in sp
           mode where the staging costs slightly more than the slot writes
           it replaces. IR_LONG_PUSHES=0/=1 forces off/on regardless of
           mode (a value now, not an existence check). */
        int want_pushes = fp_active(f);
        {
            const char *lp = getenv("IR_LONG_PUSHES");
            if (lp) want_pushes = (atoi(lp) != 0);
        }
        int pushes  = want_pushes ? ir_opt_insert_long_pushes(f) : 0;
        if ((hoisted > 0 || ivsr > 0 || fwd > 0 || cfold > 0
             || packs > 0 || dce > 0 || early > 0
             || late > 0 || match > 0 || narrow > 0 || ivnarrow > 0
             || cse > 0 || pushes > 0 || deadret > 0 || reassoc > 0
             || rcoal > 0 || pruned > 0)
            && getenv("IR_OPT_VERBOSE"))
            fprintf(stderr,
                    "ir_opt: %d prune, %d licm, %d ivsr, %d early, %d st2ld, "
                    "%d cfold, %d reassoc, %d match, %d cse, "
                    "%d packs, %d late, %d pushes, %d deadret, "
                    "%d dce, %d narrow, %d ivnarrow in func\n",
                    pruned, hoisted, ivsr, early, fwd, cfold, reassoc, match,
                    cse, packs, late, pushes, deadret, dce, narrow, ivnarrow);
    }

    /* Drop orphan vregs (abandoned builder temps — in no op slot) before the
       id-indexed analysis/allocation tables get built. Renumbers survivors;
       order-preserving so allocation is unaffected. */
    int n_orphans = ir_compact_vregs(f);
    if (n_orphans && getenv("IR_DEAD"))
        fprintf(stderr, "ir_compact: removed %d orphan vreg(s)\n", n_orphans);
    ir_compute_liveness(f);
    ir_compute_op_liveness(f);
    ir_compute_live_ranges(f);
    ir_alloc(f);
    assign_idxhalf_homes(f);
    ir_assign_slots(f);
    /* IR_DUMP_ALLOC prints the IR with phys-reg assignments and live ranges
       (distinct from the pre-lower IR_DUMP — reflects the allocator's view). */
    if (getenv("IR_DUMP_ALLOC"))
        ir_dump_func(stderr, f);
    /* Bumped once per function — both lowering passes (when lazy spill
       does two) share the same func label prefix. */
    L.func_emit_idx++;
    /* Structural IR verify (opt-in via IR_VERIFY): runs after ir_alloc/
       ir_assign_slots so the spilled-slot check sees populated
       vreg_to_phys[]. Reports to stderr; IR_VERIFY_ABORT turns a
       violation fatal. `stage` carries func_emit_idx so a report maps to
       the L_f<idx> labels in the emitted asm. */
    lower_verify_on = getenv("IR_VERIFY") != NULL;
    if (getenv("IR_VERIFY")) {
        char stage[24];
        snprintf(stage, sizeof stage, "lower f%d", L.func_emit_idx);
        int viol = ir_verify_func(f, stage);
        /* Compaction ran above, so there must be no orphan vregs left — a
           residual one means a slot was missed or a later pass minted dead
           state. Folded into IR_VERIFY as a standing tripwire. */
        viol += ir_report_dead_vregs(f, stage, 1);
        if (viol && getenv("IR_VERIFY_ABORT"))
            abort();
    }
    /* Lazy-spill config (per-pass deferral state lives in
       lower_func_render). Default ON (sound static reaching-reloads model);
       IR_NO_LAZY_SPILL opts out to the single-pass lowering for A/B. */
    L.lazy_spill_on = getenv("IR_NO_LAZY_SPILL") == NULL;
    int want_lazy = L.lazy_spill_on;
    f32_stack_arg_on = getenv("IR_NO_F32_STACK_ARG") == NULL;

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
       for the lazy-spill cross-BB carry. -1 = none. */
    int *bb_pending_out = malloc((size_t)f->n_bbs * sizeof(int));
    /* Byte-home cross-BB residency map: which slot-backed
       home (E/D) each BB exits with in its register. Module-static so it
       needn't thread through lower_func_render's signature. */
    L.bb_byte_out = malloc((size_t)f->n_bbs * sizeof(int));
    if (L.bb_byte_out)
        for (int i = 0; i < f->n_bbs; i++) L.bb_byte_out[i] = -1;
    L.bb_byte_out_dirty = calloc((size_t)f->n_bbs, sizeof(int));
    /* Rematerialization table: a width-2 vreg with EXACTLY ONE def that is
       LD_IMM or LD_SYM (non-bailing, non-addr-taken, non-volatile) is a
       loop-invariant constant — remember its defining op so cache-miss loads
       re-emit the constant instead of reloading a slot. */
    L.remat_def = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                         sizeof(const Op *));
    if (L.remat_def && !getenv("IR_NO_REMAT")) {
        int *ndef = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1), sizeof(int));
        if (ndef) {
            /* Count via ir_op_defs — some ops define through a non-dst field
               (e.g. IR_POSTSTEP self-steps src[0]); counting op->dst alone
               undercounts and would mis-tag a loop-carried counter as a
               single-def constant. */
            for (int b = 0; b < f->n_bbs; b++)
                for (int j = 0; j < f->bbs[b].n_ops; j++) {
                    int defs[8];
                    int nd = ir_op_defs(&f->bbs[b].ops[j], defs, 8);
                    for (int k = 0; k < nd; k++)
                        if (defs[k] >= 0 && defs[k] < f->n_vregs) ndef[defs[k]]++;
                }
            for (int b = 0; b < f->n_bbs; b++)
                for (int j = 0; j < f->bbs[b].n_ops; j++) {
                    const Op *o = &f->bbs[b].ops[j];
                    int d = o->dst;
                    if (d < 0 || d >= f->n_vregs || ndef[d] != 1) continue;
                    if (f->vregs[d].width != 2) continue;
                    if (f->vregs[d].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                        continue;
                    if (o->kind == IR_LD_IMM)
                        L.remat_def[d] = o;
                    else if (o->kind == IR_LD_SYM && o->mem.sym
                             && !ns_sym_bails(o->mem.sym))
                        L.remat_def[d] = o;
                }
            free(ndef);
        }
    }
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

    /* Word DE-home tentative-pick gate. The allocator gave the home exclusive
       DE (evicting other PR_DE tenants) — a net loss if no resident region
       forms (the home would only churn per-iter flush+rehome). Region
       formation needs slots + bb_alias, so it's decided here with the SAME
       compute_home_region the render uses. No region ⇒ restore the saved
       pre-pick allocation and re-slot, reverting to baseline. */
    int *wh_prepick = ir_alloc_take_word_home_prepick();
    if (wh_prepick) {
        if (f->word_home_vreg >= 0) {
            int wlo = -1, whi = -1;
            L.cur_home_is_word = 1;
            L.cur_func_whome = f->word_home_vreg;
            L.la.cur_branch_test_kind = 0;
            /* Same DE-home fold arming as the render, so op_de_clean's region
               proof here matches what the render will actually emit. */
            if (f->de_home_general) L.cur_de_home = f->word_home_vreg;
            compute_home_region(f, f->word_home_vreg, bb_alias, &wlo, &whi);
            L.cur_home_is_word = 0;
            L.cur_func_whome = -1;
            L.cur_de_home = -1;
            if (wlo < 0) {
                memcpy(f->vreg_to_phys, wh_prepick,
                       (size_t)f->n_vregs * sizeof(int));
                f->word_home_vreg = -1;
                f->de_home_general = 0;
                ir_assign_slots(f);
            }
        }
        free(wh_prepick);
    }

    /* === Pass driver ===
       Flag-off: a single render with deferral off. Flag-on: pass 1 renders
       deferral-off into a throwaway stream purely to populate the COMPLETE
       bb_hl_out HL-tenant map (deferral never changes which vreg HL holds at
       a BB end), then pass 2 renders for real with deferral on, its cross-BB
       defer decision consulting that complete map. */
    int rc;
    int *bb_hl_out_p1 = NULL;
    /* Static lazy-spill state — off unless the two-pass path arms it. */
    L.ss_phase = 0;
    L.ss_op_base = NULL;
    L.ss_op_store = NULL;
    L.ss_op_reload = NULL;
    L.ss_op_cacheread = NULL;
    L.ss_store_dead = NULL;
    L.ss_cur_g = -1;
    L.ss_pinned = 0;
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
        int alloc_ok = bb_hl_out_p1 && op_base && op_store && op_reload
            && op_cacheread && (src_snap || !total_ops);
        /* Scratch sink for pass 1: only its slot-store side-effects (the ss_op_*
           arrays) matter — the rendered text is discarded. tmpfile() is portable;
           open_memstream is POSIX-only (absent on mingw/Windows). */
        FILE *scratch = alloc_ok ? tmpfile() : NULL;
        if (!scratch) {
            /* Degraded (OOM / no memstream): single deferral-off pass.
               Correct, just forgoes the lazy win. */
            rc = lower_func_render(out, f, 0, NULL, bb_hl_out, bb_lowered,
                                   bb_pending_out, bb_pred_cnt, bb_preds,
                                   bb_alias);
            free(src_snap);
        } else {
            /* Pass 1: record the slot stores/reloads the lowerer emits. */
            L.ss_op_base = op_base;
            L.ss_op_store = op_store;
            L.ss_op_reload = op_reload;
            L.ss_op_cacheread = op_cacheread;
            L.ss_store_dead = NULL;
            L.ss_pinned = 0;
            L.ss_phase = 1;
            rc = lower_func_render(scratch, f, 0, NULL, bb_hl_out,
                                   bb_lowered, bb_pending_out, bb_pred_cnt,
                                   bb_preds, bb_alias);
            L.ss_phase = 0;
            fclose(scratch);
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
                signed char *store_dead = L.ss_pinned ? NULL
                    : ss_compute_dead(f, op_base, total_ops, op_store,
                                      op_reload, op_cacheread);
                /* Pass 2: skip the dead stores. */
                L.ss_store_dead = store_dead;
                L.ss_phase = store_dead ? 2 : 0;
                rc = lower_func_render(out, f, 1, bb_hl_out_p1, bb_hl_out,
                                       bb_lowered, bb_pending_out,
                                       bb_pred_cnt, bb_preds, bb_alias);
                L.ss_phase = 0;
                L.ss_store_dead = NULL;
                free(store_dead);
            }
            free(src_snap);
        }
        free(op_base);
        free(op_store);
        free(op_reload);
        free(op_cacheread);
        L.ss_op_base = NULL;
        L.ss_op_store = NULL;
        L.ss_op_reload = NULL;
        L.ss_op_cacheread = NULL;
    }
    free(bb_hl_out_p1);

    free(bb_alias);
    free(bb_hl_out);
    free(bb_pending_out);
    free(L.bb_byte_out); L.bb_byte_out = NULL;
    free(L.bb_byte_out_dirty); L.bb_byte_out_dirty = NULL;
    free(L.remat_def); L.remat_def = NULL;
    free(bb_lowered);
    free(bb_pred_cnt);
    for (int i = 0; i < f->n_bbs; i++) free(bb_preds[i]);
    free(bb_preds);
    ir_free_liveness(f);
    return rc;
}

/* Emission-time tripwire, run at each op's entry (IR_VERIFY):
     - consumed-inline load flags must be reset by their consumer, so they are
       0 at an op boundary; a set one leaked past a load_to_dehl.
     - HL's address-cache and value-cache are mutually exclusive.
   Reports to stderr with the bb/op site; IR_VERIFY_ABORT makes it fatal. */
static void lower_verify_op_entry(int bb_id, int op_idx)
{
    if (!lower_verify_on) return;
    const char *bad = NULL;
    /* Consumed-inline load flags: reset by their consumer, so 0 at a boundary. */
    if (L.la.cur_load_to_dehl_no_bc)
        bad = "cur_load_to_dehl_no_bc set at op entry (leaked past a load_to_dehl)";
    else if (L.la.cur_load_to_dehl_no_hl)
        bad = "cur_load_to_dehl_no_hl set at op entry (leaked past a load_to_dehl)";
    /* NB: cur_dehl_dst_no_bc_stash / cur_store_dehl_bc_dead are recomputed
       (reset) at op-top, not consumed-inline, so they legitimately carry the
       previous op's value into an entry — NOT assertable here. */
    else if (L.la.cur_dehl_push_to_stack)
        bad = "cur_dehl_push_to_stack set at op entry (leaked)";
    /* HL address-cache and value-cache are mutually exclusive. */
    else if (L.cur_hl_addr_off >= 0 && L.rs.hl >= 0)
        bad = "HL address-cache and value-cache both live";
    /* Lazy-spill I1: a deferred spill rides in HL until flushed. */
    else if (L.pending_spill_v >= 0 && L.rs.hl != L.pending_spill_v)
        bad = "pending_spill_v set but rs.hl doesn't hold it (I1 violated)";
    /* Rejected (empirically false-positive on correct code, kept as a record):
       - `cur_sp_adjust == 0`: sp is legitimately nonzero across ops beyond the
         inline-push mechanisms (832 hits).
       - `cur_byte_home_dirty ⇒ vreg>=0`: dirty can harmlessly persist with no
         vreg (a no-op flush; 8 hits).
       - residency ("register-homed live vreg must be in some rs cache"): the
         emission cache legitimately diverges from the allocator's homing
         mid-BB (400 hits); the register-lost class (8085 DSUB) is already
         caught by the allocator's read-time "no live register and no stack
         slot" abort. */
    if (bad) {
        fprintf(stderr, "ir_lower_verify: f%d bb%d op%d: %s\n",
                L.func_emit_idx, bb_id, op_idx, bad);
        if (getenv("IR_VERIFY_ABORT")) abort();
    }
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
    L.cmp_label_counter = 0;
    L.lazy_spill_on = lazy;
    L.pending_spill_v = -1;
    cur_lazy_out = out;
    cur_lazy_func = f;
    cur_op_idx = 0;
    invalidate_hl_bc();
    L.cur_byte_home_vreg = -1;   /* byte home: no resident at function entry */
    L.cur_byte_home_dirty = 0;
    L.cur_func_ehome = -1;
    L.cur_home_is_word = 0;
    L.cur_func_whome = -1;
    L.cur_de_home = -1;          /* set by the orchestrator's DE-home decision */
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vreg_to_phys
            && byte_home_slotbacked(f->vreg_to_phys[v])) { L.cur_func_ehome = v; break; }
    /* Word DE-home (--word-resident): a width-2 loop accumulator homed in DE.
       Mutually exclusive with a byte E/D-home (allocator gives up the word home
       when DE's low half is taken), so it reuses the same residency machinery
       — cur_func_ehome names "the home" either way; cur_home_is_word selects the
       width-specific leaf ops (flush/rehome/accumulate/DE→HL read). */
    if (L.cur_func_ehome < 0 && f->word_home_vreg >= 0 && f->vreg_to_phys
        && f->vreg_to_phys[f->word_home_vreg] == IR_PR_DE) {
        L.cur_func_whome = f->word_home_vreg;
        L.cur_func_ehome = L.cur_func_whome;
        L.cur_home_is_word = 1;
        /* General (non-accumulate) DE-home: arm the (ix+d) compare/ALU folds so
           the region stays DE-clean. -1 for a reduction accumulator (the
           try_word_accumulate path already keeps DE = home). */
        if (f->de_home_general) L.cur_de_home = f->word_home_vreg;
    }
    /* Home-resident loop: where the slot-backed home stays in E/D (or DE)
       across a loop, suppress per-iter spills + assert residency at the
       header. */
    L.cur_home_region_lo = L.cur_home_region_hi = -1;
    if (L.cur_func_ehome >= 0 && !getenv("IR_NO_HOME_RESIDENT"))
        compute_home_region(f, L.cur_func_ehome, bb_alias,
                            &L.cur_home_region_lo, &L.cur_home_region_hi);
    /* Home exit-flush hoist: if the region leaves to exactly ONE target block
       reached ONLY from the region, flush the home once at that block's entry
       instead of every iteration at the header. The home register = the final
       value there by the region proof (no leaving-edge redef). Applies to both
       the word DE-home (fp, flush E+D via ix) and the byte E/D-home (fp via ix
       or sp via HL, flush the one byte). IR_NO_WH_EXIT_HOIST opts out. */
    L.cur_home_exit_flush_bb = -1;
    if (L.cur_func_ehome >= 0
        && L.cur_home_region_lo >= 0 && !getenv("IR_NO_WH_EXIT_HOIST")) {
        int tgt = -1, ok = 1;
        for (int b = L.cur_home_region_lo; b <= L.cur_home_region_hi && ok; b++) {
            const BB *sb = &f->bbs[b];
            int ns = ir_bb_n_succ(sb);
            for (int s = 0; s < ns; s++) {
                int sid = ir_bb_succ_at(sb, s);
                if (sid < 0 || sid >= f->n_bbs) continue;
                if (bb_alias && bb_alias[sid] >= 0) sid = bb_alias[sid];
                if (sid >= L.cur_home_region_lo && sid <= L.cur_home_region_hi)
                    continue;                       /* in-region edge */
                if (tgt < 0) tgt = sid;
                else if (tgt != sid) { ok = 0; break; }  /* >1 distinct target */
            }
        }
        if (ok && tgt >= 0) {
            /* tgt reached ONLY from the region: every real (non-trampoline)
               block with an alias-resolved edge to tgt lies in [lo,hi]. */
            int all_in = 1;
            for (int b = 0; b < f->n_bbs && all_in; b++) {
                if (bb_alias && bb_alias[b] >= 0) continue;   /* trampoline label */
                const BB *sb = &f->bbs[b];
                int ns = ir_bb_n_succ(sb);
                for (int s = 0; s < ns; s++) {
                    int sid = ir_bb_succ_at(sb, s);
                    if (sid < 0 || sid >= f->n_bbs) continue;
                    if (bb_alias && bb_alias[sid] >= 0) sid = bb_alias[sid];
                    if (sid != tgt) continue;
                    if (b < L.cur_home_region_lo || b > L.cur_home_region_hi) {
                        all_in = 0; break;
                    }
                }
            }
            /* fp: the flush store is ix-relative, so its offset(s) must fit
               (word home writes 2 bytes: off and off+1; byte home just off).
               sp: the flush addresses via HL, which reaches any slot — but the
               word DE-home's exit flush is fp-only, so gate sp to byte homes. */
            int slot_ok;
            if (fp_active(f)) {
                int off = slot_ix_off(f, L.cur_func_ehome);
                slot_ok = fp_offset_fits(off)
                    && (!L.cur_home_is_word || fp_offset_fits(off + 1));
            } else {
                slot_ok = !L.cur_home_is_word;
            }
            if (all_in && slot_ok)
                L.cur_home_exit_flush_bb = tgt;
        }
    }
    L.cur_func_uses_params = func_uses_params(f);   /* frame-pointer elision */
    if (L.bb_byte_out)
        for (int i = 0; i < f->n_bbs; i++) L.bb_byte_out[i] = -1;
    if (L.bb_byte_out_dirty)
        for (int i = 0; i < f->n_bbs; i++) L.bb_byte_out_dirty[i] = 0;
    L.cur_sp_adjust = 0;
    bc_args_save_depth = 0;
    L.la.cur_stack_long_top = -1;
    L.la.cur_dehl_inline_push = -1;
    L.la.cur_dehl_inline_push_base_sp = 0;
    L.la.cur_dehl_push_to_stack = 0;
    cur_emitted_file = NULL;
    cur_emitted_line = 0;
    L.la.shl_skip_n = 0;
    cur_bb = NULL;
    cur_bank_fn = NULL;   /* __addressmod: bank unknown at function entry */
    L.ss_cur_g = -1;   /* no current op during prologue */
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
                    L.func_emit_idx, bb->id, L.func_emit_idx, bb_alias[i]);
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
            /* Word DE-home: pass the home-residency carry through the trampoline
               too (mirror of bb_hl_out) — else a region body reached via an
               alias (index_walk's bb2→bb3) loses the carry and needlessly
               rehomes. Byte-home left untouched (byte-identical gate). */
            if (L.cur_home_is_word && L.cur_func_ehome >= 0 && L.bb_byte_out) {
                int bcarry = -2;
                for (int p = 0; p < bb_pred_cnt[bb->id]; p++) {
                    int pid = bb_preds[bb->id][p];
                    if (!bb_lowered[pid]) { bcarry = -1; break; }
                    int v = L.bb_byte_out[pid];
                    if (v < 0) { bcarry = -1; break; }
                    if (bcarry == -2) bcarry = v;
                    else if (bcarry != v) { bcarry = -1; break; }
                }
                L.bb_byte_out[bb->id] =
                    (bcarry >= 0 && bb->live_in
                     && ir_bitset_get((const BitSet *)bb->live_in, bcarry))
                    ? bcarry : -1;
            }
            bb_lowered[bb->id] = 1;
            continue;
        }
        emit_bb_label(out, bb->id);
        /* The long data-stack is per-BB. Any push/pop imbalance at
           a BB boundary would shift sp for unrelated code. */
        L.cur_sp_adjust = 0;
        bc_args_save_depth = 0;
        L.la.cur_stack_long_top = -1;
        L.la.cur_dehl_inline_push = -1;
        L.la.cur_dehl_inline_push_base_sp = 0;
        L.la.cur_dehl_push_to_stack = 0;
        cur_bank_fn = NULL;   /* __addressmod: bank unknown at a BB merge */
        /* No pending spill crosses into a BB yet — the cross-BB inherit
           lands with the defer step. Clear it so nothing leaks. */
        L.pending_spill_v = -1;
        /* Word DE-home exit-flush hoist: this block is the region's sole,
           dedicated exit — physical DE still holds the final accumulator (the
           region proof; nothing has emitted since the exit branch). Flush it to
           the slot ONCE here, then drop the belief. The per-iter header flush is
           suppressed below. Emitted before the cache-carry logic so no ex de,hl
           can clobber DE first (pending spill already cleared). */
        if (L.cur_home_exit_flush_bb >= 0
            && bb->id == L.cur_home_exit_flush_bb) {
            if (L.cur_home_is_word) word_home_exit_flush(out, f);
            else                    byte_home_exit_flush(out, f);
            L.cur_byte_home_dirty = 0;
            L.cur_byte_home_vreg = -1;
        }
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
               carries — invalidate_hl_cache would clear rs.hl
               which we just set. */
            invalidate_de_cache();
        } else {
            invalidate_hl_cache();
        }
        /* Byte-home carry (slot-backed E/D only): keep the home resident in
           its register across the boundary iff every lowered pred exits with
           it there (bb_byte_out) and it's live-in. Else drop the belief — the
           first read reloads from the slot. A slotless C/B home is left to
           persist (never clobbered in its envelope).
           INHERIT the pred dirtiness: a pred that fell through carrying E
           without flushing (its successor was neither a back-edge nor a merge)
           leaves the slot STALE, so this BB must know the home is dirty — else
           its own back-edge/merge exit flush is wrongly suppressed and a later
           slot reload reads a stale value. Dirty if ANY carrying pred was dirty
           (conservative: an extra flush at worst). */
        if (L.cur_func_ehome >= 0) {
            int bcarry = -2, bdirty = 0;
            for (int p = 0; p < bb_pred_cnt[bb->id]; p++) {
                int pid = bb_preds[bb->id][p];
                if (!bb_lowered[pid]) { bcarry = -1; break; }
                int v = L.bb_byte_out[pid];
                if (v < 0) { bcarry = -1; break; }
                if (bcarry == -2) bcarry = v;
                else if (bcarry != v) { bcarry = -1; break; }
                if (L.bb_byte_out_dirty[pid]) bdirty = 1;
            }
            if (bcarry >= 0 && bb->live_in
                && ir_bitset_get((const BitSet *)bb->live_in, bcarry)) {
                L.cur_byte_home_vreg = bcarry;
                L.cur_byte_home_dirty = bdirty;
            } else {
                L.cur_byte_home_vreg = -1;
            }
        }
        int in_home_region = (L.cur_home_region_lo >= 0
                              && bb->id >= L.cur_home_region_lo
                              && bb->id <= L.cur_home_region_hi);
        /* A preheader of the resident region: outside it, but with an edge
           (alias-resolved) into the header. Its exit re-homes the slot-backed
           home into E so the header can assert residency. */
        int is_region_preheader = 0;
        if (L.cur_home_region_lo >= 0 && !in_home_region) {
            int ns = ir_bb_n_succ(bb);
            for (int s = 0; s < ns; s++) {
                int sid = ir_bb_succ_at(bb, s);
                if (sid < 0 || sid >= f->n_bbs) continue;
                if (bb_alias && bb_alias[sid] >= 0) sid = bb_alias[sid];
                if (sid == L.cur_home_region_lo) { is_region_preheader = 1; break; }
            }
        }
        /* Resident-loop header: the forward pass can't carry E in over the
           (unlowered) back-edge, but compute_home_region proved the loop
           keeps the home in E. Assert residency when every already-lowered
           pred (the preheader entries) carries it — the unlowered back-edge
           preds are covered by the proof. */
        /* Assert at ANY in-region BB whose belief was dropped by an unlowered
           back-edge pred (a diamond/multi-latch body is itself a back-edge
           target, not just the header — e.g. an if/else-in-loop byte
           accumulator whose merge block is lowered before its higher-id else
           arm). The region proof covers the whole span, so trusting the
           unlowered preds is sound wherever a lowered pred carries the home.
           Applies to both the word DE-home and the byte E/D-home. */
        if (L.cur_func_ehome >= 0 && L.cur_home_region_lo >= 0
            && bb->id >= L.cur_home_region_lo
            && bb->id <= L.cur_home_region_hi
            && L.cur_byte_home_vreg < 0
            && bb->live_in
            && ir_bitset_get((const BitSet *)bb->live_in, L.cur_func_ehome)) {
            int ok = 1, saw_lowered = 0;
            for (int p = 0; p < bb_pred_cnt[bb->id]; p++) {
                int pid = bb_preds[bb->id][p];
                if (!bb_lowered[pid]) continue;        /* back-edge: trust proof */
                saw_lowered = 1;
                if (L.bb_byte_out[pid] != L.cur_func_ehome) { ok = 0; break; }
            }
            if (ok && saw_lowered)
                L.cur_byte_home_vreg = L.cur_func_ehome;
        }
        /* Correctness backstop: the resident region suppresses in-loop spills
           ONLY because the home is proven to ride E throughout. If residency
           is NOT actually established at the header (e.g. a preheader re-home
           that could not be emitted), disable the region for the rest of this
           render so the body uses the normal flush rules — else the body
           would update only E while in-loop reloads read a stale slot. */
        if (bb->id == L.cur_home_region_lo && L.cur_home_region_lo >= 0
            && L.cur_byte_home_vreg != L.cur_func_ehome) {
            L.cur_home_region_lo = L.cur_home_region_hi = -1;
            in_home_region = 0;
        }
        /* Inside the resident region the home rides E with no per-iteration
           spill, so the slot is stale: mark dirty so the one flush on the
           region-exit edge fires (a leaving consumer may reload it). */
        if (in_home_region && L.cur_byte_home_vreg == L.cur_func_ehome)
            L.cur_byte_home_dirty = 1;
        /* Does this BB need to spill a dirty home before exiting? Inside the
           resident region: only when an edge LEAVES the region (the out-of-
           region target may reload from the slot); all in-region edges keep
           the home in E. Outside: the conservative rule — flush if any
           successor is a back-edge (id ≤ ours) or a merge (>1 pred). */
        int bb_exit_flush_needed = 0;
        {
            int ns = ir_bb_n_succ(bb);
            for (int s = 0; s < ns; s++) {
                int sid = ir_bb_succ_at(bb, s);
                if (sid < 0) continue;
                /* Inside the resident region the home rides E across every
                   edge with no per-iteration spill — so no branch flush.
                   Coherence for a leaving edge is restored by an entry-flush
                   (region_exit_here below), which is placed BEFORE the test
                   (the fused byte-wise compare emits its exit jump inline, so
                   a post-test flush would miss the exit path). */
                if (in_home_region) break;
                /* Resolve an empty forwarding successor to its target: an
                   aliased block emits nothing (`defc bb_k = bb_j`), so a
                   back-edge hidden behind it (bb7→bb1, bb7 numbered high but
                   aliasing the low header) would otherwise escape the id-based
                   back-edge test and the flush would never fire. */
                if (bb_alias && sid < f->n_bbs && bb_alias[sid] >= 0)
                    sid = bb_alias[sid];
                if (sid <= bb->id || bb_pred_cnt[sid] > 1) {
                    bb_exit_flush_needed = 1; break;
                }
            }
        }
        /* An in-region BB with an edge LEAVING the region (alias-resolved):
           flush the home to its slot at entry so an out-of-region consumer
           that reloads sees a coherent value. compute_home_region guarantees
           such a BB does not redefine the home, so the entry value is the
           exit value. */
        int region_exit_here = 0;
        if (in_home_region) {
            int ns = ir_bb_n_succ(bb);
            for (int s = 0; s < ns; s++) {
                int sid = ir_bb_succ_at(bb, s);
                if (sid < 0 || sid >= f->n_bbs) continue;
                if (bb_alias && bb_alias[sid] >= 0) sid = bb_alias[sid];
                if (sid < L.cur_home_region_lo || sid > L.cur_home_region_hi) {
                    region_exit_here = 1; break;
                }
            }
        }
        /* The exit-flush is hoisted to the dedicated exit block's entry (once),
           so suppress the per-iteration header flush when that hoist is active. */
        if (region_exit_here && L.cur_byte_home_vreg == L.cur_func_ehome
            && L.cur_byte_home_dirty
            && home_is_slotbacked(f, L.cur_func_ehome)
            && L.cur_home_exit_flush_bb < 0)
            home_flush(out, f);   /* keep belief; slot now coherent */
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            int rc;
            lower_verify_op_entry(bb->id, j);

            /* Commutative-swap: if the next op is a commutative long binop
               with dst in the non-first-loaded src slot, rotate dst into the
               first slot so the dead-safe lookahead + DEHL cache can fire.
               (IR_ADD var-RHS loads src[1] first → dst-in-src[0] swap;
               IR_AND/OR/XOR load src[0] first → dst-in-src[1] swap.)
               Gated on width-4 dst, distinct srcs, and dst dead here. */
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

            /* Compute dst-dead: skip op->dst's slot spill because its value
               won't be re-read from memory.
               Conditions: dst >= 0, not in bb->live_out, every later in-BB
               use of dst is served by the HL/DEHL cache (no frame touch). The
               cache-served pattern: dst is the first cache-loaded src of the
               very next op, and that op doesn't also read dst in the other src.
               Any other use disqualifies.

               First cache-loaded src is src[0] for most ops (HL for ints,
               DEHL for longs); variable-RHS long IR_ADD loads src[1] first.
               nxt_first_dehl_src() returns the actual first slot, else 0. */
            L.la.cur_dst_dead = 0;
            if (op->dst >= 0) {
                int live_out_dst = bb->live_out
                    && ir_bitset_get((const BitSet *)bb->live_out, op->dst);
                /* A def of an address-taken or volatile vreg is never dead:
                   its slot store is observable through the pointer (IR_LEA
                   reads the slot, not the value in HL) or required by
                   volatile semantics. The cache-served exception below
                   wrongly counts IR_LEA's read as a register use, which
                   would otherwise elide the spill and leave the slot
                   uninitialised (`&x` of a const/copy-init local read garbage). */
                int addr_observable = (f->vregs[op->dst].flags
                    & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) != 0;
                if (!addr_observable && !live_out_dst) {
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
                        /* A redefinition of op->dst by op k breaks the
                           cache-served handoff ONLY when k reads that operand
                           from its SLOT and writes it back: a POSTSTEP (base is
                           allocator-pinned slot-resident) or a post-stepping
                           LD_MEM (`*p++`). For those the producing def MUST
                           spill — else `int x=5; int y=x++;` and `a=*p++; b=*p;`
                           read an uninitialised / un-stepped slot. A regular ALU
                           redefinition (`a = a + b`) reads dst from the cache the
                           def leaves, so the handoff holds and the spill elides. */
                        int k_redefs_dst = 0;
                        if (bb->ops[k].kind == IR_POSTSTEP
                            || (bb->ops[k].kind == IR_LD_MEM
                                && bb->ops[k].mem.post_step != 0)) {
                            int kd[2];
                            int knd = ir_op_defs(&bb->ops[k], kd, 2);
                            for (int d = 0; d < knd; d++)
                                if (kd[d] == op->dst) { k_redefs_dst = 1; break; }
                        }
                        for (int u = 0; u < nu; u++) {
                            if (uses[u] != op->dst) continue;
                            int cache_served =
                                allow_cache_hit &&
                                k == j + 1 &&
                                !k_redefs_dst &&
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
                    if (safe) L.la.cur_dst_dead = 1;
                }
            }

            /* Branch-test lookahead: if op[i+1] is BR_ZERO/COND
               reading op->dst (and dst is dead — guaranteed when
               cur_dst_dead is set, since that requires the next op's
               src[0]==dst pattern), publish the branch info for the
               op's fastpath to consume. */
            L.la.cur_branch_test_kind = 0;
            L.la.cur_branch_test_label = -1;
            L.la.cur_skip_next_op = 0;
            if (L.la.cur_dst_dead && j + 1 < bb->n_ops) {
                const Op *nxt = &bb->ops[j + 1];
                if ((nxt->kind == IR_BR_ZERO || nxt->kind == IR_BR_COND)
                    && nxt->src[0] == op->dst) {
                    L.la.cur_branch_test_kind = nxt->kind;
                    L.la.cur_branch_test_label = nxt->label;
                }
            }

            /* DEHL-cache dead-safety lookahead: for width-4 dsts, decide
               whether store_dehl can be skipped entirely. Safe iff the next
               op consumes dst via load_to_dehl(dst) as its first DEHL-touching
               action — i.e. dst sits in the position nxt_first_dehl_src()
               reports, so the next op hits the 2-instruction cache path
               (`ld l,c; ld h,b`), no slot read, no register clobber. */
            L.la.cur_dehl_dst_dead_safe = 0;
            L.la.cur_dehl_dst_no_bc_stash = 0;
            /* FP-mode: the trailing `ld bc,hl` DEHL-cache maintenance in a
               width-4 store is dead when, scanning forward, the value's BC=low
               invariant is clobbered before any read — first event is a
               call/hcall/asm or another width-4 result, not a read. Always
               correct to elide: store_dehl_cached drops the cache claim, so a
               later read reloads via (ix+d). */
            L.la.cur_store_dehl_bc_dead = 0;
            if (fp_active(f) && op->dst >= 0
                && f->vregs[op->dst].width == 4) {
                int V = op->dst;
                for (int k = j + 1; k < bb->n_ops; k++) {
                    const Op *ko = &bb->ops[k];
                    int uses[16];
                    int nu = ir_op_uses(ko, uses,
                                (int)(sizeof uses / sizeof uses[0]));
                    int reads_v = 0;
                    for (int u = 0; u < nu; u++)
                        if (uses[u] == V) { reads_v = 1; break; }
                    if (reads_v) break;           /* read first → maint may hit */
                    if (ko->kind == IR_CALL || ko->kind == IR_HCALL
                        || ko->kind == IR_ASM
                        || (ko->dst >= 0 && ko->dst < f->n_vregs
                            && f->vregs[ko->dst].width == 4)) {
                        L.la.cur_store_dehl_bc_dead = 1;   /* clobbered before read */
                        break;
                    }
                }
            }
            /* FP byte-direct chain narrow: when the next op is a long binop
               with dst as either src, the chain reads from H/L via the rs.hl
               advertise — the producer's `ld bc,hl` is wasted. Set the
               no-bc-stash flag. Broader than dst_dead_safe (which needs a pos
               match); the chain reads both srcs so pos is irrelevant. */
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
                    L.la.cur_dehl_dst_no_bc_stash = 1;
            }
            if (L.la.cur_dst_dead && op->dst >= 0
                && f->vregs[op->dst].width == 4
                && j + 1 < bb->n_ops) {
                const Op *nxt = &bb->ops[j + 1];
                /* Unary HCALL consumer (e.g. l_f32_invf reciprocal): its one
                   width-4 operand is loaded via load_to_dehl → a cache hit off
                   this dying producer, so the slot store is dead. Kills the
                   sint2f→invf double-store in `1.0/x`. HCALL operands live in
                   hi->args, not nxt->src[]. */
                if (nxt->kind == IR_HCALL && nxt->hcall
                    && nxt->hcall->n_args == 1 && nxt->hcall->args
                    && nxt->hcall->args[0] == op->dst) {
                    L.la.cur_dehl_dst_dead_safe = 1;
                }
                int pos = nxt_first_dehl_src(nxt);
                if (!L.la.cur_dehl_dst_dead_safe && pos >= 0 && nxt->src[pos] == op->dst) {
                    switch (nxt->kind) {
                    case IR_ST_MEM:
                    case IR_NEG: case IR_NOT:
                    case IR_PUSH_DEHL_LONG:
                        L.la.cur_dehl_dst_dead_safe = 1;
                        break;
                    case IR_MOV:
                        /* Copy of a dying width-4 producer: skip the
                           producer's slot store; the MOV reads it from the
                           DEHL cache and does the one store (kills the
                           `acc += x` compound-assign double-store). */
                        L.la.cur_dehl_dst_dead_safe = 1;
                        break;
                    case IR_ADD:
                    case IR_SUB:
                    case IR_AND: case IR_OR:  case IR_XOR:
                        /* Both const-RHS (pos=0, no DEHL load of src[1])
                           and variable-RHS (pos matches first load)
                           are safe — load_to_dehl(dst) hits the cache. */
                        L.la.cur_dehl_dst_dead_safe = 1;
                        break;
                    case IR_SHL: case IR_SHR:
                        /* Both const-count and var-count fire (var-count via
                           l_lsl/lsr_dehl, DEHL = value); load_to_dehl(dst) hits
                           the cache when dst is already there. */
                        L.la.cur_dehl_dst_dead_safe = 1;
                        break;
                    case IR_ROTL:
                        /* gen_rotl consumes src[0] via load_to_dehl
                           first — cache hit, no slot read. */
                        L.la.cur_dehl_dst_dead_safe = 1;
                        break;
                    default: break;
                    }
                }
            }
            /* Redefinition-dead slot writeback: dst is LIVE (so cur_dst_dead
               is false), but the next op BOTH consumes dst via its first
               load_to_dehl (cache hit) AND redefines dst (nxt->dst==op->dst).
               Every later read sees nxt's value, whose finalize owns the slot
               — this def's writeback can never be observed (`a=ROTATE(a); a+=b;`).
               Excluded: ADDR_TAKEN/PARAM (slot readable behind the IR's back)
               and dst doubling as the other src (its 2nd read may take the slot). */
            if (!L.la.cur_dehl_dst_dead_safe
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
                        L.la.cur_dehl_dst_dead_safe = 1;
                        break;
                    default: break;
                    }
                }
            }
            /* HCALL producer → unary HCALL consumer: an HCALL's width-4
               result whose sole remaining use is the immediately-following
               unary HCALL (e.g. sint2f→invf in `1.0/x`) stays in the DEHL
               cache for that consumer, so the result's slot store is dead.
               The producer's dst lives in hcall->ret_vreg (not op->dst), so
               the cur_dst_dead paths above never reach it. */
            if (!L.la.cur_dehl_dst_dead_safe
                && op->kind == IR_HCALL && op->hcall
                && op->hcall->ret_vreg >= 0
                && f->vregs[op->hcall->ret_vreg].width == 4
                && !(f->vregs[op->hcall->ret_vreg].flags
                     & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                && j + 1 < bb->n_ops) {
                int rv = op->hcall->ret_vreg;
                const Op *nxt = &bb->ops[j + 1];
                if (nxt->kind == IR_HCALL && nxt->hcall
                    && nxt->hcall->n_args == 1 && nxt->hcall->args
                    && nxt->hcall->args[0] == rv
                    && !(bb->live_out
                         && ir_bitset_get((const BitSet *)bb->live_out, rv))) {
                    /* rv must have no other use past the consumer in this BB. */
                    int used_later = 0;
                    for (int k = j + 2; k < bb->n_ops && !used_later; k++) {
                        int uses[16];
                        int nu = ir_op_uses(&bb->ops[k], uses,
                                            (int)(sizeof uses / sizeof uses[0]));
                        for (int u = 0; u < nu; u++)
                            if (uses[u] == rv) { used_later = 1; break; }
                    }
                    if (!used_later) L.la.cur_dehl_dst_dead_safe = 1;
                }
            }

            /* Chain-OR accumulate lookahead: if op->dst is a SPILL long with a
               single in-BB use at consumer k>j+1 that is a long OR/AND/XOR
               where op->dst lands in src[1] after commutative swap, flag it for
               inline push instead of slot spill (~15 instr/element saved).
               Guard: src[0] pre-swap == op->dst; the other operand (src[1]
               pre-swap) must be produced at k-1 and die at k (swap fires). */
            L.la.cur_dehl_push_to_stack = 0;
            if (!fp_active(f)
                && !L.la.cur_dehl_dst_dead_safe
                && !L.la.cur_dst_dead
                && op->dst >= 0
                && f->vregs[op->dst].width == 4
                && !vreg_is_pr_dehl(f, op->dst)
                && L.la.cur_stack_long_top < 0) {
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
                        L.la.cur_dehl_push_to_stack = 1;
                }
            }

            /* Lever A (f32 stacked-arg residency): a width-4 result whose SOLE
               in-BB use is the stacked operand of a later HCALL (l_f32_mul
               etc.) is pushed to the data stack at production (2 instr) instead
               of a frame-slot spill+reload (~19); gen_hcall skips its push.
               Targets the `t=call(); ...; hcall(t, x)` straddle. Gated on no
               PR_BC (else gen_hcall's bc-save lands atop the staged arg) and no
               call/hcall/push between (keeps it topmost at a fixed sp). */
            /* A pending inline push normally blocks a second (one data-stack
               slot at a time), but CHAINED pushes are fine when THIS op
               consumes the pending one as its own stacked arg before
               producing its result — e.g. `p = mul(a,b); s = add(p,c)`:
               the mul consumes a's push, then its result p is pushed for
               the add. Allow it when op is that consuming HCALL. */
            int pending_ok = (L.la.cur_dehl_inline_push < 0);
            if (!pending_ok && op->kind == IR_HCALL && op->hcall
                && op->hcall->args)
                for (int a = 0; a < op->hcall->n_stacked; a++)
                    if (op->hcall->args[a] == L.la.cur_dehl_inline_push) {
                        pending_ok = 1; break;
                    }
            if (f32_stack_arg_on
                && !L.la.cur_dehl_push_to_stack
                && !fp_active(f)
                && !func_has_pr_bc(f)
                && !L.la.cur_dehl_dst_dead_safe
                && op->dst >= 0
                && f->vregs[op->dst].width == 4
                && !vreg_is_pr_dehl(f, op->dst)
                && L.la.cur_stack_long_top < 0
                && pending_ok
                && !(bb->live_out
                     && ir_bitset_get((const BitSet *)bb->live_out, op->dst))) {
                int consumer = -1, ok = 1;
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
                    /* Any data-stack push before the consumer would leave
                       the staged arg no longer topmost. */
                    if (consumer < 0
                        && (ko->kind == IR_CALL || ko->kind == IR_HCALL
                            || ko->kind == IR_PUSH_DEHL_LONG))
                        ok = 0;
                }
                if (ok && consumer >= 0) {
                    const Op *ko = &bb->ops[consumer];
                    if (ko->kind == IR_HCALL && ko->hcall
                        && ko->hcall->n_stacked == 1
                        && ko->hcall->n_args >= 1
                        && ko->hcall->args
                        && ko->hcall->args[0] == op->dst) {
                        int also_reg = 0;
                        for (int a = ko->hcall->n_stacked;
                             a < ko->hcall->n_args; a++)
                            if (ko->hcall->args[a] == op->dst) also_reg = 1;
                        if (!also_reg)
                            L.la.cur_dehl_push_to_stack = 1;
                    }
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
                    /* Preheader fall-through into a resident loop: re-home
                       the slot-backed home into E here too (this elided BR is
                       the entry edge). */
                    if (is_region_preheader && L.cur_func_ehome >= 0)
                        home_rehome(out, f);
                    /* HL state unchanged — bb_hl_out captures
                       rs.hl. But an elided fall-through still crosses
                       a BB boundary: spill a dirty slot-backed home (keeping
                       the belief) so the merge/back-edge successor can reload
                       a coherent slot if it doesn't carry. */
                    if (L.cur_func_ehome >= 0 && bb_exit_flush_needed
                        && L.cur_byte_home_dirty && L.cur_byte_home_vreg >= 0
                        && home_is_slotbacked(f, L.cur_byte_home_vreg))
                        home_flush(out, f);
                    continue;
                }
            }

            emit_op_cline(out, op);
            /* Shift-and-test skip list (set by the AND-mask + BR + SHL fused
               fastpath): the leading SHL in the target BB already had its
               `add hl,hl` done by the fused emit, so set cur_skip_shl_add_hl —
               the SHL lowerer drops the redundant `add hl,hl` but still runs
               its spill / cache tail to publish HL to the dst vreg. */
            L.ss_cur_g = L.ss_op_base ? L.ss_op_base[bb->id] + j : -1;
            for (int s = 0; s < L.la.shl_skip_n; s++) {
                if (shl_skip[s].bb_id == bb->id
                    && shl_skip[s].op_idx == j) {
                    if (shl_skip[s].is_byte) {
                        /* Byte fuse: `sla <home>` in the test BB already did
                           the shift; gen_shl's byte path emits nothing (in-
                           place) or just republishes the home reg to A. */
                        L.la.cur_skip_shl_byte = 1;
                        break;
                    }
                    hl_about_to_change(shl_skip[s].cache_vreg);
                    /* The skipped SHL consumes its source from HL (the
                       fused add hl,hl already produced it) — a genuine
                       cache hit with no loader call, so record it so the
                       dead-store analysis doesn't treat it as a reload. */
                    ss_note_cache_read(f, shl_skip[s].cache_vreg);
                    L.la.cur_skip_shl_add_hl = 1;
                    break;
                }
            }
            cur_bb = bb;
            cur_op_idx = j;
            /* Byte-home lazy-spill. Two cases for the slot-backed home (E/D):
               - A non-DE-clean op may clobber E → spill + drop the belief.
               - A terminating branch to a back-edge / merge target → spill
                 (KEEP the belief) so the slot is coherent for a successor
                 that reloads instead of carrying. A clean op feeding a
                 single-pred forward edge leaves the home resident. */
            /* Preheader of a resident loop: re-home the slot-backed home into
               E before the entry branch, so the header's residency assertion
               holds on the first iteration (the home may only be in its slot
               here — clobbered by post-init DE work like `end = base+len`). */
            if (is_region_preheader && L.cur_func_ehome >= 0
                && (op->kind == IR_BR || op->kind == IR_BR_COND
                    || op->kind == IR_BR_ZERO))
                home_rehome(out, f);
            if (L.cur_byte_home_vreg >= 0
                && home_is_slotbacked(f, L.cur_byte_home_vreg)) {
                if (!op_de_clean(f, op)) {
                    home_clobber(out, f);
                } else if (L.cur_byte_home_dirty && bb_exit_flush_needed
                           && (op->kind == IR_BR || op->kind == IR_BR_COND
                               || op->kind == IR_BR_ZERO)) {
                    home_flush(out, f);   /* keep belief */
                }
            }
            /* Static lazy-spill: tag the store/reload hooks with this op's
               global index so pass 1 records against it and pass 2's
               verdict (ss_store_dead) is read for it. */
            L.ss_cur_g = L.ss_op_base ? L.ss_op_base[bb->id] + j : -1;
            if (op->kind == IR_RET) {
                rc = lower_ret(out, f, op);
            } else {
                rc = lower_op(out, f, op);
            }
            L.ss_cur_g = -1;
            if (rc != 0) goto cleanup_err;
            if (L.la.cur_skip_next_op) {
                j++;  /* the fastpath consumed op[i+1] (the branch) */
            }
        }
        /* Fall-through exit (BB ends without a branch — control falls into
           the next BB): if a back-edge/merge successor needs a coherent slot
           and the home is dirty, spill it now (after the last op, before the
           implicit edge). Branch-ending BBs already flushed before the
           branch in the dispatch above. */
        if (L.cur_func_ehome >= 0 && bb_exit_flush_needed && L.cur_byte_home_dirty
            && L.cur_byte_home_vreg >= 0
            && home_is_slotbacked(f, L.cur_byte_home_vreg)) {
            int lastk = bb->n_ops ? bb->ops[bb->n_ops - 1].kind : IR_NOP;
            if (lastk != IR_BR && lastk != IR_BR_COND
                && lastk != IR_BR_ZERO && lastk != IR_RET
                && lastk != IR_SWITCH)
                home_flush(out, f);
        }
        /* Record the home's exit residency for successors' carry decision:
           the slot-backed home is in E/D here iff the belief still holds it,
           plus whether its slot is stale (dirty) so successors inherit it. */
        L.bb_byte_out[bb->id] =
            (L.cur_func_ehome >= 0 && L.cur_byte_home_vreg == L.cur_func_ehome)
            ? L.cur_byte_home_vreg : -1;
        if (L.bb_byte_out_dirty)
            L.bb_byte_out_dirty[bb->id] =
                (L.bb_byte_out[bb->id] >= 0 && L.cur_byte_home_dirty) ? 1 : 0;
        bb_hl_out[bb->id] = L.rs.hl;
        bb_pending_out[bb->id] = L.pending_spill_v;
        bb_lowered[bb->id] = 1;
    }

    return 0;

cleanup_err:
    /* Caller (ir_lower_func) owns the bb_* arrays and ir_free_liveness. */
    return -1;
}
