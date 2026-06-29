/*
 * ir_alloc.c — register allocator (Phase 3, staged).
 *
 * Per-vreg phys-reg assignment in f->vreg_to_phys:
 *   - IR_PR_HL   : vreg lives in HL across its (short, chained) live
 *                  range. Every def is followed immediately by a cache-
 *                  served use, so no frame slot is needed. The lowerer
 *                  consults this to skip store_hl after the producing
 *                  op. Stage 3 (this commit) is the first stage to
 *                  populate a real phys reg.
 *   - IR_PR_DE   : reserved for Stage 4 (lives in DE).
 *   - IR_PR_BC   : reserved for Stage 5 (lives in BC).
 *   - IR_PR_DEHL : reserved for Stage 6 (long lives in DE+HL pair).
 *   - IR_PR_SPILL: vreg has a frame slot; ir_assign_slots allocates it.
 *
 * Stage 3 acceptance is "no perf change": PR_HL is assigned to exactly
 * the set the existing HL-cache dynamic check (cur_dst_dead) already
 * elides, so the OR'd gate fires on the same vregs. Future stages will
 * widen the criterion and start actually moving the spill set.
 *
 * Decoupled from compiler internals (no ccdefs.h) — ir_selftest links
 * this standalone alongside ir.c / ir_analysis.c / ir_lower.c.
 */

#include "ir_alloc.h"
#include "ir_analysis.h"

#include <stdlib.h>

/* Returns 1 if the spill of op->dst at bb->ops[op_idx] is dead — its
   value is never read from the frame, only consumed via the HL cache
   by the immediately-following op. Requires liveness computed. */
static int op_dst_spill_is_dead(const BB *bb, int op_idx)
{
    const Op *op = &bb->ops[op_idx];
    if (op->dst < 0) return 0;
    if (bb->live_out
        && ir_bitset_get((const BitSet *)bb->live_out, op->dst))
        return 0;
    int allow_cache_hit = 1;
    for (int k = op_idx + 1; k < bb->n_ops; k++) {
        int uses[16];
        int nu = ir_op_uses(&bb->ops[k], uses,
                            (int)(sizeof uses / sizeof uses[0]));
        for (int u = 0; u < nu; u++) {
            if (uses[u] != op->dst) continue;
            int cache_served =
                allow_cache_hit &&
                k == op_idx + 1 &&
                bb->ops[k].src[0] == op->dst &&
                bb->ops[k].src[1] != op->dst;
            if (!cache_served) return 0;
            allow_cache_hit = 0;
        }
    }
    return 1;
}

void ir_alloc(Func *f)
{
    if (!f) return;
    free(f->vreg_to_phys);
    f->vreg_to_phys = NULL;
    if (f->n_vregs <= 0) return;
    f->vreg_to_phys = calloc((size_t)f->n_vregs, sizeof(*f->vreg_to_phys));
    if (!f->vreg_to_phys) return;

    /* Default: every vreg gets a slot. Then narrow to PR_HL for the
       cases the HL cache handles entirely (Stage 3); Stage 4/5 will
       extend with PR_DE / PR_BC. */
    for (int v = 0; v < f->n_vregs; v++)
        f->vreg_to_phys[v] = IR_PR_SPILL;

    /* Param-in-place: read AND write directly from/to the caller's
       pushed-arg slot. Smallc semantics treat function params as
       local copies on the caller's stack — the caller pops/cleans
       those slots after return and does not observe the callee's
       writes. So neither reads nor writes need the prologue copy-in
       or a separate local frame slot.

       Even ADDR_TAKEN params are safe: `&param` only needs to be
       valid for the function's lifetime (any escape — return, store
       to global — is UB in C), and the caller's pushed-arg slot is
       valid for exactly that window. Same address-stability story
       as `&local`. We compute the address via sp+(positive offset)
       just like any other slot reference.

       The flag is misnamed IR_VREG_PARAM_RO for historical reasons
       (was originally read-only-only); a later cleanup should rename
       to IR_VREG_PARAM_IN_PLACE. */
    for (int v = 0; v < f->n_vregs; v++) {
        VReg *vr = &f->vregs[v];
        if (!(vr->flags & IR_VREG_PARAM)) continue;
        vr->flags |= IR_VREG_PARAM_RO;
    }

    /* `cacheable[v]` is 1 iff every def of v is in an op whose lowerer
       path runs through spill_unless_dead / spill_and_swap_unless_dead
       (i.e., the cache-aware emit paths) AND the dst is dead-after at
       every def AND v's width is 2 (HL cache only). Other ops always
       store to the slot, so the slot is needed. */
    int *cacheable = calloc((size_t)f->n_vregs, sizeof(int));
    if (!cacheable) return;
    for (int v = 0; v < f->n_vregs; v++) cacheable[v] = 1;

    /* Params and addr-taken always need a slot. */
    for (int v = 0; v < f->n_vregs; v++) {
        const VReg *vr = &f->vregs[v];
        if ((vr->flags & IR_VREG_PARAM)
            || (vr->flags & IR_VREG_ADDR_TAKEN))
            cacheable[v] = 0;
    }
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            if (op->kind == IR_CALL && op->call && op->call->ret_vreg >= 0)
                cacheable[op->call->ret_vreg] = 0;
            if (op->kind == IR_HCALL && op->hcall
                && op->hcall->ret_vreg >= 0)
                cacheable[op->hcall->ret_vreg] = 0;
            if (op->dst < 0) continue;
            int eligible_kind;
            switch (op->kind) {
            case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
            case IR_MOV:
            case IR_ADD: case IR_SUB:
            case IR_AND: case IR_OR: case IR_XOR:
            case IR_SHL: case IR_SHR:
            case IR_INC: case IR_DEC:
            case IR_NEG: case IR_NOT:
            case IR_CMP_EQ:  case IR_CMP_NE:
            case IR_CMP_LT:  case IR_CMP_LE:
            case IR_CMP_GT:  case IR_CMP_GE:
            case IR_CMP_ULT: case IR_CMP_ULE:
            case IR_CMP_UGT: case IR_CMP_UGE:
            case IR_CONV_ZX: case IR_CONV_SX:
            case IR_CONV_BYTE_TO_HIGH:
                /* Byte→int conversion producers: their width=2 emits
                   are spill-skip-aware (spill_and_swap_unless_dead +
                   cache_hl), so a dead-after-next-op result can stay
                   in HL like any other binop dst. */
                eligible_kind = 1;
                break;
            default:
                eligible_kind = 0;
                break;
            }
            int dst_w = f->vregs[op->dst].width;
            if (dst_w != 2 || !eligible_kind || !op_dst_spill_is_dead(bb, j))
                cacheable[op->dst] = 0;
        }
    }

    for (int v = 0; v < f->n_vregs; v++) {
        if (cacheable[v]) f->vreg_to_phys[v] = IR_PR_HL;
    }
    free(cacheable);

    /* Stage 4: PR_DE for width-2 vregs whose only use is as src[1] of
       the immediately-following binop, defined by an op whose lowerer
       can route the value directly into DE (saving the HL→slot→DE
       round trip). Producer set:
         - IR_LD_IMM (emits `ld de,K`)
         - IR_LD_MEM with IR_MEM_SYM (emits `ld de,(sym)`)

       The PR_HL set above never overlaps (PR_HL requires src[0]==v in
       the next op; PR_DE requires src[1]==v), so vregs are always in
       at most one pool.

       Criterion is intentionally narrow: exactly-one def in the
       eligible-producer set, exactly-one use at op_idx+1 as src[1],
       not src[0], not live-out, not param / addr-taken (those rules
       came from the HL pool pre-filter). Anything else falls back to
       PR_SPILL with the dynamic DE cache (cur_de_vreg) handling
       opportunistic hits at emit time. */
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j + 1 < bb->n_ops; j++) {
            const Op *op  = &bb->ops[j];
            const Op *nxt = &bb->ops[j + 1];
            int producer_ok = 0;
            switch (op->kind) {
            case IR_LD_IMM:
            case IR_MOV:
                /* IR_MOV: load src directly into DE via load_to_de. */
                producer_ok = 1;
                break;
            case IR_LD_MEM:
                producer_ok = (op->mem.kind == IR_MEM_SYM
                               || op->mem.kind == IR_MEM_VREG);
                break;
            case IR_ADD: case IR_SUB:
            case IR_AND: case IR_OR: case IR_XOR:
                /* The int (width-2) binop lowerers route the final
                   byte writes into D/E (for AND/OR/XOR) or wrap the
                   `add hl,de` / `sbc hl,de` result with `ex de,hl`
                   (for ADD/SUB) when dst is PR_DE. */
                producer_ok = 1;
                break;
            case IR_SHL: case IR_SHR:
                /* Int shifts: emit into HL as usual (the bit shifts
                   need add hl,hl / srl h / rr l etc.), then wrap with
                   ex de,hl on PR_DE dst. The count >= 16 zero-result
                   path emits `ld de,0` directly. */
                producer_ok = 1;
                break;
            case IR_CONV_ZX:
            case IR_CONV_SX:
            case IR_CONV_BYTE_TO_HIGH:
                /* Width-extending conversions to int: byte→int (ZX/SX)
                   and byte→int<<8 (BYTE_TO_HIGH). The lowerer routes
                   the result bytes into E/D for PR_DE dst. Common in
                   `crc ^= ((unsigned int)*data) << 8` shapes — the
                   CONV producer feeds the XOR as src[1]. */
                producer_ok = 1;
                break;
            default:
                break;
            }
            if (!producer_ok) continue;
            if (op->dst < 0) continue;
            int v = op->dst;
            if (f->vregs[v].width != 2) continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            const VReg *vr = &f->vregs[v];
            if ((vr->flags & IR_VREG_PARAM)
                || (vr->flags & IR_VREG_ADDR_TAKEN))
                continue;
            /* Not live past this op (would need slot for cross-BB read). */
            if (bb->live_out
                && ir_bitset_get((const BitSet *)bb->live_out, v))
                continue;
            /* Next-op consumer pattern: src[1] == v, src[0] != v. */
            if (nxt->src[1] != v || nxt->src[0] == v) continue;
            int nxt_eligible;
            switch (nxt->kind) {
            case IR_ADD: case IR_SUB:
            case IR_AND: case IR_OR: case IR_XOR:
            case IR_CMP_EQ:  case IR_CMP_NE:
            case IR_CMP_LT:  case IR_CMP_LE:
            case IR_CMP_GT:  case IR_CMP_GE:
            case IR_CMP_ULT: case IR_CMP_ULE:
            case IR_CMP_UGT: case IR_CMP_UGE:
                nxt_eligible = 1;
                break;
            default:
                nxt_eligible = 0;
                break;
            }
            if (!nxt_eligible) continue;
            /* No other in-BB uses (the next op is the only consumer). */
            int single_use = 1;
            for (int k = j + 2; k < bb->n_ops && single_use; k++) {
                int uses[16];
                int nu = ir_op_uses(&bb->ops[k], uses,
                                    (int)(sizeof uses / sizeof uses[0]));
                for (int u = 0; u < nu; u++) {
                    if (uses[u] == v) { single_use = 0; break; }
                }
            }
            if (!single_use) continue;
            f->vreg_to_phys[v] = IR_PR_DE;
        }
    }

    /* PR_BC pool (Stage 5, narrow no-call case).

       Function-wide envelope: BC is preserved across every body emit
       path ONLY when the function has no IR_CALL / IR_HCALL (callee
       conventions vary on BC) and no width-4 vregs (long ops use BC as
       the low-half spill register). In that envelope, BC stays put
       between the prologue load and the function exit.

       Candidate: one width-2 PARAM with at least 2 use sites in the
       function. PARAMs are loaded once in the prologue immediately
       after PARAM_IN_PLACE copy-in is skipped, then every use site
       reads from BC via `ld l,c; ld h,b` (2 inst) instead of the full
       6-inst slot reload. Break-even is at 2 uses (6 inst init + 2 *
       use_count) vs the unchanged 6 * use_count slot reads.

       First-cut limit: ONE vreg per function. Picking the best
       candidate by use count is the natural next step but adds
       complexity (sort + interference checks); a single-occupant pool
       is fine for the first measurement. */
    int has_long = 0;
    int has_bc_clobber = 0;
    for (int v = 0; v < f->n_vregs && !has_long; v++)
        if (f->vregs[v].width == 4) has_long = 1;
    /* Calls used to exclude PR_BC entirely. Task #319 added save/restore
       around IR_CALL / IR_HCALL in the lowerer, so calls no longer
       disqualify — they just add a push bc/pop bc pair around each
       call site when PR_BC is active. has_long and has_bc_clobber
       still exclude (long ops use BC for low-half staging, and
       IR_ST_MEM IR_MEM_VREG with offset clobbers BC for the
       `ld bc,N; add hl,bc` offset add). */
    for (int i = 0; i < f->n_bbs && !has_bc_clobber; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            /* IR_ST_MEM byte/int with IR_MEM_VREG base + nonzero offset
               emits `ld bc,N; add hl,bc` for the offset add (DE holds
               the value being stored, so can't be used for the add).
               Conservative: any IR_ST_MEM IR_MEM_VREG with offset is a
               BC clobber. Stores with offset==0 don't emit the add and
               are safe. */
            if (o->kind == IR_ST_MEM
                && o->mem.kind == IR_MEM_VREG
                && o->mem.offset != 0)
                has_bc_clobber = 1;
        }
    }
    if (!has_long && !has_bc_clobber) {
        /* Per-vreg write count: any op with dst == v writes the vreg.
           Lowerer's PR_BC short-circuit only handles reads (load_to_hl
           / load_to_de copy from BC); it doesn't update BC on writes.
           So a candidate must be write-free in the function body. PARAM
           vregs that survive without modification (the common "use param
           multiple times" case) qualify; one that gets `data++` style
           updates (post-inc / compound-assign) doesn't. */
        int *write_count = calloc((size_t)f->n_vregs, sizeof(int));
        int *use_count   = calloc((size_t)f->n_vregs, sizeof(int));
        /* Use intervals: first_use/last_use are op indices in BB-id
           linear order. Used for non-overlap interference, since
           PARAMs all have ir_live_range start=0 (they're live from
           entry) — that makes ir_live_ranges_overlap too conservative
           for multi-tenant pool allocation. The use interval [first,
           last] reflects when the value actually has to be in BC.
           For write-once locals (#318), first_use is set to the def
           op (BC starts holding the value at the def, not at the
           first read). */
        int *first_use   = calloc((size_t)f->n_vregs, sizeof(int));
        int *last_use    = calloc((size_t)f->n_vregs, sizeof(int));
        /* def_kind[v] = the OpKind of v's first writing op, or -1 if
           never written. Used by the LOCAL PR_BC eligibility check to
           ensure the producer goes through spill_and_swap_unless_dead
           (only those lowerings know to also write BC for PR_BC dst). */
        int *def_kind    = calloc((size_t)f->n_vregs, sizeof(int));
        /* Loop detection (#317): BB B is "in a loop" if a back-edge
           p→h exists with h.id ≤ B.id ≤ p.id. Back-edges are
           predecessors whose id is ≥ ours, which is reliable when the
           CFG is reducible (the IR builder produces reducible CFGs).
           This is cheap (one pass over BBs) and good enough for the
           "any loop, any depth" predicate the use-weight needs. */
        int *bb_in_loop  = calloc((size_t)f->n_bbs, sizeof(int));
        /* bb_loop_lo[b] / bb_loop_hi[b]: the [header, tail] bb-id span
           of the smallest loop containing b, or b itself if b is
           outside any loop. Used to extend a candidate's PR_BC use
           interval to cover the whole loop body when the candidate is
           used inside that loop — without this, a single-static-use
           vreg in a loop appears to have a one-op interval, and a
           different PR_BC tenant scheduled at a later op (also inside
           the loop) would falsely pass the non-overlap check yet
           clobber BC on every back-edge iteration. md5's MDPrint
           exhibits exactly this shape (#349). */
        int *bb_loop_lo  = calloc((size_t)f->n_bbs, sizeof(int));
        int *bb_loop_hi  = calloc((size_t)f->n_bbs, sizeof(int));
        int *bb_first_op = calloc((size_t)f->n_bbs, sizeof(int));
        int *bb_last_op  = calloc((size_t)f->n_bbs, sizeof(int));
        if (!write_count || !use_count || !first_use || !last_use
            || !bb_in_loop || !def_kind || !bb_loop_lo || !bb_loop_hi
            || !bb_first_op || !bb_last_op) {
            free(write_count); free(use_count);
            free(first_use); free(last_use);
            free(bb_in_loop); free(def_kind);
            free(bb_loop_lo); free(bb_loop_hi);
            free(bb_first_op); free(bb_last_op);
            return;
        }
        for (int v = 0; v < f->n_vregs; v++) {
            first_use[v] = -1;
            last_use[v]  = -1;
            def_kind[v]  = -1;
        }
        for (int i = 0; i < f->n_bbs; i++) {
            bb_loop_lo[i] = i;
            bb_loop_hi[i] = i;
        }
        for (int i = 0; i < f->n_bbs; i++) {
            BB *bb = &f->bbs[i];
            /* Use succ[] (populated by ir_build) rather than pred[]
               (currently NULL — predecessor lists aren't built). For
               each successor with id ≤ ours, that's a back-edge — mark
               every BB from the back-edge target (loop header) through
               our id (back-edge tail) as in the loop body. */
            for (int s = 0; s < 2; s++) {
                int sid = bb->succ[s];
                if (sid < 0) continue;
                if (sid > i) continue;
                int lo = sid, hi = i;
                if (lo < 0) lo = 0;
                if (hi >= f->n_bbs) hi = f->n_bbs - 1;
                for (int k = lo; k <= hi; k++) {
                    bb_in_loop[k] = 1;
                    if (lo < bb_loop_lo[k]) bb_loop_lo[k] = lo;
                    if (hi > bb_loop_hi[k]) bb_loop_hi[k] = hi;
                }
            }
        }
        /* Pre-compute each BB's global op-index range so we can map
           "BB id" → "global op index" cheaply during the loop-extend
           below. bb_last_op is inclusive. Empty BBs (n_ops==0) get
           bb_first_op[i] == bb_last_op[i] + 1, which never matches an
           actual op index — harmless. */
        {
            int g = 0;
            for (int i = 0; i < f->n_bbs; i++) {
                bb_first_op[i] = g;
                g += f->bbs[i].n_ops;
                bb_last_op[i]  = g - 1;
            }
        }
        int global = 0;
        for (int i = 0; i < f->n_bbs; i++) {
            BB *bb = &f->bbs[i];
            /* Hot uses (inside a loop body) count as 4 to clear the
               break-even threshold on single-static-use-in-loop
               patterns. The exact factor doesn't matter much — 1 use
               × N iterations dominates any static-use coldness. */
            int weight = bb_in_loop[i] ? 4 : 1;
            /* For uses/defs inside a loop, the cached value has to
               survive every iteration of the loop, so the "interval"
               needs to cover the entire loop body — not just the
               single op where the use/def appears. Otherwise two
               candidates whose single static op-indices don't overlap
               can still collide on BC across the back-edge.
               BB-level extent for in-loop ops; per-op `global` for
               straight-line ops. Computed inside the op loop because
               `global` advances per op. */
            int loop_first = bb_in_loop[i]
                           ? bb_first_op[bb_loop_lo[i]] : -1;
            int loop_last  = bb_in_loop[i]
                           ? bb_last_op[bb_loop_hi[i]]  : -1;
            for (int j = 0; j < bb->n_ops; j++, global++) {
                int eff_first = bb_in_loop[i] ? loop_first : global;
                int eff_last  = bb_in_loop[i] ? loop_last  : global;
                int d = bb->ops[j].dst;
                if (d >= 0 && d < f->n_vregs) {
                    write_count[d]++;
                    /* First def: extend the use interval to cover the
                       producing op (or the surrounding loop), and
                       remember its kind. For PR_BC LOCAL we need both
                       — interval anchoring at the def so BC ownership
                       starts there, and a kind check to ensure the
                       lowerer will write BC. */
                    if (def_kind[d] < 0) def_kind[d] = (int)bb->ops[j].kind;
                    if (first_use[d] < 0 || eff_first < first_use[d])
                        first_use[d] = eff_first;
                    if (eff_last > last_use[d]) last_use[d] = eff_last;
                }
                int u[16];
                int nu = ir_op_uses(&bb->ops[j], u,
                                    (int)(sizeof u / sizeof u[0]));
                for (int k = 0; k < nu; k++) {
                    int v = u[k];
                    if (v < 0 || v >= f->n_vregs) continue;
                    use_count[v] += weight;
                    if (first_use[v] < 0 || eff_first < first_use[v])
                        first_use[v] = eff_first;
                    if (eff_last > last_use[v]) last_use[v] = eff_last;
                }
            }
        }
        /* Eligibility pass: collect candidates into an array, sort by
           use count descending (heuristic — most-used first), then
           greedy-allocate to BC checking non-overlap against already-
           allocated PR_BC vregs.

           Two candidate classes:
             - PARAM_RO vregs that are never written (`write_count==0`):
               prologue load (for the earliest first_use) or demand
               reload from caller's slot.
             - Write-once LOCALs (#318): `write_count==1`, and the
               single producer op's kind goes through
               spill_and_swap_unless_dead (the producer pattern that
               can be hooked to also write BC). Catches the common
               "compute X once, read X many times" shape in loop
               headers (e.g. crc16_ccitt's `end = data + len`). */
        int cap = 0;
        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if (vr->width != 2) continue;
            if (vr->flags & IR_VREG_ADDR_TAKEN) continue;
            if (vr->flags & IR_VREG_VOLATILE) continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            if (use_count[v] < 2) continue;
            int is_param  = (vr->flags & IR_VREG_PARAM) != 0;
            if (is_param) {
                if (write_count[v] > 0) continue;
            } else {
                if (write_count[v] != 1) continue;
                /* Producer must be a kind whose lowerer ends in
                   spill_and_swap_unless_dead — that's how BC gets
                   stamped with the value for PR_BC LOCAL dst. */
                int k = def_kind[v];
                int prod_ok = 0;
                switch (k) {
                case IR_LD_IMM: case IR_LD_SYM: case IR_LD_STR:
                case IR_LD_MEM: case IR_LEA: case IR_MOV:
                case IR_ADD: case IR_SUB:
                case IR_AND: case IR_OR: case IR_XOR:
                case IR_SHL: case IR_SHR:
                case IR_INC: case IR_DEC:
                case IR_NEG: case IR_NOT:
                case IR_CONV_ZX: case IR_CONV_SX:
                case IR_CONV_BYTE_TO_HIGH:
                    prod_ok = 1;
                    break;
                default:
                    break;
                }
                if (!prod_ok) continue;
            }
            cap++;
        }
        if (cap > 0) {
            int *cand = calloc((size_t)cap, sizeof(int));
            if (cand) {
                int n = 0;
                for (int v = 0; v < f->n_vregs; v++) {
                    const VReg *vr = &f->vregs[v];
                    if (vr->width != 2) continue;
                    if (vr->flags & IR_VREG_ADDR_TAKEN) continue;
                    if (vr->flags & IR_VREG_VOLATILE) continue;
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                    if (use_count[v] < 2) continue;
                    int is_param = (vr->flags & IR_VREG_PARAM) != 0;
                    if (is_param) {
                        if (write_count[v] > 0) continue;
                    } else {
                        if (write_count[v] != 1) continue;
                        int k = def_kind[v];
                        int prod_ok = 0;
                        switch (k) {
                        case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
                        case IR_MOV:
                        case IR_ADD: case IR_SUB:
                        case IR_AND: case IR_OR: case IR_XOR:
                        case IR_SHL: case IR_SHR:
                        case IR_INC: case IR_DEC:
                        case IR_NEG: case IR_NOT:
                        case IR_CONV_ZX: case IR_CONV_SX:
                        case IR_CONV_BYTE_TO_HIGH:
                            prod_ok = 1;
                            break;
                        default:
                            break;
                        }
                        if (!prod_ok) continue;
                    }
                    cand[n++] = v;
                }
                /* Insertion sort by use count descending. n is small
                   (rarely >4 in practice). */
                for (int i = 1; i < n; i++) {
                    int v = cand[i];
                    int j = i;
                    while (j > 0 && use_count[cand[j - 1]] < use_count[v]) {
                        cand[j] = cand[j - 1];
                        j--;
                    }
                    cand[j] = v;
                }
                /* Greedy allocate: each candidate takes BC if its use
                   interval doesn't overlap any already-allocated PR_BC
                   vreg's interval. Inclusive overlap: [a.first, a.last]
                   ∩ [b.first, b.last] non-empty iff
                   max(a.first, b.first) <= min(a.last, b.last). */
                for (int i = 0; i < n; i++) {
                    int v = cand[i];
                    int ok = 1;
                    for (int j = 0; j < f->n_vregs && ok; j++) {
                        if (f->vreg_to_phys[j] != IR_PR_BC) continue;
                        int s = first_use[v] > first_use[j]
                              ? first_use[v] : first_use[j];
                        int e = last_use[v]  < last_use[j]
                              ? last_use[v]  : last_use[j];
                        if (s <= e) ok = 0;
                    }
                    if (ok) f->vreg_to_phys[v] = IR_PR_BC;
                }
                free(cand);
            }
        }
        free(write_count);
        free(use_count);
        free(first_use);
        free(last_use);
        free(bb_in_loop);
        free(def_kind);
        free(bb_loop_lo);
        free(bb_loop_hi);
        free(bb_first_op);
        free(bb_last_op);
    }
}
