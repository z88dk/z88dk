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
extern int c_reserve_iy;   /* platform reserves IY — no IY residency */
extern int c_reserve_ix;   /* platform reserves IX (sp-mode) — no IX residency */
extern char c_debug_entry_points; /* -debug on a no-IX CPU: maintain a global
                                     __debug_framepointer via l_debug_push_frame
                                     so cdb frame offsets are walkable */

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
    int z_from_a;/* 1 when the LAST emitted instruction set Z/S from A's current
                    value (an `and`/`or`/`xor` on A). Invalidate-by-default at
                    the vemit chokepoint, like the `a` tracker above: anything
                    else emitted clears it, so a stale claim is impossible. Lets
                    a following truth-test of that byte skip its `or a` — the
                    mask has already set Z. */
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
    int cur_hl_addr_off;
    /* Data-stack depth in bytes from inline long pushes: the z80 stack doubles
       as an operand stack (DEHL = implicit TOS). ir_opt inserts IR_PUSH/
       POP_DEHL_LONG across DEHL-clobbering long live ranges (+4 each); sp-rel
       slot reads add this to compensate. Reset per BB. Stack-consuming helpers
       (l_long_or/add) pop their RHS with no IR_POP — gen_hcall decrements it. */
    int cur_sp_adjust;
    /* Stack-transient spill (IR_PR_STACK): the vreg whose value is currently
       push-parked at TOS (via `push hl` at its def), or -1. Its single use pops
       it. cur_sp_adjust is held +2 while it's parked so intervening sp-relative
       slot accesses stay correct. Allocator guarantees these ranges are disjoint
       within a BB (one parked at a time), so a single slot suffices. Reset per
       BB alongside cur_sp_adjust. */
    int cur_stack_resident;
    /* cur_sp_adjust captured right after the park's `push hl`. The pop is valid
       only while the parked word is still at TOS — cur_sp_adjust unchanged since
       (nothing else pushed on top). stack_parked() checks this; on mismatch the
       read falls through to require_slot (a loud abort, never a silent wrong
       pop). */
    int cur_stack_resident_spadj;
    /* NO_SLOT byte emergency spill via AF (replaces the old below-sp `ld
       (ix-(frame+1)),a` / sp-1 write). When a slotless byte in A must survive an
       A-clobber (e.g. a store whose address load uses `ld a,(hl+)`), it is parked
       with `push af` and reloaded with `pop af` — a real, interrupt-safe stack
       slot. LIFO stack (nesting: a byte parked inside another's span). Each entry
       records cur_sp_adjust at park so the pop only fires while still TOS. Reset
       per BB. */
    int af_park_vreg[4], af_park_spadj[4], af_park_depth;
    int func_emit_idx, cmp_label_counter, fc_ret_label_counter;
    /* Phase-0 live-range measurement (IR_SPILL_STATS): a slot-traffic proxy
       counted at the vemit chokepoint. spill_ix = fp frame-slot accesses
       (`(ix`/`(iy` operands); spill_sp = sp-relative slot-address computations
       (`add hl,sp`). Reset per function, reported at function-render end. Pure
       measurement — no codegen effect; output stays byte-identical. */
    int spill_ix, spill_sp;
    int cur_func_uses_params;
    int cur_frameless;   /* fp-eligible but no IX frame (params read off sp) */
    int cur_byte_home_vreg, cur_byte_home_dirty, cur_func_ehome;
    /* DE-home co-design (cur_de_home): the general (non-accumulate) width-2 vreg
       the orchestrator elected to keep in DE across a loop — MOVED to g_hc.de_home
       (step 3a). cur_home_region_lo/hi is the proven BB span it stays resident. */
    int cur_home_region_lo, cur_home_region_hi, cur_home_exit_flush_bb;
    int *bb_byte_out;
    /* Per-BB A-cache exit tenant: the vreg A holds at BB exit, or -1. Set only
       when a byte compare (cp/or a) left the tested byte in A — word compares
       clobber A (rs.a=-1). A successor reached from single-source agreeing preds
       inherits it (branches preserve A), eliminating per-arm reloads of a byte
       tested in an if/switch chain. */
    int *bb_a_out;
    /* Per-vreg write count (dst defs + POSTSTEP self-steps). A byte cached in A
       after a slot read is only safe if it never changes behind A's back — i.e.
       written exactly once (its def), read-only after. A counter (i++) is
       written more than once, so caching A for it goes stale on the inc. */
    int *vreg_wc;
    /* Parallel to bb_byte_out: was the slot-backed byte home DIRTY (E holds
       the value, slot stale) at this BB's exit? A successor that carries the
       home in must inherit this dirtiness — else its back-edge/merge flush is
       wrongly suppressed and a slot reload reads a stale value. */
    int *bb_byte_out_dirty;
    /* Rematerialization: for a width-2 vreg defined exactly once by LD_IMM or
       LD_SYM (a compile-time constant / static address), remat_def[v] points at
       that defining op. On a cache-miss load the lowerer re-emits `ld rp,<const>`
       instead of a slot reload (cheaper, and the value is loop-invariant so it
       never needs spilling). NULL = not rematerializable. MOVED to g_hc.remat_def
       (step 3a) so the alloc-time proof can see it. */
    int lazy_spill_on, pending_spill_v;
    /* Set by rec_end when the just-rendered function's frame is 100% dead
       (every spill slot went unaccessed). The pass driver reads it to re-lower
       the function frameless (frame_size=0). Gate: IR_DEADFRAME. */
    int frame_fully_dead;
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
        int cur_push_dehl_bc_dead;
        int cur_dehl_dst_dead_safe, cur_dst_dead;
        int cur_remat_def_dead;  /* remat NO_SLOT def with no same-BB reader → skip it */
        int cur_br_value_dead;   /* BR_ZERO/COND: tested value dead after → test in place */
        int cur_branch_test_label, cur_skip_next_op;
        int shl_skip_n, cur_skip_shl_add_hl, cur_skip_shl_byte;
    } la;
} LowerState;

/* Home-cleanliness proof context (ADR 0017, step 3a). The small set of
   allocator-decision facts the DE/byte-home region proof (compute_home_region →
   home_span_valid → op_de_clean[_static] + the de_clean_* predicates) depends on,
   factored OUT of the lowerer state `L` so step 3b can run the SAME proof at
   alloc-time by populating this from the candidate (where `L` doesn't exist).
   During lowering the render sets these exactly as before — same values, now on
   g_hc — so codegen stays byte-identical. */
typedef struct {
    int de_home;          /* general (non-accumulate) DE-home vreg, or -1 */
    int home_is_word;     /* home is a width-2 DE home (vs a byte E/D home) */
    int func_whome;       /* the word DE-home vreg, or -1 */
    int branch_test_kind; /* lookahead branch kind steering a fused compare (0=none) */
    const Op **remat_def; /* per-vreg rematerialising def (LD_IMM/LD_SYM), or NULL */
    const Op **lea_def;   /* per-vreg IR_LEA def (single-def only), or NULL. Lets a
                             load/store through a frame address reach the same
                             `(ix+d)` form a scalar local uses, instead of
                             materialising the address first. */
    const Op **byte_remat; /* per-vreg: a width-1 single-use LD_MEM from a global
                              (IR_MEM_SYM) with no memory-write between def and use
                              — rematerialise `ld a,(sym)` at the use instead of a
                              slot store+reload. Opt-in IR_BYTE_REMAT. */
} HomeCtx;
static HomeCtx g_hc = { .de_home = -1, .func_whome = -1 };

/* [IR_BYTE_REMAT] The rematerialising global-load op for byte vreg v, or NULL. */
static const Op *byte_remat_of(const Func *f, int v)
{
    if (!g_hc.byte_remat || v < 0 || v >= f->n_vregs) return NULL;
    return g_hc.byte_remat[v];
}
/* Format the global operand of a byte-remat load into buf as `_sym[+off]`. */
static void byte_remat_symstr(char *buf, size_t n, const Op *o)
{
    const char *pfx = ir_sym_prefix(o->mem.sym), *nm = ir_sym_name(o->mem.sym);
    if (o->mem.offset) snprintf(buf, n, "%s%s+%d", pfx, nm, o->mem.offset);
    else               snprintf(buf, n, "%s%s", pfx, nm);
}

static LowerState L = {
    .rs = { .fa = -1, .i64_acc = -1 },
    .cur_hl_addr_off = -1, .cur_func_uses_params = 1,
    .cur_byte_home_vreg = -1, .cur_func_ehome = -1,
    .cur_home_region_lo = -1, .cur_home_region_hi = -1,
    .cur_home_exit_flush_bb = -1, .pending_spill_v = -1,
    .cur_stack_resident = -1,
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

/* IR_SPILL_STATS (Phase-0 measurement): -1 = not yet probed, else 0/1. */
static int spill_stats_on = -1;
/* IR_EMIT_TRACE (copt-audit): log each HL-bus staging emit with the IR op-kind
   being lowered, mapping copt staging-rule fires back to their gen_* path. */
static int emit_trace_on = -1;
static const Op *lower_cur_op;   /* the op currently being lowered */

/* IR_VERIFY (LRA Phase-0): per-op capture of emitted instruction text so the
   op_clobbers model can be cross-checked against what the emitter actually
   writes. Inert (no codegen change); only active under IR_VERIFY. */
static int  verify_on = -1;
static char verify_buf[8192];
static int  verify_len;

/* IR_CLOB_VERIFY (inert, log-only): flag where an op's emitted code ACTUALLY
   writes a physical reg (per lra_line_writes — the SAME decomposer ir_verify_op
   uses, so no new asm parser) yet the residency cache (rs.hl/de/bc/a) still
   claims the pre-op vreg — i.e. a stale cache the lowering forgot to invalidate.
   Cross-op only (a prior op's belief surviving an op that writes the reg). Reuses
   the IR_VERIFY per-op asm buffering + rs.* snapshot taken at op entry. */
static int  clob_verify_on = -1;
static long clob_verify_count;
static int  clob_snap_hl, clob_snap_de, clob_snap_bc, clob_snap_a;

/* Unified instruction-effects query (P0 Step 2 — decomposer consolidation).
   ONE query every consumer uses (ir_verify_op, IR_CLOB_VERIFY, the re-renderer's
   park sweep, the IR_A_CARRY A-invalidator in vemit), COMPOSING the two
   single-responsibility kernels — lra_line_writes (whole-reg WRITE mask) and
   bc_line_effect (sub-register B/C reads/writes + park/control) — plus the
   value-change refinements. So an asm line is decomposed in one place; the
   kernels are its private implementation. Declared here (above vemit) so the
   A-carry invalidator can query the just-emitted line's effect on A. */
typedef struct {
    RegMask writes;     /* whole-reg writes (lra_line_writes) */
    RegMask self_pres;  /* subset of writes whose VALUE is preserved (`or a`,`and a`) */
    RegMask stepped;    /* subset of writes that are an in-place inc/dec */
    RegMask swapped;    /* subset of writes that are a reg-reg exchange */
    int unknown;
    /* sub-register B/C (the park-liveness sweep needs B and C tracked separately) */
    int b_read, c_read, b_write, c_write;
    int park;           /* the exact `ld bc,hl` low-half stash */
    int is_boundary;    /* ret/reti/retn — BC dead at exit (result ABI is DE:HL) */
    int is_call;        /* jp/jr/djnz/call/rst — a successor may read BC */
} InstrEffects;
static InstrEffects instr_effects(const char *line);

/* Windowed byte A-carry: widen the A-cache carry window (a_cache_carry_safe)
   AND, as its correctness partner, invalidate the A-cache at the vemit chokepoint
   on any emitted line that VALUE-CHANGES A. Invalidate-by-default (Design C): A
   survives only across lines instr_effects PROVES preserve A's value — an
   unrecognised (unknown) or A-writing line drops rs.a. An incomplete recogniser
   therefore loses BYTES, never CORRECTNESS.

   DEFAULT-ON. Opt out with IR_A_CARRY=0 — that reproduces the pre-flip codegen
   byte-for-byte and is the regression-test path.

   ►► REVISIT / TUNE LATER: default-on costs a few bytes on cold sites with a FLAT
   tick delta. Root: caching A holding a pointer low byte flips a `ptr+K` lowering
   from `push de;ld de,K;add hl,de;pop de` (6 B) to an A-based
   `add a,K;ld l,a;ld a,h;adc a,0;ld h,a` (7 B) — +1 B/−16 T per site, a cold-path
   byte-for-tick trade the size push doesn't want. The clean fix (deferred, not
   blocking): gate that A-based +K pointer lowering to fire only when it does NOT
   grow bytes, then this is a pure win. */
static int  a_carry_on = -1;
static int  a_carry_enabled(void)
{
    if (a_carry_on < 0) {
        const char *e = getenv("IR_A_CARRY");
        a_carry_on = (e && e[0] == '0') ? 0 : 1;      /* default ON; IR_A_CARRY=0 opts out */
    }
    return a_carry_on;
}

/* IR_REMAT_LEA: rematerialise &local frame-slot addresses (see the remat table in
   ir_lower_func). Default ON after the gauntlet — full byte matrix 0-regress all 9
   CPUs sp+fp (−747B), ticks 0-slower (interpbench pure win, ez80-fp excluded as a
   byte-for-tick), long_ir + run-matrix green, real files byte-identical. IR_REMAT_LEA=0
   opts out (byte-identical to pre-flip). */
static int  remat_lea_on = -1;
static int  remat_lea_enabled(void)
{
    if (remat_lea_on < 0) {
        const char *e = getenv("IR_REMAT_LEA");
        remat_lea_on = (e && e[0] == '0') ? 0 : 1;    /* default ON; IR_REMAT_LEA=0 opts out */
    }
    return remat_lea_on;
}

/* IR_HL_CARRY (opt-in, WIP): the same invalidate-by-default tracker extended to
   HL and DE — the vehicle for HL/DE operand-residency carry (the #2 size bucket).
   Increment 0 = the inert safety net: rs.hl/rs.de survive across raw emits and are
   dropped only when the emitted line VALUE-CHANGES the reg. Two HL-specific
   guards vs the A tracker: (1) do NOT drop rs.hl while a lazy word spill is
   pending (pending_spill_v>=0) — the hl_about_to_change choke owns HL then and
   flushes before the clobber; (2) do NOT treat `ex de,hl` (swapped) as a clobber —
   the lowerer's swap_hl_de_caches already permutes the beliefs.

   DEFAULT-ON: the full valid-tick-CPU ticks matrix is a PURE WIN — fewer bytes,
   0 byte regressions AND all tick cells faster / 0 slower (it removes reload
   memory traffic, so bytes and ticks drop together). Opt out with IR_HL_CARRY=0 —
   reproduces the pre-flip codegen byte-for-byte (the regression-test path). */
static int  hl_carry_on = -1;
static int  hl_carry_enabled(void)
{
    if (hl_carry_on < 0) {
        const char *e = getenv("IR_HL_CARRY");
        hl_carry_on = (e && e[0] == '0') ? 0 : 1;   /* default ON; IR_HL_CARRY=0 opts out */
    }
    return hl_carry_on;
}

/* The HL/DE tracker may only drop a belief whose value is RECOVERABLE without it
   — i.e. the tenant has a spill slot. Unlike A (always transient, always slot-
   backed), HL/DE can be a NO_SLOT register HOME (PR_HL/PR_DE): there the reg is
   the value's sole home, and this per-LINE tracker cannot see multi-line
   preservation (a `push hl;…;pop hl` reads as a clobber on the `pop`), so dropping
   would STRAND the value (a read with no register and no slot).
   Register homes are the lowerer's to manage precisely; the tracker leaves them
   and only governs RECOVERABLE values transiently resident in HL/DE: those with a
   frame spill slot, OR rematerialisable ones (NO_SLOT symbol-address / LD_SYM whose
   value load_to_* re-derives via `ld hl,_sym`). A plain global VALUE loaded into a
   NO_SLOT non-remat vreg is NOT recoverable (load_to_hl would strand it) → excluded. */
static const Func *cur_lazy_func;   /* fwd; defined below (the func being lowered) */
static int  vreg_is_remat(const Func *f, int vreg);   /* fwd; def in analysis.inc.c */
static int  hlde_belief_droppable(int v)
{
    const Func *f = cur_lazy_func;
    if (!f || v < 0) return 0;
    if (f->vreg_spill_slot && f->vreg_spill_slot[v] >= 0) return 1;
    return vreg_is_remat(f, v);
}
static void clob_verify_report(void)
{
    fprintf(stderr, "IR_CLOB_VERIFY: %ld cross-op stale-cache site(s)\n",
            clob_verify_count);
}

/* IR_EMIT_TRACE: when the lowerer emits an HL-centric-bus staging instruction
   (ex de,hl / DEHL park / HL<->DE copy / push hl;pop de), log the IR op-kind
   being lowered (-> which gen_* path) + source line. Maps each copt staging-rule
   fire back to its emitting lowerer path. Inert unless IR_EMIT_TRACE is set. */
static void emit_trace_check(const char *buf)
{
    static const char *const stg[] = {
        "ex\tde,hl", "ld\tbc,hl", "ld\tde,hl", "ld\td,h", "ld\te,l",
        "push\thl", "pop\tde", "ld\thl,bc", "ld\tl,c", "ld\th,b", 0 };
    for (int i = 0; stg[i]; i++)
        if (strcmp(buf, stg[i]) == 0) {
            char path[256];
            const char *file = lower_unquote(lower_cur_file, path, sizeof path);
            fprintf(stderr, "EMIT_TRACE\t%s\t%s\t%s:%d\n",
                    buf, lower_cur_op ? ir_op_name(lower_cur_op->kind) : "?",
                    file ? file : "?", lower_cur_line);
            return;
        }
}

/* [IR_FRAMEPROBE] Emit-site frame-access accounting. note_slot_use records
   WHICH vreg a slot access belongs to and whether the read is redundant;
   vemit sees the instruction that actually comes out. Counting at the emit
   site is what makes the numbers convertible to bytes — rec_slotuse also
   counts non-emitting slot_off guard calls, so event counts overstate by a
   ratio that varies per function (measured 1.5x-3.6x on binary-trees).

   Byte model for one (ix/iy+d) instruction: 3 bytes (prefix + opcode + disp),
   6 when the other operand is a 16-bit pair (z80asm expands `ld (ix+d),hl`
   and friends into two 3-byte accesses), 4 for an immediate byte store
   (DD 36 d n). Validated against the assembler listing — see the commit. */
static int  fh_cur_v = -1;      /* vreg of the slot access in progress */
static int  fh_cur_red = 0;     /* ...and whether that read was redundant */
static int  fh_nv;              /* bound for the two arrays below */
static int *rec_fh_bytes;       /* bytes of frame access attributed to v */
static int *rec_fh_redbytes;    /* ...of which, on redundant reads */
static int  frameprobe_on(void);

static int frameprobe_line_bytes(const char *b)
{
    if (!strstr(b, "(ix") && !strstr(b, "(iy")) return 0;
    /* 16-bit pair operand -> two accesses */
    if (strstr(b, ",hl") || strstr(b, ",de") || strstr(b, ",bc")
        || strstr(b, "hl,(") || strstr(b, "de,(") || strstr(b, "bc,("))
        return 6;
    /* `ld (ix+d),<imm>` — DD 36 d n */
    const char *c = strstr(b, "),");
    if (c && (c[2] == '-' || (c[2] >= '0' && c[2] <= '9'))) return 4;
    return 3;
}

static void vemit(FILE *out, const char *fmt, va_list ap)
{
    if (spill_stats_on < 0) spill_stats_on = getenv("IR_SPILL_STATS") ? 1 : 0;
    if (verify_on < 0)      verify_on      = getenv("IR_VERIFY") ? 1 : 0;
    if (clob_verify_on < 0) { clob_verify_on = getenv("IR_CLOB_VERIFY") ? 1 : 0;
                              if (clob_verify_on) atexit(clob_verify_report); }
    if (emit_trace_on < 0)  emit_trace_on  = getenv("IR_EMIT_TRACE") ? 1 : 0;
    int acarry = a_carry_enabled();
    int hlcarry = hl_carry_enabled();
    if (spill_stats_on || verify_on || clob_verify_on || emit_trace_on || acarry || hlcarry || frameprobe_on()) {
        /* Fully-expanded instruction text. Buffer only when a probe is on; the
           emitted bytes are unchanged. */
        char buf[256];
        va_list ap2; va_copy(ap2, ap);
        vsnprintf(buf, sizeof buf, fmt, ap2);
        va_end(ap2);
        if (spill_stats_on) {
            if (strstr(buf, "(ix") || strstr(buf, "(iy")) L.spill_ix++;
            if (strstr(buf, "add\thl,sp")) L.spill_sp++;
        }
        if (frameprobe_on() && rec_fh_bytes && fh_cur_v >= 0 && fh_cur_v < fh_nv) {
            int nb = frameprobe_line_bytes(buf);
            if (nb) {
                rec_fh_bytes[fh_cur_v] += nb;
                if (fh_cur_red) rec_fh_redbytes[fh_cur_v] += nb;
            }
        }
        if ((verify_on || clob_verify_on) && verify_len + (int)strlen(buf) + 2 < (int)sizeof verify_buf)
            verify_len += snprintf(verify_buf + verify_len,
                                   sizeof verify_buf - verify_len, "%s\n", buf);
        if (emit_trace_on) emit_trace_check(buf);
        /* IR_A_CARRY partner: invalidate-by-default A tracker. Keep rs.a only if
           this line PROVABLY preserves A's value (recognised AND either does not
           write A or self-preserves it, e.g. `or a`/`and a` flag tests). An
           unknown or A-writing line drops the belief — the sole codegen-affecting
           branch here, gated so gate-off stays byte-identical. cache_a after an
           establishing `ld a,…` re-sets rs.a, so being invalidated on that line
           is harmless. */
        if ((acarry && L.rs.a >= 0) || (hlcarry && (L.rs.hl >= 0 || L.rs.de >= 0))) {
            InstrEffects e = instr_effects(buf);
            if (acarry && L.rs.a >= 0
                && (e.unknown || ((e.writes & IR_R_A) && !(e.self_pres & IR_R_A))))
                L.rs.a = -1;
            if (hlcarry) {
                /* HL: respect the lazy word spill — while a spill is pending the
                   choke owns HL and flushes before the physical clobber, so the
                   belief there is the choke's to manage, not ours. */
                if (L.rs.hl >= 0 && L.pending_spill_v < 0
                    && hlde_belief_droppable(L.rs.hl)
                    && (e.unknown || ((e.writes & IR_R_HL)
                                      && !(e.self_pres & IR_R_HL)
                                      && !(e.swapped & IR_R_HL))))
                    L.rs.hl = -1;
                if (L.rs.de >= 0
                    && hlde_belief_droppable(L.rs.de)
                    && (e.unknown || ((e.writes & IR_R_DE)
                                      && !(e.self_pres & IR_R_DE)
                                      && !(e.swapped & IR_R_DE))))
                    L.rs.de = -1;
            }
        }
    }
    /* Invalidate rs.z_from_a by default: every emitted line clears the claim,
       and the byte-ALU emitter re-asserts it immediately after its own emit.
       The mnemonic cannot be read off `fmt` — the ALU forms pass it as an
       ARGUMENT ("%s%u" with pfx="and\t"), so the format string does not carry
       it. */
    L.rs.z_from_a = 0;
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

/* Word copy HL -> DE, the backend's commonest staging move (7 sites).
   `ld de,hl` is accepted by z80asm on every target and assembles to exactly
   what `ld d,h / ld e,l` does — except on Rabbit 4000/6000, where it is a
   native ONE-byte instruction while the two 8-bit moves are page-prefixed at
   2 bytes EACH. Four bytes to do what one byte does, at every HL->DE staging
   site, is where r4k's whole IR_DS_SHARE byte regression came from.
   Neither form touches flags and D/E do not alias H/L, so this is a pure
   spelling change everywhere else. The copt rules that matched the pair as
   TEXT (#G4, #IR-const/sym-to-DE, #GB6 in lib/80cc_rules.1) were updated to
   match this form, so they keep firing. */
static void emit_hl_to_de(FILE *out)
{
    emit(out, "ld\tde,hl");
}

/* Word copy DE -> HL, the mirror of emit_hl_to_de and the same bargain:
   `ld hl,de` is one byte on Rabbit 4000/6000 against 4 for the two
   page-prefixed 8-bit moves, and assembles to the same 2 bytes as the pair
   everywhere else. The copt rules that matched the pair as TEXT (#GB3, #GB5,
   #GB6, #DE7) were updated with it. */
static void emit_de_to_hl(FILE *out)
{
    emit(out, "ld\thl,de");
}

/* HL <-> BC, same bargain again. The backend already spelled several of these
   `ld bc,hl` / `ld hl,bc`; these two finish the job so no gp-pair copy is left
   as two page-prefixed 8-bit moves on Rabbit. copt rules #285e, #GB1, #GB2 and
   #GB4 matched the pair forms as TEXT and were updated with these. */
static void emit_hl_to_bc(FILE *out)
{
    emit(out, "ld\tbc,hl");
}
static void emit_bc_to_hl(FILE *out)
{
    emit(out, "ld\thl,bc");
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

/* Emit an sp-moving instruction and record the sp delta in one step, so the
   tracked offset can't desync from the emitted push/pop. `sp_delta` is the
   change to cur_sp_adjust (the compensation added to sp-rel slot offsets):
   a push shifts slots +2, a pop -2. Applied AFTER the instruction, mirroring
   the hand-written `emit(...); cur_sp_adjust += 2;` order. A combined
   clobber + sp-move primitive (emit_c_sp: apply_clobbers, then vemit, then the
   sp delta — flush on the pre-move sp) belongs alongside this for the
   pop-with-clobber sites, but lands with that sweep so it isn't dead code. */
static void emit_sp(FILE *out, int sp_delta, const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vemit(out, fmt, ap);
    va_end(ap);
    L.cur_sp_adjust += sp_delta;
}

/* Prefix per-function labels with func_emit_idx so they don't collide
   across functions in the same module (`L_bb_0` would otherwise duplicate). */

static void emit_bb_label(FILE *out, int bb_id)
{
    fprintf(out, "L_f%d_bb_%d:\n", L.func_emit_idx, bb_id);
}

/* Copy a rendered function from `rout` to `out`, dropping dead BB-label
   definitions — an `L_fN_bb_M:` line no jump / defc / switch-table operand
   names. Correct by construction (a label with zero textual references is
   unreachable by name); also lets copt peepholes match across the former label
   boundary. Only exact `L_f<d>_bb_<d>:` lines are candidates; other labels
   (func entry `._name`, `_shl_loop_`, defc aliases) pass through untouched.
   `max_bb` bounds the reference bitset. */
/* Rewrite a `\tjp\t[cc,]L_f<idx>_bb_<n>` line's target number in place per thr[]
   (jump threading). Only touches unconditional/conditional `jp` lines; the label
   prefix `L_f<idx>_bb_` and any condition/comment are preserved. */
static void thread_jp_line(FILE *out, const char *line, const int *thr, int max_bb)
{
    if (strncmp(line, "\tjp\t", 4) != 0) { fputs(line, out); return; }
    char *p = strstr(line, "_bb_");
    if (!p || p[4] < '0' || p[4] > '9') { fputs(line, out); return; }
    int n = 0; const char *q = p + 4;
    while (*q >= '0' && *q <= '9') n = n * 10 + (*q++ - '0');
    if (n > max_bb || thr[n] < 0 || thr[n] == n) { fputs(line, out); return; }
    fwrite(line, 1, (size_t)(p + 4 - line), out);   /* up to and incl `_bb_` */
    fprintf(out, "%d", thr[n]);                      /* threaded target */
    fputs(q, out);                                   /* rest (`:`... no — operand tail/comment) */
}

/* Is `s` a line that may legitimately sit between a dead register copy and the
   reload that kills it — a label def, blank, comment, or C_LINE marker — none
   of which read/write HL or DE? (An instruction, or any other directive, stops
   the lookahead.) A label is fine: it only adds arrival edges, all of which run
   the same following reload before touching the pair. */
static int hlde_skippable_between(const char *s)
{
    if (s[0] == '\n' || s[0] == '\r' || s[0] == ';') return 1;
    if (strncmp(s, "\tC_LINE", 7) == 0) return 1;
    if (s[0] != '\t' && s[0] != ' ') {           /* label def `NAME:` */
        const char *c = strchr(s, ':');
        if (c && (c[1] == '\n' || c[1] == '\r' || c[1] == '\0')) return 1;
    }
    return 0;
}

/* Does `s` UNCONDITIONALLY overwrite the whole `hl`/`de` pair without reading
   it — `ld <pair>,<x>` (x not (hl)) or `pop <pair>`? Then a preceding one-way
   copy into that pair is dead. */
static int hlde_full_reload(const char *s, const char *pair)
{
    char pat[12];
    snprintf(pat, sizeof pat, "\tld\t%s,", pair);
    if (strncmp(s, pat, strlen(pat)) == 0 && !strstr(s, "(hl")) return 1;
    snprintf(pat, sizeof pat, "\tpop\t%s", pair);
    if (strncmp(s, pat, strlen(pat)) == 0) return 1;
    return 0;
}

/* ---- branch relaxation: `jp` -> `jr` for in-range local targets ---------- */
/* 80cc renders every CFG branch as a 3-byte `jp` because the displacement is
   unknown at render time, and NOTHING downstream recovers it: copt has no
   addresses, and z80asm only ever WIDENS (`-opt-speed` turns `jr` into `jp`;
   an out-of-range `jr` is a hard "integer range" error, never auto-widened).
   So every in-range branch costs a byte. This pass converts them, using an
   UPPER BOUND on the span: an exact size model is impossible to maintain
   (z88dk synthetics differ per CPU — `ld hl,(ix+d)` is synthetic on z80 but
   native on ez80/kc160/rabbit — and r4k moves much of the main page behind a
   0x7f prefix), but an upper bound only ever costs us a conversion, never
   correctness. Getting it wrong is a LOUD assembler error, not a miscompile.

   The bound is one table with no per-CPU branches: each entry is the worst
   case over ALL targets, validated against real z80asm listings on
   z80/z80n/z180/ez80/gbz80/rabbit/r4k/kc160. `call` is charged 8 rather than 3
   because copt runs AFTER us and its only code-GROWING rules are call
   substitutions (`z80rules.9`'s intrinsic inlining, the per-CPU `l_gint`/
   `l_pint`/`l_long_aslo` helper inlining) — charging every call its worst case
   makes the bound valid post-copt without modelling copt at all.

   Ticks: `jr cc` is 12 T taken / 7 T not-taken vs `jp cc`'s flat 10 T, and an
   unconditional `jr` is a flat +2 T. So the ONLY conversion that cannot pay for
   itself is one that is always taken — and inside a loop that is exactly the
   unconditional jump. Excluding those (and only those) is what makes this a win
   on both axes; on z80 it takes the aggregate from −0.167 % to −0.458 % ticks
   and cuts the slower cells from 10 to 4 (worst +0.18 %), for roughly half the
   bytes. Two structural proxies were tried and REFUTED first — do not retry:
     - forward-only (skip back edges): 13 slower cells instead of 15. A taken
       FORWARD guard costs the same +2 T, so direction is not taken-ness.
     - skip everything at max loop depth: no tick change at all (the hot branch
       in a nested loop sits at depth 1, not max); and skipping every in-loop
       branch leaves just −8 B corpus-wide — the bytes ARE in the loops, so
       there is no free lunch to be had by excluding loops wholesale.

   DEFAULT-ON; `IR_JR=0` opts out (byte-identical to the pre-relaxation
   compiler). Regression: test/suites/long_ir/jrelax.c. */
static int relax_uc = -1;
static int relax_uncond_ok(void)     /* IR_JR_UNCOND=1: allow uncond-in-loop */
{
    if (relax_uc < 0) {
        const char *e = getenv("IR_JR_UNCOND");
        relax_uc = (e && e[0] == '1');
    }
    return relax_uc;
}

static int relax_on = -1;
static int branch_relax_enabled(void)
{
    if (relax_on < 0) {
        /* 8080/8085 have no `jr` at all. Every other supported CPU has both the
           unconditional form and the nz/z/nc/c conditionals. */
        const char *e = getenv("IR_JR");
        relax_on = (e && e[0] == '0') ? 0 : !IS_808x();
    }
    return relax_on;
}

/* Upper bound, in bytes, on what `l` assembles to on ANY target. Data
   directives return a blocker so no branch is measured across a table. */
static int relax_line_size(const char *l)
{
    const char *s = l;
    while (*s == '\t' || *s == ' ') s++;
    if (*s == '\0' || *s == '\n' || *s == '\r' || *s == ';') return 0;
    if (s == l) return 0;                       /* col-0: label def / defc */
    /* Assembler directives emit nothing (EXTERN/GLOBAL/defc/C_LINE/...) except
       the data ones, which we refuse to measure across. */
    if (!strncmp(s, "def", 3)) {
        if (!strncmp(s, "defc", 4)) return 0;
        return 4096;                            /* defb/defw/defm/defs: blocker */
    }
    if (!strncmp(s, "EXTERN", 6) || !strncmp(s, "GLOBAL", 6)
        || !strncmp(s, "PUBLIC", 6) || !strncmp(s, "C_LINE", 6)
        || !strncmp(s, "SECTION", 7) || !strncmp(s, "MODULE", 6)
        || !strncmp(s, "INCLUDE", 7))
        return 0;
    /* Mnemonic. */
    const char *e = s;
    while (*e && *e != '\t' && *e != ' ' && *e != '\n') e++;
    size_t n = (size_t)(e - s);
    const char *arg = e;
    while (*arg == '\t' || *arg == ' ') arg++;
    #define MN(x) (n == strlen(x) && !strncmp(s, x, n))
    /* Index-register addressing: 6 (the z80 synthetic `ld rr,(ix+d)` pair). */
    if (strstr(arg, "(ix") || strstr(arg, "(iy")) return 6;
    /* Rabbit's 16-bit logical ops expand to 8. */
    if ((MN("or") || MN("and") || MN("xor") || MN("bool"))
        && (!strncmp(arg, "hl", 2))) return 8;
    /* A 16-bit load from MEMORY is up to 6 (gbz80 has no `ld hl,(nn)` and the
       arch rules expand it; ez80's `ld hl,(hl)` is 6). A plain `ld rr,imm` is
       <= 4 everywhere (worst: z80n `ld ix,0`), so don't over-charge it. */
    if (MN("ld") && strchr(arg, '(') != NULL) return 6;
    /* `add hl,rr` is 1, but `add hl,<imm>` is a z80n synthetic at up to 6. */
    if (MN("add") && !strncmp(arg, "hl,", 3)) {
        const char *o = arg + 3;
        if (strncmp(o, "de", 2) && strncmp(o, "bc", 2) && strncmp(o, "hl", 2)
            && strncmp(o, "sp", 2))
            return 6;
        return 4;
    }
    /* copt may inline a call (see the header comment): charge its worst case. */
    if (MN("call")) return 8;
    /* Everything else in the emitted repertoire is <= 4 on every target; an
       unrecognised mnemonic is charged 8 so a future lowering cannot silently
       invalidate the bound. */
    if (MN("ld") || MN("jp") || MN("jr") || MN("djnz") || MN("push")
        || MN("pop") || MN("inc") || MN("dec") || MN("add") || MN("adc")
        || MN("sub") || MN("sbc") || MN("and") || MN("or") || MN("xor")
        || MN("cp") || MN("ex") || MN("exx") || MN("ret") || MN("reti")
        || MN("retn") || MN("nop") || MN("halt") || MN("di") || MN("ei")
        || MN("neg") || MN("cpl") || MN("scf") || MN("ccf") || MN("rst")
        || MN("im") || MN("rlca") || MN("rrca") || MN("rla") || MN("rra")
        || MN("sla") || MN("sra") || MN("srl") || MN("rl") || MN("rr")
        || MN("rlc") || MN("rrc") || MN("bit") || MN("set") || MN("res")
        || MN("in") || MN("out") || MN("lea") || MN("mlt") || MN("bool")
        || MN("ldi") || MN("ldir") || MN("ldd") || MN("lddr") || MN("swap")
        || MN("daa") || MN("slp"))
        return 4;
    #undef MN
    return 8;
}

/* A label DEFINITION line (`L_f1_bb_3:` at column 0). `defc` aliases are NOT
   definitions at this position — they name a label that lives elsewhere — and
   are excluded by the column-0 identifier test below. */
static int relax_label_name(const char *l, char *buf, size_t bufsz)
{
    if (l[0] == '\t' || l[0] == ' ' || l[0] == ';' || l[0] == '\n') return 0;
    if (!((l[0] >= 'A' && l[0] <= 'Z') || (l[0] >= 'a' && l[0] <= 'z')
          || l[0] == '_')) return 0;
    const char *c = strchr(l, ':');
    if (!c) return 0;
    const char *t = c + 1;
    while (*t == '\r') t++;
    if (*t != '\n' && *t != '\0') return 0;      /* `L:` must end the line */
    size_t n = (size_t)(c - l);
    if (n == 0 || n >= bufsz) return 0;
    memcpy(buf, l, n); buf[n] = '\0';
    return 1;
}

/* `\tjp\t[cc,]TARGET\n` -> condition (or "" when unconditional) + target, but
   only for conditions that HAVE a `jr` form (nz/z/nc/c — po/pe/p/m do not). */
static int relax_jp_parts(const char *l, char *cc, size_t ccsz,
                          char *tgt, size_t tgtsz)
{
    if (strncmp(l, "\tjp\t", 4) != 0) return 0;
    const char *p = l + 4;
    const char *comma = strchr(p, ',');
    cc[0] = '\0';
    if (comma) {
        size_t n = (size_t)(comma - p);
        if (n >= ccsz) return 0;
        memcpy(cc, p, n); cc[n] = '\0';
        if (strcmp(cc, "nz") && strcmp(cc, "z") && strcmp(cc, "nc")
            && strcmp(cc, "c"))
            return 0;                            /* po/pe/p/m: no jr form */
        p = comma + 1;
    }
    size_t i = 0;
    while (p[i] && p[i] != '\n' && p[i] != '\r' && p[i] != '\t'
           && p[i] != ' ' && p[i] != ';') {
        if (i + 1 >= tgtsz) return 0;
        tgt[i] = p[i]; i++;
    }
    if (i == 0) return 0;
    tgt[i] = '\0';
    /* Anything trailing other than a comment means we don't understand it. */
    while (p[i] == ' ' || p[i] == '\t') i++;
    if (p[i] != '\n' && p[i] != '\0' && p[i] != '\r' && p[i] != ';') return 0;
    return 1;
}

/* copt's #JI inverts `jp cc,L / jp M / L:` into `jp !cc,M / L:` (-3b). It needs
   BOTH jumps to still be `jp`, and -3b beats the -2b we would get by relaxing
   the pair, so leave that window alone and let copt have it. Returns 1 when
   line `i` is either jump of such a window. (The `jr`-conditional variants of
   #JI in 80cc_rules.1 still need their second line to be `jp`, so the test
   covers a relaxed conditional too.) */
static int relax_in_ji_window(char **lines, int n, int i)
{
    for (int base = (i > 0 ? i - 1 : 0); base <= i && base + 1 < n; base++) {
        const char *a = lines[base], *b = lines[base + 1];
        int a_cond = (!strncmp(a, "\tjp\t", 4) || !strncmp(a, "\tjr\t", 4))
                     && strchr(a, ',');
        if (!a_cond) continue;
        if (strncmp(b, "\tjp\t", 4) != 0 || strchr(b, ',')) continue;
        /* the conditional's target must be the label that follows the pair */
        char tgt[256], lbl[256];
        const char *p = strchr(a, ',');
        if (!p) continue;
        size_t k = 0;
        p++;
        while (p[k] && p[k] != '\n' && p[k] != '\r' && p[k] != '\t'
               && p[k] != ' ' && p[k] != ';' && k + 1 < sizeof tgt) {
            tgt[k] = p[k]; k++;
        }
        tgt[k] = '\0';
        if (k == 0) continue;
        int j = base + 2;
        while (j < n && (lines[j][0] == '\n' || lines[j][0] == ';'
                         || !strncmp(lines[j], "\tC_LINE", 7))) j++;
        if (j < n && relax_label_name(lines[j], lbl, sizeof lbl)
            && !strcmp(lbl, tgt))
            return 1;
    }
    return 0;
}

/* Per-BB loop-nesting depth, the same cheap back-edge-span approximation the
   selection code in this file already uses (`bdep`): count the [target..source]
   spans of back edges containing each BB. Ranking only — never correctness. */
static int *relax_bb_depth(const Func *f, int *out_max)
{
    *out_max = 0;
    if (!f || f->n_bbs <= 0) return NULL;
    int *d = calloc((size_t)f->n_bbs, sizeof(int));
    if (!d) return NULL;
    for (int i = 0; i < f->n_bbs; i++)
        for (int s = 0; s < ir_bb_n_succ(&f->bbs[i]); s++) {
            int t = ir_bb_succ_at(&f->bbs[i], s);
            if (t < 0 || t > i) continue;                 /* back-edge: t <= i */
            for (int b = t; b <= i && b < f->n_bbs; b++) d[b]++;
        }
    for (int i = 0; i < f->n_bbs; i++) if (d[i] > *out_max) *out_max = d[i];
    return d;
}

/* `L_f<idx>_bb_<n>:` -> n, else -1. */
static int relax_bb_of_label(const char *l)
{
    if (l[0] != 'L') return -1;
    const char *p = strstr(l, "_bb_");
    if (!p || p[4] < '0' || p[4] > '9') return -1;
    int n = 0; const char *q = p + 4;
    while (*q >= '0' && *q <= '9') n = n * 10 + (*q++ - '0');
    return (*q == ':') ? n : -1;
}

static void filter_relax_branches(FILE *out, FILE *src, const Func *f)
{
    char buf[1024];
    char **lines = NULL; int n = 0, cap = 0;
    while (fgets(buf, sizeof buf, src)) {
        if (n == cap) { cap = cap ? cap * 2 : 256;
            char **nl = realloc(lines, (size_t)cap * sizeof *lines);
            if (!nl) { free(lines); rewind(src);            /* OOM: verbatim */
                while (fgets(buf, sizeof buf, src)) fputs(buf, out); return; }
            lines = nl; }
        lines[n++] = strdup(buf);
        if (!lines[n - 1]) { for (int i = 0; i < n - 1; i++) free(lines[i]);
            free(lines); rewind(src);
            while (fgets(buf, sizeof buf, src)) fputs(buf, out); return; }
    }
    int *size = malloc((size_t)(n > 0 ? n : 1) * sizeof(int));
    /* Innermost-loop exclusion. A branch in the hottest loop is taken on nearly
       every iteration, where `jr` costs +2 T over `jp` with no not-taken saving
       to offset it — that is where the whole measured tick cost lives (5 benches,
       one dominant loop each). Loop DEPTH is the usable proxy: unlike branch
       direction (tried, refuted — a taken forward guard costs the same), depth
       actually tracks iteration count. Attribute each line to the BB label above
       it and skip conversion at max depth. Ranking only: skipping merely forgoes
       bytes. */
    int maxdep = 0;
    int *bdep = relax_bb_depth(f, &maxdep);
    int *linedep = (bdep && n > 0) ? calloc((size_t)n, sizeof(int)) : NULL;
    if (linedep) {
        int cur = 0;                                 /* prologue: depth 0 */
        for (int i = 0; i < n; i++) {
            int b = relax_bb_of_label(lines[i]);
            /* An elided (dead) BB label leaves its lines attributed to the
               preceding BB — it fell through from there, so same loop. */
            if (b >= 0 && b < f->n_bbs) cur = bdep[b];
            linedep[i] = cur;
        }
    }
    if (getenv("IR_JR_LOG"))
        fprintf(stderr, "IR_JR: fn=%s n_bbs=%d maxdep=%d bdep=%s linedep=%s\n",
                (f && f->fn) ? ir_sym_name(f->fn) : "?", f ? f->n_bbs : -1,
                maxdep, bdep ? "y" : "n", linedep ? "y" : "n");
    if (size) {
        for (int i = 0; i < n; i++) size[i] = relax_line_size(lines[i]);
        /* Converting shrinks the span, which can bring further branches into
           range, so iterate to a fixpoint (bounded — each round converts at
           least one line or stops). */
        for (int round = 0; round < 4; round++) {
            int changed = 0;
            for (int i = 0; i < n; i++) {
                char cc[8], tgt[256], lbl[256];
                if (!relax_jp_parts(lines[i], cc, sizeof cc, tgt, sizeof tgt))
                    continue;
                if (relax_in_ji_window(lines, n, i)) continue;
                /* Never relax an UNCONDITIONAL jump inside a loop: it is
                   taken every iteration, so `jr` is a flat +2 T with nothing to
                   pay for it, whereas a CONDITIONAL at the same spot still wins
                   whenever it falls through (7 T vs `jp cc`'s flat 10 T). This
                   one rule is what turns the tick picture around — see the
                   header comment. `IR_JR_UNCOND=1` opts out (byte-max variant).
                */
                if (!cc[0] && linedep && linedep[i] >= 1 && !relax_uncond_ok())
                    continue;
                int t = -1;
                for (int j = 0; j < n; j++)
                    if (relax_label_name(lines[j], lbl, sizeof lbl)
                        && !strcmp(lbl, tgt)) { t = j; break; }
                if (t < 0) continue;             /* not a local label */
                /* Span EXCLUDES the branch itself; `jr` measures from the byte
                   after its 2-byte encoding, so both directions fit when the
                   in-between bytes are <= 126. */
                int lo = (t > i) ? i + 1 : t, hi = (t > i) ? t : i;
                long span = 0;
                for (int k = lo; k < hi && span <= 126; k++) span += size[k];
                if (span > 126) continue;
                char nl2[1024];
                if (cc[0]) snprintf(nl2, sizeof nl2, "\tjr\t%s,%s\n", cc, tgt);
                else       snprintf(nl2, sizeof nl2, "\tjr\t%s\n", tgt);
                char *rep = strdup(nl2);
                if (!rep) continue;
                free(lines[i]); lines[i] = rep;
                size[i] = 2;
                changed = 1;
            }
            if (!changed) break;
        }
    }
    for (int i = 0; i < n; i++) { fputs(lines[i], out); free(lines[i]); }
    free(lines); free(size); free(bdep); free(linedep);
}

/* Post-render peephole: drop a dead one-way register copy `ld hl,de` (HL:=DE)
   or `ld de,hl` (DE:=HL) when the destination pair is FULLY reloaded before any
   use — the next real instruction (skipping labels / blank / comment / C_LINE
   lines) overwrites the whole pair without reading it.

   The two-line spellings `ld h,d; ld l,e` / `ld d,h; ld e,l` are still matched:
   this filter runs on rendered text, and it is cheaper to keep both forms here
   than to require that every producer of a copy has been converted. THIS IS THE
   THIRD CONSUMER of that text — the emitters, the copt rules in
   lib/80cc_rules.1, and this. Changing how a copy is spelled means changing all
   three together, or a fold silently stops firing: respelling the copy without
   this hunk cost gbz80 79 bytes, entirely from copies that used to die here.
   The reload is then the first pair-touching instruction on EVERY path leaving
   the copy, so the copy is dead. Sound on all CPUs; in practice only gbz80
   emits the one-way form (z80 recovers via `ex de,hl`), where the copy is a
   2-byte waste. Sees across a LIVE label — which copt's fixed 3-line window
   (#GB2/#GB3) cannot. Reads `src` fully into memory (one function's asm) so the
   lookahead is a simple index scan. */
static void filter_dead_reg_copies(FILE *out, FILE *src)
{
    char buf[1024];
    char **lines = NULL; int n = 0, cap = 0;
    while (fgets(buf, sizeof buf, src)) {
        if (n == cap) { cap = cap ? cap * 2 : 256;
            char **nl = realloc(lines, (size_t)cap * sizeof *lines);
            if (!nl) { free(lines); rewind(src);            /* OOM: verbatim */
                while (fgets(buf, sizeof buf, src)) fputs(buf, out); return; }
            lines = nl; }
        lines[n++] = strdup(buf);
        if (!lines[n - 1]) { for (int i = 0; i < n - 1; i++) free(lines[i]);
            free(lines); rewind(src);
            while (fgets(buf, sizeof buf, src)) fputs(buf, out); return; }
    }
    char *drop = calloc((size_t)(n > 0 ? n : 1), 1);
    if (drop) {
        for (int i = 0; i < n; i++) {
            const char *pair; int len;
            if (strcmp(lines[i], "\tld\thl,de\n") == 0)      { pair = "hl"; len = 1; }
            else if (strcmp(lines[i], "\tld\tde,hl\n") == 0) { pair = "de"; len = 1; }
            else if (i + 1 < n && strcmp(lines[i], "\tld\th,d\n") == 0
                     && strcmp(lines[i + 1], "\tld\tl,e\n") == 0) { pair = "hl"; len = 2; }
            else if (i + 1 < n && strcmp(lines[i], "\tld\td,h\n") == 0
                     && strcmp(lines[i + 1], "\tld\te,l\n") == 0) { pair = "de"; len = 2; }
            else continue;
            int j = i + len;
            while (j < n && hlde_skippable_between(lines[j])) j++;
            if (j < n && hlde_full_reload(lines[j], pair)) {
                for (int k = 0; k < len; k++) drop[i + k] = 1;
                i += len - 1;                        /* consume the copy */
            }
        }
    }
    for (int i = 0; i < n; i++) {
        if (!drop || !drop[i]) fputs(lines[i], out);
        free(lines[i]);
    }
    free(lines); free(drop);
}

/* ---- bc-live: drop dead DE:BC parks (`ld bc,hl`) ------------------------- */
/* A width-4 low-half park has NO cross-BB carry (the DEHL cache is invalidated
   at every BB boundary — ir_lower_analysis.inc.c), so its only consumer is an
   in-BB `ld hl,bc` recovery (or a byte read of B/C). BC-liveness is therefore
   STRAIGHT-LINE: a `ld bc,hl` is dead iff, from its point down to the next
   unconditional control transfer, nothing reads B or C before BC is fully
   rewritten. A backward single-register liveness scan over the emitted stream
   removes the dead ones — cleaner than a forward regcache flag (which cannot see
   past the next op) and beyond copt's fixed-window reach (variable-length scan).
   Discipline: reads OVER-estimated, writes UNDER-estimated (only exact full-kill
   forms), so a mis-classified line only leaves a park un-dropped, never drops a
   live one. Default-on; `--opt-disable=bc-live` opts out. */
static int bc_ident_ch(char c)
{
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
        || (c >= '0' && c <= '9') || c == '_';
}

/* Does operand text `ops` mention `reg` (\"b\"/\"c\"/\"bc\") as a standalone
   register token (not inside a symbol/hex, not a substring of another reg)? */
static int bc_tok(const char *ops, const char *reg)
{
    if (!ops) return 0;
    size_t rl = strlen(reg);
    for (const char *p = ops; *p; p++) {
        if (strncmp(p, reg, rl) != 0) continue;
        char before = (p == ops) ? ',' : p[-1];
        char after  = p[rl];
        if (!bc_ident_ch(before) && !bc_ident_ch(after)) return 1;
    }
    return 0;
}

/* Backward BC-liveness sweep: delete every dead `ld bc,hl` park. */
static void filter_dead_bc_parks(FILE *out, FILE *src)
{
    char buf[1024];
    char **lines = NULL; int n = 0, cap = 0;
    while (fgets(buf, sizeof buf, src)) {
        if (n == cap) { cap = cap ? cap * 2 : 256;
            char **nl = realloc(lines, (size_t)cap * sizeof *lines);
            if (!nl) { free(lines); rewind(src);
                while (fgets(buf, sizeof buf, src)) fputs(buf, out);
                return; }
            lines = nl; }
        lines[n++] = strdup(buf);
        if (!lines[n - 1]) { for (int i = 0; i < n - 1; i++) free(lines[i]);
            free(lines); rewind(src);
            while (fgets(buf, sizeof buf, src)) fputs(buf, out);
            return; }
    }
    char *drop = calloc((size_t)(n > 0 ? n : 1), 1);
    if (drop) {
        /* Forward pre-pass: collapse a park's redundant HL recover. Right after
           `ld bc,hl` (BC=HL), an adjacent `ld hl,bc` is a no-op (HL already
           holds the value) — this is copt #285c, but doing it here first lets
           the liveness scan below see past the recover, so a park whose ONLY
           BC reader was that recover becomes droppable in this same pass (else
           copt removes the recover only AFTER the scan has run, orphaning the
           now-dead park). Dropping the recover is always safe: HL is unchanged. */
        for (int i = 0; i + 1 < n; i++)
            if (strcmp(lines[i], "\tld\tbc,hl\n") == 0
                && strcmp(lines[i + 1], "\tld\thl,bc\n") == 0)
                drop[i + 1] = 1;
        int b_live = 0, c_live = 0;
        for (int i = n - 1; i >= 0; i--) {
            if (drop[i]) continue;                 /* collapsed recover: gone */
            InstrEffects e = instr_effects(lines[i]);   /* single query (composes bc_line_effect) */
            int rb = e.b_read, rc = e.c_read, wb = e.b_write, wc = e.c_write;
            int park = e.park, boundary = e.is_boundary, call = e.is_call;
            /* `ret` (boundary): BC is dead at exit (long result ABI is DE:HL),
               so a park before it is droppable. A branch/call (`call`): BC may
               be read by a successor — treat as LIVE so only a park overwritten
               by straight-line code before the next branch is dropped. */
            if (boundary) { b_live = c_live = 0; continue; }
            if (call)     { b_live = c_live = 1; continue; }
            if (park) {
                if (!b_live && !c_live) drop[i] = 1;
                b_live = c_live = 0;               /* park defines BC */
                continue;
            }
            b_live = rb ? 1 : (wb ? 0 : b_live);
            c_live = rc ? 1 : (wc ? 0 : c_live);
        }
    }
    for (int i = 0; i < n; i++) {
        if (!drop || !drop[i]) fputs(lines[i], out);
        free(lines[i]);
    }
    free(lines); free(drop);
}

static void emit_dropping_dead_bb_labels(FILE *out, FILE *rout, int max_bb,
                                         const Func *f)
{
    char line[1024];
    char *ref = (max_bb >= 0) ? calloc((size_t)max_bb + 1, 1) : NULL;
    int *thr = (max_bb >= 0) ? malloc(((size_t)max_bb + 1) * sizeof(int)) : NULL;
    if (!ref || !thr) {                          /* OOM: copy verbatim */
        free(ref); free(thr);
        rewind(rout);
        while (fgets(line, sizeof line, rout)) fputs(line, out);
        return;
    }
    /* Branch relaxation runs LAST: threading, dead-label elision and the
       peepholes below all change the span a `jr` has to reach, so measuring
       before them would be measuring the wrong function. `fout` is the real
       destination for everything downstream of here. */
    FILE *relax = branch_relax_enabled() ? tmpfile() : NULL;
    FILE *fout = relax ? relax : out;
    for (int i = 0; i <= max_bb; i++) thr[i] = -1;
    /* Pass 0: jump-threading map. A run of one or more bare labels
       `L_f..._bb_<n>:` whose first following instruction is an UNCONDITIONAL
       `jp L_f..._bb_<m>` (no `,`) are jp-only trampolines: thread every n->m.
       Operand rewrite only — the trampoline body stays (its fall-through
       predecessors still need it), so this is sound even when a label is reached
       by fall-through (unlike a defc alias). No-op directive/blank/comment lines
       between the labels and the `jp` are skipped (C_LINE markers etc.). */
    rewind(rout);
    int pend[64], npend = 0;
    while (fgets(line, sizeof line, rout)) {
        if (strncmp(line, "\tC_LINE", 7) == 0 || line[0] == '\n'
            || line[0] == '\r' || line[0] == ';')
            continue;
        if (line[0] == 'L') {                     /* a bb label def? keep collecting */
            char *p = strstr(line, "_bb_");
            if (p && p[4] >= '0' && p[4] <= '9') {
                int n = 0; char *q = p + 4;
                while (*q >= '0' && *q <= '9') n = n * 10 + (*q++ - '0');
                if (*q == ':' && (q[1] == '\n' || q[1] == '\0') && n <= max_bb
                    && npend < 64)
                    pend[npend++] = n;
            }
            continue;
        }
        /* first real instruction after the label run */
        if (npend > 0 && strncmp(line, "\tjp\t", 4) == 0 && !strchr(line, ',')) {
            char *p = strstr(line, "_bb_");
            if (p && p[4] >= '0' && p[4] <= '9') {
                int m = 0; char *q = p + 4;
                while (*q >= '0' && *q <= '9') m = m * 10 + (*q++ - '0');
                for (int k = 0; k < npend; k++) thr[pend[k]] = m;
            }
        }
        npend = 0;
    }
    /* Also fold defc bb-aliases (`defc L_f<idx>_bb_<X> = L_f<idx>_bb_<Y>`) into the
       threading map. The defc makes L_X and L_Y the SAME address, so rewriting a
       `jp [cc,]L_X` operand to L_Y is binary-identical — but it exposes the real
       target to copt, surfacing more jump-over-next-label inversions (#JI) and
       cross-label peepholes that the alias would otherwise hide. Only when X has no
       trampoline thread already. */
    rewind(rout);
    while (fgets(line, sizeof line, rout)) {
        if (strncmp(line, "defc L_f", 8) != 0) continue;
        char *lp = strstr(line, "_bb_");
        if (!lp || lp[4] < '0' || lp[4] > '9') continue;
        int X = 0; char *q = lp + 4;
        while (*q >= '0' && *q <= '9') X = X * 10 + (*q++ - '0');
        char *eq = strchr(q, '=');
        if (!eq) continue;
        char *rp = strstr(eq, "_bb_");
        if (!rp || rp[4] < '0' || rp[4] > '9') continue;
        int Y = 0; q = rp + 4;
        while (*q >= '0' && *q <= '9') Y = Y * 10 + (*q++ - '0');
        if (X >= 0 && X <= max_bb && Y >= 0 && Y <= max_bb && X != Y
            && thr[X] < 0)
            thr[X] = Y;
    }
    for (int i = 0; i <= max_bb; i++) {           /* resolve transitively */
        int t = thr[i], hops = 0;
        while (t >= 0 && t <= max_bb && thr[t] >= 0 && thr[t] != t
               && hops <= max_bb) { t = thr[t]; hops++; }
        if (hops > max_bb) thr[i] = -1;           /* cycle → don't thread */
        else if (t >= 0) thr[i] = t;
    }
    /* Pass 1: mark every BB number that appears as a REFERENCE — using the
       THREADED target for jp operands, since pass 2 rewrites them. */
    rewind(rout);
    while (fgets(line, sizeof line, rout)) {
        int is_jp = (strncmp(line, "\tjp\t", 4) == 0);
        int is_defc = (strncmp(line, "defc L_f", 8) == 0);
        for (char *p = strstr(line, "_bb_"); p; p = strstr(p, "_bb_")) {
            char *q = p + 4;
            if (*q < '0' || *q > '9') { p = q; continue; }
            int n = 0;
            while (*q >= '0' && *q <= '9') n = n * 10 + (*q++ - '0');
            int own_def = (line[0] == 'L' && *q == ':' && p == strstr(line, "_bb_"));
            /* The LHS of `defc L_X = L_Y` DEFINES alias X (like a label def), not
               a reference — otherwise X always looks referenced and its now-dead
               alias (every `jp L_X` threaded to L_Y) can never be dropped. */
            int alias_def = (is_defc && p == strstr(line, "_bb_"));
            if (!own_def && !alias_def && n <= max_bb) {
                int tgt = (is_jp && thr[n] >= 0) ? thr[n] : n;
                if (tgt <= max_bb) ref[tgt] = 1;
            }
            p = q;
        }
    }
    /* Pass 2/3 write to `dst`; when a final peephole (dead-reg-copy and/or the
       bc-live park sweep) is enabled dst is a scratch temp filtered into `out`,
       else dst == out. */
    int do_regcopy = !opt_disabled("dead-regcopy");
    int do_bc_live = !opt_disabled("bc-live");
    FILE *peep = (do_regcopy || do_bc_live) ? tmpfile() : NULL;
    FILE *dst = peep ? peep : fout;
    /* Pass 2: emit, dropping `L_f<d>_bb_<n>:` lines whose n is unreferenced, and
       DEFERRING `defc L_f..._bb_...` alias lines. The defc's are 0-byte symbol
       definitions emitted inline at the alias BBs' layout slots; moving them out
       of the instruction stream makes the real (defc-are-nothing) adjacency
       visible to copt without changing the binary. */
    rewind(rout);
    while (fgets(line, sizeof line, rout)) {
        if (strncmp(line, "defc L_f", 8) == 0) continue;   /* defer to pass 3 */
        if (line[0] == 'L') {
            char *p = strstr(line, "_bb_");
            if (p) {
                char *q = p + 4;
                int has = (*q >= '0' && *q <= '9'), n = 0;
                while (*q >= '0' && *q <= '9') n = n * 10 + (*q++ - '0');
                if (has && *q == ':' && (q[1] == '\n' || q[1] == '\0')
                    && (n > max_bb || !ref[n]))
                    continue;                    /* drop dead label */
            }
        }
        thread_jp_line(dst, line, thr, max_bb);  /* rewrites jp targets; else fputs */
    }
    /* Pass 3: the deferred alias defc's, at the end of the function — but only
       those still referenced. Threading rewrote every `jp [cc,]L_X` to its real
       target, so an alias whose X is now unreferenced (ref[X]==0) is dead output.
       A still-referenced X (e.g. a switch-table `defw L_X`, or a reference the
       threading pass did not rewrite) keeps its alias so the symbol resolves. */
    rewind(rout);
    while (fgets(line, sizeof line, rout)) {
        if (strncmp(line, "defc L_f", 8) != 0) continue;
        char *p = strstr(line, "_bb_");
        if (p && p[4] >= '0' && p[4] <= '9') {
            int n = 0; char *q = p + 4;
            while (*q >= '0' && *q <= '9') n = n * 10 + (*q++ - '0');
            if (n <= max_bb && !ref[n]) continue;   /* orphaned alias → drop */
        }
        fputs(line, dst);
    }
    if (peep) {
        rewind(peep);
        if (do_regcopy && do_bc_live) {
            FILE *scratch = tmpfile();
            if (scratch) {
                filter_dead_reg_copies(scratch, peep);
                rewind(scratch);
                filter_dead_bc_parks(fout, scratch);
                fclose(scratch);
            } else {
                filter_dead_reg_copies(fout, peep);  /* OOM: skip bc stage */
            }
        } else if (do_bc_live) {
            filter_dead_bc_parks(fout, peep);
        } else {
            filter_dead_reg_copies(fout, peep);
        }
        fclose(peep);
    }
    if (relax) {
        rewind(relax);
        filter_relax_branches(out, relax, f);
        fclose(relax);
    }
    free(ref);
    free(thr);
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
/* Current BB being lowered (set per-op by lower_func). Read by the AND-mask +
   shift-test peephole to inspect successor BBs' first ops, and by the windowed
   A-carry safety scan in the register-cache helpers. */
static const BB    *cur_bb;

/* ir_home_at — the single I1 read path (ADR 0017): where is value `v` homed?
   Today homes are whole-function (a degenerate one-interval-per-vreg table), so
   this returns the allocator's assignment vreg_to_phys[v]. When ranged residency
   lands (Step 4) the body gains an interval lookup keyed on the current lowering
   point (cur_bb / cur_op_idx) — the signature and every call site stay unchanged,
   only this body does. The lowerer must ask here, never re-derive a home.
   This is a POINT query ("is v homed in R at the op being lowered"). Assignment-
   level queries (which vregs are EVER homed in R — prepass / all-vreg scans) keep
   reading f->vreg_to_phys directly; they are not point residency and stay as-is.
   Callers must pass an in-range v (the vreg_in_pr_* helpers guard before calling). */
static PhysReg ir_home_at(const Func *f, int v)
{
    PhysReg pr = f->vreg_to_phys[v];
    /* Ranged residency: the home holds v only within [home_lo, home_hi] (flat
       op-index). Outside it — or when there is no ambient lowering point
       (L.ss_cur_g < 0: prologue / assignment-level query) — fall back to the
       assignment. Whole-function intervals (the default) make this a no-op. */
    if (pr != IR_PR_SPILL && f->home_lo && L.ss_cur_g >= 0
        && (L.ss_cur_g < f->home_lo[v] || L.ss_cur_g > f->home_hi[v]))
        return IR_PR_SPILL;
    return pr;
}

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
   register arg assuming a frame — UNLESS auto-push made the arg the whole
   frame, see autopush_frameless). */
static int autopush_frameless(const Func *f);
static int frame_has_saved_fp(const Func *f)
{
    if (!f) return 0;
    if (c_framepointer_is_ix == -1) return 0;
    if (f->is_naked) return 0;
    /* Frameless (Tier-B): fp-eligible but no IX — params are read off sp at
       entry into their register homes, so no saved IX and caller-arg offsets
       shift down by 2 (param_caller_off keys on this). */
    if (L.cur_frameless) return 0;
    /* Auto-push frameless: the fastcall arg was materialised by a push and is
       the WHOLE frame — no IX needed, address it sp-relative like sp-mode. */
    if (autopush_frameless(f)) return 0;
    if (f->frame_size == 0 && !f->uses_acc && !f->is_interrupt
        && fastcall_arg_vreg(f) < 0 && !L.cur_func_uses_params)
        return 0;            /* no frame needed → no IX */
    return 1;
}

/* True iff entry maintains the software frame pointer for -debug on a CPU with
   no IX (8080/8085/gbz80). `call l_debug_push_frame` saves the caller's
   __debug_framepointer on the stack (2 bytes, between the locals and the return
   address — same slot a saved IX would occupy) and points __debug_framepointer
   at that save, so the debugger can walk frames and resolve `,B,1,d` cdb records.
   The body still addresses locals/params via sp; this save is purely for the
   debugger. Excludes naked (no frame) and interrupt (its push-all frames it). */
static int frame_has_debug_fp(const Func *f)
{
    if (!f) return 0;
    if (c_framepointer_is_ix != -1) return 0;   /* real IX frame handles it */
    if (!c_debug_entry_points) return 0;
    if (f->is_naked || f->is_interrupt) return 0;
    return 1;
}

/* True iff entry saved IY for an idx3 (second-index) residency home. IY is
   callee-saved, so a function parking a loop-carried word there push/pop's it
   in the prologue/epilogue; the saved IY sits between the locals and the return
   address (like the frame-pointer save), shifting caller-arg offsets up by 2.
   sp-mode only (idx3_reg == IY); interrupts save IY via their own push-all. */
static int frame_has_saved_iy(const Func *f)
{
    if (!f || f->is_naked || f->is_interrupt || !f->vreg_to_phys) return 0;
    for (int i = 0; i < f->n_vregs; i++) {
        int p = f->vreg_to_phys[i];
        /* IY word home (idx3) — the original case, gated on idx3_reg==IY. */
        if (f->idx3_reg != IR_PR_NONE && p == f->idx3_reg) return 1;
        /* IY byte-half home (assign_idxhalf_homes): also occupies IY, which is
           callee-saved — a leaf that homes a byte in IYL/IYH must push/pop IY to
           preserve a caller's IY (e.g. qsort holds the comparator fnptr there).
           Mirrors frame_has_saved_ix's IXL/IXH cover. idxhalf is sp-mode only, so
           no fp (ix+d) param-offset interaction. Inert when idxhalf is disabled
           (--opt-disable=idxhalf → no half homes exist). */
        if (p == IR_PR_IYL || p == IR_PR_IYH) return 1;
    }
    return 0;
}

/* True iff the function contains an indirect (function-pointer) call. In sp
   mode the fnptr dispatch loads the pointer into idx2 = IX (`push hl; pop ix;
   jp (ix)` via l_jpix), clobbering IX. */
static int func_has_indirect_call(const Func *f)
{
    if (!f) return 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if (o->kind == IR_CALL && o->call && o->call->fnptr_vreg >= 0)
                return 1;
        }
    }
    return 0;
}

/* True iff the function makes a __far access or far call. The far helpers
   (l_farcall / lp_* far load-store) use IX. */
static int func_uses_far(const Func *f)
{
    if (!f) return 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if (o->kind == IR_LD_FAR || o->kind == IR_ST_FAR
                || o->kind == IR_LD_FARSYM)
                return 1;
            if (o->kind == IR_CALL && o->call && o->call->far_fnptr)
                return 1;
        }
    }
    return 0;
}

/* True iff entry must save the caller's IX because this sp-mode function itself
   USES IX. IX is callee-saved in the z88dk ABI — it is the frame pointer for
   fp-mode / sdcc-ix callers (and for #13-flipped functions' fp callers), and
   the std library preserves it (qsort/bsearch push/pop it around their own
   internal IX use). So an sp-mode function that touches IX must push/pop it;
   the saved IX sits between the locals and the return address (like the idx3
   IY save via frame_has_saved_iy), shifting caller-arg offsets up by 2.
   IX is used in sp mode by:
     - a word residency home (idx2 = IX) or a byte-half home (IXL/IXH);
     - the accumulator helpers (uses_acc: float-in-FA / long long — their
       dcallee `pop ix` retaddr stash clobbers IX);
     - __far accesses / far calls (l_farcall / lp_* use IX);
     - an indirect (fnptr) call, whose sp dispatch loads the fnptr into idx2=IX.
   fp-mode saves IX via frame_has_saved_fp instead (return 0 here); 808x/gbz80
   have no index registers. Covers native sp AND the #13 fp->sp flip (lowered
   with c_framepointer_is_ix == -1). Generalises the former frame_has_saved_ix_flip. */
static int frame_has_saved_ix(const Func *f)
{
    if (!f || f->is_naked || f->is_interrupt) return 0;
    if (c_framepointer_is_ix == 1) return 0;   /* fp: IX is the frame pointer */
    if (IS_808x() || IS_GBZ80()) return 0;     /* no index registers */
    if (f->uses_acc) return 1;                 /* acc/float/i64 helpers clobber IX */
    if (func_uses_far(f)) return 1;            /* l_farcall / lp_* clobber IX */
    if (func_has_indirect_call(f)) return 1;   /* fnptr dispatch via idx2 = IX */
    if (f->vreg_to_phys)
        for (int i = 0; i < f->n_vregs; i++) {
            int p = f->vreg_to_phys[i];
            if (p == IR_PR_IX || p == IR_PR_IXL || p == IR_PR_IXH) return 1;
        }
    return 0;
}

static int fp_active(const Func *f)
{
    /* Wide-accumulator functions can't keep their frame pointer in IX: the
       acc helpers clobber it. They save/restore IX but address sp-relative. */
    if (f->uses_acc) return 0;
    /* Frameless keeps the fp-mode residency codegen (register homes, DE-clean
       loops) — only the IX frame itself is gone; the few frame accesses (entry
       param reads) route to sp via the !cur_frameless gates at those sites. */
    if (L.cur_frameless) return 1;
    if (!frame_has_saved_fp(f)) return 0;
    return 1;
}

/* Frameless (Tier-B) eligibility: an fp-eligible function that needs NO frame
   in its body — frame_size==0 (no locals/spills) and every parameter is
   register-homed in BC/DE (read once at entry off sp, never from a slot in the
   body). Then the IX setup/teardown is pure overhead, so skip it. Wide-
   acc / interrupt / naked / fastcall / sdcccall1 / idx3-saved functions are
   excluded (special framing or register-arg entry). Opt-in IR_FRAMELESS. */
static int fastcall_arg_vreg(const Func *f);
static int frame_has_saved_iy(const Func *f);
static int autopush_param_on(void);
static int deadframe_on(void);
static int frameless_ok(const Func *f)
{
    if (opt_disabled("frameless")) return 0;
    if (c_framepointer_is_ix == -1) return 0;    /* sp-mode is already frameless */
    if (f->is_naked || f->is_interrupt || f->uses_acc) return 0;
    if (f->frame_size != 0) return 0;
    /* A fastcall arg arrives in registers (HL/DEHL), not on the caller stack;
       it historically needed a slot, so a fastcall function is not frameless. */
    if (fastcall_arg_vreg(f) >= 0) return 0;
    if (f->flags & SDCCCALL1) return 0;
    if (frame_has_saved_iy(f)) return 0;
    if (!f->vreg_to_phys) return 0;
    for (int v = 0; v < f->n_vregs; v++) {
        const VReg *vr = &f->vregs[v];
        if (!(vr->flags & (IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE))) continue;
        int ph = f->vreg_to_phys[v];
        /* The home must be one that CANNOT send the access back to memory: a
           frameless function has no IX, and a PARAM_IN_PLACE's slot is the
           CALLER's frame at (ix+d), so any reload of it reads through a
           register that was never set up (see below — most ix-addressing sites
           do not carry the !cur_frameless gate).
           - DE is REJECTED: it is the lowerer's `ex de,hl` scratch, so a
             DE-homed param is evicted and reloaded as a matter of course.
             long_ir/looppr `lp_strcmp` did exactly that under
             IR_BC_STEP_PARAM and ran away (231k -> 67.7M ticks, fp only; sp is
             fine because the same reload is sp-relative).
           - a RANGED home is REJECTED: outside its span the value is slotted by
             definition, so it must reach memory.
           Whole-function BC is what remains. This is the SHORT-TERM narrowing;
           the real fix is to route every frame access to sp when frameless. */
        if (ph != IR_PR_BC) return 0;
        if (f->home_lo && f->home_hi
            && (f->home_lo[v] != INT_MIN || f->home_hi[v] != INT_MAX))
            return 0;
    }
    return 1;
}

/* Auto-push frameless (IR_AUTOPUSH_PARAM, fp mode only): true iff a fastcall
   function's ENTIRE frame is the auto-pushed param(s) — nothing else needs a
   slot. Then no IX frame is required: the prologue push materialises the param,
   and forcing frame_has_saved_fp -> 0 (hence fp_active -> 0) routes every slot
   access + the return-value-safe reclaim through the already-shipped sp-mode
   paths, exactly like a leaf fp-mode function with frame_size==0 (which also
   elides IX) but with a pushed arg. Excludes the special-framing entries
   (naked / interrupt / acc / sdcccall1 / idx3-saved). */
static int autopush_frameless(const Func *f)
{
    if (!autopush_param_on()) return 0;
    if (c_framepointer_is_ix == -1) return 0;   /* sp-mode: no IX anyway */
    if (!f || f->is_naked || f->is_interrupt || f->uses_acc) return 0;
    if (f->flags & SDCCCALL1) return 0;
    if (frame_has_saved_iy(f)) return 0;
    int ab = 0;
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vregs[v].flags & IR_VREG_AUTOPUSH) {
            int w = f->vregs[v].width;
            ab += (w == 1) ? 2 : (w > 0 ? w : 2);  /* a byte pushes hl → 2 */
        }
    return ab > 0 && f->frame_size == ab;   /* the push IS the whole frame */
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
                    + (frame_has_debug_fp(f) ? 2 : 0)   /* l_debug_push_frame save */
                    + (frame_has_saved_iy(f) ? 2 : 0)   /* saved IY (idx3) */
                    + (frame_has_saved_ix(f) ? 2 : 0)  /* [#13] flipped-fn saved IX */
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
static void note_slot_use(int v);   /* frame-slot use accounting: fwd (defined with rec state) */
/* [IR_DEADSTORE] write-context depth: >0 while lowering a store function body,
   so note_slot_use attributes its slot_off calls (store + guard checks) to the
   write count. Save/restore (not set/clear) because stores nest via
   pending_spill_resolve. */
static int slot_write_ctx;
/* [#13 frameless probe] per-render count of (ix+-d) DATA accesses (every one
   computes its offset through slot_ix_off). rec_counting==0 ⇒ don't count (pass
   1 / no instrumentation). A framed function with ds_ixaccess==0 emitted its IX
   apparatus (push ix;ld ix,0;add ix,sp;ld sp,ix;pop ix) for NOTHING — the frame
   is serviced entirely sp-relative (sp-parking / add hl,sp), so IX is dead
   overhead and a sp-mode flip is ~zero-cost. rec_counting is defined below with
   the rest of the rec state (tentative fwd here so slot_ix_off can bump it). */
static int rec_counting;
static int ds_ixaccess;
static int ds_last_framed;   /* [#13] frame_has_saved_fp of last-rendered fn */

static int slot_off(const Func *f, int vreg_id)
{
    note_slot_use(vreg_id);          /* frame-slot chokepoint (also via slot_ix_off) */
    if (f->vregs[vreg_id].flags & IR_VREG_PARAM_IN_PLACE)
        return param_caller_off(f, vreg_id);
    return f->vreg_spill_slot[vreg_id];
}

/* A vreg read/written through its frame slot MUST have one. A negative
   slot_off means a register-only vreg (PR_HL/DE/BC/DEHL) reached a slot
   access with its register already clobbered and no backing slot to
   reload from — an allocator/lowering bug. `ld hl,-1; add hl,sp` would
   read below the frame and silently miscompile, so fail loudly instead. */
/* B4 increment 1 — inert home-recoverability verifier (env IR_REC_VERIFY).
   Classifies, per value READ at a load site, how the value was recovered:
   from its home register (REG), a stack slot (SLOT), or rematerialised
   (REMAT). A register-homed value read where it is in NEITHER its register
   NOR a slot NOR rematerialisable hits require_slot → the true "unrealizable
   home" violation (logged there). Zero codegen change; runs only on the
   FINAL render (skips lazy-spill's throwaway pass 1, L.ss_phase==1). This
   validates the recoverability model that Increment 2 turns into the
   proactive home_realizable() predicate. */
enum { REC_REG, REC_SLOT, REC_REMAT };
static void rec_note(int bucket, int v);      /* record a recovery of v */
static void rec_note_violation(const Func *f, int v);  /* require_slot fail */

static void require_slot(const Func *f, int vreg_id)
{
    if (slot_off(f, vreg_id) >= 0) return;
    rec_note_violation(f, vreg_id);   /* B4: unrealizable home (about to abort) */
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
    if (rec_counting) ds_ixaccess++;     /* [#13] an (ix+-d) data access */
    return slot_off(f, vreg_id) - f->frame_size;
}

/* Forward declarations for BC/DE cache helpers used by load_to_hl_adj
   and load_to_de. Definitions are with the rest of the cache state
   later in the file (kept together for readability). */
static int  emit_remat_word(FILE *out, const Func *f, int vreg_id, const char *rp);
static int  op_is_commutative(OpKind kind);
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
static int  vreg_is_pr_de(const Func *f, int v);
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
static void cache_hl(int vreg);
static void cache_dehl(int v);
static void invalidate_hl_cache(void);
static void invalidate_de_cache(void);
static void invalidate_hl_keep_de(void);
static void invalidate_hl_keep_a(void);
static int  vreg_in_idx2(const Func *f, int v);
static int  vreg_idx_home(const Func *f, int v);
static const char *vreg_idx_name(const Func *f, int v);
static int  vreg_in_exx(const Func *f, int v);
static const char *exx_half_lo(const Func *f);
static const char *exx_half_hi(const Func *f);
static const char *exx_pair(const Func *f);
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

/* Cross-BB HL slot-address carry (default on; IR_HLADDR_BB=0 reverts). */
static int hladdr_bb_carry_on(void)
{
    static int on = -1;
    if (on < 0) {
        const char *e = getenv("IR_HLADDR_BB");
        on = (e && *e == '0') ? 0 : 1;
    }
    return on;
}
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
/* As emit_acc_slot_addr, plus a constant byte displacement into the slot (an
   IR_LEA's folded member offset). `ofs` applies in BOTH modes, unlike `adj`,
   which is the sp-push shift and is meaningless when IX holds the frame. */
static void emit_slot_addr_ofs(FILE *out, const Func *f, int vreg, int adj,
                               int ofs)
{
    if (fp_active(f)) {
        int ixoff = slot_ix_off(f, vreg) + ofs;
        /* ez80: lea hl,ix+d in one op, no DE clobber, vs push/pop + add. */
        if (IS_EZ80() && ixoff >= -128 && ixoff <= 127) {
            emit(out, "lea\thl,%s%+d", frame_reg(), ixoff);
            return;
        }
        emit(out, "push\t%s", frame_reg());
        emit(out, "pop\thl");
        if (ixoff) {
            emit(out, "ld\tde,%d", ixoff);
            emit(out, "add\thl,de");
            /* The `ld de` above destroys DE, and with it the HIGH half of any
               live DEHL long. Without this the long-store path kept believing
               DE held the value and wrote the displacement's bytes instead:
               long_ir structval test_struct_mixed_odd, every Rabbit in fp mode.
               (sp mode escapes it — there the address is `ld hl,off; add hl,sp`,
               which leaves DE alone; ez80 escapes via `lea`.) */
            invalidate_de_cache();
        }
    } else {
        emit(out, "ld\thl,%d", slot_off(f, vreg) + L.cur_sp_adjust + adj + ofs);
        emit(out, "add\thl,sp");
    }
}

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
            /* The `ld de` above destroys DE, and with it the HIGH half of any
               live DEHL long. Without this the long-store path kept believing
               DE held the value and wrote the displacement's bytes instead:
               long_ir structval test_struct_mixed_odd, every Rabbit in fp mode.
               (sp mode escapes it — there the address is `ld hl,off; add hl,sp`,
               which leaves DE alone; ez80 escapes via `lea`.) */
            invalidate_de_cache();
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
        emit_hl_to_bc(out);
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

/* ===== LRA Phase 0: op_clobbers model + IR_VERIFY cross-check =============
   Read-only classification of which physical value-registers an op's lowering
   writes, plus a verifier that parses the emitted asm and asserts the actual
   writes are a subset of the model. Inert (IR_VERIFY only); the substrate the
   live-range allocator's soundness rests on (a value in register r survives an
   op iff r is NOT in op_clobbers(op)). */

/* A register-name token (as emitted, lowercase) → value-register mask. */
static RegMask lra_reg_of(const char *t)
{
    if (!t[0]) return 0;
    if (t[0] == '(') return IR_R_MEM;                 /* (hl) (de) (nn) (ix+d) */
    if (!strcmp(t,"a"))  return IR_R_A;
    if (!strcmp(t,"f")||!strcmp(t,"af")) return IR_R_F | (t[1]=='f'?IR_R_A:0);
    if (!strcmp(t,"h")||!strcmp(t,"l")||!strcmp(t,"hl")) return IR_R_HL;
    if (!strcmp(t,"d")||!strcmp(t,"e")||!strcmp(t,"de")) return IR_R_DE;
    if (!strcmp(t,"b")||!strcmp(t,"c")||!strcmp(t,"bc")) return IR_R_BC;
    if (!strncmp(t,"ix",2)) return IR_R_IX;           /* ix ixl ixh */
    if (!strncmp(t,"iy",2)) return IR_R_IY;
    if (!strcmp(t,"sp")) return IR_R_SP;
    return 0;                                         /* immediate / label / cc */
}

/* THE asm-line decomposer — ONE parse, every effect. Replaces the former two
   parsers (lra_line_writes for the whole-reg write mask, bc_line_effect for the
   sub-register B/C liveness); only the pure token helpers lra_reg_of / bc_tok
   remain. Every consumer (ir_verify_op, IR_CLOB_VERIFY, the re-renderer's park
   sweep) goes through here. Input may be tab-prefixed (re-renderer) or
   mnemonic-first (verify) — leading whitespace is skipped so both work. */
static InstrEffects instr_effects(const char *line)
{
    InstrEffects e; memset(&e, 0, sizeof e);
    const char *p = line;
    while (*p == ' ' || *p == '\t') p++;                 /* normalise both callers */
    char m[16] = {0}; int mi = 0;
    while (*p && *p != ' ' && *p != '\t' && *p != '\n' && *p != '\r' && *p != ';' && mi < 15)
        m[mi++] = *p++;
    if (!m[0]) return e;                                 /* blank/comment: transparent */
    while (*p == ' ' || *p == '\t') p++;
    char ops[64] = {0}; int oi = 0;
    while (*p && *p != '\n' && *p != '\r' && *p != ';' && oi < 63) ops[oi++] = *p++;
    while (oi > 0 && (ops[oi-1] == ' ' || ops[oi-1] == '\t')) ops[--oi] = 0;
    /* o0 = dest (before comma), o1 = src (after comma, ws-skipped for lra_reg_of),
       src = raw comma+1 (bc_tok/park use the raw form, exactly as before). */
    char o0[64] = {0}, o1[64] = {0};
    const char *comma = strchr(ops, ',');
    const char *src = comma ? comma + 1 : "";
    if (comma) {
        int n = (int)(comma - ops); if (n > 63) n = 63;
        memcpy(o0, ops, (size_t)n);
        const char *q = src; while (*q == ' ') q++;
        int k = 0; while (*q && k < 63) o1[k++] = *q++;
    } else {
        memcpy(o0, ops, (size_t)(oi < 64 ? oi : 63));
    }

    /* ---- (A) whole-reg WRITE mask (was lra_line_writes) ---- */
    RegMask w = 0;
    if (strstr(line,"hl+") || strstr(line,"hl-")) w |= IR_R_HL;   /* gbz80 auto-step */
    if (strstr(line,"de+") || strstr(line,"de-")) w |= IR_R_DE;
    if (!strcmp(m,"ld"))                                 w |= lra_reg_of(o0);
    else if (!strcmp(m,"add")||!strcmp(m,"adc")||!strcmp(m,"sbc")) w |= lra_reg_of(o0)|IR_R_F;
    else if (!strcmp(m,"sub")) w |= (!strcmp(o0,"hl") ? (IR_R_HL|IR_R_F) : (IR_R_A|IR_R_F));
    else if (!strcmp(m,"and")||!strcmp(m,"or")||!strcmp(m,"xor")) w |= IR_R_A|IR_R_F;
    else if (!strcmp(m,"cp"))                            w |= IR_R_F;
    else if (!strcmp(m,"inc")||!strcmp(m,"dec"))         w |= lra_reg_of(o0)|IR_R_F;
    else if (!strcmp(m,"sla")||!strcmp(m,"sra")||!strcmp(m,"srl")||!strcmp(m,"rl")
          || !strcmp(m,"rr")||!strcmp(m,"rlc")||!strcmp(m,"rrc")||!strcmp(m,"swap"))
                                                         w |= lra_reg_of(o0)|IR_R_F;
    else if (!strcmp(m,"rlca")||!strcmp(m,"rrca")||!strcmp(m,"rla")||!strcmp(m,"rra"))
                                                         w |= IR_R_A|IR_R_F;
    else if (!strcmp(m,"neg")||!strcmp(m,"cpl"))         w |= IR_R_A|IR_R_F;
    else if (!strcmp(m,"bit")||!strcmp(m,"set")||!strcmp(m,"res")) w |= (m[0]=='b'?IR_R_F:lra_reg_of(o1));
    else if (!strcmp(m,"ex"))                            w |= lra_reg_of(o0)|lra_reg_of(o1);
    else if (!strcmp(m,"exx"))                           w |= IR_R_HL|IR_R_DE|IR_R_BC;
    else if (!strcmp(m,"push"))                          w |= IR_R_SP|IR_R_MEM;
    else if (!strcmp(m,"pop"))                           w |= lra_reg_of(o0)|IR_R_SP;
    else if (!strcmp(m,"call")||!strcmp(m,"rst")) {
        int bc_clean = (strstr(o0,"l_asr")||strstr(o0,"l_lsr")||strstr(o0,"l_lsl"));
        w |= IR_R_A|IR_R_HL|IR_R_DE|IR_R_F|IR_R_MEM | (bc_clean ? 0 : IR_R_BC);
    }
    else if (!strcmp(m,"djnz"))                          w |= IR_R_BC|IR_R_F;
    else if (!strcmp(m,"mlt"))                           w |= lra_reg_of(o0);
    else if (!strcmp(m,"mul")||!strcmp(m,"muls"))        w |= lra_reg_of(o0)|IR_R_F;
    else if (!strcmp(m,"div")||!strcmp(m,"divu")||!strcmp(m,"divs")) w |= lra_reg_of(o0)|IR_R_A|IR_R_F;
    else if (!strcmp(m,"ldi")||!strcmp(m,"ldd")||!strcmp(m,"ldir")||!strcmp(m,"lddr"))
                                                         w |= IR_R_HL|IR_R_DE|IR_R_BC|IR_R_MEM|IR_R_F;
    else if (!strcmp(m,"scf")||!strcmp(m,"ccf"))         w |= IR_R_F;
    else if (!strcmp(m,"ret")||!strcmp(m,"jp")||!strcmp(m,"jr")||!strcmp(m,"nop")
          || !strcmp(m,"di")||!strcmp(m,"ei")||!strcmp(m,"halt")||!strcmp(m,"reti")
          || !strcmp(m,"retn")) { /* control/none */ }
    else                                                 e.unknown = 1;
    e.writes = w;

    /* ---- (B) value-change refinements ---- */
    if ((!strcmp(m,"or")||!strcmp(m,"and")) && !strcmp(o0,"a")) e.self_pres |= IR_R_A;
    if (!strcmp(m,"inc")||!strcmp(m,"dec"))                     e.stepped   |= lra_reg_of(o0);
    if (!strcmp(m,"exx"))                                       e.swapped   |= IR_R_HL|IR_R_DE|IR_R_BC;
    else if (!strcmp(m,"ex") && strstr(ops,"de") && strstr(ops,"hl") && !strstr(ops,"(sp)"))
        e.swapped |= IR_R_HL|IR_R_DE;

    /* ---- (C) sub-register B/C + park/boundary/call (was bc_line_effect) ---- */
    /* Directives carry text operands (paths, symbols) — never registers; a bare
       `c` in "foo.c" must NOT read as reg C (else a park stays live over C_LINE). */
    if (!strcmp(m,"C_LINE") || !strncmp(m,"def",3) || !strcmp(m,"GLOBAL")
        || !strcmp(m,"SECTION") || !strcmp(m,"MODULE") || !strcmp(m,"LSTON")
        || !strcmp(m,"LSTOFF"))
        return e;
    if (!strcmp(m,"ret")||!strcmp(m,"reti")||!strcmp(m,"retn")) { e.is_boundary = 1; return e; }
    if (!strcmp(m,"jp")||!strcmp(m,"jr")||!strcmp(m,"djnz")||!strcmp(m,"call")||!strcmp(m,"rst")) { e.is_call = 1; return e; }
    if (!strcmp(m,"exx")) { e.b_read = e.c_read = 1; return e; }
    if (!strcmp(m,"ldir")||!strcmp(m,"lddr")||!strcmp(m,"ldi")||!strcmp(m,"ldd")
        ||!strcmp(m,"cpir")||!strcmp(m,"cpdr")||!strcmp(m,"cpi")||!strcmp(m,"cpd")) {
        e.b_read = e.c_read = 1; return e;
    }
    if (!strcmp(m,"ld")) {
        if (!strcmp(o0,"bc")) {
            e.b_write = e.c_write = 1;
            e.b_read = bc_tok(src,"b")||bc_tok(src,"bc");
            e.c_read = bc_tok(src,"c")||bc_tok(src,"bc");
            if (!strcmp(src,"hl")) e.park = 1;
            return e;
        }
        if (!strcmp(o0,"b")) { e.b_write = 1; e.b_read = bc_tok(src,"b")||bc_tok(src,"bc");
                               e.c_read = bc_tok(src,"c")||bc_tok(src,"bc"); return e; }
        if (!strcmp(o0,"c")) { e.c_write = 1; e.c_read = bc_tok(src,"c")||bc_tok(src,"bc");
                               e.b_read = bc_tok(src,"b")||bc_tok(src,"bc"); return e; }
        e.b_read = bc_tok(ops,"b")||bc_tok(ops,"bc");
        e.c_read = bc_tok(ops,"c")||bc_tok(ops,"bc");
        return e;
    }
    if (!strcmp(m,"pop")) { if (!strcmp(ops,"bc")) e.b_write = e.c_write = 1; return e; }
    e.b_read = bc_tok(ops,"b")||bc_tok(ops,"bc");
    e.c_read = bc_tok(ops,"c")||bc_tok(ops,"bc");
    return e;
}

/* A vreg's physical register as a mask (its result-home). Byte halves map to
   their pair; SPILL/none → 0 (the value's home is memory, written via HL/MEM). */
RegMask phys_regmask(const Func *f, int v)
{
    if (v < 0 || !f->vreg_to_phys) return 0;
    switch (f->vreg_to_phys[v]) {
    case IR_PR_A:                 return IR_R_A;
    case IR_PR_HL:                return IR_R_HL;
    case IR_PR_DE: case IR_PR_E: case IR_PR_D: return IR_R_DE;
    case IR_PR_BC: case IR_PR_C: case IR_PR_B: return IR_R_BC;
    case IR_PR_DEHL:              return IR_R_HL|IR_R_DE;
    case IR_PR_IX: case IR_PR_IXL: case IR_PR_IXH: return IR_R_IX;
    case IR_PR_IY: case IR_PR_IYL: case IR_PR_IYH: return IR_R_IY;
    default:                      return 0;
    }
}

/* Helper clobber table (PRESERVE_REGS Track B). Names here are the `l_` runtime
   helpers AUDITED (grep of libsrc/l + libsrc/math asm) to use neither IX/IY nor
   the alt/shadow bank (exx) — so a value homed in IX/IY/BC'/DE'/HL' survives the
   call. CONSERVATIVE by construction: an unknown or unaudited helper is NOT
   listed and falls through to IR_R_ALL, so a mis-omission costs residency, never
   correctness. A mis-INCLUSION would be a silent miscompile, so only add a name
   after confirming its asm (all CPU variants) is index+alt clean. Long/i64/float/
   far/fnptr helpers (l_long_*, l_i64_*, l_f*, lp_*, l_setix/iy, l_jpix/iy) DO use
   the index regs and must never be listed. */
static int helper_preserves_index_alt(const char *name)
{
    static const char *const clean[] = {
        /* multiplies (16x16, narrowing 16x16->32) */
        "l_mult", "l_mult_u", "l_mulu_32_16x16",
        /* divides / modulo (16-bit) */
        "l_div", "l_div_u",
        /* shifts (BC-clean-by-contract shift family; asr verified, lsr/lsl same) */
        "l_asr", "l_lsr", "l_lsl",
        /* unary */
        "l_neg", "l_abs",
    };
    for (size_t i = 0; i < sizeof clean / sizeof clean[0]; i++)
        if (!strcmp(name, clean[i])) return 1;
    return 0;
}

/* The model: registers op's lowering may clobber (value regs only; SP/MEM are
   stack/memory bookkeeping, checked separately). First cut — refined against
   the IR_VERIFY log. Under-approx is caught by the verifier; over-approx is
   sound but costs residency. */
RegMask op_clobbers(const Func *f, const Op *op)
{
    int dw = (op->dst >= 0 && op->dst < f->n_vregs) ? f->vregs[op->dst].width : 0;
    /* Width of the WIDEST operand, not just the dst: a 32-bit compare/store has
       a width-2 (bool) dst but width-4 operands, and its lowering uses the DEHL
       helpers + BC (and cleans a pushed long via `pop bc`). */
    int ow = dw;
    for (int s = 0; s < 2; s++)
        if (op->src[s] >= 0 && op->src[s] < f->n_vregs
            && f->vregs[op->src[s]].width > ow) ow = f->vregs[op->src[s]].width;
    RegMask wide = (ow >= 4) ? (IR_R_HL|IR_R_DE|IR_R_BC) : 0;   /* DEHL/i64 helpers use BC */
    RegMask dst  = phys_regmask(f, op->dst);                    /* result home */
    /* An operand's register can itself be written: an aliased two-address ALU
       (dst=src0) and — crucially — a `*p++` deref that steps its pointer
       operand (`inc bc` when p is BC-homed). Folding operand homes in keeps the
       model precise there without blanket-pessimising BC on plain loads. */
    RegMask ops = phys_regmask(f, op->src[0]) | phys_regmask(f, op->src[1])
                | (op->mem.kind == IR_MEM_VREG ? phys_regmask(f, op->mem.base) : 0);
    switch (op->kind) {
    case IR_NOP: case IR_BR: case IR_PHI:
        return 0;
    case IR_HCALL:
        /* Helper clobber table (PRESERVE_REGS Track B): the audited integer
           word/byte arithmetic helpers touch neither the index registers nor
           the alt bank (verified against libsrc/l asm), so they PRESERVE IX/IY/
           BC'/DE'/HL' — only the main bank + flags + memory are clobbered. That
           lets an IX/IY/alt-bank home survive the call. Unknown/long/float/i64/
           far helpers stay conservative (IR_R_ALL). */
        if (op->hcall && op->hcall->name && helper_preserves_index_alt(op->hcall->name))
            return IR_R_HL | IR_R_DE | IR_R_BC | IR_R_A | IR_R_F | IR_R_MEM;
        return IR_R_ALL;
    case IR_CALL:
        /* 5b: IX/IY are callee-saved. A DIRECT call to a known function preserves
           BOTH — every 80cc function does (fp mode: IX is the frame pointer, saved
           via frame_has_saved_fp; sp mode: frame_has_saved_ix push/pop's it when
           the function uses IX; IY likewise via frame_has_saved_iy), and the
           callable library saves them: far mem/str routines, the float libs, and
           qsort/bsearch (which push/pop IX around their own comparator dispatch).
           The only callable IY clobberers are ZX-Spectrum-specific (zxmath ftoa,
           sp1 sprites, wyz sound) and run under --reserve-regs-iy anyway. So a
           value in IX or IY survives a direct call with no spill/reload. INDIRECT
           (function-pointer) calls have an unknown target → stay conservative. */
        /* __preserves_regs(...) on the callee removes those register pairs
           from the clobber set (op->call->preserved; 0 when unannotated), so
           a value stays resident across the call — e.g. a pointer kept in BC
           across intrinsic_swap_endian (declared __preserves_regs(b,c)). */
        if (op->call && op->call->fnptr_vreg < 0)
            return (IR_R_ALL & ~IR_R_IY & ~IR_R_IX) & ~op->call->preserved;
        return IR_R_ALL;
    case IR_ASM: case IR_PUSH_ARG:
    case IR_PUSH_STRUCT: case IR_RET: case IR_MEMSET:
    case IR_MEMCPY:
        return IR_R_ALL;               /* opaque: helper call / whole-reg-set */
    /* Table dispatch is NOT opaque. gen_switch emits only the l_case /
       l_long_case / l_i64_case call, and all three walk the table through
       HL/DE/BC/A — verified against libsrc/l/sccz80/9-common/l_case.asm,
       .../i32/l_long_case.asm and the gbz80 variant, none of which names an
       index register (l_long_case's only `ix` is a 2014 comment recording that
       its IX use was REMOVED). So an IX/IY home survives a switch. */
    case IR_SWITCH:
        return IR_R_ALL & ~IR_R_IX & ~IR_R_IY;
    /* The wide-accumulator helpers DO destroy IX — mm48_fpmul pops the return
       address into IX and runs `add ix,sp` with no matching push, which is why
       a function on this tier is flagged uses_acc and addresses sp-relative.
       IY is a different story: across every acc backend (math48 921 files,
       am9511 558, daimath32, mbf32, mbf64, z88math, cpcmath, and the i64
       helpers) NOTHING writes IY, and the two float routines that use it at all
       — genmath fdiv and the math32 clang __f* set — bracket it with push iy /
       pop iy. 80cc's own gen_acc_* emit only `call` and `ld`. So IY survives
       the acc tier and only IX must be given up. */
    case IR_ACC_UNOP: case IR_ACC_BINOP: case IR_ACC_CMP:
        return IR_R_ALL & ~IR_R_IY;
    case IR_MUL:
        return IR_R_HL|IR_R_DE|IR_R_BC|IR_R_A|IR_R_F;
    case IR_SHL: case IR_SHR:
        /* z80n stages the shift count into B for `bsrl/bsra de,b`. */
        return IR_R_HL|IR_R_DE|IR_R_A|IR_R_F|wide|dst|ops
             | (IS_Z80N() ? IR_R_BC : 0);
    case IR_CMP_EQ: case IR_CMP_NE:
    case IR_CMP_LT: case IR_CMP_LE: case IR_CMP_GT: case IR_CMP_GE:
    case IR_CMP_ULT: case IR_CMP_ULE: case IR_CMP_UGT: case IR_CMP_UGE:
        /* 8085 word compares stage an operand into BC (`ld c,e; ld b,d`). */
        return IR_R_HL|IR_R_DE|IR_R_A|IR_R_F|wide|dst|ops
             | (IS_8085() ? IR_R_BC : 0);
    default:
        /* Everything else — loads/materialise/MOV/ALU/compare/conv/shift/store:
           HL workhorse + A scratch + DE (operand staging / `ex de,hl` word
           commit) + flags + result home + operand homes; wide (DEHL) uses BC. */
        return IR_R_HL|IR_R_DE|IR_R_A|IR_R_F|wide|dst|ops;
    }
}

/* ---- B4 recoverability verifier state (per function, final render) ---- */
static int   rec_on = -1;         /* -1 = unqueried; 0/1/2 = off/on/verbose */
static int  *rec_reg;             /* per-vreg: uses recovered from a register */
static int  *rec_slot;            /* per-vreg: uses recovered from a slot */
static int  *rec_remat;           /* per-vreg: uses rematerialised */
static int   rec_nv;              /* size of the above (this function) */
static int   rec_counting;        /* 1 while a final render is instrumented */

/* Frame-slot use accounting (shared by IR_DEADSTORE and IR_DEADFRAME).
   rec_slotuse[v] counts genuine frame-slot accesses emitted for v (hooked in
   slot_off/slot_ix_off — the two chokepoints every frame-slot load/store passes
   through; stack transients and cache hits don't). A SPILL vreg with a slot but
   rec_slotuse==0 is a DEAD slot (served entirely from registers/push-pop/remat);
   an all-dead frame is dropped frameless (IR_DEADFRAME). Sound: over-counts from
   non-emit slot_off checks → never falsely dead. */
static int  *rec_slotuse;
/* [IR_DEADSTORE, inert] rec_slotwrite[v] counts frame-slot WRITES of v — the
   subset of rec_slotuse[v] emitted by the store functions (store_a_byte/
   store_hl, via note_slot_write). Then reads = rec_slotuse - rec_slotwrite. A
   spill vreg WRITTEN but never READ (rec_slotwrite>0, reads==0) is a dead store:
   its value is served from a register for every use, so the store is redundant.
   Discipline (like the lazy-spill hooks): note_slot_write must be PRECISE — a
   missed write site only over-counts reads → a live-looking slot → conservative
   (store kept). Never over-count writes. */
static int  *rec_slotwrite;
/* [IR_FRAMEPROBE, inert] Frame-traffic census. rec_fh_red[v] counts REDUNDANT
   slot reads of v: a read in the same call-free region as an earlier read of v
   with no intervening write. That is the residency opportunity — a value the
   lowerer re-fetched when it could have kept it in a register — as distinct
   from a first read (unavoidable) or a read after a call (the register would
   have been clobbered anyway). rec_fh_seen[v] is the per-region latch, cleared
   at every call/hcall/asm and BB boundary by frameprobe_region_break(). */
static int  *rec_fh_red;
static char *rec_fh_seen;
static int   frameprobe_on(void)
{ static int c = -1; if (c < 0) c = getenv("IR_FRAMEPROBE") ? 1 : 0; return c; }
static int   dsx_on = -1;
/* [IR_DEADSTORE] dead-spill vreg ids found by the last render's read/write split
   (populated in rec_end, consumed by the driver to mark IR_VREG_DEAD_SPILL and
   re-lower). Per-function; reset at the top of rec_end. */
static int   ds_dead[512];
static int   ds_ndead;

static int rec_enabled(void)
{
    if (rec_on < 0) {
        const char *e = getenv("IR_REC_VERIFY");
        rec_on = e ? (e[0] == '2' ? 2 : (e[0] ? 1 : 0)) : 0;
    }
    return rec_on;
}

/* IR_DEADSTORE dead byte-spill elision (DEFAULT-ON). The render's read/write
   split (rec_end) lists byte spills written but never read; the driver marks
   them, drops the slots, and re-lowers (the value rides A to its readers).
   Pure win both axes (bytes and ticks fall together — dead memory traffic
   removed). Opt out with IR_DEADSTORE=0 (reproduces pre-flip codegen);
   IR_DEADSTORE=2 adds the per-slot report. */
/* Width-2 half of IR_DEADSTORE (dead call-result / word slot stores).
   Default-on; `IR_DSWORD=0` opts out, leaving the width-1 behaviour that
   shipped with #10 — the bisect handle for this bug family. */
static int dsw_on = -1;
static int dsw_enabled(void)
{
    if (dsw_on < 0) {
        const char *e = getenv("IR_DSWORD");
        dsw_on = (e && e[0] == '0') ? 0 : 1;
    }
    return dsw_on;
}

/* [IR_DS_SHARE] Refine the coalesced-read veto: block a dead store only when a
   byte-sharing reader never writes its own slot (the channel shape), instead of
   on any sharing reader at all. Default ON; `IR_DS_SHARE=0` opts out and
   restores the pre-flip codegen byte-for-byte.

   Flipped on after the 391-cell matrix (23 benches x 10 cpus x sp/fp): 0 cells
   slower on ANY cpu and 0 cells larger on any cpu, net -1200B, every cell built
   AND run in both configurations with no failures. Bytes and cycles move
   together here because eliding a store removes memory traffic — there was no
   byte-for-tick trade to weigh.

   The r4k byte regression the first matrix showed was NOT this pass; it was the
   HL->DE staging copy being spelled as two page-prefixed 8-bit moves on Rabbit
   (fixed in 1b43c3a4c7, see emit_hl_to_de).

   Careful with the predicate: "reads a slot it never wrote" is NOT
   `rec_slotwrite == 0`. See the marking site — a MULTI-DEF reader can have one
   def that stores and another that rides a register, and the first version of
   this shipped that way and miscompiled emu.c. */
static int ds_share = -1;
static int ds_share_on(void)
{
    if (ds_share < 0) {
        const char *e = getenv("IR_DS_SHARE");
        ds_share = (e && e[0] == '0') ? 0 : 1;
    }
    return ds_share;
}

static int dsx_enabled(void)
{
    if (dsx_on < 0) {
        const char *e = getenv("IR_DEADSTORE");
        dsx_on = !e ? 1 : (e[0] == '0' ? 0 : (e[0] == '2' ? 2 : 1));
    }
    return dsx_on;
}

/* [#13] IR_FLIPCOST report gate (inert): print the frameless-via-sp cost model
   per framed function — ds_ixaccess (ix+-d accesses = N), the ~11B IX-apparatus
   save, and the flip verdict. ds_ixaccess==0 = IX dead overhead (zero-cost flip). */
static int ff_on = -1;
static int ff_enabled(void)
{
    if (ff_on < 0) { const char *e = getenv("IR_FLIPCOST"); ff_on = (e && e[0]) ? 1 : 0; }
    return ff_on;
}

static void rec_reset(void)
{
    free(rec_reg); free(rec_slot); free(rec_remat); free(rec_slotuse);
    free(rec_slotwrite); free(rec_fh_red); free(rec_fh_seen);
    free(rec_fh_bytes); free(rec_fh_redbytes);
    rec_fh_bytes = rec_fh_redbytes = NULL; fh_cur_v = -1; fh_cur_red = 0; fh_nv = 0;
    rec_reg = rec_slot = rec_remat = rec_slotuse = rec_slotwrite = NULL;
    rec_fh_red = NULL; rec_fh_seen = NULL;
    rec_nv = 0; rec_counting = 0;
}

/* Begin instrumenting a function's FINAL render. Skips lazy-spill's scratch
   pass 1 (L.ss_phase==1) so each value is counted exactly once. */
static void rec_begin(const Func *f)
{
    rec_reset();
    ds_ixaccess = 0;                  /* [#13] per-render (ix+-d)-access count */
    if ((!rec_enabled() && !deadframe_on() && !dsx_enabled()
         && !ff_enabled())
        || L.ss_phase == 1 || f->n_vregs <= 0)
        return;
    rec_nv = f->n_vregs;
    rec_reg   = calloc((size_t)rec_nv, sizeof(int));
    rec_slot  = calloc((size_t)rec_nv, sizeof(int));
    rec_remat = calloc((size_t)rec_nv, sizeof(int));
    rec_slotuse = calloc((size_t)rec_nv, sizeof(int));
    rec_slotwrite = calloc((size_t)rec_nv, sizeof(int));
    rec_fh_red    = calloc((size_t)rec_nv, sizeof(int));
    rec_fh_seen   = calloc((size_t)rec_nv, 1);
    rec_fh_bytes    = calloc((size_t)rec_nv, sizeof(int));
    rec_fh_redbytes = calloc((size_t)rec_nv, sizeof(int));
    fh_nv = rec_nv;
    if (!rec_reg || !rec_slot || !rec_remat || !rec_slotuse || !rec_slotwrite) {
        rec_reset(); return; }
    rec_counting = 1;
}

/* Record a genuine frame-slot access emitted for v (called from slot_off /
   slot_ix_off). Guarded by rec_counting so only the final render counts. When
   the WRITE context is active (slot_write_ctx, set for the whole body of a store
   function) the access is ALSO a write — so every slot_off inside a store (the
   actual store AND its non-emit guard checks like `slot_off()<0`) is attributed
   to the write, leaving rec_slotuse - rec_slotwrite = the true READ count. */
static void note_slot_use(int v)
{
    if (!rec_counting || v < 0 || v >= rec_nv || !rec_slotuse) return;
    rec_slotuse[v]++;
    if (slot_write_ctx && rec_slotwrite) rec_slotwrite[v]++;
    /* Was v ALREADY read in this call-free region? That, and only that, makes
       THIS read redundant — sample the latch BEFORE updating it. (Testing
       rec_fh_red[v] > 0 instead means "v was ever redundant", which wrongly
       tags every later read, including the first one in a fresh region.) */
    int was_seen = rec_fh_seen ? rec_fh_seen[v] : 0;
    if (rec_fh_seen && rec_fh_red) {
        if (slot_write_ctx) rec_fh_seen[v] = 0;      /* write refreshes the slot */
        else { if (was_seen) rec_fh_red[v]++; rec_fh_seen[v] = 1; }
    }
    /* Hand the emit site the attribution for whatever instruction follows. */
    fh_cur_v   = v;
    fh_cur_red = (!slot_write_ctx && was_seen) ? 1 : 0;
}

/* A call / asm clobbers the register file, so a reload after it is NOT
   redundant — reset the latches. Also called at each BB boundary. */
static void frameprobe_region_break(void)
{
    if (rec_fh_seen && rec_nv > 0) memset(rec_fh_seen, 0, (size_t)rec_nv);
}

static void rec_note(int bucket, int v)
{
    if (!rec_counting || v < 0 || v >= rec_nv) return;
    switch (bucket) {
    case REC_REG:   rec_reg[v]++;   break;
    case REC_SLOT:  rec_slot[v]++;  break;
    case REC_REMAT: rec_remat[v]++; break;
    }
}

/* A register-homed value was read with no register, no slot, no remat — the
   home is unrealizable. require_slot already aborts on this; log it first so a
   corpus run names the (function,value). Expect ZERO on the current corpus. */
static void rec_note_violation(const Func *f, int v)
{
    if (!rec_enabled()) return;
    PhysReg pr = (f->vreg_to_phys && v >= 0 && v < f->n_vregs)
        ? f->vreg_to_phys[v] : IR_PR_SPILL;
    fprintf(stderr, "IR_REC VIOLATION: %s v%d homed in %s (w=%d) unrealizable "
            "— read with no register, no slot, no remat\n",
            f->fn ? ir_sym_name(f->fn) : "?", v, ir_phys_name(pr),
            (v >= 0 && v < f->n_vregs) ? f->vregs[v].width : -1);
}

/* End of the final render: emit the per-function recovery distribution. One
   REG-homed value whose uses are ALL slot/remat (rec_reg==0) means the home
   register is never actually read — a home the ranger should not have kept.
   Reported as a "cold home" note (not a miscompile). */
static void rec_end(const Func *f)
{
    L.frame_fully_dead = 0;
    ds_ndead = 0;                    /* [IR_DEADSTORE] per-fn dead-spill list reset */
    ds_last_framed = frame_has_saved_fp(f);   /* [#13] */
    if (!rec_counting) { rec_reset(); return; }
    /* Stop counting BEFORE the reports: our own slot_off() calls below must not
       self-increment rec_slotuse. */
    rec_counting = 0;
    if (rec_enabled()) {
        int homed = 0, ureg = 0, uslot = 0, uremat = 0, cold = 0;
        for (int v = 0; v < rec_nv && v < f->n_vregs; v++) {
            int total = rec_reg[v] + rec_slot[v] + rec_remat[v];
            if (!total) continue;
            int is_homed = f->vreg_to_phys && f->vreg_to_phys[v] != IR_PR_SPILL;
            if (!is_homed) continue;
            homed++; ureg += rec_reg[v]; uslot += rec_slot[v]; uremat += rec_remat[v];
            if (rec_reg[v] == 0) cold++;
            if (rec_on >= 2)
                fprintf(stderr, "IR_REC:   v%d[%s] reg=%d slot=%d remat=%d%s\n",
                        v, ir_phys_name(f->vreg_to_phys[v]),
                        rec_reg[v], rec_slot[v], rec_remat[v],
                        rec_reg[v] == 0 ? "  COLD-HOME" : "");
        }
        if (homed)
            fprintf(stderr, "IR_REC: %s homed=%d uses reg=%d slot=%d remat=%d "
                    "cold-homes=%d\n",
                    f->fn ? ir_sym_name(f->fn) : "?", homed, ureg, uslot, uremat,
                    cold);
    }
    /* Dead frame-slot report, per-BYTE and coalescing-aware. Slots are shared
       across non-interfering vregs, so a frame byte is DEAD only if every vreg
       covering it had no genuine frame-slot access (rec_slotuse over-counts
       non-emit slot_off checks → sound, never falsely dead). covered[p] = some
       SPILL vreg's slot spans byte p; live[p] = a vreg that DID access its slot
       spans p. dead = covered & !live — the exact droppable frame shrink. This
       is also increment-2's drop rule: only drop a slot whose members are ALL
       dead. */
    if ((deadframe_on() || dsx_enabled())
        && f->frame_size > 0 && f->vreg_spill_slot) {
        int fs = f->frame_size;
        char *covered = calloc((size_t)fs, 1);
        char *live    = calloc((size_t)fs, 1);
        if (covered && live) {
            for (int v = 0; v < rec_nv && v < f->n_vregs; v++) {
                /* ANY vreg owning a slot, not just the PR_SPILL ones: a
                   call-split / ranged home has a REGISTER phys and a slot (its
                   home outside the range). The clearing code below already
                   drops every slot regardless of phys — scanning only PR_SPILL
                   here meant the verdict was taken over fewer slots than it
                   then cleared. */
                int off = f->vreg_spill_slot[v];
                if (off < 0 || off >= fs) continue;
                int w = f->vregs[v].width > 0 ? f->vregs[v].width : 2;
                /* rec_slotuse only counts frame LOAD/STORE via slot_off; it does
                   NOT see address-of (&v) or wide (long) stores emitted via
                   push/pop — both reference the slot without slot_off. Treating
                   such a vreg as "dead" would drop a live slot (miscompile), so
                   for the elision verdict force its bytes live unless it's a
                   plain width<=2 non-addr-taken spill (the paths slot_off fully
                   covers). Sound: at worst keeps a frame that could go. */
                /* A RANGED home (call-split, or any home_lo/home_hi narrower
                   than the function) lives in its REGISTER inside the range and
                   in this slot outside it. Render 1 serves the in-range reads
                   from the register, so rec_slotuse can be 0 while the slot is
                   still the value's only home elsewhere — dropping it makes the
                   re-lower read a vreg with neither register nor slot
                   (require_slot abort). Not trustable, same as addr-taken. */
                int ranged = (f->vregs[v].flags & IR_VREG_CALL_SPLIT)
                          || (f->home_lo && f->home_hi
                              && (f->home_lo[v] != INT_MIN
                                  || f->home_hi[v] != INT_MAX));
                int trustable = w <= 2
                             && !(f->vregs[v].flags & IR_VREG_ADDR_TAKEN)
                             && !ranged;
                for (int p = off; p < off + w && p < fs; p++) {
                    covered[p] = 1;
                    if (rec_slotuse[v] != 0 || !trustable) live[p] = 1;
                }
            }
            int deadbytes = 0;
            for (int p = 0; p < fs; p++) if (covered[p] && !live[p]) deadbytes++;
            /* Whole frame dead → the pass driver re-lowers this function
               frameless (frame_size=0). Only every-byte-dead qualifies: a
               partial shrink would move live slot offsets. */
            L.frame_fully_dead = (deadbytes == fs);
        }
        /* [IR_FRAMEPROBE, INERT] Frame-traffic census. The +1921B (emu.c) /
           +192B (binary-trees) that 80cc spends on (ix+d) over sdcc is three
           different diseases wearing one symptom, and the aggregate cannot
           tell them apart:
             REDUNDANT reads  -> residency: the value was re-fetched inside a
                                 call-free region when a register would have
                                 held it. Fixable by keeping it resident.
             FIRST reads      -> unavoidable given the value is spilled at all.
             spilled VREGS    -> allocation pressure: too many values spilled
                                 in the first place. A different lever.
             width-4 traffic  -> a long costs 4 slot bytes per touch; sdcc does
                                 ALU straight off (ix+d) instead.
           Split by class (param / named local / compiler temp) because the
           fixes differ, and reported per function so a target can be picked.
           Reads are the honest emitted count (rec_slotuse - rec_slotwrite);
           `bytes` / `redbytes` are counted at the EMIT site (vemit) and are the
           convertible figures — validated to the assembler listing exactly on
           binary-trees (360) and to 0.5% on emu.c (6105 vs 6072).

           TWO THINGS A CONSUMER MUST KNOW.
           (1) The pass driver re-lowers functions (dead-store, deadframe,
               spflip), so a function can print more than once — keep the LAST
               line per name. On emu.c that is 74 lines for 45 functions;
               summing all of them gives 8250 instead of 6105.
           (2) `redundant` is an UPPER BOUND on the residency opportunity, not a
               saving. It counts every re-read in a call-free region, including
               ones no allocator could avoid because no register was free. The
               check: emu.c redundant = 3546 bytes, but sdcc compiles the same
               source with 4151 bytes of frame access against 80cc's 6072 — so
               at most 1921 is addressable. Use this census to find WHERE the
               traffic is, and the sdcc delta to bound HOW MUCH. */
        if (frameprobe_on()) {
            long rd[3] = {0,0,0}, wr[3] = {0,0,0}, red[3] = {0,0,0};
            long rd_w4 = 0, red_w4 = 0;
            int nspill = 0;
            for (int v = 0; v < rec_nv && v < f->n_vregs; v++) {
                if (!rec_slotuse[v]) continue;
                const VReg *vr = &f->vregs[v];
                int cls = (vr->flags & IR_VREG_PARAM) ? 0 : (vr->sym ? 1 : 2);
                int r = rec_slotuse[v] - (rec_slotwrite ? rec_slotwrite[v] : 0);
                int w = rec_slotwrite ? rec_slotwrite[v] : 0;
                if (r < 0) r = 0;
                rd[cls] += r; wr[cls] += w;
                red[cls] += rec_fh_red ? rec_fh_red[v] : 0;
                if (vr->width == 4) {
                    rd_w4 += r; red_w4 += rec_fh_red ? rec_fh_red[v] : 0;
                }
                nspill++;
            }
            long tr = rd[0]+rd[1]+rd[2], tw = wr[0]+wr[1]+wr[2];
            long tred = red[0]+red[1]+red[2];
            /* Emit-site bytes: the convertible number. tb is every byte of
               (ix/iy+d) this function emitted; trb the subset spent on reads
               classed redundant. tb is checkable against the listing. */
            long tb = 0, trb = 0;
            for (int v = 0; v < rec_nv && v < f->n_vregs; v++) {
                tb  += rec_fh_bytes    ? rec_fh_bytes[v]    : 0;
                trb += rec_fh_redbytes ? rec_fh_redbytes[v] : 0;
            }
            if (tr + tw > 0)
                fprintf(stderr,
                    "FRAMEPROBE %s spilled=%d reads=%ld writes=%ld redundant=%ld"
                    " bytes=%ld redbytes=%ld"
                    " | param r=%ld/red=%ld local r=%ld/red=%ld temp r=%ld/red=%ld"
                    " | w4 r=%ld/red=%ld\n",
                    f->fn ? ir_sym_name(f->fn) : "?", nspill, tr, tw, tred,
                    tb, trb,
                    rd[0], red[0], rd[1], red[1], rd[2], red[2], rd_w4, red_w4);
        }
        /* [IR_PARAMRELOAD, INERT] Per-PARAM actual slot READ count from this
           render — the honest mirage test. The allocator-side census counts raw
           refs; this counts reloads the lowerer really emitted
           (rec_slotuse - rec_slotwrite), so a value the belief cache serves
           shows 0-1 and a genuinely reloaded one shows its true cost. */
        if (getenv("IR_PARAMRELOAD")) {
            for (int v = 0; v < rec_nv && v < f->n_vregs; v++) {
                const VReg *vr = &f->vregs[v];
                if (!(vr->flags & IR_VREG_PARAM)) continue;
                if (f->vreg_to_phys && f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                int reads = rec_slotuse[v] - (rec_slotwrite ? rec_slotwrite[v] : 0);
                if (reads >= 2)
                    fprintf(stderr, "PARAMRELOAD %s v%d w=%d reads=%d\n",
                            f->fn ? ir_sym_name(f->fn) : "?", v, vr->width, reads);
            }
        }
        /* [IR_PARAMHOME, INERT] Sizing probe for the param register-home lever.
           IR_PARAMRELOAD above says WHICH params are reloaded and how often;
           this says what a register home would be WORTH, which is the number
           the lever has to be argued on.

           The gap this measures: a param read in place costs the frame-address
           setup plus the load at EVERY use, while a register home pays that
           once and then 2 bytes (push/pop) per call the live range crosses —
           what sdcc does with BC. The existing residency gates never see these
           values: IR_SPLIT_PROBE / IR_GPHOME_PROBE report nothing on a function
           whose params are read in place, because such a param is not a spilled
           reused vreg and so never enters the call-split candidate set.

           Per candidate: emitted reads (honest — belief-cache hits already
           removed), writes, calls crossed, and whether it is ever a deref base
           (the class Phase-1 call-split excludes, since `ld a,(bc)` serves those
           without a reload). `save` is bytes under the model below; the raw
           counts are there so the model can be re-argued without re-running.

           Approximations, all deliberately conservative:
             - the span is first-to-last op referencing v in linear op order,
               ignoring control flow, so a loop-carried param under-counts the
               calls actually crossed (save is over-stated for those — the
               deref/write columns are the ones to check before trusting a row);
             - only width<=2 scores, since a 4-byte param cannot live in one
               pair. Wider params print with save=0 rather than being dropped,
               so the reads they cost stay visible.

           IR_PARAMHOME=1 per-candidate lines + a per-function total;
           IR_PARAMHOME=2 adds the function totals for functions with no
           candidate, to confirm coverage rather than silence. */
        if (getenv("IR_PARAMHOME")) {
            int verbose = getenv("IR_PARAMHOME")[0] == '2';
            /* Bytes per counted read event. The two modes count DIFFERENT
               things, so the cost has to follow suit or fp reads score double:
                 sp — one event is a whole operand. `ld hl,N / add hl,sp` (4B)
                      forms the address once, then the load: +4B for a word
                      (ld a,(hl) / inc hl / ld h,(hl) / ld l,a), +1B for a byte.
                 fp — one event is a single (ix+d) byte access, 3B, no setup;
                      a word operand therefore counts twice and costs 3B twice.
               Cross-check on ItemCheck: 10 sp events and 20 fp events describe
               the same ten word loads, and 10*8 vs 20*3 put the two modes in
               the same range instead of an artificial 2x apart. */
            int fp = fp_active(f) && !L.cur_frameless;
            int cost_w = fp ? 3 : 8;      /* per read event, width-2 operand */
            int cost_b = fp ? 3 : 5;      /* per read event, width-1 operand */
            int fn_cands = 0, fn_reads = 0, fn_save = 0;
            for (int v = 0; v < rec_nv && v < f->n_vregs; v++) {
                const VReg *vr = &f->vregs[v];
                if (!(vr->flags & IR_VREG_PARAM)) continue;
                if (f->vreg_to_phys && f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) continue;
                int reads  = rec_slotuse[v] - (rec_slotwrite ? rec_slotwrite[v] : 0);
                int writes = rec_slotwrite ? rec_slotwrite[v] : 0;
                if (reads < 2) continue;
                /* Walk the function once: linear op index, first/last reference
                   to v, calls between them, and any use as a deref base. */
                int idx = 0, first = -1, last = -1, deref = 0;
                int ncall_before_first = 0, ncall_before_last = 0, ncall = 0;
                for (int b = 0; b < f->n_bbs; b++)
                    for (int j = 0; j < f->bbs[b].n_ops; j++, idx++) {
                        const Op *o = &f->bbs[b].ops[j];
                        if (o->kind == IR_CALL || o->kind == IR_HCALL) ncall++;
                        int u[16];
                        int nu = ir_op_uses(o, u, 16);
                        int refs = (o->dst == v);
                        for (int k = 0; k < nu && !refs; k++) refs = (u[k] == v);
                        if (!refs) continue;
                        if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                            && o->mem.kind == IR_MEM_VREG && o->mem.base == v)
                            deref = 1;
                        if (first < 0) { first = idx; ncall_before_first = ncall; }
                        last = idx; ncall_before_last = ncall;
                    }
                int calls = (first < 0) ? 0
                          : ncall_before_last - ncall_before_first;
                int save = 0;
                if (vr->width >= 1 && vr->width <= 2) {
                    int rc = (vr->width == 1) ? cost_b : cost_w;
                    save = (reads - 1) * rc - 2 * calls;
                    if (save < 0) save = 0;
                }
                fn_cands++; fn_reads += reads; fn_save += save;
                /* span = ops between first and last reference: a long span is
                   more likely to lose the register to pressure, so it tempers
                   `save` without changing it. */
                fprintf(stderr,
                        "PARAMHOME %s v%d w=%d reads=%d writes=%d calls=%d "
                        "span=%d deref=%d save=%d\n",
                        f->fn ? ir_sym_name(f->fn) : "?", v, vr->width,
                        reads, writes, calls, (first < 0) ? 0 : last - first,
                        deref, save);
            }
            if (fn_cands || verbose)
                fprintf(stderr, "PARAMHOME-FN %s mode=%s cands=%d reads=%d "
                        "save=%d\n",
                        f->fn ? ir_sym_name(f->fn) : "?", fp ? "fp" : "sp",
                        fn_cands, fn_reads, fn_save);
        }
        /* [IR_DEADSTORE, INERT] Write-only (dead-store) byte-slot report. Uses
           the read/write split: reads[v] = rec_slotuse[v] - rec_slotwrite[v].
           Coalescing-aware: readb[p]=1 iff SOME spill covering byte p was read,
           so a shared slot read via a different vreg keeps the store live (the
           set_arg1 protection). A trustable scalar spill written but with reads==0
           and NONE of its bytes read-by-others is a genuine dead store. No
           codegen change — this only prints; validates the model before elision. */
        char *readb = dsx_enabled() ? calloc((size_t)fs, 1) : NULL;
        /* [IR_DS_SHARE] The byte a coalesced reader reads WITHOUT EVER WRITING
           IT. `readb` blocks on any sharing reader at all, which is a blanket
           distrust of the slot allocator: ir_slots coalesces only vregs whose
           live ranges do not interfere, so a reader that also STORES its own
           slot is served by that store, never by the dead one — v is not live
           where the reader is, so v's store is either before the reader's def
           (overwritten) or after its last use (unobservable).
           What earned the distrust is the OTHER shape: a reader that reads a
           slot it never wrote, so its value must have been put there by
           somebody else's store — the slot is a channel between two vregs, and
           the dead-looking store is the thing filling it. That is set_arg1 at
           (ix-12), the miscompile this check was added for. Blocking on only
           that shape keeps the protection and stops vetoing the rest. */
        char *readb_chan = dsx_enabled() ? calloc((size_t)fs, 1) : NULL;
        if (readb && readb_chan && rec_slotwrite) {
            for (int v = 0; v < rec_nv && v < f->n_vregs; v++) {
                int is_spill = !f->vreg_to_phys || f->vreg_to_phys[v] == IR_PR_SPILL;
                int off = is_spill ? f->vreg_spill_slot[v] : -1;
                if (off < 0 || off >= fs) continue;
                if (rec_slotuse[v] - rec_slotwrite[v] <= 0) continue;   /* not read */
                int w = f->vregs[v].width > 0 ? f->vregs[v].width : 2;
                /* A reader is SELF-SERVED only if it has exactly ONE def and
                   that def stored the slot: then the slot holds its own value
                   at every read. rec_slotwrite>0 alone is not enough — a
                   multi-def reader can have one def that stores and another
                   that rides a register, and the non-storing path is then
                   served by whatever was in the slot, which is the store we
                   were about to elide. */
                int ndef = 0;
                for (int b = 0; b < f->n_bbs && ndef < 2; b++)
                    for (int j = 0; j < f->bbs[b].n_ops; j++)
                        if (f->bbs[b].ops[j].dst == v && ++ndef >= 2) break;
                int self_served = (ndef == 1 && rec_slotwrite[v] > 0);
                for (int p = off; p < off + w && p < fs; p++) {
                    readb[p] = 1;
                    if (!self_served) readb_chan[p] = 1;
                }
            }
            int nfn = 0;
            for (int v = 0; v < rec_nv && v < f->n_vregs; v++) {
                if (!f->vreg_to_phys || f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                const VReg *vr = &f->vregs[v];
                int off = f->vreg_spill_slot[v];
                if (off < 0 || off >= fs) continue;
                if (rec_slotwrite[v] == 0) continue;                   /* not written */
                if (rec_slotuse[v] - rec_slotwrite[v] != 0) continue;  /* is read */
                Kind vk = vr->kind;
                int scalar = vk == KIND_CHAR || vk == KIND_SHORT || vk == KIND_INT
                          || vk == KIND_LONG || vk == KIND_PTR || vk == KIND_ENUM
                          || vk == KIND_CARRY;
                int w = vr->width > 0 ? vr->width : 2;
                if (!scalar || w > 4
                    || (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                     | IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE
                                     | IR_VREG_NO_SLOT)))
                    continue;
                int shared_read = 0;                    /* coalesced-with-a-reader? */
                const char *blockmap = ds_share_on() ? readb_chan : readb;
                for (int p = off; p < off + w && p < fs; p++)
                    if (blockmap[p]) { shared_read = 1; break; }
                if (shared_read) {
                    if (dsx_on >= 2)
                        fprintf(stderr, "IR_DEADSTORE:   v%d w=%d slot=%d write-only "
                                "but slot COALESCED-READ — keep\n", v, w, off);
                    continue;
                }
                nfn++;
                if (ds_ndead < (int)(sizeof ds_dead / sizeof ds_dead[0]))
                    ds_dead[ds_ndead++] = v;
                if (dsx_on >= 2)
                    fprintf(stderr, "IR_DEADSTORE:   v%d w=%d slot=%d wr=%d rd=0 "
                            "DEAD-STORE\n", v, w, off, rec_slotwrite[v]);
            }
            if (nfn && dsx_on >= 2)   /* report only at IR_DEADSTORE=2 — default-on
                                         must be SILENT (was printing every compile) */
                fprintf(stderr, "IR_DEADSTORE: %s dead-stores=%d\n",
                        f->fn ? ir_sym_name(f->fn) : "?", nfn);
        }
        free(readb);
        free(readb_chan);
        free(covered); free(live);
    }
    /* [#13, INERT] frameless-via-sp cost model. A function that emitted the IX
       apparatus (frame_has_saved_fp) but made ZERO (ix+-d) data accesses
       (ds_ixaccess==0) wastes the whole ~11B apparatus — its frame is serviced
       sp-relative (sp-parking / add hl,sp), so a genuine-sp flip is ~zero-cost.
       With ds_ixaccess>0 the flip costs ~+2B per access (sp vs ix), so flip iff
       2*N < save. Reports only; no codegen change. */
    if (ff_enabled() && frame_has_saved_fp(f)) {
        int N = ds_ixaccess;
        int save = 11;                       /* push ix;ld ix,0;add ix,sp;ld sp,ix;pop ix */
        int cost = 2 * N;
        fprintf(stderr, "IR_FLIPCOST: %-24s ixacc=%-3d frame=%-3d save=%d cost=%d %s\n",
                f->fn ? ir_sym_name(f->fn) : "?", N, f->frame_size, save, cost,
                N == 0 ? "ZERO-COST-FLIP"
                       : (cost < save ? "FLIP" : "keep"));
    }
    rec_reset();
}

/* Cross-check the just-lowered op's emitted instructions against op_clobbers.
   Logs (does not abort) so a full corpus run reveals every model gap. */
static void ir_verify_op(const Func *f, const Op *op, const char *buf)
{
    RegMask actual = 0, pushed = 0; int unknown = 0;
    RegMask self_pres = 0, swapped = 0;   /* value-change refinements (instr_effects) */
    char line[256]; const char *p = buf;
    while (*p) {
        int i = 0; while (*p && *p != '\n' && i < 255) line[i++] = *p++;
        line[i] = 0; if (*p == '\n') p++;
        if (!line[0]) continue;
        /* A push R / pop R pair PRESERVES R (net not clobbered), even if R is
           used as scratch in between: record what's saved, and on a matching
           pop clear that reg from the accumulated writes. */
        if (!strncmp(line, "push", 4)) {
            RegMask r = lra_reg_of(line + 5);
            pushed |= r;
        } else if (!strncmp(line, "pop", 3)) {
            RegMask r = lra_reg_of(line + 4);
            if (pushed & r) { actual &= ~r; pushed &= ~r; continue; }  /* restore */
        }
        { InstrEffects e = instr_effects(line);
          actual |= e.writes; self_pres |= e.self_pres; swapped |= e.swapped;
          if (e.unknown) unknown = 1; }
    }
    /* IR_CLOB_VERIFY stale-cache check: the op's emitted code ACTUALLY wrote a
       reg (in `actual`), yet rs.<reg> still equals the pre-op snapshot (a live
       vreg) — the physical reg was clobbered but the residency cache still claims
       the old owner. A later cache-hit on that vreg would serve a stale value.
       Uses `actual` (from lra_line_writes, push/pop-restore aware) so an op that
       net-preserves a reg via push/pop is NOT flagged. */
    if (clob_verify_on > 0) {
        /* A VALUE-CHANGING write is one the cache can't survive: drop the flag-test/
           self-preserving writes (`or a`) and reg-reg swaps (`ex de,hl` — the cache
           should follow the permutation, not go stale). */
        RegMask vchg = actual & ~self_pres & ~swapped;
        struct { RegMask m; int snap; int post; const char *nm; } ck[4] = {
            { IR_R_HL, clob_snap_hl, L.rs.hl, "HL" },
            { IR_R_DE, clob_snap_de, L.rs.de, "DE" },
            { IR_R_BC, clob_snap_bc, L.rs.bc, "BC" },
            { IR_R_A,  clob_snap_a,  L.rs.a,  "A"  },
        };
        for (int i = 0; i < 4; i++) {
            if (!((vchg & ck[i].m) && ck[i].snap >= 0 && ck[i].post == ck[i].snap
                  && op->dst != ck[i].snap))   /* not a re-def of its own claimed vreg */
                continue;
            /* Forward-liveness gate: a stale claim is only HARMFUL if the claimed
               vreg is LIVE after the op — a dead claim is never read back, so the
               stale cache can't miscompile. (Necessary-not-sufficient: a live vreg
               might still reload from its slot rather than hit the stale reg-cache,
               so this over-reports vs the true read-back count, but it removes the
               benign-dead bulk.) Same liveness query the I2 check uses below. */
            int live_out;
            if (cur_bb && cur_op_idx + 1 < cur_bb->n_ops) {
                const BitSet *lo = ir_op_live_in(cur_bb, cur_op_idx + 1);
                live_out = lo && ir_bitset_get(lo, ck[i].snap);
            } else if (cur_bb) {
                live_out = cur_bb->live_out
                    && ir_bitset_get((const BitSet *)cur_bb->live_out, ck[i].snap);
            } else live_out = 1;
            if (!live_out) continue;   /* dead claim → benign */
            fprintf(stderr,
                "IR_CLOB_VERIFY: %s (bb%d op%d dst=%d) wrote %s but rs.%s still "
                "claims v%d (LIVE) — STALE CACHE\n",
                ir_op_name(op->kind), cur_bb ? cur_bb->id : -1, cur_op_idx,
                op->dst, ck[i].nm, ck[i].nm, ck[i].snap);
            clob_verify_count++;
        }
    }

    if (verify_on <= 0) return;   /* below is the IR_VERIFY op_clobbers leak check */
    RegMask model = op_clobbers(f, op);
    /* SP (stack-spill push/pop, ret) and MEM are stack/memory bookkeeping, not
       value-register residency — not part of the clobber soundness check. */
    RegMask leak = actual & ~model & ~IR_R_MEM & ~IR_R_SP;
    if (leak) {
        fprintf(stderr, "IR_VERIFY: %s writes %#x not in clobbers %#x | asm:",
                ir_op_name(op->kind), (unsigned)leak, (unsigned)model);
        const char *q = buf; char ln[256];
        while (*q) { int k=0; while (*q && *q!='\n' && k<255) ln[k++]=*q++; ln[k]=0; if(*q=='\n')q++;
            if (ln[0] && (instr_effects(ln).writes & leak)) fprintf(stderr, " [%s]", ln); }
        fprintf(stderr, "\n");
    }
    if (unknown)
        fprintf(stderr, "IR_VERIFY: %s emitted an unmodelled mnemonic\n",
                ir_op_name(op->kind));

    /* Interval-level check (ADR 0017 I2, step 3b) — WIP, opt-in IR_VERIFY_I2.
       Within the home's EFFECTIVE resident region, no op's ACTUAL emitted writes
       may include the home register unless the op (re)defines the home. The intent
       is a soundness net for an over-admitted region (the op-level leak check
       can't catch it — such a clobber is within the op's own op_clobbers).
       KNOWN LIMITATION (why it's opt-in, not under plain IR_VERIFY yet): DE-clean
       lowering uses the `ex de,hl` PARK idiom (swap home into HL, operate, swap
       back). lra_line_writes counts each `ex de,hl` as a DE write and does no
       dataflow, so this FALSE-FIRES on the park idiom (the AND/bitop region cases).
       A robust I2 net for DE homes needs value-dataflow-aware effects (the ADR's
       "effects declared, not parsed" model) — see RESIDENCY_REDESIGN_PLAN.md §3b(ii).
       Kept opt-in for investigating the non-park fires (e.g. wide LD_MEM). */
    if (getenv("IR_VERIFY_I2")
        && L.cur_func_ehome >= 0 && L.cur_home_region_lo >= 0 && cur_bb
        && cur_bb->id >= L.cur_home_region_lo
        && cur_bb->id <= L.cur_home_region_hi) {
        RegMask hm = phys_regmask(f, L.cur_func_ehome);
        /* Liveness gate: a clobber of the home register only matters if the home
           is still LIVE after this op. A DEAD home (last use here or earlier) may
           have its register reused freely — the region proof neither does nor need
           protect a dead value (e.g. a sign test `sla e` that consumes the home, or
           a park `ex de,hl; ld hl,K; …; ex de,hl` where the home isn't read again).
           Without this gate the check false-fires on every such dead-home op. */
        int home_live_out;
        if (cur_op_idx + 1 < cur_bb->n_ops) {
            const BitSet *lo = ir_op_live_in(cur_bb, cur_op_idx + 1);
            home_live_out = lo && ir_bitset_get(lo, L.cur_func_ehome);
        } else {
            home_live_out = cur_bb->live_out
                && ir_bitset_get((const BitSet *)cur_bb->live_out, L.cur_func_ehome);
        }
        /* A reg-reg swap (ex de,hl / exx) is a permutation, not a clobber of the
           home's VALUE — exclude it (kills the DE-home `ex de,hl` park false-fire
           noted below), now that instr_effects distinguishes it. */
        if (hm && (actual & hm & ~swapped) && home_live_out) {
            int defs[8]; int nd = ir_op_defs(op, defs, 8);
            int home_def = 0;
            for (int k = 0; k < nd; k++)
                if (defs[k] == L.cur_func_ehome) { home_def = 1; break; }
            if (!home_def) {
                fprintf(stderr,
                    "IR_VERIFY: I2 home v%d(w=%d,word=%d) region [%d,%d]: %s dst=%d at bb%d clobbers home reg "
                    "%#x (asm-actual %#x) | asm:",
                    L.cur_func_ehome, f->vregs[L.cur_func_ehome].width, g_hc.home_is_word,
                    L.cur_home_region_lo, L.cur_home_region_hi,
                    ir_op_name(op->kind), op->dst, cur_bb->id, (unsigned)hm, (unsigned)actual);
                const char *q = buf; char ln[256];
                while (*q) { int k2=0; while (*q && *q!='\n' && k2<255) ln[k2++]=*q++; ln[k2]=0; if(*q=='\n')q++;
                    if (ln[0]) fprintf(stderr, " [%s]", ln); }
                fprintf(stderr, "\n");
            }
        }
    }
}


static int lower_op(FILE *out, Func *f, const Op *op)
{
    /* Track the op's source location (independent of C_LINE emit mode) so
       a lowering abort can name file:line + echo the source line. */
    lower_cur_file = op->file;
    lower_cur_line = op->line;
    lower_cur_op   = op;
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
    case IR_COPY_STEP_BRZ:     return gen_copy_step_brz(out, f, op);
    case IR_DEREF_CMP_BR:      return gen_deref_cmp_br(out, f, op);
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
    case IR_MUL:               return gen_mul(out, f, op);
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
        } else if (f->ret_width == 1) {
            /* Byte-declared function: the char-return ABI hands back only the
               low byte (in L); callers re-zero/sign-extend the result
               themselves (the frontend emits a CONV on the call result — see
               use_int/use_or). So materialise just the low byte and skip the
               `ld h,0` zero-extend that load_to_hl would add — H is dead.
               (ir_opt_narrow_byte narrows the value's IR width for this same
               reason, but the RET lowering still widened it to HL.) */
            if (!hl_has(op->src[0])) {
                load_byte_to_a(out, f, op->src[0]);
                emit(out, "ld\tl,a");
            }
        } else {
            if (!hl_has(op->src[0]))
                load_to_hl(out, f, op->src[0]);
        }
    }
    if (fp_active(f) && !L.cur_frameless) {
        /* FP teardown: IX holds the saved-IX address (frame_top). `ld sp,ix`
           drops the locals, then `pop ix` restores caller's IX. Both preserve
           DEHL (and HL alone), so int-return and long-return converge here.
           idx3/IY-home in fp mode: the prologue pushed ix THEN iy, so after
           `ld sp,ix` (ix == &saved_iy) the saved IY is on top — pop it BEFORE
           the frame ptr, or `pop ix` would read the IY slot. */
        const char *fr = frame_reg();
        emit(out, "ld\tsp,%s", fr);
        if (frame_has_saved_iy(f)) emit(out, "pop\tiy");
        emit(out, "pop\t%s", fr);
    } else if (!L.cur_frameless && f->frame_size > 0) {
        if (use_add_sp(f, f->frame_size, is_acc ? 0 : 2)) {
            /* add sp,d preserves HL/DE/BC, so the int/long return-value
               stashes below are unneeded — drop the frame in one chain. */
            emit_add_sp_chain(out, f->frame_size);
        } else if (f->frame_size <= 4 && tos_pushpop_ok(f)) {
            /* Small frame: reclaim with `pop af` (2 bytes) / `inc sp` (1) — both
               preserve HL/DE/BC, so the return value (HL / DE:HL) survives with
               NO ex-de-hl / bc stash, and it is smaller AND faster than the
               `ld hl,N; add hl,sp; ld sp,hl` restore. `pop af` clobbers only AF,
               which never holds a return value (HL / DEHL / memory-acc).
               Gated to tos_pushpop_ok CPUs: kc160 has dear push/pop and cheap
               sp addressing, so `pop af` there is a byte win but a tick loss. */
            int n = f->frame_size;
            while (n >= 2) { emit(out, "pop\taf"); n -= 2; }
            if (n) emit(out, "inc\tsp");
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
           above, so sp now points at the saved regs — pop the saved IY first
           (pushed last, on top) then restore the caller's IX (frame ptr) so
           `ret` reads the return address. Touches only IX/IY/SP, leaving the
           return value in HL/DEHL/FA intact. (fp_active handled IY in its own
           teardown above; this branch is the !fp_active acc-tier case only.) */
        if (frame_has_saved_iy(f)) emit(out, "pop\tiy");
        emit(out, "pop\t%s", frame_reg());
    } else if (!fp_active(f) && (frame_has_saved_iy(f) || frame_has_saved_ix(f))) {
        /* Pure sp-mode: restore the saved index regs before the return address is
           read. Prologue pushed IY (idx3) THEN IX (flipped idx2), so IX is on top
           — pop it first. Touches only IX/IY/SP. */
        if (frame_has_saved_ix(f)) emit(out, "pop\tix");
        if (frame_has_saved_iy(f)) emit(out, "pop\tiy");
    }
    if (frame_has_debug_fp(f)) {
        /* no-IX -debug teardown: the frame drop above left sp at the saved
           __debug_framepointer. l_debug_pop_frame restores it and removes the
           2-byte save, preserving the return value in HL/DEHL (clobbers BC).
           Sits below any critical l_pop_ei, matching the prologue push order. */
        emit(out, "call\tl_debug_pop_frame");
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
    if (frame_has_saved_iy(f))      /* idx3: preserve caller's IY (callee-saved),
                                       below the return address / above the frame */
        emit(out, "push\tiy");
    if (frame_has_saved_ix(f)) /* sp-mode fn that uses IX: preserve the caller's
                                       IX (callee-saved — frame ptr for fp/sdcc
                                       callers, #13-flip's fp caller) */
        emit(out, "push\tix");
    if (frame_has_debug_fp(f))      /* no-IX -debug: chain __debug_framepointer.
                                       Pushes 2 bytes, preserves HL (fastcall arg),
                                       clobbers BC — must precede the fastcall/sc1
                                       register stash below and the frame alloc. */
        emit(out, "call\tl_debug_push_frame");

    /* FRAMEPTR setup. Point IX at entry-sp when FP addressing is active;
       must be set BEFORE the frame alloc so it captures sp between locals
       and caller's frame for full [-128,+127] reach per slot. Teardown is
       ours too (IR emits `ret` directly, gen_pop_frame doesn't fire). */
    if (fp_active(f) && !L.cur_frameless) {
        const char *fr = frame_reg();
        if (IS_KC160()) {
            /* kc160: IX/IY = SP in one op (`ld ix,sp` ED 06 / `ld iy,sp` ED 16),
               vs the generic `ld <fr>,0; add <fr>,sp`. */
            emit(out, "ld\t%s,sp", fr);
        } else {
            emit(out, "ld\t%s,0", fr);
            emit(out, "add\t%s,sp", fr);
        }
    }
    /* Fastcall arg arrives in HL (width 1/2), DEHL (width 4), or the
       memory accumulator fa / __i64_acc (width 5/6/8) — not on the caller
       stack. The frame alloc below clobbers HL, so stash the register
       cases across it: width 1/2 → DE (free); width 4 → the low half in BC
       (free at fastcall entry — only DEHL holds the arg), DE keeps the high
       half. A wide acc arg is memory-resident and survives the frame alloc,
       so it needs no stash. Placed into the param's home after the frame. */
    int fc_vreg = fastcall_arg_vreg(f);
    int fc_autopush = (fc_vreg >= 0)
                   && (f->vregs[fc_vreg].flags & IR_VREG_AUTOPUSH);
    int autopush_bytes = 0;
    if (fc_autopush) {
        /* Materialise the param on the stack at the TOP of the frame: push it
           here (after any IX setup, before the frame alloc) so it lands just
           below the return address / saved IX. width 4 → `push de; push hl`
           leaves L,H,E,D low→high = correct little-endian long; width 2 →
           `push hl`. The push IS the store — no stash, no reconstruct, and it
           drops out of the frame alloc below. */
        int w = f->vregs[fc_vreg].width;
        if (w == 4) { emit(out, "push\tde"); emit(out, "push\thl"); autopush_bytes = 4; }
        else        { emit(out, "push\thl");                        autopush_bytes = 2; }
    } else if (fc_vreg >= 0) {
        int w = f->vregs[fc_vreg].width;
        if (w == 4) {
            emit_hl_to_bc(out);          /* low half → BC */
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
            emit_hl_to_bc(out);          /* 1st (int) → BC across frame alloc */
        } else if (sc1_ok && sc1_r1 == SC1_DEHL) {
            emit(out, "ex\tde,hl");      /* sc1 HLDE -> native DEHL (HL=lo, DE=hi) */
            emit_hl_to_bc(out);          /* low half → BC across frame alloc */
        } else if (sc1_ok && sc1_r2 == SC1_L) {
            emit(out, "ld\tc,l");        /* 2nd char (L) → C across frame alloc
                                            (1st char in A survives) */
        }
    }

    /* Allocate the frame. An auto-pushed param already occupies the top
       `autopush_bytes` of the frame (materialised by the push above), so
       allocate only the remainder; the epilogue still reclaims the full
       frame_size (the push included). */
    int alloc_size = f->frame_size - autopush_bytes;
    if (alloc_size > 0) {
        if (use_add_sp(f, -alloc_size, 0)) {
            emit_add_sp_chain(out, -alloc_size);
        } else if (alloc_size <= 4) {
            /* Small frame: reserve with `push af` (2 bytes) + `dec sp` (1) — 1-2
               instructions vs the 5-byte `ld hl,-N; add hl,sp; ld sp,hl`, and
               clobbers no register (push af leaves A/F unchanged; the ld-hl form
               destroys HL). The pushed garbage becomes frame slots, overwritten
               by spills before any read (same as the ld-hl form leaves garbage). */
            int n = alloc_size;
            while (n >= 2) { emit(out, "push\taf"); n -= 2; }
            if (n) emit(out, "dec\tsp");
        } else {
            emit(out, "ld\thl,-%d", alloc_size);
            emit(out, "add\thl,sp");
            emit(out, "ld\tsp,hl");
        }
    }

    if (fc_autopush) {
        /* Already materialised on the stack (its slot IS the pushed word).
           `push hl` left the param in HL; whether it survives is down to the
           FRAME ALLOC, not the push: the `ld hl,-N` form destroys HL, but
           `dec sp`/`push af` (alloc_size<=4) and a zero-size alloc leave it
           intact. When HL is preserved and the param fits it (width<=2),
           advertise HL=param so the first use reads `ld a,l` / from HL instead of
           reloading the slot we just pushed. (Autopush now only fires for a SOLE
           fastcall param, so there is no caller-stack param whose sp-relative
           read this HL belief could race.) A byte's high half may be junk, but
           width-1 reads go through load_byte_to_a (`ld a,l`) and any widen
           re-zeroes H, so it never leaks. */
        if (alloc_size <= 4 && f->vregs[fc_vreg].width <= 2)
            hl_about_to_change(fc_vreg);
        else
            invalidate_hl_bc();
        invalidate_de_cache();
    } else if (fc_vreg >= 0 && f->vregs[fc_vreg].width > 4) {
        /* wide (acc-tier) arg: still in fa / __i64_acc (memory) — store it
           to the param's slot, like gen_ld_mem's wide path. */
        emit_acc_slot_addr(out, f, fc_vreg, 0);
        emit_acc_store_hl(out, f, fc_vreg);
        invalidate_hl_bc();
        *wide_acc_cell(f, fc_vreg) = fc_vreg;
    } else if (fc_vreg >= 0 && f->vregs[fc_vreg].width == 4) {
        /* width-4: the arg's high half survived in DE and the low half in BC
           (the pre-frame stash); HL was clobbered by the frame alloc.
           Reconstruct DEHL (low half from BC) and place it in the param's
           home (DEHL register or slot). */
        emit_bc_to_hl(out);
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
                emit_bc_to_hl(out);        /* native DEHL: HL=low (from BC) */
                store_dehl_finalize(out, f, sc1_p1);
            } else {                       /* 1st int stashed in BC */
                emit_bc_to_hl(out);
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
                    + (frame_has_saved_iy(f) ? 2 : 0)   /* saved IY (idx3) */
                    + (frame_has_saved_ix(f) ? 2 : 0)  /* [#13] flipped-fn saved IX */
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
            emit_hl_to_idx_word(out, f, v->id);
            invalidate_hl_cache();
            continue;
        }
        /* exx/alt-bank invariant param: load it into the alt pair ONCE. In the
           alt bank (`exx`) read the caller slot via the alt HL (scratch) into
           the home pair's halves, then swap back. sp is unchanged by exx, so
           poff is valid; the alt bank isn't stacked, so no offset shift. */
        if (vreg_in_exx(f, v->id) && width == 2) {
            emit(out, "exx");
            emit(out, "ld\thl,%d", poff);
            emit(out, "add\thl,sp");
            emit(out, "ld\t%s,(hl)", exx_half_lo(f));
            emit(out, "inc\thl");
            emit(out, "ld\t%s,(hl)", exx_half_hi(f));
            emit(out, "exx");
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

/* Is the def at bb->ops[j] "dst-dead" — its result is consumed only from the
   HL/DEHL/A register cache and never re-read from a frame slot, so its spill
   store can be skipped? Pure (f, bb, j); the render sets L.la.cur_dst_dead from
   it, and the slot allocator's no-slot pruning reuses it (same predicate → the
   two never disagree on whether a slot is touched). Extracted verbatim from the
   render's inline computation. */
/* For a BR_ZERO/BR_COND at bb->ops[j]: is the tested value src[0] DEAD after the
   branch (not live-out, not addr-observable, no later in-BB use)? If so the
   zero-test needn't materialise the value in a register (the fall-through won't
   reuse it) — emit_test_zero can test a slot word in place. Mirror of
   def_dst_dead's liveness logic for the src side. */
static int br_value_dead_after(const Func *f, const BB *bb, int j)
{
    const Op *op = &bb->ops[j];
    if (op->kind != IR_BR_ZERO && op->kind != IR_BR_COND) return 0;
    int v = op->src[0];
    if (v < 0 || v >= f->n_vregs) return 0;
    if (f->vregs[v].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (bb->live_out && ir_bitset_get((const BitSet *)bb->live_out, v)) return 0;
    for (int k = j + 1; k < bb->n_ops; k++) {
        int u[16]; int nu = ir_op_uses(&bb->ops[k], u, (int)(sizeof u / sizeof u[0]));
        for (int i = 0; i < nu; i++) if (u[i] == v) return 0;
        if (bb->ops[k].dst == v) return 1;   /* redefined → old value dead */
    }
    return 1;
}

static int def_dst_dead(const Func *f, const BB *bb, int j)
{
    const Op *op = &bb->ops[j];
    if (op->dst < 0) return 0;
    int live_out_dst = bb->live_out
        && ir_bitset_get((const BitSet *)bb->live_out, op->dst);
    int addr_observable = (f->vregs[op->dst].flags
        & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) != 0;
    /* Byte copy-loop idiom `while ((*d++ = v))` — a width-1 dst stored then
       zero-branched, no other use: rides A across both (see the render). */
    if (!addr_observable && !live_out_dst
        && f->vregs[op->dst].width == 1 && j + 2 < bb->n_ops) {
        const Op *st = &bb->ops[j + 1];
        const Op *br = &bb->ops[j + 2];
        if (st->kind == IR_ST_MEM && st->mem.kind == IR_MEM_VREG
            && st->src[0] == op->dst && st->mem.base != op->dst
            && !st->mem.bank_fn
            && (br->kind == IR_BR_ZERO || br->kind == IR_BR_COND)
            && br->src[0] == op->dst) {
            int only_two = 1;
            for (int k = j + 3; k < bb->n_ops && only_two; k++) {
                int uu[16];
                int nu2 = ir_op_uses(&bb->ops[k], uu,
                                     (int)(sizeof uu / sizeof uu[0]));
                for (int u = 0; u < nu2; u++)
                    if (uu[u] == op->dst) { only_two = 0; break; }
            }
            if (only_two) return 1;
        }
    }
    if (!addr_observable && !live_out_dst) {
        int safe = 1;
        int allow_cache_hit = 1;
        int cache_pos = 0;
        if (j + 1 < bb->n_ops && f->vregs[op->dst].width == 4) {
            int p = nxt_first_dehl_src(&bb->ops[j + 1]);
            if (p >= 0) cache_pos = p;
        }
        for (int k = j + 1; k < bb->n_ops && safe; k++) {
            int uses[16];
            int nu = ir_op_uses(&bb->ops[k], uses,
                                (int)(sizeof uses / sizeof uses[0]));
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
            if (!safe) break;
            if (bb->ops[k].kind == IR_PUSH_DEHL_LONG
                && bb->ops[k].src[0] == op->dst)
                break;
            int defs[2];
            int nd = ir_op_defs(&bb->ops[k], defs, 2);
            int redef = 0;
            for (int d = 0; d < nd; d++)
                if (defs[d] == op->dst) { redef = 1; break; }
            if (redef) break;
        }
        if (safe) return 1;
    }
    return 0;
}

/* A rematerialisable NO_SLOT def (a global address `ld hl,_sym` or an immediate)
   whose value is never read again IN ITS OWN BB. Its register materialisation is
   then dead: every reader rematerialises (a same-cost `ld rp,_sym`/`ld rp,K`),
   so emitting the def just to have its register clobbered before any same-BB read
   is pure waste — the classic loop-preheader `ld hl,_sym` the body overwrites
   before use. KEEP it when a same-BB reader exists (that reader can share the
   register); cross-BB readers rematerialise regardless, so skipping is at worst
   byte-neutral there and a win when the def is otherwise dead. */
static int remat_def_materialization_dead(const Func *f, const BB *bb, int j)
{
    const Op *op = &bb->ops[j];
    if (op->dst < 0 || !vreg_is_remat(f, op->dst)) return 0;
    for (int k = j + 1; k < bb->n_ops; k++) {
        int u[16];
        int nu = ir_op_uses(&bb->ops[k], u, (int)(sizeof u / sizeof u[0]));
        for (int i = 0; i < nu; i++)
            if (u[i] == op->dst) return 0;   /* same-BB reader → keep the def */
    }
    return 1;
}

/* A NO_SLOT byte rides A from its def straight to its consumer and is never
   written back. That is only sound when the consumer READS the byte from A and
   can never need to spill it to a slot. Terminal A-readers qualify: a memory
   store of the byte (ST_MEM) and a branch test (BR_ZERO/BR_COND) — the exact
   shapes the copy-loop / `while (*s)` / `*d = *s` idioms produce.

   Byte ALU / MOV / widening consumers do NOT qualify: their operand staging
   can `store_a_byte` an A-resident operand to a slot (e.g. gen_sub spills the
   subtrahend to free A; a def that clobbers A spills a still-live A byte), and
   with no slot that lands below-frame / aborts. Those keep their slot. This
   was the umaxd.c:49 abort — a byte `o[p+16]` deref whose value flowed to a
   MOV kept in A, then got spilled during a neighbouring op's A staging. */
static int no_slot_consumer_safe(const Func *f, const BB *bb, int j)
{
    int v = bb->ops[j].dst;
    if (j + 1 >= bb->n_ops) return 0;
    const Op *use = &bb->ops[j + 1];
    switch (use->kind) {
    case IR_ST_MEM:                       /* store the byte to memory */
        /* The base!=v aliasing guard only applies to a VREG (pointer) store —
           a SYM/absolute store has no base vreg (mem.base is unused/0, which
           would spuriously alias a value vreg that happens to be id 0). */
        return use->src[0] == v
            && (use->mem.kind != IR_MEM_VREG || use->mem.base != v);
    case IR_BR_ZERO:                      /* test the byte, branch */
    case IR_BR_COND:
        return use->src[0] == v;
    case IR_CONV_ZX:                      /* widen byte→int/long: reads the */
    case IR_CONV_SX:                      /* byte from A (`ld l,a; ld h,0` / */
        return use->src[0] == v;          /* sign-extend), never from a slot */
    case IR_CMP_EQ: case IR_CMP_NE:       /* byte compare vs an IMMEDIATE: the */
    case IR_CMP_LT: case IR_CMP_LE:       /* one register operand is read from */
    case IR_CMP_GT: case IR_CMP_GE:       /* A (`cp n`), no second operand to */
    case IR_CMP_ULT: case IR_CMP_ULE:     /* stage → A never spills to a slot. */
    case IR_CMP_UGT: case IR_CMP_UGE:     /* (A two-register compare CAN spill */
        return use->src[0] == v           /* an operand — excluded.) */
            && use->src[1] < 0;
    default:
        return 0;
    }
    (void)f;
}

/* Dead-slot pruning: flag byte SPILL vregs that never touch a frame slot, so
   ir_assign_slots reserves none (shrinking frame_size, often to 0). A byte vreg
   is A-only iff EVERY def is dst-dead AND feeds a terminal A-reader
   (no_slot_consumer_safe) — then lowering keeps each result in A, serves the use
   from the cache, and never spills it. Runs after ir_alloc (needs phys) and
   before ir_assign_slots. Word/wider temps keep the ss dead-store pass; this is
   the byte analogue the ss machinery doesn't cover. */
static void compute_no_slot_bytes(Func *f)
{
    if (opt_disabled("slot-prune")) return;
    for (int v = 0; v < f->n_vregs; v++) {
        VReg *vr = &f->vregs[v];
        if (vr->width != 1) continue;
        if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                         | IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE)) continue;
        if (f->vreg_to_phys && f->vreg_to_phys[v] != IR_PR_SPILL) continue;
        int n_defs = 0, all_dead = 1;
        for (int b = 0; b < f->n_bbs && all_dead; b++) {
            const BB *bb = &f->bbs[b];
            for (int j = 0; j < bb->n_ops; j++) {
                int defs[2];
                int nd = ir_op_defs(&bb->ops[j], defs, 2);
                int is_def = 0;
                for (int k = 0; k < nd; k++) if (defs[k] == v) { is_def = 1; break; }
                if (!is_def) continue;
                n_defs++;
                /* Only a plain single-dst def can be an A-only byte: a POSTSTEP
                   or post-step LD_MEM redefines its base too (multi-def) — never
                   the A-cached shape. def_dst_dead vets the value flow; the
                   consumer must be a terminal A-reader that never spills it. */
                if (bb->ops[j].dst != v || !def_dst_dead(f, bb, j)
                    || !no_slot_consumer_safe(f, bb, j)) {
                    all_dead = 0; break;
                }
            }
        }
        if (n_defs >= 1 && all_dead)
            vr->flags |= IR_VREG_NO_SLOT;
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

   DEFAULT-ON, SP-MODE ONLY (--opt-disable=idxhalf opts out). Homing a byte in an index
   half CLOBBERS the whole IX/IY, both callee-saved in the z88dk ABI — e.g.
   l_qsort/l_bsearch hold the comparator fnptr in IY across the comparator call,
   so a leaf that homes a byte in IYL/IYH must preserve the caller's IY. That is
   now handled: frame_has_saved_ix / frame_has_saved_iy push/pop the index reg
   whenever a byte-half home occupies it (sp idx2=IX, idx3=IY). SP MODE ONLY for
   two reasons: (1) fp barely benefits (idx read ≈ cheap (ix+d) slot); (2) the
   frame_has_saved_iy +2 param-offset compensation is sp-relative — fp params are
   (ix+d) and would need separate handling. So we never idxhalf in fp: the value
   isn't there AND the fp offset path never runs. NET-BYTE gate below: only home
   when it saves code (in sp the dear `ld hl,N;add hl,sp` slot access makes byte
   and cycle savings correlate, so net-bytes>0 ⇒ a balanced win; the gate rejects
   break-even shapes that only pay the +4B IY-save). */
static int idxhalf_enabled(void)
{
    return !opt_disabled("idxhalf");   /* default on; --opt-disable=idxhalf opts out */
}
static void assign_idxhalf_homes(Func *f)
{
    if (!idxhalf_enabled()) return;                 /* default on; --opt-disable=idxhalf opts out */
    if (c_framepointer_is_ix != -1) return;         /* SP MODE ONLY (see above) */
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || IS_EZ80())) return;
    if (!f || f->n_vregs <= 0 || !f->vreg_to_phys) return;
    /* No calls/asm — else IX/IY would be trashed mid-live-range. */
    for (int b = 0; b < f->n_bbs; b++)
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            OpKind k = f->bbs[b].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return;
        }
    /* Candidate halves — never offer halves of the FRAME register (it's used as
       a pair by every (ix+d) access, and the frame isn't a vreg so the interval
       check can't see it), nor of a platform-reserved index register
       (--reserve-regs-ix/-iy). c_framepointer_is_ix == 1 → IX is the frame,
       == -1 → sp-mode (no frame). (fp_active is per-function but unreliable here
       — frame_size isn't set until ir_assign_slots runs after this pass; the
       global choice is the safe, stable gate.) A non-frame index reg's own
       tenant (an idx2 counter/param) IS a vreg, so its half availability is
       decided per byte by live-interval overlap below. */
    PhysReg halves[4]; int nhalves = 0;
    if (!c_reserve_iy) {               /* IY never the frame; offer unless reserved */
        halves[nhalves++] = IR_PR_IYL; halves[nhalves++] = IR_PR_IYH;
    }
    if (c_framepointer_is_ix != 1 && !c_reserve_ix) {   /* IX not the frame nor reserved */
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
    long *wuse = calloc((size_t)nv, sizeof(long));   /* depth-weighted use score (ticks) */
    int *ruse = calloc((size_t)nv, sizeof(int));     /* RAW use count (code-size / net-byte) */
    int *first = malloc((size_t)nv * sizeof(int));
    int *last  = malloc((size_t)nv * sizeof(int));
    if (!ndef || !wuse || !ruse || !first || !last) {
        free(ndef); free(wuse); free(ruse); free(first); free(last); return;
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
                ruse[u[k]]++;                        /* raw (unweighted) use site count */
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
            /* NET-BYTE gate (sp): home only when the index-half saves code.
               `save_per` (3) ≈ a dear sp slot byte access (`ld hl,N; add hl,sp;
               ld a,(hl)` ≈ 5B) − `ld a,iyl` (2B). `ovh` (10) folds the one-time
               push/pop index-reg save (~4B, frame_has_saved_*) PLUS the setup /
               move slop a low-access half-home incurs (a byte needing a CB-page
               shift or an HL transit can't stay in a half — the op-shape term
               the model lacks). RAW (unweighted) access sites — code size is
               static, not per-iteration. In sp the byte and cycle savings
               correlate, so net-bytes>0 tracks the balanced win. Calibrated by
               sweep: home iff RAW accesses ≥ 4 — keeps hot-accumulator shapes,
               rejects break-even shapes that only pay the save. */
            {
                long acc = (long)ndef[v] + ruse[v];
                if (acc * 3 - 10 <= 0) continue;
            }
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
    free(ndef); free(wuse); free(ruse); free(first); free(last); free(bdep);
}

int ir_lower_func(FILE *out, Func *f)
{
    if (!f) {
        fputs("ir_lower: null Func\n", stderr);
        return -1;
    }
    L.spill_ix = L.spill_sp = 0;   /* IR_SPILL_STATS: per-function reset */

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
        /* Spatial address CSE: clustered accesses (stencil a[k]/a[k±1], neighbour
           sums) share one anchor address + a folded byte offset. BEFORE ivsr so
           the shared base+index structure is still visible (ivsr would otherwise
           strength-reduce each clustered access into an independent stepped IV,
           hiding the common index); ivsr then reduces just the anchor and the
           offset loads ride it. IR_NO_ADDR_CSE opts out. */
        /* Fold a constant `&local + K` into the LEA before addr-cse groups
           addresses, so a struct member is one frame address rather than a
           base plus a run-time add. */
        int leaofs  = ir_opt_lea_offset(f);
        int addrcse = ir_opt_addr_cse(f);
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
        /* Fold &symbol EQ/NE operands to immediates BEFORE dce (which then
           reclaims the dead LD_SYM). After cse so a folded compare's imm_sym
           can't confuse value numbering. */
        int symcmp  = ir_opt_sym_cmp_fold(f);
        (void)ir_opt_conv_mask_fold(f);   /* AND(sx,mask)→zx; dce reclaims the sx */
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
             || cse > 0 || addrcse > 0 || leaofs > 0 || pushes > 0 || deadret > 0 || reassoc > 0
             || rcoal > 0 || pruned > 0 || symcmp > 0)
            && getenv("IR_OPT_VERBOSE"))
            fprintf(stderr,
                    "ir_opt: %d prune, %d licm, %d ivsr, %d early, %d st2ld, "
                    "%d cfold, %d reassoc, %d match, %d cse, %d addrcse, "
                    "%d packs, %d late, %d pushes, %d deadret, %d symcmp, "
                    "%d dce, %d narrow, %d ivnarrow in func\n",
                    pruned, hoisted, ivsr, early, fwd, cfold, reassoc, match,
                    cse, addrcse, packs, late, pushes, deadret, symcmp, dce, narrow, ivnarrow);
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
    compute_no_slot_bytes(f);

    /* [IR_BYTE_REMAT] Byte-remat table: a width-1 vreg whose SINGLE def is a
       global byte load (LD_MEM IR_MEM_SYM, non-volatile, non-banked) and whose
       SINGLE use sits in the same BB with NO memory-writing op between — so the
       global is provably unchanged and `ld a,(sym)` can be re-issued at the use
       instead of a frame-slot store+reload (a global load is rematerialisable).
       Kills the daft `ld a,(g);ld (ix-n),a; … ld a,(ix-n)` spill of a value that
       is just a memory read. DEFAULT ON; --opt-disable=byte-remat opts out
       (byte-identical to the pre-remat pickers). */
    g_hc.byte_remat = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                             sizeof(const Op *));
    if (g_hc.byte_remat && !opt_disabled("byte-remat")) {
        for (int b = 0; b < f->n_bbs; b++) {
            const BB *bb = &f->bbs[b];
            for (int j = 0; j < bb->n_ops; j++) {
                const Op *o = &bb->ops[j];
                int d = o->dst;
                if (d < 0 || d >= f->n_vregs) continue;
                if (o->kind != IR_LD_MEM || o->mem.kind != IR_MEM_SYM) continue;
                if (f->vregs[d].width != 1) continue;
                if (f->vregs[d].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                    continue;
                if (o->mem.volatile_ || !o->mem.sym || ns_sym_bails(o->mem.sym))
                    continue;
                /* exactly one def + one use, use in this BB after j */
                int ndef = 0, nuse = 0, use_j = -1;
                for (int bb2 = 0; bb2 < f->n_bbs; bb2++)
                    for (int k = 0; k < f->bbs[bb2].n_ops; k++) {
                        const Op *p = &f->bbs[bb2].ops[k];
                        int df[8]; int nd = ir_op_defs(p, df, 8);
                        for (int t = 0; t < nd; t++) if (df[t] == d) ndef++;
                        int u[16]; int nu = ir_op_uses(p, u, 16);
                        for (int t = 0; t < nu; t++) if (u[t] == d) {
                            nuse++; if (bb2 == b) use_j = k;
                        }
                    }
                if (ndef != 1 || nuse != 1 || use_j <= j) continue;
                if (bb->live_out
                    && ir_bitset_get((const BitSet *)bb->live_out, d)) continue;
                /* The single use MUST be an op that reads the value via
                   load_byte_to_a / byte_alu_operand — the only sites that
                   rematerialise. Skipping the slot store for a value read any
                   OTHER way (e.g. IR_RET, which does `ld l,(slot)`) leaves the
                   slot uninitialised → garbage. gen_bitop's width-1 AND/OR/XOR
                   is that path; restrict to it. */
                const Op *uop = &bb->ops[use_j];
                int use_ok = (uop->kind == IR_AND || uop->kind == IR_OR
                              || uop->kind == IR_XOR)
                             && uop->dst >= 0 && f->vregs[uop->dst].width == 1;
                /* Byte EQ/NE between two width-1 VREGS also qualifies: it takes
                   gen_cmp_eq_ne's `cp` path, which reads one operand through
                   load_byte_to_a and the other through byte_alu_operand — both
                   rematerialise. The two folds that run ahead of it
                   (try_cmp_ixd_fold, try_exx_compare) are width-2 only, so they
                   cannot reach a byte operand and read its (absent) slot.
                   Requiring src[1] to be a real vreg keeps the const-RHS shapes
                   out: `b == 0` goes to emit_test_zero and an out-of-range
                   constant to the widened path, neither of which remats.
                   This is what lets the compared byte stay in A rather than be
                   evicted by a global load, so the A-carry can hand it to the
                   next block and the value's own slot — and often the whole
                   frame — falls away. */
                if (!use_ok && (uop->kind == IR_CMP_EQ || uop->kind == IR_CMP_NE)
                    && uop->src[0] >= 0 && uop->src[0] < f->n_vregs
                    && uop->src[1] >= 0 && uop->src[1] < f->n_vregs
                    && f->vregs[uop->src[0]].width == 1
                    && f->vregs[uop->src[1]].width == 1)
                    use_ok = 1;
                if (!use_ok) continue;
                /* no memory-writing op between the load and its use */
                int hazard = 0;
                for (int k = j + 1; k < use_j && !hazard; k++) {
                    OpKind kk = bb->ops[k].kind;
                    if (kk == IR_ST_MEM || kk == IR_CALL || kk == IR_HCALL
                        || kk == IR_ASM || kk == IR_OUT || kk == IR_COPY_STEP_BRZ)
                        hazard = 1;
                }
                if (!hazard) {
                    g_hc.byte_remat[d] = o;
                    /* No slot needed — rematerialised at its use, never spilled
                       or reloaded — so ir_assign_slots skips it, frame_size shrinks. */
                    f->vregs[d].flags |= IR_VREG_NO_SLOT;
                }
            }
        }
    }
    /* Auto-push param (opt-in IR_AUTOPUSH_PARAM): a fastcall register param that
       spills is materialised by a `push` at entry instead of stash+alloc+store.
       Flag it here (vreg_to_phys is final) so ir_assign_slots places it at the
       top frame offset and emit_prologue pushes it. The flag persists through the
       word-home revert re-run of ir_assign_slots below. Width 1 too: the byte
       arrives in L, so `push hl` materialises it at the slot's low byte (H is
       discarded) — the autopush machinery treats it as a 2-byte slot (naive: the
       byte is not consumed from the stack in the common single-use case, so a
       no-push register-resident form is a future refinement). */
    if (autopush_param_on()) {
        int fc = fastcall_arg_vreg(f);
        /* Only when the fastcall arg is the SOLE parameter. With any caller-stack
           param (multi-arg fastcall: rightmost in HL, the rest pushed), the
           autopush `push hl` shifts sp, but the body reads those stack params
           sp-relative WITHOUT accounting for the push (and the epilogue doesn't
           reclaim it) — so `a` reads the return address and `ret` pops the pushed
           arg → wild jump. sccz80 compensates (read at sp+N, `pop bc` before ret);
           80cc doesn't, so exclude the multi-arg case (it reverts to the correct
           non-autopush path). */
        int other_stack_param = 0;
        if (fc >= 0)
            for (int v = 0; v < f->n_vregs; v++)
                if ((f->vregs[v].flags & IR_VREG_PARAM) && v != fc) {
                    other_stack_param = 1; break;
                }
        if (fc >= 0 && !other_stack_param
            && f->vreg_to_phys && f->vreg_to_phys[fc] == IR_PR_SPILL) {
            int w = f->vregs[fc].width;
            if (w == 1 || w == 2 || w == 4)
                f->vregs[fc].flags |= IR_VREG_AUTOPUSH;
        }
    }
    /* Rematerialization table: a width-2 vreg with EXACTLY ONE def that is
       LD_IMM or LD_SYM (non-bailing, non-addr-taken, non-volatile) is a
       loop-invariant constant — remember its defining op so cache-miss loads
       re-emit the constant instead of reloading a slot. Built BEFORE
       ir_assign_slots so the NO_SLOT tagging (constants need no slot — they
       rematerialise) shrinks the frame and drops the def's spill store. */
    {   /* Single-def IR_LEA map: which frame slot (and displacement) a
           pointer vreg names. Ungated — it only records a fact. */
        int nv = f->n_vregs > 0 ? f->n_vregs : 1;
        int *nd = calloc((size_t)nv, sizeof(int));
        g_hc.lea_def = calloc((size_t)nv, sizeof(const Op *));
        if (nd && g_hc.lea_def) {
            for (int b = 0; b < f->n_bbs; b++)
                for (int j = 0; j < f->bbs[b].n_ops; j++) {
                    const Op *o = &f->bbs[b].ops[j];
                    if (o->dst >= 0 && o->dst < nv) {
                        nd[o->dst]++;
                        g_hc.lea_def[o->dst] = (o->kind == IR_LEA) ? o : NULL;
                    }
                }
            for (int v = 0; v < nv; v++)
                if (nd[v] != 1) g_hc.lea_def[v] = NULL;
        }
        free(nd);
    }
    g_hc.remat_def = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                         sizeof(const Op *));
    if (g_hc.remat_def && !opt_disabled("remat")) {
        int *ndef = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1), sizeof(int));
        /* A symbol address used as a STORE base (`ld (hl/bc),a` write-back) is NOT
           NO_SLOT-eligible: the pointer-store RMW lowering holds the base in a
           register across the value computation and does not compose with
           just-in-time rematerialisation (the base in HL gets clobbered by the
           value's `pop hl`; bitfield store miscompile). Keep those slotted — their
           pre-change behaviour (read-remat + slot) is correct. */
        int *store_base = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1), sizeof(int));
        /* remat-LEA is gated to CALLLESS functions (see the [IR_REMAT_LEA] note):
           recomputing a frame-slot address mid-call-argument-marshalling would need
           cur_sp_adjust to reflect the already-pushed args, and a &local passed to a
           call is the concrete failure (sortbench qsort_rec's cmp(&v[j],&pivot)). A
           function with no IR_CALL has no such marshalling, so every remat point is
           sp-adjust-safe. */
        int func_has_call = 0;
        if (ndef && store_base) {
            for (int b = 0; b < f->n_bbs; b++)
                for (int j = 0; j < f->bbs[b].n_ops; j++) {
                    const Op *so = &f->bbs[b].ops[j];
                    if (so->kind == IR_CALL) func_has_call = 1;
                    if (so->kind == IR_ST_MEM && so->mem.kind == IR_MEM_VREG
                        && so->mem.base >= 0 && so->mem.base < f->n_vregs)
                        store_base[so->mem.base] = 1;
                }
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
                    const Op *rd = NULL;
                    if (o->kind == IR_LD_IMM)
                        rd = o;
                    else if (o->kind == IR_LD_SYM && o->mem.sym
                             && !ns_sym_bails(o->mem.sym))
                        rd = o;
                    /* [IR_REMAT_LEA] Frame-slot address (&local) rematerialises:
                       recompute at each use (emit_remat_word: `ld hl,slot_off+
                       cur_sp_adjust; add hl,sp`) instead of spilling+reloading — the
                       offset is fixed per function and cur_sp_adjust is tracked, so
                       fp==sp with only the target pair clobbered (no IX/DE gymnastics).
                       EXCLUSIONS, each a measured non-win:
                       - byte-wise CPUs (808x/gbz80): spill LEA values as data-stack
                         transients (PR_STACK push/pop) not frame slots, so dropping
                         the slot shifts the stack and offsets go inconsistent (irgaps
                         miscompiles — the deferred "extend" step);
                       - ez80 in FP mode: its cheap `lea`/`ld hl,(ix+d)` addressing
                         register-homes LEAs, so per-use recompute in a hot loop is a
                         byte-for-tick LOSS (interpbench ez80-fp −27B but +4.6% ticks).
                         ez80-SP keeps it: sp addressing is dear there, so it is a pure
                         win (−117B, −6.6% ticks).
                       Store-base LEAs keep their slot (below). Default-on;
                       IR_REMAT_LEA=0 opts out. */
                    else if (o->kind == IR_LEA && o->src[0] >= 0 && !func_has_call
                             && !(IS_808x() || IS_GBZ80())
                             && !(IS_EZ80() && fp_active(f))
                             && remat_lea_enabled())
                        rd = o;
                    if (rd) {
                        g_hc.remat_def[d] = rd;
                        /* A compile-time constant (integer immediate OR symbol
                           address) is rematerialisable at every use for the same
                           cost as a slot reload → needs NO slot. Skipping it drops
                           the def's spill store (often DEAD: a spilled global address
                           is frequently never read) AND the frame slot;
                           reads rematerialise via emit_remat_word (load_to_hl/de/bc).
                           EXCLUDE store bases: the pointer-store RMW holds the base
                           in a register across the value computation and does NOT
                           compose with just-in-time rematerialisation (the base in
                           HL is clobbered by the value's `pop hl` — bitfield-on-
                           global, MMIO `*(T*)K = v`); those keep their slot. */
                        if (store_base[d]) continue;
                        f->vregs[d].flags |= IR_VREG_NO_SLOT;
                    }
                }
            free(ndef);
        }
        free(store_base);
    }
    ir_assign_slots(f);
    /* Frameless (Tier-B): decided once frame_size + homes are known; must be set
       before any fp_active/frame_has_saved_fp use (prepick region proof, render).
       Changes param_caller_off's saved-IX offset (frame_has_saved_fp=0 → +2). */
    L.cur_frameless = frameless_ok(f);
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
    L.lazy_spill_on = !opt_disabled("lazy-spill");
    int want_lazy = L.lazy_spill_on;
    f32_stack_arg_on = !opt_disabled("f32-stack-arg");

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
    L.bb_a_out = malloc((size_t)f->n_bbs * sizeof(int));
    if (L.bb_a_out)
        for (int i = 0; i < f->n_bbs; i++) L.bb_a_out[i] = -1;
    L.vreg_wc = (f->n_vregs > 0) ? calloc((size_t)f->n_vregs, sizeof(int)) : NULL;
    if (L.vreg_wc)
        for (int i = 0; i < f->n_bbs; i++)
            for (int j = 0; j < f->bbs[i].n_ops; j++) {
                const Op *o = &f->bbs[i].ops[j];
                if (o->dst >= 0 && o->dst < f->n_vregs) L.vreg_wc[o->dst]++;
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs) L.vreg_wc[o->src[0]]++;
            }
    /* (remat_def table built earlier, BEFORE ir_assign_slots, so its NO_SLOT
       tagging is seen by slot assignment — see the block above gen ir_assign_slots.) */
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
            g_hc.home_is_word = 1;
            g_hc.func_whome = f->word_home_vreg;
            g_hc.branch_test_kind = 0;
            /* Same DE-home fold arming as the render, so op_de_clean's region
               proof here matches what the render will actually emit. */
            if (f->de_home_general) g_hc.de_home = f->word_home_vreg;
            compute_home_region(f, f->word_home_vreg, bb_alias, &wlo, &whi);
            g_hc.home_is_word = 0;
            g_hc.func_whome = -1;
            g_hc.de_home = -1;
            if (wlo < 0) {
                memcpy(f->vreg_to_phys, wh_prepick,
                       (size_t)f->n_vregs * sizeof(int));
                f->word_home_vreg = -1;
                f->de_home_general = 0;
                f->de_home_is_ptr = 0;
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
    /* Render the function body to a scratch file, then copy to `out` dropping
       dead BB labels (emit_dropping_dead_bb_labels). IR_NO_LABEL_ELIDE opts out
       to writing `out` directly. */
    int elide_labels = !opt_disabled("label-elide");
    int max_bb = -1;
    for (int i = 0; i < f->n_bbs; i++)
        if (f->bbs[i].id > max_bb) max_bb = f->bbs[i].id;
    int *bb_hl_out_p1 = NULL;
    FILE *rout;
    int df_retry_done = 0;   /* dead-frame elision: at most one re-lower */
    int ds_retry_done = 0;   /* [IR_DEADSTORE] dead byte-spill elision: one re-lower */
 deadframe_retry:
    /* Render into a DISCARDABLE buffer whether or not labels are being elided.
       The dead-store / dead-frame retries below `goto deadframe_retry` and
       render the function again, discarding the first attempt with
       `fclose(rout)` — which only discards anything when rout is a temp file.
       With rout aliased to `out` (what --opt-disable=label-elide used to do)
       the first render stayed in the output and the retry APPENDED a second
       copy of the whole function: two bodies, both carrying L_f<n>_bb_0, and
       z80asm rejected the duplicate label. If tmpfile() is unavailable we fall
       back to writing `out` directly and must then suppress the retries, since
       there is no way to take the first render back. */
    rout = tmpfile();
    if (!rout) { rout = out; elide_labels = 0; }
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
        /* ss_op_base is the per-BB base of the FLAT op index — an addressing
           map, not lazy-spill state. It is what makes L.ss_cur_g (the ambient
           lowering point) valid, and ir_home_at() needs that point to honour a
           RANGED register home: outside [home_lo,home_hi] the value lives in
           its slot, not the register. With the map absent, ss_cur_g stayed -1,
           ir_home_at skipped the bounds test and reported the raw assignment
           everywhere — so a ranged BC home looked whole-function and
           `ld bc,K` was emitted for a def OUTSIDE the span with no slot store.
           The value then died at the first call that clobbered BC. Build it
           here too so the non-lazy render sees the same homes. */
        int nb = f->n_bbs > 0 ? f->n_bbs : 1;
        int *nl_op_base = malloc((size_t)nb * sizeof(int));
        if (nl_op_base) {
            int t = 0;
            for (int b = 0; b < f->n_bbs; b++) {
                nl_op_base[b] = t;
                t += f->bbs[b].n_ops;
            }
            L.ss_op_base = nl_op_base;
        }
        rc = lower_func_render(rout, f, 0, NULL, bb_hl_out, bb_lowered,
                               bb_pending_out, bb_pred_cnt, bb_preds,
                               bb_alias);
        L.ss_op_base = NULL;
        free(nl_op_base);
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
            rc = lower_func_render(rout, f, 0, NULL, bb_hl_out, bb_lowered,
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
                rc = lower_func_render(rout, f, 1, bb_hl_out_p1, bb_hl_out,
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
    /* [IR_DEADSTORE] Dead byte-spill elision: the render's read/write split
       (rec_end) listed byte spills WRITTEN but never READ (ds_dead), coalescing-
       checked. Mark them IR_VREG_DEAD_SPILL, recompute slots (ir_assign_slots
       drops them → frame shrinks), and re-lower — the store helper skips the
       store and the value rides its register to the readers (in-BB, or the next
       BB via bb_a_out / bb_hl_out). Composes with the dead-FRAME retry below: a
       frame emptied by this goes frameless.

       WIDTH 1 (store_a_byte, rides A) needs the A-carry; WIDTH 2 (store_hl /
       store_hl_keep_hl, rides HL) needs the HL-carry. The width-2 half exists
       because ss_compute_dead — nominally the word path — does not see a CALL
       RESULT store (it is committed via store_hl_keep_hl), which is the most
       common word dead-store shape there is: 46 in the bench corpus, 15 in
       emu.c. Runs before deadframe. */
    if (dsx_enabled() && !ds_retry_done && rc == 0 && ds_ndead > 0
        && (a_carry_enabled() || (hl_carry_enabled() && dsw_enabled()))) {
        /* EXCLUDE STORE BASES (width-2 only — the pointer case). The read/write
           counts come from render #1, where a store base is cache-served and so
           shows zero slot reads; but the pointer-store RMW holds the base in a
           register across the value computation, and dropping its slot makes the
           re-lower need a reload that did not exist before — i.e. eliding can
           CREATE the reader it was told did not exist. Same exclusion the
           symbol-address remat makes, for the same reason (long_ir storecall.c:
           `*(u16 *)ralign(p,1) = v`, a store through a call-returned pointer). */
        char *st_base = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1), 1);
        if (st_base)
            for (int b = 0; b < f->n_bbs; b++)
                for (int j = 0; j < f->bbs[b].n_ops; j++) {
                    const Op *so = &f->bbs[b].ops[j];
                    if (so->kind == IR_ST_MEM && so->mem.kind == IR_MEM_VREG
                        && so->mem.base >= 0 && so->mem.base < f->n_vregs)
                        st_base[so->mem.base] = 1;
                }
        int marked = 0;
        for (int i = 0; i < ds_ndead; i++) {
            int v = ds_dead[i];
            if (v < 0 || v >= f->n_vregs) continue;
            int w = f->vregs[v].width;
            if (w == 1 ? !a_carry_enabled()
                       : (w != 2 || !hl_carry_enabled() || !dsw_enabled()))
                continue;
            if (w == 2 && (!st_base || st_base[v])) continue;
            /* EXCLUDE gbz80 from the width-2 half: it has no `ex de,hl`, which
               the store_hl skip path relies on to honour the DE=value contract,
               and its word values ride different registers so the HL carry does
               not reach the readers (long_ir/string strrev_empty aborts with a
               slotless read). 8080/8085 keep it — they have `xchg`. */
            if (w == 2 && IS_GBZ80()) continue;
            if (f->vregs[v].flags & IR_VREG_DEAD_SPILL) continue;
            f->vregs[v].flags |= IR_VREG_DEAD_SPILL;
            marked++;
        }
        free(st_base);
        /* rout==out means tmpfile() failed: the first render is already in the
           output and cannot be taken back, so a retry would duplicate it. */
        if (marked && rout != out) {
            ds_retry_done = 1;
            ir_assign_slots(f);                 /* drop dead slots, recompact */
            L.cur_frameless = frameless_ok(f);
            free(bb_hl_out_p1); bb_hl_out_p1 = NULL;
            if (rout != out) fclose(rout);
            goto deadframe_retry;
        }
    }
    /* Dead-frame elision (IR_DEADFRAME): the render just proved (rec_end) that
       every spill slot is dead — the whole frame is unused. Re-lower the
       function once with frame_size=0: the spill vregs shed their (dead) slots
       and the existing frame_size==0 IX-elision makes it frameless. Safe by
       construction — a dead slot is never addressed, so dropping it and the
       frame shifts nothing that is emitted. The scratch render is discarded. */
    if (deadframe_on() && !df_retry_done && rc == 0
        && L.frame_fully_dead && f->frame_size > 0 && rout != out) {
        df_retry_done = 1;
        /* Clear EVERY slot, not just the PR_SPILL ones. A vreg with a RANGED
           register home (home_lo/home_hi narrower than the whole function)
           also owns a frame slot — that is where it lives outside its range —
           yet its vreg_to_phys is the REGISTER, not PR_SPILL. Restricting the
           sweep to PR_SPILL left such a vreg holding its old offset while the
           frame it addressed was gone. Offset 0 then reads as a valid slot at
           sp+0, which in a frameless function is the RETURN ADDRESS: the
           width-2 store took the `pop de / push hl` top-of-stack path and
           overwrote it (SMSlib menu loop: every iteration replaced the return
           address with the joypad word). frame_fully_dead already proves no
           slot is read, so dropping them all is safe; leaving one addressable
           was not. */
        for (int v = 0; v < f->n_vregs; v++)
            if (f->vreg_spill_slot && f->vreg_spill_slot[v] >= 0)
                f->vreg_spill_slot[v] = -1;
        f->frame_size = 0;
        L.cur_frameless = frameless_ok(f);
        free(bb_hl_out_p1); bb_hl_out_p1 = NULL;
        if (rout != out) fclose(rout);
        goto deadframe_retry;
    }
    /* [IR_IX_VERIFY] sp-mode INDEX-preservation completeness check (debug-gated):
       if the render touched IX/IY but frame_has_saved_ix/iy decided NOT to save
       it, the caller's callee-saved index reg is clobbered — a hole in the save
       predicate. Scans the rendered body (tmpfile only). 1 = warn, 2 = abort.
       Prove-completeness harness for the IX-callee-saved arc + the #13 flip's
       idx3=IY / idxhalf saves: run across the corpus; expect zero hits.
       Covers BOTH index registers — the IY analog underpins guard #1
       (frame_has_saved_iy) of the frameless-via-sp flip. */
    if (rc == 0 && elide_labels && rout != out && c_framepointer_is_ix != 1) {
        const char *v = getenv("IR_IX_VERIFY");
        int chk_ix = (v && v[0]) ? !frame_has_saved_ix(f) : 0;
        int chk_iy = (v && v[0]) ? !frame_has_saved_iy(f) : 0;
        if (chk_ix || chk_iy) {
            rewind(rout);
            char ln[1024]; int tix = 0, tiy = 0;
            while (fgets(ln, sizeof ln, rout)) {
                if (chk_ix && !tix
                    && (strstr(ln, "\tix") || strstr(ln, ",ix") || strstr(ln, "(ix")))
                    tix = 1;
                if (chk_iy && !tiy
                    && (strstr(ln, "\tiy") || strstr(ln, ",iy") || strstr(ln, "(iy")))
                    tiy = 1;
                if ((!chk_ix || tix) && (!chk_iy || tiy)) break;
            }
            if (tix)
                fprintf(stderr, "IR_IX_VERIFY: %s touches IX in sp mode with NO "
                        "save (frame_has_saved_ix missed it)\n",
                        f->fn ? ir_sym_name(f->fn) : "?");
            if (tiy)
                fprintf(stderr, "IR_IX_VERIFY: %s touches IY in sp mode with NO "
                        "save (frame_has_saved_iy missed it)\n",
                        f->fn ? ir_sym_name(f->fn) : "?");
            if ((tix || tiy) && v[0] == '2') abort();
        }
    }
    if (rout != out) {
        if (elide_labels && rc == 0)
            emit_dropping_dead_bb_labels(out, rout, max_bb, f);
        else { rewind(rout); char buf[1024];   /* verbatim: no elision, or error */
               while (fgets(buf, sizeof buf, rout)) fputs(buf, out); }
        fclose(rout);
    }
    free(bb_hl_out_p1);

    free(bb_alias);
    free(bb_hl_out);
    free(bb_pending_out);
    free(L.bb_byte_out); L.bb_byte_out = NULL;
    free(L.bb_a_out); L.bb_a_out = NULL;
    free(L.vreg_wc); L.vreg_wc = NULL;
    free(L.bb_byte_out_dirty); L.bb_byte_out_dirty = NULL;
    free(g_hc.remat_def); g_hc.remat_def = NULL;
    free(g_hc.byte_remat); g_hc.byte_remat = NULL;
    free(bb_lowered);
    free(bb_pred_cnt);
    for (int i = 0; i < f->n_bbs; i++) free(bb_preds[i]);
    free(bb_preds);
    ir_free_liveness(f);
    if (spill_stats_on > 0)
        fprintf(stderr, "SPILL %-24s ix=%-5d sp=%-5d\n",
                f->fn ? ir_sym_name(f->fn) : "?", L.spill_ix, L.spill_sp);
    return rc;
}

/* [#13 frameless-via-sp flip, opt-in IR_SPFLIP] Lower f fp for real (buffered),
   read ds_ixaccess/ds_last_framed; for an ix-frame-dead fn re-lower a pristine
   sp CLONE and emit that. Excludes `main` + IR_SPEXCL (bisect). */
static int spflip_enabled(void)
{
    static int v = -1;
    if (v < 0) {
        const char *e = getenv("IR_SPFLIP");
        /* DEFAULT-ON (frameless-via-sp costed flip, fp mode only). Opt out with
           IR_SPFLIP=0 (matches the IR_DEADSTORE=0 convention). Inert unless
           c_framepointer_is_ix==1, so default/sp builds are unaffected. */
        v = (e && strcmp(e, "0") == 0) ? 0 : 1;
    }
    return v;
}

/* [#13 costed flip] The flip is byte-beneficial when the saved IX apparatus
   exceeds the sp-vs-ix data-access cost. The zero-cost case is ds_ixaccess==0
   (always flip). The costed budget widens to framed fns with a FEW (ix±d)
   accesses: flip iff 2*N < K (the IR_FLIPCOST model, ~2B/access sp-vs-ix on z80).
   DEFAULT K=6 -> 2*N<6 -> N<=2: the near-clean knee measured across the corpus;
   higher K widens the win but adds byte-growth outliers.
   IR_SPCOST=K overrides (calibration / a per-CPU gate could set it per target). */
static int flip_cost_budget(void)
{
    static int k = -2;
    if (k == -2) { const char *e = getenv("IR_SPCOST"); k = (e && e[0]) ? atoi(e) : 6; }
    return k;
}

int ir_lower_func_flip(FILE *out, Func *f)
{
    extern int c_framepointer_is_ix;
    if (!spflip_enabled() || c_framepointer_is_ix != 1 || !f)
        return ir_lower_func(out, f);
    const char *nm = f->fn ? ir_sym_name(f->fn) : "";
    int excluded = (strcmp(nm, "main") == 0);
    /* IR_SPINC (comma list): if set, flip ONLY names containing a listed token. */
    const char *inc = getenv("IR_SPINC");
    if (!excluded && inc && inc[0]) {
        int hit = 0; char buf[512]; strncpy(buf, inc, sizeof buf - 1); buf[sizeof buf-1]=0;
        for (char *t = strtok(buf, ","); t; t = strtok(NULL, ","))
            if (strstr(nm, t)) { hit = 1; break; }
        if (!hit) excluded = 1;
    }
    /* IR_SPEXCL (comma list): exclude names containing any listed token. */
    if (!excluded) { const char *ex = getenv("IR_SPEXCL");
        if (ex && ex[0]) { char buf[512]; strncpy(buf, ex, sizeof buf-1); buf[sizeof buf-1]=0;
            for (char *t = strtok(buf, ","); t; t = strtok(NULL, ","))
                if (strstr(nm, t)) { excluded = 1; break; } } }
    if (excluded) return ir_lower_func(out, f);
    Func *spc = ir_clone_func(f);
    FILE *fpbuf = tmpfile();
    if (!spc || !fpbuf) {
        if (spc) ir_free_cloned_func(spc);
        if (fpbuf) fclose(fpbuf);
        return ir_lower_func(out, f);
    }
    int rc = ir_lower_func(fpbuf, f);
    /* ►► Exclude uses_acc (float/longlong): fp_active is already false for them
       (they address sp-relative) and they save IX because the acc/float HELPERS
       clobber it — flipping drops that push ix, so the helper trashes the fp
       caller's frame pointer → hang. Their IX save isn't a vreg home (idx2), so
       frame_has_saved_ix can't catch it; exclude outright. */
    /* Also exclude the register-arg entry conventions (mirror frameless_ok):
       fastcall (arg in HL/DEHL) and __sdcccall(1) have special prologues that
       juggle the register arg assuming the fp frame — flipping mishandles it. */
    int candidate = (rc == 0 && ds_last_framed && 2 * ds_ixaccess < flip_cost_budget()
                     && !f->uses_acc
                     && fastcall_arg_vreg(f) < 0 && !(f->flags & SDCCCALL1));
    if (candidate) {
        extern int ir_idx2_reg(void); extern int ir_idx3_reg(void); extern int ir_exx_reg(void);
        int save = c_framepointer_is_ix;
        c_framepointer_is_ix = -1;
        spc->idx2_reg = ir_idx2_reg();     /* sp idx2=IX/idx3=IY: keep the opt */
        spc->idx3_reg = ir_idx3_reg();
        spc->exx_reg  = ir_exx_reg();
        spc->flipped_from_fp = 1;          /* ►► save IX/IY it uses (fp callers need
                                              them callee-saved) — see emit_prologue */
        FILE *spbuf = tmpfile();
        int rc2 = spbuf ? ir_lower_func(spbuf, spc) : -1;
        c_framepointer_is_ix = save;
        ir_free_cloned_func(spc);
        /* ►► ABI safety net (general): if the sp output TOUCHES IX/IY as a
           register (`\tix`/`,ix`/`(ix`) WITHOUT a matching `push ix` save, the
           flipped fn would clobber the fp caller's callee-saved IX/IY — e.g. an
           fnptr call via l_jpix emits `pop ix; call l_jpix` (unsaved). An idx2=IX
           home IS saved (frame_has_saved_ix → push ix) so it passes. A
           uses_acc callee clobbers IX INVISIBLY (inside the helper) — hence the
           separate uses_acc exclusion above; this scan only sees the fn's own
           text. On reject, emit the fp buffer (no flip). */
        int ok = (rc2 == 0);
        if (ok && spbuf) {
            int uix = 0, uiy = 0, six = 0, siy = 0; char ln[1024]; rewind(spbuf);
            while (fgets(ln, sizeof ln, spbuf)) {
                if (strstr(ln, "\tix") || strstr(ln, ",ix") || strstr(ln, "(ix")) uix = 1;
                if (strstr(ln, "\tiy") || strstr(ln, ",iy") || strstr(ln, "(iy")) uiy = 1;
                if (strstr(ln, "push\tix")) six = 1;
                if (strstr(ln, "push\tiy")) siy = 1;
            }
            if ((uix && !six) || (uiy && !siy)) ok = 0;
        }
        if (ok && getenv("IR_SPFLIP_LOG"))
            fprintf(stderr, "SPFLIP: %s flipped to sp\n", nm);
        if (ok) { rewind(spbuf); char ch[4096]; size_t n;
                  while ((n = fread(ch, 1, sizeof ch, spbuf)) > 0) fwrite(ch, 1, n, out); }
        else if (rc == 0) { rewind(fpbuf); char ch[4096]; size_t n;
                  while ((n = fread(ch, 1, sizeof ch, fpbuf)) > 0) fwrite(ch, 1, n, out); }
        if (spbuf) fclose(spbuf);
        fclose(fpbuf);
        return ok ? rc2 : rc;
    }
    ir_free_cloned_func(spc);
    if (rc == 0) {
        rewind(fpbuf); char ch[4096]; size_t n;
        while ((n = fread(ch, 1, sizeof ch, fpbuf)) > 0) fwrite(ch, 1, n, out);
    }
    fclose(fpbuf);
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
    /* Per-render BC-tenant map, the mirror of bb_hl_out. Local to one render:
       the carry is only consulted within a pass. NULL (OOM) degrades to "never
       carry", which is the safe direction. */
    int *bb_bc_out = malloc((size_t)(f->n_bbs > 0 ? f->n_bbs : 1) * sizeof(int));
    if (bb_bc_out)
        for (int i = 0; i < f->n_bbs; i++) bb_bc_out[i] = -1;
    /* Per-render HL slot-ADDRESS out map, the address analogue of bb_hl_out:
       the canonical slot offset HL points at when this BB ends, -1 = none. */
    int *bb_hl_addr_out = malloc((size_t)(f->n_bbs > 0 ? f->n_bbs : 1) * sizeof(int));
    if (bb_hl_addr_out)
        for (int i = 0; i < f->n_bbs; i++) bb_hl_addr_out[i] = -1;
    /* Per-pass state reset (everything that was at function entry except
       func_emit_idx, which the caller bumps once for both passes). */
    L.cmp_label_counter = 0;
    L.lazy_spill_on = lazy;
    L.pending_spill_v = -1;
    cur_lazy_out = out;
    cur_lazy_func = f;
    cur_op_idx = 0;
    rec_begin(f);   /* B4 recoverability verifier — final render only */
    invalidate_hl_bc();
    L.cur_byte_home_vreg = -1;   /* byte home: no resident at function entry */
    L.cur_byte_home_dirty = 0;
    L.cur_func_ehome = -1;
    g_hc.home_is_word = 0;
    g_hc.func_whome = -1;
    g_hc.de_home = -1;          /* set by the orchestrator's DE-home decision */
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vreg_to_phys
            && byte_home_slotbacked(f->vreg_to_phys[v])) { L.cur_func_ehome = v; break; }
    /* Word DE-home (--word-resident): a width-2 loop accumulator homed in DE.
       Mutually exclusive with a byte E/D-home (allocator gives up the word home
       when DE's low half is taken), so it reuses the same residency machinery
       — cur_func_ehome names "the home" either way; cur_home_is_word selects the
       width-specific leaf ops (flush/rehome/accumulate/DE→HL read). */
    if (L.cur_func_ehome < 0 && f->word_home_vreg >= 0
        && vreg_in_pr_de(f, f->word_home_vreg)) {
        g_hc.func_whome = f->word_home_vreg;
        L.cur_func_ehome = g_hc.func_whome;
        g_hc.home_is_word = 1;
        /* General (non-accumulate) DE-home: arm the (ix+d) compare/ALU folds so
           the region stays DE-clean. -1 for a reduction accumulator (the
           try_word_accumulate path already keeps DE = home). */
        if (f->de_home_general) g_hc.de_home = f->word_home_vreg;
    }
    /* Home-resident loop: where the slot-backed home stays in E/D (or DE)
       across a loop, suppress per-iter spills + assert residency at the
       header. */
    /* Store the proof OUTPUT in the table (f), then take the lowerer's mutable
       working copy from it (ADR 0017 step 3b): the render may disable the region
       mid-pass via the residency backstop below, so L.* diverges from the durable
       f-> fields, which stay the pristine proof result for the IR_VERIFY net. */
    f->home_region_lo = f->home_region_hi = -1;
    if (L.cur_func_ehome >= 0 && !opt_disabled("home-resident"))
        compute_home_region(f, L.cur_func_ehome, bb_alias,
                            &f->home_region_lo, &f->home_region_hi);
    L.cur_home_region_lo = f->home_region_lo;
    L.cur_home_region_hi = f->home_region_hi;
    /* Home exit-flush hoist: if the region leaves to exactly ONE target block
       reached ONLY from the region, flush the home once at that block's entry
       instead of every iteration at the header. The home register = the final
       value there by the region proof (no leaving-edge redef). Applies to both
       the word DE-home (fp, flush E+D via ix) and the byte E/D-home (fp via ix
       or sp via HL, flush the one byte). IR_NO_WH_EXIT_HOIST opts out. */
    L.cur_home_exit_flush_bb = -1;
    if (L.cur_func_ehome >= 0
        && L.cur_home_region_lo >= 0 && !opt_disabled("wh-exit-hoist")) {
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
                    && (!g_hc.home_is_word || fp_offset_fits(off + 1));
            } else {
                slot_ok = !g_hc.home_is_word;
            }
            if (all_in && slot_ok)
                L.cur_home_exit_flush_bb = tgt;
        }
    }
    L.cur_func_uses_params = func_uses_params(f);   /* frame-pointer elision */
    if (L.bb_byte_out)
        for (int i = 0; i < f->n_bbs; i++) L.bb_byte_out[i] = -1;
    if (L.bb_a_out)
        for (int i = 0; i < f->n_bbs; i++) L.bb_a_out[i] = -1;
    if (L.bb_byte_out_dirty)
        for (int i = 0; i < f->n_bbs; i++) L.bb_byte_out_dirty[i] = 0;
    L.cur_sp_adjust = 0;
    L.cur_stack_resident = -1;
    L.af_park_depth = 0;
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
    /* HL residency the prologue established (an autopush param left in HL): the
       entry BB has no predecessors, so its HL-carry below would reset it — seed
       it in so the first use reads HL instead of reloading the pushed slot. */
    int entry_hl = L.rs.hl;

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
            if (g_hc.home_is_word && L.cur_func_ehome >= 0 && L.bb_byte_out) {
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
        L.cur_stack_resident = -1;   /* stack-transient never crosses a BB */
        /* BC carry across the BB boundary — the exact mirror of the HL carry
           below. Previously the BC belief simply SURVIVED a boundary with no
           check, which is unsound: BC may be taken by a transient deref base or
           another tenant on some path in, and a ranged home (IR_VREG_CALL_SPLIT)
           is only BC-resident inside its span. histbench is the case that
           exposed it — `bins[]++` grabs BC after the multiply span, so every
           iteration after the first read a STALE multiplicand across the back
           edge. Carry only when every predecessor is already lowered, they all
           agree on bc_out, and the value is live-in; otherwise go cold so the
           span-entry `emit_bc_reload` fires. Keeping the proven carries is what
           avoids paying for the reload where BC genuinely survived. */
        {
            int bcarry = -2;
            for (int p = 0; p < bb_pred_cnt[bb->id]; p++) {
                int pid = bb_preds[bb->id][p];
                if (!bb_lowered[pid]) { bcarry = -1; break; }
                int v = bb_bc_out ? bb_bc_out[pid] : -1;
                if (v < 0) { bcarry = -1; break; }
                if (bcarry == -2) bcarry = v;
                else if (bcarry != v) { bcarry = -1; break; }
            }
            /* Only a RANGED home needs the proof. A whole-function BC home is
               RESERVED by the allocator for the entire function, so its belief
               legitimately survives any boundary — validating it there forces
               pointless reloads (+224 B corpus when tried). A ranged home owns
               BC only inside its span, so its carry must be proven. */
            int need_proof = (L.rs.bc >= 0 && L.rs.bc < f->n_vregs
                              && (f->vregs[L.rs.bc].flags & IR_VREG_CALL_SPLIT));
            if (need_proof
                && !(bcarry == L.rs.bc && bb->live_in
                     && ir_bitset_get((const BitSet *)bb->live_in, bcarry)))
                invalidate_bc_cache();
        }
        L.af_park_depth = 0;         /* AF byte-park never crosses a BB */
        bc_args_save_depth = 0;
        L.la.cur_stack_long_top = -1;
        L.la.cur_dehl_inline_push = -1;
        L.la.cur_dehl_inline_push_base_sp = 0;
        L.la.cur_dehl_push_to_stack = 0;
        cur_bank_fn = NULL;   /* __addressmod: bank unknown at a BB merge */
        /* No pending spill crosses into a BB yet — the cross-BB inherit
           lands with the defer step. Clear it so nothing leaks. */
        L.pending_spill_v = -1;
        int hl_clobbered_at_entry = 0;
        /* Word DE-home exit-flush hoist: this block is the region's sole,
           dedicated exit — physical DE still holds the final accumulator (the
           region proof; nothing has emitted since the exit branch). Flush it to
           the slot ONCE here, then drop the belief. The per-iter header flush is
           suppressed below. Emitted before the cache-carry logic so no ex de,hl
           can clobber DE first (pending spill already cleared). */
        if (L.cur_home_exit_flush_bb >= 0
            && bb->id == L.cur_home_exit_flush_bb) {
            /* Skip the flush when the home is DEAD at the (sole, region-only)
               exit block: its slot is never read again, so writing it back is
               pure waste. Hot for a loop-regalloc pointer home dead after its
               loop (strcpy's `s`/`d`) and any dead-after-loop accumulator. The
               exit block is the unique region-leaving target, so its live_in
               captures all post-region liveness of the home. */
            int hv = g_hc.home_is_word ? g_hc.func_whome : L.cur_func_ehome;
            int home_live = hv >= 0 && bb->live_in
                && ir_bitset_get((const BitSet *)bb->live_in, hv);
            if (home_live) {
                if (g_hc.home_is_word) word_home_exit_flush(out, f);
                else                    byte_home_exit_flush(out, f);
                /* Both flushes address the home's slot through HL, so HL no
                   longer holds whatever the predecessors left in it — the
                   address carry below must not re-assert their belief. */
                hl_clobbered_at_entry = 1;
            }
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
        } else if (bb_pred_cnt[bb->id] == 0 && entry_hl >= 0
                   && bb->live_in
                   && ir_bitset_get((const BitSet *)bb->live_in, entry_hl)) {
            /* Entry BB: inherit the prologue's HL residency (the autopush param
               the push left in HL, alloc preserved) — falls through from the
               prologue, so HL still holds it. */
            hl_about_to_change(entry_hl);
            invalidate_de_cache();
        } else {
            invalidate_hl_cache();
        }
        entry_hl = -1;   /* consumed at the first BB; never re-seed */
        /* Cross-BB HL slot-ADDRESS carry — the address analogue of the value
           carry above, and the reason a slot accessed in two blocks used to
           recompute `ld hl,off; add hl,sp` in each.

           An address belief is NOT a value belief: it says HL points at slot K,
           and a frame slot's absolute address is fixed for the function's
           lifetime (mid-function pushes allocate BELOW the frame, they never
           move slots). So unlike bb_hl_out there is no live_in test to apply —
           the address cannot go stale, only the register can be clobbered.
           Hence the conditions are purely physical: every predecessor lowered,
           and all agreeing on the same slot, so the belief is true on every
           incoming edge.

           Runs AFTER the chain above because invalidate_hl_cache() there
           clears cur_hl_addr_off (same reason the A-carry re-establishes rs.a
           below). Skipped when the value carry took HL — the two are mutually
           exclusive, since cache_hl_slot_addr clears rs.hl and
           hl_about_to_change clears the address — and when a home exit-flush
           already clobbered HL. IR_HLADDR_BB=0 opts out. */
        if (carry < 0 && !hl_clobbered_at_entry && bb_hl_addr_out
            && hladdr_bb_carry_on()) {
            int addr_carry = -2;
            for (int p = 0; p < bb_pred_cnt[bb->id]; p++) {
                int pid = bb_preds[bb->id][p];
                if (!bb_lowered[pid]) { addr_carry = -1; break; }
                int o = bb_hl_addr_out[pid];
                if (o < 0) { addr_carry = -1; break; }
                if (addr_carry == -2) addr_carry = o;
                else if (addr_carry != o) { addr_carry = -1; break; }
            }
            if (addr_carry >= 0) {
                L.rs.hl = -1;
                L.cur_hl_addr_off = addr_carry;
            }
        }
        /* A-cache carry: a byte tested in an if/switch chain is loaded to A for
           the first compare and stays there (cp/or a don't touch A, branches
           preserve it) — so the per-arm reload is dead. Carry A across the
           boundary iff every lowered pred exits with the SAME vreg in A
           (bb_a_out, set only where a byte compare left it) and it's live-in.
           invalidate_hl_cache above cleared rs.a, so (re)establish it here. */
        {
            int acarry = -2;
            for (int p = 0; p < bb_pred_cnt[bb->id]; p++) {
                int pid = bb_preds[bb->id][p];
                if (!bb_lowered[pid]) { acarry = -1; break; }
                int v = L.bb_a_out ? L.bb_a_out[pid] : -1;
                if (v < 0) { acarry = -1; break; }
                if (acarry == -2) acarry = v;
                else if (acarry != v) { acarry = -1; break; }
            }
            if (acarry >= 0 && !getenv("IR_NO_A_CARRY") && bb->live_in
                && ir_bitset_get((const BitSet *)bb->live_in, acarry))
                cache_a(acarry);
            else
                invalidate_a_cache();
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
        int in_home_region = (L.cur_home_region_lo >= 0
                              && bb->id >= L.cur_home_region_lo
                              && bb->id <= L.cur_home_region_hi);
        /* Step 3c (SSoT): inside the stored home region the byte-home carry is
           SUBSUMED by the region — the region assertion below re-establishes the
           home from the proof, and the in-region dirty force (~line 3397) covers
           the dirty flag, so the loop-portion of the bb_byte_out carry would only
           re-derive what the region already knows. Skip it in-region and let the
           assertion establish the belief (byte-identical over the corpus × sp/fp).
           OUTSIDE the region the carry still
           handles non-loop/diamond residency + dirty inheritance. */
        if (L.cur_func_ehome >= 0 && !in_home_region) {
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
        } else if (L.cur_func_ehome >= 0) {
            /* In-region: the region assertion (below) re-establishes the belief. */
            L.cur_byte_home_vreg = -1;
        }
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
        if (frameprobe_on()) frameprobe_region_break();   /* BB boundary */
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            int rc;
            lower_verify_op_entry(bb->id, j);
            if (frameprobe_on()
                && (op->kind == IR_CALL || op->kind == IR_HCALL
                    || op->kind == IR_ASM))
                frameprobe_region_break();

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
            /* dst-dead: skip op->dst's slot spill because its value won't be
               re-read from memory (all later in-BB uses are cache-served). The
               predicate is shared with the slot allocator's no-slot pruning. */
            L.la.cur_dst_dead = def_dst_dead(f, bb, j);
            L.la.cur_remat_def_dead = remat_def_materialization_dead(f, bb, j);
            L.la.cur_br_value_dead = br_value_dead_after(f, bb, j);

            /* Branch-test lookahead: if op[i+1] is BR_ZERO/COND
               reading op->dst (and dst is dead — guaranteed when
               cur_dst_dead is set, since that requires the next op's
               src[0]==dst pattern), publish the branch info for the
               op's fastpath to consume. */
            g_hc.branch_test_kind = 0;
            L.la.cur_branch_test_label = -1;
            L.la.cur_skip_next_op = 0;
            if (L.la.cur_dst_dead && j + 1 < bb->n_ops) {
                const Op *nxt = &bb->ops[j + 1];
                if ((nxt->kind == IR_BR_ZERO || nxt->kind == IR_BR_COND)
                    && nxt->src[0] == op->dst) {
                    g_hc.branch_test_kind = nxt->kind;
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
            /* Same question for a long value being PUSHED as a call
               argument. gen_push_dehl_long loads DEHL and pushes it, then the
               call clobbers BC — so the BC=low stash the load leaves behind is
               dead unless something reads the value between the push and that
               clobber. The helper-call path already reasons this way
               (hcall_vreg_used_after), but an ordinary call's arguments go
               through IR_PUSH_DEHL_LONG, which never asked. That is the
               `ld hl,<lo> / ld de,<hi> / ld bc,hl / push de / push hl / call`
               sequence: binary-trees passes a long to NewTreeNode and
               BottomUpTree, so it pays the stash on every one.
               Keyed on src[0] rather than dst — a push has no dst. */
            L.la.cur_push_dehl_bc_dead = 0;
            if (fp_active(f)
                && (op->kind == IR_PUSH_DEHL_LONG || op->kind == IR_PUSH_ARG)
                && op->src[0] >= 0 && op->src[0] < f->n_vregs
                && f->vregs[op->src[0]].width == 4) {
                int V = op->src[0];
                for (int k = j + 1; k < bb->n_ops; k++) {
                    const Op *ko = &bb->ops[k];
                    int uses[16];
                    int nu = ir_op_uses(ko, uses,
                                (int)(sizeof uses / sizeof uses[0]));
                    int reads_v = 0;
                    for (int u = 0; u < nu; u++)
                        if (uses[u] == V) { reads_v = 1; break; }
                    if (reads_v) break;           /* read first → stash may hit */
                    if (ko->kind == IR_CALL || ko->kind == IR_HCALL
                        || ko->kind == IR_ASM
                        || (ko->dst >= 0 && ko->dst < f->n_vregs
                            && f->vregs[ko->dst].width == 4)) {
                        L.la.cur_push_dehl_bc_dead = 1;
                        break;
                    }
                }
            }
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
                /* Same conclusion for a dead-dst long that is immediately
                   PUSHED as a call argument. cache_dehl_no_spill skips the
                   slot write and stashes BC=low so a later cache hit can
                   recover HL via `ld hl,bc` — but it also advertises rs.hl,
                   and gen_push_arg's consumer takes `push de` / `push hl`,
                   reading HL and DE and never BC. If BC is then clobbered
                   before anything reads the value again, the stash is dead.
                   This is the producer-side half of the argument case: the
                   push's own load_to_dehl is a cache hit, so no_bc there has
                   nothing left to suppress. */
                if (fp_active(f) && op->dst >= 0
                    && f->vregs[op->dst].width == 4
                    && j + 1 < bb->n_ops
                    && (bb->ops[j + 1].kind == IR_PUSH_ARG
                        || bb->ops[j + 1].kind == IR_PUSH_DEHL_LONG)
                    && bb->ops[j + 1].src[0] == op->dst) {
                    int V = op->dst;
                    for (int k = j + 2; k < bb->n_ops; k++) {
                        const Op *ko = &bb->ops[k];
                        int uses[16];
                        int nu = ir_op_uses(ko, uses,
                                    (int)(sizeof uses / sizeof uses[0]));
                        int reads_v = 0;
                        for (int u = 0; u < nu; u++)
                            if (uses[u] == V) { reads_v = 1; break; }
                        if (reads_v) break;       /* read first → stash may hit */
                        if (ko->kind == IR_CALL || ko->kind == IR_HCALL
                            || ko->kind == IR_ASM
                            || (ko->dst >= 0 && ko->dst < f->n_vregs
                                && f->vregs[ko->dst].width == 4)) {
                            L.la.cur_dehl_dst_no_bc_stash = 1;
                            break;
                        }
                    }
                }
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
                int tgt = op->label;
                if (bb_alias && tgt >= 0 && tgt < f->n_bbs
                    && bb_alias[tgt] >= 0)
                    tgt = bb_alias[tgt];
                /* Skip against the next BB that actually EMITS code —
                   alias-elided trampolines produce no bytes, and an empty
                   byte-shift-fuse "skip" arm (its SHL hoisted before the
                   branch) also produces none, so falling through lands on the
                   BB after them. */
                int next_emitted = -1;
                for (int k = i + 1; k < f->n_bbs; k++) {
                    if (bb_alias && bb_alias[k] >= 0)
                        continue;
                    if (f->bbs[k].id != tgt
                        && bb_is_empty_shl_arm_to(f, &f->bbs[k], tgt))
                        continue;
                    next_emitted = k;
                    break;
                }
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
            if (verify_on > 0 || clob_verify_on > 0) {
                verify_len = 0;   /* capture this op's emitted asm */
                clob_snap_hl = L.rs.hl; clob_snap_de = L.rs.de;   /* rs.* at op entry */
                clob_snap_bc = L.rs.bc; clob_snap_a  = L.rs.a;
            }
            if (op->kind == IR_RET) {
                rc = lower_ret(out, f, op);
            } else {
                rc = lower_op(out, f, op);
            }
            if (verify_on > 0 || clob_verify_on > 0) { verify_buf[verify_len] = 0; ir_verify_op(f, op, verify_buf); }
            /* [IR_CALLSPLIT] A def of a call-split value OUTSIDE its BC span
               writes the slot (its canonical home) but does NOT update BC, so a
               BC belief left over from the span now LIES (holds the pre-def
               value). Drop it so a later out-of-span read reloads from the
               coherent slot. (In-span defs don't occur — selection requires the
               span read-only — but the ir_home_at guard makes this a no-op there,
               where BC legitimately holds the value.) */
            {
                int dd[8]; int nd = ir_op_defs(op, dd, 8);
                for (int k = 0; k < nd; k++) {
                    int dv = dd[k];
                    if (dv >= 0 && dv < f->n_vregs
                        && (f->vregs[dv].flags & IR_VREG_CALL_SPLIT)
                        && L.rs.bc == dv && ir_home_at(f, dv) != IR_PR_BC)
                        invalidate_bc_cache();
                }
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
        if (bb_bc_out) bb_bc_out[bb->id] = L.rs.bc;
        if (bb_hl_addr_out) bb_hl_addr_out[bb->id] = L.cur_hl_addr_off;
        /* A holds a known byte here only if a byte compare (cp/or a) left it —
           word compares and calls clear rs.a. So rs.a captures A-preservation
           to the (branch) terminator; successors inherit it. */
        if (L.bb_a_out) L.bb_a_out[bb->id] = L.rs.a;
        bb_pending_out[bb->id] = L.pending_spill_v;
        bb_lowered[bb->id] = 1;
    }

    rec_end(f);
    free(bb_bc_out);
    free(bb_hl_addr_out);
    return 0;

cleanup_err:
    /* Caller (ir_lower_func) owns the bb_* arrays and ir_free_liveness. */
    free(bb_bc_out);
    free(bb_hl_addr_out);
    rec_reset();
    return -1;
}
