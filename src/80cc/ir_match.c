/*
 * ir_match.c — declarative IR pattern-matcher engine + production table.
 *
 * One engine owns what each ir_opt_* fusion pass used to hand-roll:
 * the scan, the binding, the standard safety conditions, the rewrite
 * plumbing and the NOP/compact step. A pattern contributes only its
 * templates plus (optionally) a check()/apply() escape hatch. Design
 * and migration plan: PATTERN_MATCHER_PLAN.md. The lesson encoded
 * here (BUG_LOG A33–A40): the bugs live in the side conditions, not
 * the match — so those are written, and fixed, exactly once.
 *
 * The engine itself reads only the IR (ir.c / ir_analysis.c), so the
 * pattern tests stay portable; CPU applicability arrives as the target's
 * CPU_* bit on f->cpu (stamped by ir_build), tested against each pattern's
 * exclude_cpus mask rather than a direct c_cpu read.
 */

#include "ccdefs.h"      /* define.h's CPU_* ids for per-CPU pattern exclusion */
#include "ir_match.h"
#include "ir_analysis.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define IR_MATCH_MAX_ROUNDS    4
#define IR_MATCH_MAX_PATTERNS  64
#define IR_MATCH_MAX_DISABLED  32

/* ----- --opt-disable=pattern:<name> ------------------------------------ */

static char *disabled_names[IR_MATCH_MAX_DISABLED];
static int   n_disabled;

void ir_match_disable(const char *name)
{
    if (!name || !*name) return;
    if (n_disabled >= IR_MATCH_MAX_DISABLED) return;
    for (int i = 0; i < n_disabled; i++)
        if (strcmp(disabled_names[i], name) == 0) return;
    char *copy = malloc(strlen(name) + 1);
    if (!copy) return;
    strcpy(copy, name);
    disabled_names[n_disabled++] = copy;
}

void ir_match_clear_disabled(void)
{
    for (int i = 0; i < n_disabled; i++) free(disabled_names[i]);
    n_disabled = 0;
}

static int pattern_disabled(const PatternDef *p)
{
    for (int i = 0; i < n_disabled; i++)
        if (p->name && strcmp(disabled_names[i], p->name) == 0) return 1;
    return 0;
}

/* ----- APPLY_KILLS scratch ----------------------------------------------
   The current BB's kill bitmap, exposed to a custom apply for the
   duration of its call (single-threaded, non-reentrant). */
static unsigned char *g_apply_dead;
static int            g_apply_dead_n;

void ir_match_mark_dead(int op_idx)
{
    if (g_apply_dead && op_idx >= 0 && op_idx < g_apply_dead_n)
        g_apply_dead[op_idx] = 1;
}

/* ----- Use counts -------------------------------------------------------
   Function-wide use counts back the single-use side condition.
   Recomputed after every successful rewrite: a stale-HIGH count only
   suppresses matches (safe), but a rewrite can both remove uses (the
   NOPed satellites) and add them (the anchor's new srcs), so partial
   updating is exactly the kind of side-condition bug this engine
   exists to retire. The recompute is O(ops) — irrelevant at our
   function sizes. */
static void compute_use_counts(const Func *f, int *uc)
{
    memset(uc, 0, (size_t)f->n_vregs * sizeof(int));
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            int uses[16];
            int nu = ir_op_uses(&bb->ops[j], uses,
                                (int)(sizeof uses / sizeof uses[0]));
            for (int u = 0; u < nu && u < 16; u++) {
                int v = uses[u];
                if (v >= 0 && v < f->n_vregs) uc[v]++;
            }
        }
    }
}

/* ----- Gap-tolerance barriers -------------------------------------------
   An intervening op breaks a gapped match when it could observe or
   disturb state the pattern relies on. The plan's list (call / hcall /
   asm / branch / volatile mem op) plus the sequence-sensitive ops the
   lowerer pins to their neighbours (PUSH_ARG sits glued to its
   producer; the DEHL push/pop pair and critical sections order
   against everything). */
static int gap_barrier(const Op *op)
{
    switch (op->kind) {
    case IR_CALL: case IR_HCALL: case IR_ASM:
    case IR_BR: case IR_BR_COND: case IR_BR_ZERO:
    case IR_SWITCH: case IR_RET:
    case IR_IN: case IR_OUT:
    case IR_LD_FAR: case IR_ST_FAR:
    case IR_CRITICAL_ENTER: case IR_CRITICAL_LEAVE:
    case IR_PUSH_ARG:
    case IR_PUSH_DEHL_LONG: case IR_POP_DEHL_LONG:
        return 1;
    case IR_LD_MEM: case IR_ST_MEM:
        return op->mem.volatile_;
    default:
        return 0;
    }
}

/* ----- Slot / op matching ------------------------------------------------
   bind[] maps var id (1-based; bind[0] unused) → vreg id, -1 unbound.
   Same var ⇒ same vreg; distinct vars ⇒ distinct vregs (rotl's
   t1 != t2 for free). */

#define BIND_SIZE (IR_MATCH_MAX_VARS + 1)

static int match_slot(int spec, int vreg, int *bind)
{
    if (spec == IR_MS_ANY)  return 1;
    if (spec == IR_MS_NONE) return vreg == -1;
    if (spec < 1 || spec > IR_MATCH_MAX_VARS) return 0;
    if (vreg < 0) return 0;
    if (bind[spec] >= 0) return bind[spec] == vreg;
    for (int v = 1; v <= IR_MATCH_MAX_VARS; v++)
        if (bind[v] == vreg) return 0;     /* distinctness */
    bind[spec] = vreg;
    return 1;
}

static int kind_in_set(const OpTemplate *t, OpKind k)
{
    if (t->kind == IR_MK_ANY) return k != IR_NOP;
    if (k == (OpKind)t->kind) return 1;
    if (t->kind_alt  && k == (OpKind)(t->kind_alt  - 1)) return 1;
    if (t->kind_alt2 && k == (OpKind)(t->kind_alt2 - 1)) return 1;
    if (t->kind_alt3 && k == (OpKind)(t->kind_alt3 - 1)) return 1;
    return 0;
}

static int match_op_once(const Func *f, const Op *op, const OpTemplate *t,
                         int *bind, int swap_srcs)
{
    if (!kind_in_set(t, op->kind))
        return 0;
    if (t->imm_pred == IR_IMM_EQ && op->imm != t->imm_val)
        return 0;
    if (t->width) {
        if (op->dst < 0 || op->dst >= f->n_vregs) return 0;
        if (f->vregs[op->dst].width != t->width) return 0;
    }
    int s0 = swap_srcs ? op->src[1] : op->src[0];
    int s1 = swap_srcs ? op->src[0] : op->src[1];
    if (!match_slot(t->dst,  op->dst, bind)) return 0;
    if (!match_slot(t->src0, s0,      bind)) return 0;
    if (!match_slot(t->src1, s1,      bind)) return 0;
    return 1;
}

/* Match one template against one op, rolling bindings back on failure.
   IR_PAT_COMMUTATIVE retries with the op's srcs swapped when both
   template src slots are var ids. */
static int match_op(const Func *f, const Op *op, const OpTemplate *t,
                    int *bind, unsigned flags)
{
    int saved[BIND_SIZE];
    memcpy(saved, bind, sizeof(saved));
    if (match_op_once(f, op, t, bind, 0)) return 1;
    memcpy(bind, saved, sizeof(saved));
    if ((flags & IR_PAT_COMMUTATIVE) && (t->src0 >= 1 || t->src1 >= 1)) {
        if (match_op_once(f, op, t, bind, 1)) return 1;
        memcpy(bind, saved, sizeof(saved));
    }
    return 0;
}

/* Does op define any currently-bound vreg? (Breaks a gapped match.) */
static int defines_bound(const Op *op, const int *bind)
{
    int defs[4];
    int nd = ir_op_defs(op, defs, (int)(sizeof defs / sizeof defs[0]));
    for (int d = 0; d < nd && d < 4; d++) {
        if (defs[d] < 0) continue;
        for (int v = 1; v <= IR_MATCH_MAX_VARS; v++)
            if (bind[v] == defs[d]) return 1;
    }
    return 0;
}

/* ----- Structural match --------------------------------------------------
   Try to match pattern P with its FIRST sequence op at bb->ops[j].
   Sequence order is template order, except IR_PAT_EITHER_ORDER (with
   n_ops >= 3) also tries templates 0 and 1 swapped. idx[]/imm[] are
   filled by TEMPLATE index, so check()/apply()/imm_from stay stable
   under the swap. NOPs (this round's earlier kills) are transparent.
   Returns 1 on structural match. */
static int try_match_at(const Func *f, BB *bb, const PatternDef *P, int j,
                        int order, int *idx, int64_t *imm, int *bind)
{
    for (int v = 0; v <= IR_MATCH_MAX_VARS; v++) bind[v] = -1;

    int pos = j;
    for (int k = 0; k < P->n_ops; k++) {
        /* Template for sequence position k under this order. */
        int tk = k;
        if (order && k < 2) tk = 1 - k;
        const OpTemplate *t = &P->ops[tk];

        if (k > 0) {
            /* Advance to the next candidate op. */
            pos++;
            if (P->flags & IR_PAT_GAP_OK) {
                for (;;) {
                    if (pos >= bb->n_ops) return 0;
                    const Op *op = &bb->ops[pos];
                    if (op->kind == IR_NOP) { pos++; continue; }
                    /* match_op rolls bindings back on failure. */
                    if (match_op(f, op, t, bind, P->flags)) break;
                    if (!(P->flags & IR_PAT_GAP_VALUES)
                        && gap_barrier(op)) return 0;
                    if (defines_bound(op, bind)) return 0;
                    pos++;
                }
                idx[tk] = pos;
                imm[tk] = bb->ops[pos].imm;
                continue;
            }
            /* Adjacent (NOPs transparent). */
            while (pos < bb->n_ops && bb->ops[pos].kind == IR_NOP) pos++;
            if (pos >= bb->n_ops) return 0;
        } else {
            if (bb->ops[pos].kind == IR_NOP) return 0;
        }
        if (!match_op(f, &bb->ops[pos], t, bind, P->flags)) return 0;
        idx[tk] = pos;
        imm[tk] = bb->ops[pos].imm;
    }
    return 1;
}

/* ----- Standard side conditions ------------------------------------------
   Internal temps — vars that are some template's dst AND another
   template's src — must be function-wide single-use (their one use is
   the matched consumer; subsumes not-live-out-of-BB, since liveness
   isn't computed at opt time) and must not be ADDR_TAKEN / PARAM /
   VOLATILE vregs. Enforced by the engine for every pattern; written —
   and fixed — once. */
static int temps_ok(const Func *f, const PatternDef *P,
                    const int *bind, const int *uc)
{
    for (int v = 1; v <= IR_MATCH_MAX_VARS; v++) {
        if (bind[v] < 0) continue;
        int is_dst = 0, is_src = 0;
        for (int k = 0; k < P->n_ops; k++) {
            if (P->ops[k].dst == v) is_dst = 1;
            if (P->ops[k].src0 == v || P->ops[k].src1 == v) is_src = 1;
        }
        if (!is_dst || !is_src) continue;
        int r = bind[v];
        if (r >= f->n_vregs) return 0;
        if (uc[r] != 1) return 0;
        if (f->vregs[r].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_PARAM
                                 | IR_VREG_VOLATILE)) return 0;
    }
    return 1;
}

/* ----- Rewrite ----------------------------------------------------------- */

/* The anchor is the template whose matched op the rewrite mutates;
   default (anchor == 0) is the last template. */
static int anchor_index(const PatternDef *P)
{
    return P->anchor ? P->anchor - 1 : P->n_ops - 1;
}

static void generic_apply(Func *f, BB *bb, const PatternDef *P,
                          const int *idx, const int64_t *imm,
                          const int *bind)
{
    (void)f;
    Op *a = &bb->ops[idx[anchor_index(P)]];
    Op n;
    memset(&n, 0, sizeof(n));
    n.kind   = (OpKind)P->new_kind;
    n.dst    = a->dst;
    n.src[0] = (P->new_src0 >= 1) ? bind[(int)P->new_src0] : a->src[0];
    n.src[1] = -1;
    n.imm    = (P->imm_from >= 1) ? imm[(int)P->imm_from - 1] : a->imm;
    n.mem.base = -1;
    n.label  = -1;
    n.file   = a->file;
    n.line   = a->line;
    *a = n;
}

static void nop_satellites(BB *bb, const PatternDef *P, const int *idx)
{
    int a = anchor_index(P);
    for (int k = 0; k < P->n_ops; k++) {
        if (k == a) continue;
        if (P->ops[k].keep) continue;
        Op *s = &bb->ops[idx[k]];
        s->kind   = IR_NOP;
        s->dst    = -1;
        s->src[0] = -1;
        s->src[1] = -1;
    }
}

/* ----- Engine ------------------------------------------------------------ */

static int run_table_rounds(Func *f, const PatternDef *pats, int n_pats,
                            int max_rounds)
{
    if (!f || !pats || n_pats <= 0) return 0;
    if (n_pats > IR_MATCH_MAX_PATTERNS) n_pats = IR_MATCH_MAX_PATTERNS;
    if (max_rounds > IR_MATCH_MAX_ROUNDS) max_rounds = IR_MATCH_MAX_ROUNDS;

    int counts[IR_MATCH_MAX_PATTERNS];
    memset(counts, 0, sizeof(counts));
    int total = 0;

    int uc_cap = f->n_vregs;
    int *uc = calloc(uc_cap > 0 ? (size_t)uc_cap : 1, sizeof(int));
    if (!uc) return 0;

    for (int round = 0; round < max_rounds; round++) {
        int round_changed = 0;
        compute_use_counts(f, uc);

        for (int b = 0; b < f->n_bbs; b++) {
            BB *bb = &f->bbs[b];
            int bb_dirty = 0;
            /* Ops killed by COMPACTING patterns this round — only
               these are removed at the end of the BB scan. NOPs from
               NO_COMPACT patterns (and any pre-existing ones) stay
               put, exactly as the inherited passes' per-pass dead[]
               arrays behaved: each pass only ever compacted its OWN
               kills, never rotl's distance-padding NOPs. Lazily
               allocated; n_ops can't grow mid-scan (rewrites never
               insert ops). */
            unsigned char *dead = NULL;

            for (int j = 0; j < bb->n_ops; j++) {
                if (bb->ops[j].kind == IR_NOP) continue;
                for (int p = 0; p < n_pats; p++) {
                    const PatternDef *P = &pats[p];
                    if (P->n_ops < 1 || P->n_ops > IR_MATCH_MAX_OPS)
                        continue;
                    if (P->exclude_cpus & f->cpu)
                        continue;
                    if (pattern_disabled(P)) continue;

                    int     idx[IR_MATCH_MAX_OPS];
                    int64_t imm[IR_MATCH_MAX_OPS];
                    int     bind[BIND_SIZE];
                    int n_orders =
                        ((P->flags & IR_PAT_EITHER_ORDER) && P->n_ops >= 3)
                        ? 2 : 1;
                    int matched = 0;
                    for (int ord = 0; ord < n_orders && !matched; ord++) {
                        if (!try_match_at(f, bb, P, j, ord, idx, imm, bind))
                            continue;
                        /* Single-use temps exist to make satellite
                           deletion safe; a keep-satellites pattern
                           only reads values, and a NO_AUTO_TEMPS
                           pattern owns its conditions in check(). */
                        if (!(P->flags & (IR_PAT_KEEP_SATELLITES
                                          | IR_PAT_NO_AUTO_TEMPS))
                            && !temps_ok(f, P, bind, uc)) continue;
                        if (P->check
                            && !P->check(f, bb, idx, imm, bind, uc))
                            continue;
                        matched = 1;
                    }
                    if (!matched) continue;

                    if (P->apply) {
                        /* APPLY_KILLS apply discovers its own victims
                           (pack's tree-walked chain) and marks them via
                           ir_match_mark_dead — expose the kill bitmap
                           for the duration of the call. */
                        if (P->flags & IR_PAT_APPLY_KILLS) {
                            if (!dead)
                                dead = calloc((size_t)bb->n_ops, 1);
                            g_apply_dead   = dead;
                            g_apply_dead_n = bb->n_ops;
                        }
                        P->apply(f, bb, idx, imm, bind);
                        if (P->flags & IR_PAT_APPLY_KILLS) {
                            g_apply_dead = NULL;
                            if (dead) bb_dirty = 1;
                        }
                    } else {
                        generic_apply(f, bb, P, idx, imm, bind);
                    }
                    if (!(P->flags & IR_PAT_KEEP_SATELLITES)) {
                        nop_satellites(bb, P, idx);
                        {
                            if (!dead)
                                dead = calloc((size_t)bb->n_ops, 1);
                            if (dead) {
                                int ai = anchor_index(P);
                                for (int k = 0; k < P->n_ops; k++)
                                    if (k != ai && !P->ops[k].keep)
                                        dead[idx[k]] = 1;
                            }
                            bb_dirty = 1;
                        }
                    }

                    counts[p]++;
                    total++;
                    round_changed++;

                    /* A custom apply may have created vregs. */
                    if (f->n_vregs > uc_cap) {
                        int *nu = realloc(uc,
                                          (size_t)f->n_vregs * sizeof(int));
                        if (!nu) { free(uc); return total; }
                        uc = nu;
                        uc_cap = f->n_vregs;
                    }
                    compute_use_counts(f, uc);

                    /* Resume past the anchor; the satellites before it
                       are NOPs now and stay transparent. */
                    j = idx[P->n_ops - 1];
                    break;
                }
            }

            /* Compact ONLY this round's compacting-pattern kills —
               leftover NOPs from them would break the adjacency the
               dead-spill analysis relies on, but NO_COMPACT NOPs are
               load-bearing (long-push distances) and must survive. */
            if (bb_dirty && dead) {
                int new_n = 0;
                for (int k = 0; k < bb->n_ops; k++) {
                    if (dead[k]) continue;
                    if (new_n != k) bb->ops[new_n] = bb->ops[k];
                    new_n++;
                }
                bb->n_ops = new_n;
            }
            free(dead);
        }

        if (!round_changed) break;
    }
    free(uc);

    if (total > 0 && getenv("IR_OPT_VERBOSE")) {
        fputs("ir_match:", stderr);
        for (int p = 0; p < n_pats; p++)
            if (counts[p])
                fprintf(stderr, " %s x%d",
                        pats[p].name ? pats[p].name : "?", counts[p]);
        fputc('\n', stderr);
    }
    return total;
}

int ir_match_run_table(Func *f, const PatternDef *pats, int n_pats)
{
    return run_table_rounds(f, pats, n_pats, IR_MATCH_MAX_ROUNDS);
}

/* ----- Production table --------------------------------------------------
   Stages 1–7 migrate the ir_opt_* fusion passes here one at a time,
   each gated on a byte-identical bench-corpus diff
   (PATTERN_MATCHER_PLAN.md §6). Keep longest-n_ops patterns first
   among those sharing an anchor kind — earlier table entries win at a
   given anchor. */

/* immconv — CONV of a known immediate folds to a re-width'd LD_IMM
   (migrated from ir_opt_fold_imm_conv). ir_build's typed-store paths
   converge constants through a CONV (`g = 0xD4` into a char global is
   LD_IMM(int) + CONV_TRUNC), which would lower to an HL load + byte
   spill + reload; folded, it's `ld a,K` at the use. The LD_IMM
   satellite survives (KEEP_SATELLITES — it may feed other readers;
   orphans die in DCE), and the gap runs on VALUES (a vreg-held
   immediate survives calls/stores; only redefinition breaks it).
   Chained folds (CONV of a folded CONV) converge across rounds. */

enum { IV_V = 1, IV_D };   /* immconv binding vars */

static int immconv_check(Func *f, BB *bb, const int idx[],
                         const int64_t imm[], const int bind[],
                         const int uc[])
{
    (void)imm; (void)uc;
    const Op *a = &bb->ops[idx[1]];
    if (a->dst < 0 || a->dst >= f->n_vregs) return 0;
    /* Don't converge the constant through the CONV when the source is an
       address-taken or volatile local: its slot can be written through an
       aliasing pointer between the LD_IMM and the CONV, so the CONV must
       reload from memory rather than reuse the literal (`long n; long *p=&n;
       n=10; *p+=31; return n;` would fold the return to a stale 10). */
    if (f->vregs[bind[IV_V]].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
        return 0;
    int sw = f->vregs[bind[IV_V]].width;
    int dw = f->vregs[a->dst].width;
    return (sw == 1 || sw == 2 || sw == 4)
        && (dw == 1 || dw == 2 || dw == 4);
}

static void immconv_apply(Func *f, BB *bb, const int idx[],
                          const int64_t imm[], const int bind[])
{
    Op *a = &bb->ops[idx[1]];
    int sw = f->vregs[bind[IV_V]].width;
    int dw = f->vregs[a->dst].width;
    uint64_t sm = (sw == 1) ? 0xff : (sw == 2) ? 0xffff : 0xffffffffu;
    uint64_t dm = (dw == 1) ? 0xff : (dw == 2) ? 0xffff : 0xffffffffu;
    uint64_t v = (uint64_t)imm[0] & sm;
    int64_t res;
    if (a->kind == IR_CONV_SX) {
        /* Sign-extend from src width, then clip to dst width. */
        uint64_t sign = (uint64_t)1 << (sw * 8 - 1);
        res = (int64_t)(((v ^ sign) - sign) & dm);
    } else if (a->kind == IR_CONV_BYTE_TO_HIGH) {
        res = (int64_t)(((v & 0xff) << 8) & dm);
    } else {
        /* TRUNC keeps the low dst-width bytes; ZX is the same mask
           (v already clipped to src width). */
        res = (int64_t)(v & dm);
    }
    a->kind   = IR_LD_IMM;
    a->src[0] = -1;
    a->src[1] = -1;
    a->imm    = res;
}

/* rotl — the ROTATE_LEFT macro triple (migrated from
   ir_opt_fuse_rotl): `SHL t1 <- v,n; SHR t2 <- v,32-n; OR d <- t1,t2`
   with the shifts in either order and the OR's operands either way
   becomes IR_ROTL d <- v, imm n. One cache-served read of v instead
   of two (the second shift reloaded the slot after the first
   clobbered DEHL), and the lowering byte-permutes + bit-rotates in
   registers instead of running two count-N shift loops + a 4-byte OR.
   Width-4 only.

   The ROTL lowering bit-rotates via CB-prefix srl/rl — 8080/8085 only
   have RAL/RAR through A, so the pattern is excluded there (exclude_cpus)
   and the SHL|SHR|OR triple lowers via the shift helpers instead. */

enum { RV_V = 1, RV_T1, RV_T2 };   /* rotl binding vars */

static int rotl_check(Func *f, BB *bb, const int idx[],
                      const int64_t imm[], const int bind[],
                      const int uc[])
{
    (void)bb; (void)idx; (void)uc;
    if (f->vregs[bind[RV_V]].width != 4) return 0;
    int nl = (int)imm[0], nr = (int)imm[1];
    return nl >= 1 && nl <= 31 && nl + nr == 32;
}

/* symoff — LD_SYM + ADD/SUB imm fold (migrated from
   ir_opt_sym_offset_fold): `LD_SYM a <- sym+K1; ADD b <- a (imm=K2)`
   (a single-use) becomes `LD_SYM b <- sym+(K1±K2)`. The lowerer emits
   `ld hl,_sym+K` for LD_SYM-with-offset (1 inst); unfolded, member
   accesses like `g.counter` cost `ld hl,_sym; ld de,K; add hl,de`. */

enum { YV_A = 1 };   /* symoff binding var */

static int symoff_check(Func *f, BB *bb, const int idx[],
                        const int64_t imm[], const int bind[],
                        const int uc[])
{
    (void)f; (void)bind; (void)uc;
    const Op *ld = &bb->ops[idx[0]];
    const Op *ar = &bb->ops[idx[1]];
    if (ld->mem.kind != IR_MEM_SYM || !ld->mem.sym) return 0;
    int64_t add = (ar->kind == IR_ADD) ? imm[1] : -imm[1];
    int64_t no = (int64_t)ld->mem.offset + add;
    return no >= INT32_MIN && no <= INT32_MAX;
}

static void symoff_apply(Func *f, BB *bb, const int idx[],
                         const int64_t imm[], const int bind[])
{
    (void)f; (void)bind;
    Op *ld = &bb->ops[idx[0]];
    Op *ar = &bb->ops[idx[1]];
    int64_t add = (ar->kind == IR_ADD) ? imm[1] : -imm[1];
    int64_t no  = (int64_t)ld->mem.offset + add;
    SYMBOL *sym = ld->mem.sym;
    Op n;
    memset(&n, 0, sizeof(n));
    n.kind       = IR_LD_SYM;
    n.dst        = ar->dst;
    n.src[0]     = -1;
    n.src[1]     = -1;
    n.mem.kind   = IR_MEM_SYM;
    n.mem.sym    = sym;
    n.mem.base   = -1;
    n.mem.offset = (int)no;
    n.label      = -1;
    n.file       = ar->file;
    n.line       = ar->line;
    *ar = n;
}

/* vregoff — the VREG twin of symoff (migrated from
   ir_opt_vreg_offset_fold), three shapes anchored on the mem op.
   Templates carry only the kinds and adjacency; everything that
   lives in mem fields (base / post_step / volatile_) plus the
   single-use and width gates sit in check() — NO_AUTO_TEMPS, since
   the consumer's "use" of the folded vreg is mem.base, which is not
   a template slot the auto rule can see.

     vregoff_sym  LD_SYM t <- sym+K1; MEM [t, K2]
                  → absolute MEM SYM[sym+K1+K2] (`ld a,(_sym+K)`)
     vregoff_imm  ADD/SUB t <- p (imm=K); MEM [t, off]
                  → MEM [p, off±K] (`p + 3` struct-member access)
     vregoff_idx  ADD/SUB t1 <- i (imm=K); ADD t2 <- p,t1 (either
                  order); MEM [t2, off] → ADD t2 <- p,i; MEM [t2,
                  off±K] — the md5 `b[ii+3]` byte-gather. The middle
                  ADD survives with t1 swapped for i (template keep
                  bit). */

enum { ZV_T = 1, ZV_P, ZV_T2, ZV_I };   /* vregoff binding vars */

static int vregoff_mem_ok(const Func *f, const Op *m, int base,
                          const int uc[], int width_of)
{
    if (m->mem.kind != IR_MEM_VREG) return 0;
    if (m->mem.base != base) return 0;
    if (m->mem.post_step != 0) return 0;
    if (m->mem.volatile_) return 0;
    if (m->src[0] == base || m->src[1] == base) return 0;
    if (uc[base] != 1) return 0;
    return f->vregs[width_of].width == 2;
}

static int vregoff_sym_check(Func *f, BB *bb, const int idx[],
                             const int64_t imm[], const int bind[],
                             const int uc[])
{
    (void)imm;
    const Op *ad = &bb->ops[idx[0]];
    const Op *ms = &bb->ops[idx[1]];
    if (ad->mem.kind != IR_MEM_SYM || !ad->mem.sym) return 0;
    int t = bind[ZV_T];
    if (!vregoff_mem_ok(f, ms, t, uc, t)) return 0;
    int64_t no = (int64_t)ad->mem.offset + ms->mem.offset;
    return no >= INT32_MIN && no <= INT32_MAX;
}

static void vregoff_sym_apply(Func *f, BB *bb, const int idx[],
                              const int64_t imm[], const int bind[])
{
    (void)f; (void)imm; (void)bind;
    Op *ad = &bb->ops[idx[0]];
    Op *ms = &bb->ops[idx[1]];
    ms->mem.kind   = IR_MEM_SYM;
    ms->mem.sym    = ad->mem.sym;
    ms->mem.base   = -1;
    ms->mem.offset = (int)((int64_t)ad->mem.offset + ms->mem.offset);
}

static int64_t vregoff_k(const Op *ad, int64_t imm0)
{
    return (ad->kind == IR_ADD) ? imm0 : -imm0;
}

static int vregoff_imm_check(Func *f, BB *bb, const int idx[],
                             const int64_t imm[], const int bind[],
                             const int uc[])
{
    const Op *ad = &bb->ops[idx[0]];
    const Op *mo = &bb->ops[idx[1]];
    int t = bind[ZV_T];
    if (!vregoff_mem_ok(f, mo, t, uc, t)) return 0;
    int64_t no = (int64_t)mo->mem.offset + vregoff_k(ad, imm[0]);
    return no >= INT32_MIN && no <= INT32_MAX;
}

static void vregoff_imm_apply(Func *f, BB *bb, const int idx[],
                              const int64_t imm[], const int bind[])
{
    (void)f;
    Op *ad = &bb->ops[idx[0]];
    Op *mo = &bb->ops[idx[1]];
    mo->mem.base   = bind[ZV_P];
    mo->mem.offset = (int)((int64_t)mo->mem.offset
                           + vregoff_k(ad, imm[0]));
}

static int vregoff_idx_check(Func *f, BB *bb, const int idx[],
                             const int64_t imm[], const int bind[],
                             const int uc[])
{
    const Op *ad = &bb->ops[idx[0]];
    const Op *a2 = &bb->ops[idx[1]];
    const Op *m3 = &bb->ops[idx[2]];
    int t1 = bind[ZV_T], t2 = bind[ZV_T2];
    if (uc[t1] != 1 || f->vregs[t1].width != 2) return 0;
    /* t1 in EXACTLY one of the index ADD's slots. */
    if ((a2->src[0] == t1) == (a2->src[1] == t1)) return 0;
    if (!vregoff_mem_ok(f, m3, t2, uc, t2)) return 0;
    int64_t no = (int64_t)m3->mem.offset + vregoff_k(ad, imm[0]);
    return no >= INT32_MIN && no <= INT32_MAX;
}

static void vregoff_idx_apply(Func *f, BB *bb, const int idx[],
                              const int64_t imm[], const int bind[])
{
    (void)f;
    Op *ad = &bb->ops[idx[0]];
    Op *a2 = &bb->ops[idx[1]];
    Op *m3 = &bb->ops[idx[2]];
    int t1 = bind[ZV_T];
    int slot = (a2->src[0] == t1) ? 0 : 1;
    a2->src[slot]  = bind[ZV_I];
    m3->mem.offset = (int)((int64_t)m3->mem.offset
                           + vregoff_k(ad, imm[0]));
}

static const PatternDef ir_patterns[] = {
    { .name = "immconv", .n_ops = 2,
      .flags = IR_PAT_GAP_OK | IR_PAT_GAP_VALUES | IR_PAT_KEEP_SATELLITES,
      .ops = {
          { .kind = IR_LD_IMM, .dst = IV_V, .imm_pred = IR_IMM_ANY },
          { .kind = IR_CONV_TRUNC,
            .kind_alt  = 1 + IR_CONV_ZX,
            .kind_alt2 = 1 + IR_CONV_SX,
            .kind_alt3 = 1 + IR_CONV_BYTE_TO_HIGH,
            .dst = IV_D, .src0 = IV_V },
      },
      .check = immconv_check, .apply = immconv_apply },

    { .name = "rotl", .n_ops = 3,
      .flags = IR_PAT_EITHER_ORDER | IR_PAT_COMMUTATIVE,
      /* gen_rotl emits CB shifts (srl/rr/set); on 8080/8085 (no CB ops)
         leave the SHL|SHR|OR unfused so it lowers via the shift helpers. */
      .exclude_cpus = CPU_8080 | CPU_8085,
      .ops = {
          { .kind = IR_SHL, .dst = RV_T1, .src0 = RV_V,
            .imm_pred = IR_IMM_ANY, .width = 4 },
          { .kind = IR_SHR, .dst = RV_T2, .src0 = RV_V,
            .imm_pred = IR_IMM_ANY, .width = 4 },
          /* dst is ANY, not a var: `a = ROTATE_LEFT(a, s)` writes the
             OR back into the source vreg, and a var here would
             collide with RV_V under the distinctness rule. Generic
             apply keeps the anchor's dst regardless. */
          { .kind = IR_OR, .dst = IR_MS_ANY,
            .src0 = RV_T1, .src1 = RV_T2 },
      },
      .check = rotl_check,
      .new_kind = IR_ROTL, .new_src0 = RV_V, .imm_from = 1 },
};
static const int ir_n_patterns =
    (int)(sizeof ir_patterns / sizeof ir_patterns[0]);

/* symoff and the vregoff family run as SINGLE-ROUND scans after the
   rounds-to-fixpoint table above, mirroring the single linear passes
   they migrated from: those passes' j-skips left fold CHAINS
   half-folded (vregoff_idx output is a vregoff_imm candidate the old
   scan never revisited), and rounds would fold them deeper — better
   code, but that relax lands as its own measured commit. vregoff runs
   AFTER symoff completes so it sees the folded LD_SYMs, exactly as
   the pass order did. */

static const PatternDef ir_patterns_symoff[] = {
    { .name = "symoff", .n_ops = 2,
      .ops = {
          { .kind = IR_LD_SYM, .dst = YV_A },
          /* dst is ANY: nothing stops the folded address landing back
             in the ADD's own dst, and the rewrite keeps it. */
          { .kind = IR_ADD, .kind_alt = 1 + IR_SUB, .dst = IR_MS_ANY,
            .src0 = YV_A, .imm_pred = IR_IMM_ANY },
      },
      .check = symoff_check, .apply = symoff_apply },
};

static const PatternDef ir_patterns_vregoff[] = {
    { .name = "vregoff_sym", .n_ops = 2,
      .flags = IR_PAT_NO_AUTO_TEMPS,
      .ops = {
          { .kind = IR_LD_SYM, .dst = ZV_T },
          { .kind = IR_LD_MEM, .kind_alt = 1 + IR_ST_MEM,
            .dst = IR_MS_ANY, .src0 = IR_MS_ANY, .src1 = IR_MS_ANY },
      },
      .check = vregoff_sym_check, .apply = vregoff_sym_apply },

    { .name = "vregoff_imm", .n_ops = 2,
      .flags = IR_PAT_NO_AUTO_TEMPS,
      .ops = {
          { .kind = IR_ADD, .kind_alt = 1 + IR_SUB, .dst = ZV_T,
            .src0 = ZV_P, .imm_pred = IR_IMM_ANY },
          { .kind = IR_LD_MEM, .kind_alt = 1 + IR_ST_MEM,
            .dst = IR_MS_ANY, .src0 = IR_MS_ANY, .src1 = IR_MS_ANY },
      },
      .check = vregoff_imm_check, .apply = vregoff_imm_apply },

    { .name = "vregoff_idx", .n_ops = 3,
      .flags = IR_PAT_NO_AUTO_TEMPS | IR_PAT_COMMUTATIVE,
      .ops = {
          { .kind = IR_ADD, .kind_alt = 1 + IR_SUB, .dst = ZV_T,
            .src0 = ZV_I, .imm_pred = IR_IMM_ANY },
          /* keep: survives with t1 swapped for i in apply. */
          { .kind = IR_ADD, .dst = ZV_T2, .src0 = ZV_T,
            .src1 = IR_MS_ANY, .keep = 1 },
          { .kind = IR_LD_MEM, .kind_alt = 1 + IR_ST_MEM,
            .dst = IR_MS_ANY, .src0 = IR_MS_ANY, .src1 = IR_MS_ANY },
      },
      .check = vregoff_idx_check, .apply = vregoff_idx_apply },
};

/* incmhl — long (*p)++ fuse (migrated from ir_opt_long_inc_mhl):

     LD_MEM v_old <- [v_p, 0]      (width 4, MEM_VREG)
     ADD    v_new <- v_old (imm=1)
     ST_MEM [v_p, 0], v_new

   with v_old/v_new used nowhere outside the triple (the
   discarded-result `(*p)++;` / `c->i[k]++;` statement shape) becomes
   one IR_HCALL l_long_inc_mhl(v_p) — the helper increments the long
   at *HL in place (IX-clean: F + HL only). One slot load + call (~5
   inst) replaces the inline ~30-inst long LD/ADD/ST chain. Offset
   restricted to 0: the helper expects HL = pointer. POST/PRE shapes
   where the value IS used fall through to the inline path. */

enum { LV_OLD = 1, LV_NEW };   /* incmhl binding vars */

static int incmhl_check(Func *f, BB *bb, const int idx[],
                        const int64_t imm[], const int bind[],
                        const int uc[])
{
    (void)f; (void)imm; (void)bind; (void)uc;
    const Op *ld = &bb->ops[idx[0]];
    const Op *st = &bb->ops[idx[2]];
    if (ld->mem.kind != IR_MEM_VREG || ld->mem.volatile_) return 0;
    if (st->mem.kind != IR_MEM_VREG || st->mem.volatile_) return 0;
    if (st->mem.base != ld->mem.base) return 0;
    if (st->mem.offset != ld->mem.offset) return 0;
    /* Helper expects HL = pointer — offset 0 only (covers shapes
       where the address ADD already folded into the base vreg). */
    return ld->mem.offset == 0;
}

static void incmhl_apply(Func *f, BB *bb, const int idx[],
                         const int64_t imm[], const int bind[])
{
    (void)f; (void)imm; (void)bind;
    Op *ld = &bb->ops[idx[0]];
    int ptr_v = ld->mem.base;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    int *args = calloc(1, sizeof(int));
    if (!hi || !args) { free(hi); free(args); return; }
    hi->name     = "l_long_inc_mhl";
    args[0]      = ptr_v;
    hi->args     = args;
    hi->n_args   = 1;
    hi->ret_vreg = -1;
    Op n;
    memset(&n, 0, sizeof(n));
    n.kind     = IR_HCALL;
    n.dst      = -1;
    n.src[0]   = -1;
    n.src[1]   = -1;
    n.mem.base = -1;
    n.label    = -1;
    n.hcall    = hi;
    n.file     = ld->file;
    n.line     = ld->line;
    *ld = n;
}

static const PatternDef ir_patterns_incmhl[] = {
    { .name = "incmhl", .n_ops = 3, .anchor = 1,
      .ops = {
          { .kind = IR_LD_MEM, .dst = LV_OLD, .width = 4 },
          { .kind = IR_ADD, .dst = LV_NEW, .src0 = LV_OLD,
            .imm_pred = IR_IMM_EQ, .imm_val = 1, .width = 4 },
          { .kind = IR_ST_MEM, .src0 = LV_NEW },
      },
      .check = incmhl_check, .apply = incmhl_apply },
};

int ir_match_run(Func *f)
{
    int n = run_table_rounds(f, ir_patterns, ir_n_patterns,
                             IR_MATCH_MAX_ROUNDS);
    /* Offset folds run to fixpoint (was single-round, mirroring the
       old linear passes). vregoff_idx output (ADD t2 <- p,i ; MEM
       [t2, off+K]) is itself a vregoff_imm candidate the single pass
       never revisited — rounds re-fold it, dropping an md5 address
       spill. symoff to fixpoint is a corpus no-op but folds chained
       sym+K1+K2 correctly. */
    n += run_table_rounds(f, ir_patterns_symoff, 1, IR_MATCH_MAX_ROUNDS);
    n += run_table_rounds(f, ir_patterns_vregoff,
                          (int)(sizeof ir_patterns_vregoff
                                / sizeof ir_patterns_vregoff[0]),
                          IR_MATCH_MAX_ROUNDS);
    n += run_table_rounds(f, ir_patterns_incmhl, 1, 1);
    return n;
}

/* ----- Early phase (pre-st2ld) -------------------------------------------
   poststep and movfuse run before st2ld: its load-forwarding creates
   fresh MOVs that multiply use counts movfuse's single-use gate reads
   (MD5 Transform's prologue `UINT4 a = buf[0]` loads). Run as two
   SEQUENTIAL single-pattern fixpoints mirroring the pass order they
   migrated from — one merged run could fuse MOV;MOV;INC shapes the
   old pipeline missed, and that relax must land separately. */

/* poststep — `MOV t <- x; INC/DEC x` (post-step-as-value, migrated
   from ir_opt_fuse_poststep) fuses to IR_POSTSTEP t <- x (imm=±1):
   one slot read + writeback with the old value left in HL (~88T)
   instead of the old-value round-trip through a frame temp (~230T in
   fp mode). Hot in every `while (n--)` / `*p++` loop. NO_AUTO_TEMPS:
   x is a real, multi-use loop variable — the INC's def of x is
   preserved by the multi-def anchor, not deleted. */

enum { PV_T = 1, PV_X };   /* poststep binding vars */

static int poststep_check(Func *f, BB *bb, const int idx[],
                          const int64_t imm[], const int bind[],
                          const int uc[])
{
    (void)bb; (void)idx; (void)imm; (void)uc;
    return !(f->vregs[bind[PV_X]].flags & IR_VREG_VOLATILE);
}

static void poststep_apply(Func *f, BB *bb, const int idx[],
                           const int64_t imm[], const int bind[])
{
    (void)f; (void)imm; (void)bind;
    Op *a = &bb->ops[idx[0]];
    a->kind = IR_POSTSTEP;
    a->imm  = (bb->ops[idx[1]].kind == IR_INC) ? 1 : -1;
}

static const PatternDef pat_poststep = {
    .name = "poststep", .n_ops = 2, .anchor = 1,
    .flags = IR_PAT_NO_AUTO_TEMPS,
    .ops = {
        { .kind = IR_MOV, .dst = PV_T, .src0 = PV_X, .width = 2 },
        { .kind = IR_INC, .kind_alt = 1 + IR_DEC,
          .dst = PV_X, .src0 = PV_X, .width = 2 },
    },
    .check = poststep_check, .apply = poststep_apply,
};

/* derefpp — `*p++` / `*p--`: a load through a pointer immediately
   followed by stepping that same pointer fuses into one post-step load
   (mem.post_step = ±step), so the lowerer dereferences AND bumps p in a
   single HL tenancy instead of reloading p's slot for the separate step.
   The pointer p is in mem.base (not a template src slot), so the base↔step
   identity is checked in derefpp_check. Anchors on the LOAD (op[0]); the
   step op is the satellite. NO_AUTO_TEMPS: p is a real multi-use loop
   var whose def folds into the post-step anchor (ir_op_defs reports the
   post-step's base def), exactly like poststep's INC. Supported shapes
   (gated to what the post-step lowering emits): byte load + INC/DEC
   (char* `*p++`, step ±1); word load + forward ADD-imm (int* `*p++`,
   step +K). */
enum { DPV_P = 1 };

static int derefpp_check(Func *f, BB *bb, const int idx[],
                         const int64_t imm[], const int bind[], const int uc[])
{
    (void)imm; (void)uc;
    const Op *ld = &bb->ops[idx[0]];
    const Op *st = &bb->ops[idx[1]];
    int p = bind[DPV_P];
    if (ld->mem.kind != IR_MEM_VREG) return 0;
    if (ld->mem.offset != 0 || ld->mem.post_step != 0 || ld->mem.volatile_)
        return 0;
    if (ld->mem.base != p) return 0;          /* the load is through p */
    if (ld->dst < 0 || ld->dst == p) return 0; /* `p = *p++` would self-clobber */
    if (f->vregs[p].flags & IR_VREG_VOLATILE) return 0;
    int w = f->vregs[ld->dst].width;
    if (st->kind == IR_ADD || st->kind == IR_SUB) {
        if (st->src[1] != -1) return 0;        /* imm-form step only */
        if (st->kind == IR_SUB || imm[1] <= 0) return 0; /* forward only */
        return w == 2;                          /* word `*p++` (int*) */
    }
    return w == 1;                              /* byte `*p++` (INC/DEC) */
}

static void derefpp_apply(Func *f, BB *bb, const int idx[],
                          const int64_t imm[], const int bind[])
{
    (void)f; (void)bind;
    Op *ld = &bb->ops[idx[0]];
    const Op *st = &bb->ops[idx[1]];
    int64_t step;
    switch (st->kind) {
    case IR_INC: step = 1;       break;
    case IR_DEC: step = -1;      break;
    case IR_ADD: step = imm[1];  break;
    default:     step = -imm[1]; break;   /* IR_SUB (unreached: gated out) */
    }
    ld->mem.post_step = (int)step;
}

static const PatternDef pat_derefpp = {
    .name = "derefpp", .n_ops = 2, .anchor = 1,
    .flags = IR_PAT_NO_AUTO_TEMPS,
    .ops = {
        { .kind = IR_LD_MEM, .dst = IR_MS_ANY,
          .src0 = IR_MS_NONE, .src1 = IR_MS_NONE },
        { .kind = IR_INC, .kind_alt = 1 + IR_DEC,
          .kind_alt2 = 1 + IR_ADD, .kind_alt3 = 1 + IR_SUB,
          .dst = DPV_P, .src0 = DPV_P, .src1 = IR_MS_NONE,
          .imm_pred = IR_IMM_ANY },
    },
    .check = derefpp_check, .apply = derefpp_apply,
};

/* stpp — store post-step (`*p++ = v`), the store-side mirror of derefpp.
   After the poststep pass fuses `MOV t<-p; INC p` into `POSTSTEP t<-p`, the
   pre-increment store idiom reads:
       POSTSTEP t <- p (imm=±1)      ; t = old p, p += 1
       ST_MEM  [t], v                ; *old_p = v
   which is `*p++ = v`. Fuse to `ST_MEM [p], v (post_step=±1)`: store through
   p, then step p — one register pointer instead of a slot round-trip for the
   copy. The POSTSTEP (satellite) is dropped; ir_op_defs reports the store's
   base redef so liveness keeps p live. Requires t used ONLY by the store
   (single-use) so dropping the POSTSTEP is safe. Byte stores, offset 0,
   non-volatile, non-banked only — matching what gen_st_mem's post-step
   lowering handles. Gated behind IR_LOOP_RA: it changes `*p++=v` codegen
   corpus-wide, so it stays opt-in with the loop register allocator that
   motivates it (a walking dst pointer homed in BC/DE → `ld (de),a; inc de`). */
enum { SPV_P = 1, SPV_T };

static int stpp_check(Func *f, BB *bb, const int idx[],
                      const int64_t imm[], const int bind[], const int uc[])
{
    (void)imm;
    const Op *ps = &bb->ops[idx[0]];   /* POSTSTEP (satellite) */
    const Op *st = &bb->ops[idx[1]];   /* ST_MEM   (anchor)    */
    int p = bind[SPV_P];
    int t = bind[SPV_T];
    if (ps->kind != IR_POSTSTEP) return 0;
    if (ps->imm != 1 && ps->imm != -1) return 0;   /* byte ±1 step only */
    if (st->kind != IR_ST_MEM) return 0;
    if (st->mem.kind != IR_MEM_VREG) return 0;
    if (st->mem.base != t) return 0;               /* store through the copy */
    if (st->mem.offset != 0) return 0;
    if (st->mem.volatile_ || st->mem.bank_fn || st->mem.elem == KIND_CPTR)
        return 0;
    if (st->mem.post_step != 0) return 0;
    if (t < 0 || p < 0 || t == p) return 0;
    if (t >= f->n_vregs || uc[t] != 1) return 0;   /* t used only by the store */
    if (f->vregs[p].flags & IR_VREG_VOLATILE) return 0;
    if (st->src[0] < 0) return 0;                  /* real value (not folded imm) */
    if (st->src[0] == t || st->src[0] == p) return 0;
    if (f->vregs[st->src[0]].width != 1) return 0; /* byte store */
    return 1;
}

static void stpp_apply(Func *f, BB *bb, const int idx[],
                       const int64_t imm[], const int bind[])
{
    (void)f; (void)imm;
    const Op *ps = &bb->ops[idx[0]];
    Op *st = &bb->ops[idx[1]];             /* anchor = ST_MEM */
    st->mem.base = bind[SPV_P];            /* store through p directly */
    st->mem.post_step = (int)ps->imm;      /* then p += imm */
}

static const PatternDef pat_stpp = {
    .name = "stpp", .n_ops = 2, .anchor = 2,   /* anchor = ST_MEM (index 1) */
    .flags = IR_PAT_NO_AUTO_TEMPS,
    .ops = {
        { .kind = IR_POSTSTEP, .dst = SPV_T, .src0 = SPV_P,
          .imm_pred = IR_IMM_ANY },
        { .kind = IR_ST_MEM, .dst = IR_MS_NONE,
          .src0 = IR_MS_ANY, .src1 = IR_MS_NONE },
    },
    .check = stpp_check, .apply = stpp_apply,
};

/* copystep — the byte copy-loop `while ((*d++ = *s++))` (strcpy/strcat). After
   derefpp + stpp the loop body is the adjacent triple
       LD_MEM  t <- [s] (post_step ±1)     ; t = *s, s += step
       ST_MEM  [d], t   (post_step ±1)     ; *d = t, d += step
       BR_ZERO t, exit                     ; if t == 0 goto exit
   with t used ONLY by the store + branch (dead after). Fuse to one
   IR_COPY_STEP_BRZ carrying (s=src[0], d=src[1], step=imm, label): it lowers to
   `ld a,(de); ld (bc),a; inc de; inc bc; or a; jp z`. The byte temp t vanishes
   as a vreg — so nothing spills, and a function that was frameless-but-for-t's
   slot drops frame_size to 0. Anchors on the BR_ZERO (the others NOP); the BB's
   loop-back BR is untouched, so successors are unchanged. */
enum { CSV_T = 1 };

static int copystep_check(Func *f, BB *bb, const int idx[],
                          const int64_t imm[], const int bind[], const int uc[])
{
    (void)imm;
    const Op *ld = &bb->ops[idx[0]];
    const Op *st = &bb->ops[idx[1]];
    const Op *br = &bb->ops[idx[2]];
    int t = bind[CSV_T];
    if (ld->kind != IR_LD_MEM || st->kind != IR_ST_MEM
        || br->kind != IR_BR_ZERO) return 0;
    if (ld->mem.kind != IR_MEM_VREG || st->mem.kind != IR_MEM_VREG) return 0;
    /* both post-step ±1, same step, byte, offset 0, plain (not far/volatile). */
    int step = ld->mem.post_step;
    if (step != 1 && step != -1) return 0;
    if (st->mem.post_step != step) return 0;
    if (ld->mem.offset || st->mem.offset) return 0;
    if (ld->mem.volatile_ || st->mem.volatile_) return 0;
    if (ld->mem.bank_fn || st->mem.bank_fn) return 0;
    if (ld->mem.elem == KIND_CPTR || st->mem.elem == KIND_CPTR) return 0;
    if (t < 0 || t >= f->n_vregs || f->vregs[t].width != 1) return 0;
    if (st->src[0] != t || br->src[0] != t) return 0;   /* t is stored + tested */
    if (uc[t] != 2) return 0;                            /* used ONLY here (dead after) */
    int s = ld->mem.base, d = st->mem.base;
    if (s < 0 || d < 0 || s == d || s == t || d == t) return 0;
    if (f->vregs[s].flags & IR_VREG_VOLATILE) return 0;
    if (f->vregs[d].flags & IR_VREG_VOLATILE) return 0;
    return 1;
}

static void copystep_apply(Func *f, BB *bb, const int idx[],
                           const int64_t imm[], const int bind[])
{
    (void)f; (void)imm; (void)bind;
    const Op *ld = &bb->ops[idx[0]];
    const Op *st = &bb->ops[idx[1]];
    Op *br = &bb->ops[idx[2]];             /* anchor = BR_ZERO */
    int s = ld->mem.base, d = st->mem.base, step = ld->mem.post_step;
    int label = br->label;
    br->kind = IR_COPY_STEP_BRZ;
    br->src[0] = s;
    br->src[1] = d;
    br->imm = step;
    br->label = label;
    br->mem.base = -1;
}

static const PatternDef pat_copystep = {
    .name = "copystep", .n_ops = 3, .anchor = 3,  /* anchor = BR_ZERO (index 2) */
    .flags = IR_PAT_NO_AUTO_TEMPS,
    .ops = {
        { .kind = IR_LD_MEM, .dst = CSV_T,
          .src0 = IR_MS_NONE, .src1 = IR_MS_NONE },
        { .kind = IR_ST_MEM, .dst = IR_MS_NONE,
          .src0 = CSV_T, .src1 = IR_MS_NONE },
        { .kind = IR_BR_ZERO, .dst = IR_MS_NONE,
          .src0 = CSV_T, .src1 = IR_MS_NONE },
    },
    .check = copystep_check, .apply = copystep_apply,
};

/* movfuse — producer + single-use MOV (migrated from
   ir_opt_fuse_mov): `<producer> t <- ...; MOV d <- t` with t
   function-wide single-use and same width as d redirects the
   producer's dst to d and drops the MOV — eliminating the producer's
   slot store + MOV's reload + store (~14 bytes per pair; MD5
   Transform's `UINT4 a = buf[0], ...` prologue is the canonical hit).
   The producer template is IR_MK_ANY; check() filters against the
   allowed-kind list (a final "result" write — no CALL/HCALL, whose
   ret_vreg lives in their payload structs). NO_AUTO_TEMPS: the
   inherited conditions are exactly use_count==1 + width equality,
   without the auto rule's flag checks. */

enum { FV_T = 1, FV_D };   /* movfuse binding vars */

static int movfuse_producer_ok(OpKind k)
{
    switch (k) {
    case IR_LD_MEM: case IR_LD_IMM: case IR_LD_SYM: case IR_LD_STR:
    case IR_LEA:
    case IR_ADD: case IR_SUB:
    case IR_AND: case IR_OR:  case IR_XOR:
    case IR_NEG: case IR_NOT:
    case IR_INC: case IR_DEC:
    case IR_SHL: case IR_SHR:
    case IR_CONV_ZX: case IR_CONV_SX:
    case IR_CONV_TRUNC: case IR_CONV_BYTE_TO_HIGH:
    case IR_CMP_EQ: case IR_CMP_NE:
    case IR_CMP_LT: case IR_CMP_LE: case IR_CMP_GT: case IR_CMP_GE:
    case IR_CMP_ULT: case IR_CMP_ULE: case IR_CMP_UGT: case IR_CMP_UGE:
    /* MOV-MOV chain: copy-propagate the middle vreg out by
       redirecting the first MOV's dst (chains converge across
       rounds). */
    case IR_MOV:
        return 1;
    default:
        return 0;
    }
}

static int movfuse_check(Func *f, BB *bb, const int idx[],
                         const int64_t imm[], const int bind[],
                         const int uc[])
{
    (void)imm;
    if (!movfuse_producer_ok(bb->ops[idx[0]].kind)) return 0;
    int t = bind[FV_T], d = bind[FV_D];
    if (uc[t] != 1) return 0;
    return f->vregs[t].width == f->vregs[d].width;
}

static void movfuse_apply(Func *f, BB *bb, const int idx[],
                          const int64_t imm[], const int bind[])
{
    (void)f; (void)imm;
    bb->ops[idx[0]].dst = bind[FV_D];
}

static const PatternDef pat_movfuse = {
    .name = "movfuse", .n_ops = 2, .anchor = 1,
    .flags = IR_PAT_NO_AUTO_TEMPS,
    .ops = {
        { .kind = IR_MK_ANY, .dst = FV_T,
          .src0 = IR_MS_ANY, .src1 = IR_MS_ANY },
        { .kind = IR_MOV, .dst = FV_D, .src0 = FV_T },
    },
    .check = movfuse_check, .apply = movfuse_apply,
};

int ir_match_run_early(Func *f)
{
    int n = ir_match_run_table(f, &pat_poststep, 1);
    n += ir_match_run_table(f, &pat_derefpp, 1);
    /* stpp needs the POSTSTEP that poststep just produced. Default-on with
       the loop register allocator (IR_NO_LOOP_RA opts out) — it feeds the
       DE/BC walking-pointer home (`*d++` → `ld (de),a; inc de`). */
    if (!getenv("IR_NO_LOOP_RA")) {
        n += ir_match_run_table(f, &pat_stpp, 1);
        /* copystep needs the post-step LD_MEM (derefpp) + ST_MEM (stpp). */
        n += ir_match_run_table(f, &pat_copystep, 1);
    }
    n += ir_match_run_table(f, &pat_movfuse, 1);
    return n;
}

/* ----- packbytes phase (post-cse) ----------------------------------------
   Little-endian byte-pack idiom → wide load (migrated from
   ir_opt_pack_bytes):
     r = ((long)b[k+3]<<24)|((long)b[k+2]<<16)
       | ((long)b[k+1]<<8) | (long)b[k];
   After the vregoff folds + cse the per-BB shape is, per lane,
     LD_MEM  b_j <- [t, off0+j]  (w1); CONV_ZX l_j <- b_j (w4);
     SHL s_j <- l_j (imm=8j) for j>0
   combined by a 3-node OR tree — which IS one width-4 load from
   [t, off0] on a little-endian target. The md5 byte-gather is the
   canonical hit (~28 ops → 1).

   Not template-shaped: it's a tree walk with backward def-chasing, so
   it's a 1-op anchor (the root OR) with the whole match in check()
   and the chain-kill in an APPLY_KILLS apply — the engine still owns
   the anchor scan, use counts, the kill bitmap and compaction (the
   escape hatch PATTERN_MATCHER_PLAN.md §3 reserved). Runs after cse
   (which dedups duplicate per-lane address ADDs) in its own phase. */

typedef struct {
    int load_idx, conv_idx, shl_idx;   /* op indices; shl_idx -1 = lane 0 */
    int base, offset, shift;
} PackLane;

/* Chase single-def MOV copies back to the canonical source vreg (cse
   rewrites duplicate address ADDs into MOVs). */
static int pack_canon(Func *f, BB *bb, const int *def_idx, int v)
{
    for (int g = 0; g < 8 && v >= 0 && v < f->n_vregs; g++) {
        int di = def_idx[v];
        if (di < 0) break;
        const Op *d = &bb->ops[di];
        if (d->kind != IR_MOV || d->src[0] < 0) break;
        v = d->src[0];
    }
    return v;
}

/* Resolve single-use vreg v into a lane (SHL? / CONV_ZX / LD_MEM).
   Returns 0 ok, -1 no match. */
static int pack_match_lane(Func *f, BB *bb, const int *def_idx,
                           const int *uc, int v, PackLane *out)
{
    if (v < 0 || v >= f->n_vregs || uc[v] != 1) return -1;
    int di = def_idx[v];
    if (di < 0) return -1;
    Op *d = &bb->ops[di];

    int shift = 0, shl_idx = -1;
    if (d->kind == IR_SHL && d->src[1] == -1
        && (d->imm == 8 || d->imm == 16 || d->imm == 24)) {
        shift = (int)d->imm; shl_idx = di;
        v = d->src[0];
        if (v < 0 || v >= f->n_vregs || uc[v] != 1) return -1;
        di = def_idx[v];
        if (di < 0) return -1;
        d = &bb->ops[di];
    }
    if (d->kind != IR_CONV_ZX || f->vregs[d->dst].width != 4) return -1;
    int conv_idx = di;
    v = d->src[0];
    if (v < 0 || v >= f->n_vregs || uc[v] != 1) return -1;
    if (f->vregs[v].width != 1) return -1;
    di = def_idx[v];
    if (di < 0) return -1;
    d = &bb->ops[di];
    if (d->kind != IR_LD_MEM || d->mem.kind != IR_MEM_VREG) return -1;
    if (d->mem.volatile_ || d->mem.post_step != 0 || d->mem.base < 0)
        return -1;

    out->load_idx = di; out->conv_idx = conv_idx; out->shl_idx = shl_idx;
    out->base = pack_canon(f, bb, def_idx, d->mem.base);
    out->offset = d->mem.offset; out->shift = shift;
    return 0;
}

/* Walk the OR tree at root_idx, validate the 4-lane little-endian
   pack, and return the rewrite + kill set. def_idx is built by the
   caller. Returns 0 ok (out_* and lanes/or_idx filled), -1 no match. */
static int pack_analyze(Func *f, BB *bb, const int *def_idx,
                        const int *uc, int root_idx,
                        int *out_base, int *out_off,
                        PackLane lanes[4], int or_idx[3])
{
    const Op *root = &bb->ops[root_idx];
    if (root->kind != IR_OR) return -1;
    if (root->dst < 0 || f->vregs[root->dst].width != 4) return -1;

    int n_lanes = 0, n_ors = 0, sp = 0, stack[8], ok = 1;
    stack[sp++] = root->src[0];
    stack[sp++] = root->src[1];
    while (sp > 0 && ok) {
        int v = stack[--sp];
        if (v < 0 || v >= f->n_vregs) { ok = 0; break; }
        int di = (uc[v] == 1) ? def_idx[v] : -1;
        Op *d = (di >= 0) ? &bb->ops[di] : NULL;
        if (d && d->kind == IR_OR && f->vregs[d->dst].width == 4) {
            if (n_ors >= 3 || sp > 5) { ok = 0; break; }
            or_idx[n_ors++] = di;
            stack[sp++] = d->src[0];
            stack[sp++] = d->src[1];
        } else {
            if (n_lanes >= 4
                || pack_match_lane(f, bb, def_idx, uc, v,
                                   &lanes[n_lanes]) < 0) { ok = 0; break; }
            n_lanes++;
        }
    }
    if (!ok || n_lanes != 4 || n_ors != 2) return -1;

    int seen = 0, base = lanes[0].base, base_off = INT32_MAX;
    for (int i = 0; i < 4; i++) {
        if (lanes[i].base != base) return -1;
        int start = lanes[i].offset - lanes[i].shift / 8;
        if (base_off == INT32_MAX) base_off = start;
        else if (start != base_off) return -1;
        int bit = 1 << (lanes[i].shift / 8);
        if (seen & bit) return -1;
        seen |= bit;
    }
    if (seen != 0xF) return -1;

    /* Window safety: between the first matched load and the root OR,
       no stores / calls / asm / io and no redef of base. */
    int lo = root_idx;
    for (int i = 0; i < 4; i++)
        if (lanes[i].load_idx < lo) lo = lanes[i].load_idx;
    for (int k = lo; k <= root_idx; k++) {
        OpKind kk = bb->ops[k].kind;
        if (kk == IR_ST_MEM || kk == IR_CALL || kk == IR_HCALL
            || kk == IR_ASM || kk == IR_IN || kk == IR_OUT) return -1;
        if (k > lo && bb->ops[k].dst == base) return -1;
    }
    *out_base = base; *out_off = base_off;
    return 0;
}

/* def_idx of first definer per vreg in this BB (caller frees). */
static int *pack_def_idx(Func *f, BB *bb)
{
    int *def_idx = malloc((size_t)f->n_vregs * sizeof(int));
    if (!def_idx) return NULL;
    for (int v = 0; v < f->n_vregs; v++) def_idx[v] = -1;
    for (int j = 0; j < bb->n_ops; j++) {
        int d = bb->ops[j].dst;
        if (d >= 0 && d < f->n_vregs && def_idx[d] < 0) def_idx[d] = j;
    }
    return def_idx;
}

static int packbytes_check(Func *f, BB *bb, const int idx[],
                           const int64_t imm[], const int bind[],
                           const int uc[])
{
    (void)imm; (void)bind;
    int *def_idx = pack_def_idx(f, bb);
    if (!def_idx) return 0;
    int base, off;
    PackLane lanes[4]; int or_idx[3];
    int rc = pack_analyze(f, bb, def_idx, uc, idx[0],
                          &base, &off, lanes, or_idx);
    free(def_idx);
    return rc == 0;
}

static void packbytes_apply(Func *f, BB *bb, const int idx[],
                            const int64_t imm[], const int bind[])
{
    (void)imm; (void)bind;
    /* apply doesn't receive uc — recompute (the analysis must re-run
       to recover the kill set, and single-use checks need counts). */
    int *uc = calloc(f->n_vregs > 0 ? (size_t)f->n_vregs : 1, sizeof(int));
    int *def_idx = pack_def_idx(f, bb);
    if (!uc || !def_idx) { free(uc); free(def_idx); return; }
    compute_use_counts(f, uc);
    int base, off;
    PackLane lanes[4]; int or_idx[3];
    int rc = pack_analyze(f, bb, def_idx, uc, idx[0],
                          &base, &off, lanes, or_idx);
    free(def_idx);
    free(uc);
    if (rc != 0) return;

    Op *root = &bb->ops[idx[0]];
    int dst = root->dst;
    const char *file = root->file;
    int line = root->line;
    memset(root, 0, sizeof(*root));
    root->kind       = IR_LD_MEM;
    root->dst        = dst;
    root->src[0]     = -1;
    root->src[1]     = -1;
    root->label      = -1;
    root->mem.kind   = IR_MEM_VREG;
    root->mem.base   = base;
    root->mem.offset = off;
    root->file       = file;
    root->line       = line;
    for (int i = 0; i < 4; i++) {
        ir_match_mark_dead(lanes[i].load_idx);
        ir_match_mark_dead(lanes[i].conv_idx);
        if (lanes[i].shl_idx >= 0) ir_match_mark_dead(lanes[i].shl_idx);
    }
    ir_match_mark_dead(or_idx[0]);   /* the two inner ORs (n_ors==2) */
    ir_match_mark_dead(or_idx[1]);
    /* The base producer stays live — the wide load uses it. */
}

static const PatternDef ir_patterns_packbytes[] = {
    { .name = "packbytes", .n_ops = 1,
      .flags = IR_PAT_KEEP_SATELLITES | IR_PAT_APPLY_KILLS,
      .ops = { { .kind = IR_OR, .dst = IR_MS_ANY,
                 .src0 = IR_MS_ANY, .src1 = IR_MS_ANY, .width = 4 } },
      .check = packbytes_check, .apply = packbytes_apply },
};

int ir_match_run_packbytes(Func *f)
{
    return run_table_rounds(f, ir_patterns_packbytes, 1, 1);
}

/* ----- Late phase (post-cse/packs) ---------------------------------------
   The byte-extract idiom (migrated from ir_opt_extract_byte):
   (unsigned char)((x >> 8k) & 0xFF) — and the int-typed variant used
   for table indexing — lower as a width-4 SHR, a width-4 AND (4+
   redundant ops: the shift already zeroed those bytes) and a TRUNC
   through a frame temp; collapsed to IR_EXTRACT_BYTE dst <- x (imm=k)
   they cost one register copy on a DEHL-cache hit. Three shapes,
   longest first so the table prefers exactly what the old pass did —
   when the SHR's dst is multi-use, the 3-op entry's temp condition
   fails and the AND-only entry folds byte 0, keeping the SHR alive:

     xbyte     SHR w <- v (8|16|24); AND t <- w (0xFF); TRUNC d <- t
     xbyte_b0  AND t <- v (0xFF); TRUNC d <- t            (byte 0)
     xbyte_shr SHR t <- v (8|16|24); TRUNC d <- t         (w1 dst only
               — a w2 dst would need the shifted high bits, which
               aren't all zero for SAR)

   Arithmetic vs logical SHR doesn't matter: byte k of x is byte k
   regardless of what fills the high bits. GAP_VALUES: the chain is
   pure value flow — it survives calls/stores (the old pass chased
   defs with no intervening-op checks at all; the engine adds the
   bound-vreg redefinition break, which the old pass was missing).
   Runs after cse + packs: cse dedups duplicate chains first, and
   EXTRACT_BYTE is not CSE-eligible. */

enum { XV_V = 1, XV_W, XV_T };   /* extract-byte binding vars */

static int xbyte_shift_ok(int64_t n)
{
    return n == 8 || n == 16 || n == 24;
}

/* dst checks shared by the three entries: the anchor TRUNC's dst is
   IR_MS_ANY (no collision constraint — like rotl's aliased dst), so
   validity and width live here. */
static int xbyte_dst_ok(const Func *f, const Op *a, int w1_only)
{
    if (a->dst < 0 || a->dst >= f->n_vregs) return 0;
    int dw = f->vregs[a->dst].width;
    return w1_only ? dw == 1 : (dw == 1 || dw == 2);
}

static int xbyte_check(Func *f, BB *bb, const int idx[],
                       const int64_t imm[], const int bind[],
                       const int uc[])
{
    (void)uc;
    if (!xbyte_shift_ok(imm[0])) return 0;
    if ((imm[1] & 0xFFFFFFFF) != 0xFF) return 0;
    if (f->vregs[bind[XV_V]].width != 4) return 0;
    return xbyte_dst_ok(f, &bb->ops[idx[2]], 0);
}

static int xbyte_b0_check(Func *f, BB *bb, const int idx[],
                          const int64_t imm[], const int bind[],
                          const int uc[])
{
    (void)uc;
    if ((imm[0] & 0xFFFFFFFF) != 0xFF) return 0;
    if (f->vregs[bind[XV_V]].width != 4) return 0;
    return xbyte_dst_ok(f, &bb->ops[idx[1]], 0);
}

static int xbyte_shr_check(Func *f, BB *bb, const int idx[],
                           const int64_t imm[], const int bind[],
                           const int uc[])
{
    (void)uc;
    if (!xbyte_shift_ok(imm[0])) return 0;
    if (f->vregs[bind[XV_V]].width != 4) return 0;
    return xbyte_dst_ok(f, &bb->ops[idx[1]], 1);
}

static void xbyte_rewrite(BB *bb, int anchor_idx, int v, int k)
{
    Op *a = &bb->ops[anchor_idx];
    Op n;
    memset(&n, 0, sizeof(n));
    n.kind     = IR_EXTRACT_BYTE;
    n.dst      = a->dst;
    n.src[0]   = v;
    n.src[1]   = -1;
    n.imm      = k;
    n.mem.base = -1;
    n.label    = -1;
    n.file     = a->file;
    n.line     = a->line;
    *a = n;
}

static void xbyte_apply(Func *f, BB *bb, const int idx[],
                        const int64_t imm[], const int bind[])
{
    (void)f;
    xbyte_rewrite(bb, idx[2], bind[XV_V], (int)imm[0] / 8);
}

static void xbyte_b0_apply(Func *f, BB *bb, const int idx[],
                           const int64_t imm[], const int bind[])
{
    (void)f; (void)imm;
    xbyte_rewrite(bb, idx[1], bind[XV_V], 0);
}

static void xbyte_shr_apply(Func *f, BB *bb, const int idx[],
                            const int64_t imm[], const int bind[])
{
    (void)f;
    xbyte_rewrite(bb, idx[1], bind[XV_V], (int)imm[0] / 8);
}

static const PatternDef ir_patterns_late[] = {
    { .name = "xbyte", .n_ops = 3,
      .flags = IR_PAT_GAP_OK | IR_PAT_GAP_VALUES,
      .ops = {
          { .kind = IR_SHR, .dst = XV_W, .src0 = XV_V,
            .imm_pred = IR_IMM_ANY, .width = 4 },
          { .kind = IR_AND, .dst = XV_T, .src0 = XV_W,
            .imm_pred = IR_IMM_ANY, .width = 4 },
          { .kind = IR_CONV_TRUNC, .dst = IR_MS_ANY, .src0 = XV_T },
      },
      .check = xbyte_check, .apply = xbyte_apply },

    { .name = "xbyte_b0", .n_ops = 2,
      .flags = IR_PAT_GAP_OK | IR_PAT_GAP_VALUES,
      .ops = {
          { .kind = IR_AND, .dst = XV_T, .src0 = XV_V,
            .imm_pred = IR_IMM_ANY, .width = 4 },
          { .kind = IR_CONV_TRUNC, .dst = IR_MS_ANY, .src0 = XV_T },
      },
      .check = xbyte_b0_check, .apply = xbyte_b0_apply },

    { .name = "xbyte_shr", .n_ops = 2,
      .flags = IR_PAT_GAP_OK | IR_PAT_GAP_VALUES,
      .ops = {
          { .kind = IR_SHR, .dst = XV_T, .src0 = XV_V,
            .imm_pred = IR_IMM_ANY, .width = 4 },
          { .kind = IR_CONV_TRUNC, .dst = IR_MS_ANY, .src0 = XV_T },
      },
      .check = xbyte_shr_check, .apply = xbyte_shr_apply },
};
static const int ir_n_patterns_late =
    (int)(sizeof ir_patterns_late / sizeof ir_patterns_late[0]);

int ir_match_run_late(Func *f)
{
    return ir_match_run_table(f, ir_patterns_late, ir_n_patterns_late);
}
