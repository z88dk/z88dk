/*
 * ir_alloc.c — register allocator.
 *
 * Per-vreg phys-reg assignment in f->vreg_to_phys:
 *   - IR_PR_HL   : vreg lives in HL across its (short, chained) live
 *                  range. Every def is followed immediately by a cache-
 *                  served use, so no frame slot is needed. The lowerer
 *                  consults this to skip store_hl after the producing
 *                  op.
 *   - IR_PR_DE   : lives in DE.
 *   - IR_PR_BC   : lives in BC.
 *   - IR_PR_DEHL : long vreg lives in the DE+HL pair. Same shape as
 *                  PR_HL but for width-4 values: produced once,
 *                  consumed once in the immediately following op. No frame
 *                  slot allocated; store_dehl_finalize calls
 *                  cache_dehl_no_spill unconditionally for these vregs.
 *   - IR_PR_SPILL: vreg has a frame slot; ir_assign_slots allocates it.
 *
 * Decoupled from compiler internals (no ccdefs.h) — ir_selftest links
 * this standalone alongside ir.c / ir_analysis.c / ir_lower.c.
 */

#include "ccdefs.h"     /* FASTCALL flag bit (sets DEFINE_H for ir.h) */
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
            const Op *use = &bb->ops[k];
            int cache_served =
                allow_cache_hit &&
                k == op_idx + 1 &&
                ((use->src[0] == op->dst && use->src[1] != op->dst)
                 /* Computed pointer consumed as the next op's LD_MEM
                    base: gen_ld_mem loads the base FIRST and cache-
                    aware (hl_has), so the spill is dead. ST_MEM is
                    excluded — it loads the VALUE before the address,
                    clobbering HL. post_step needs the base's slot
                    (in-place `inc (hl)` step). */
                 || (use->kind == IR_LD_MEM
                     && use->mem.kind == IR_MEM_VREG
                     && use->mem.base == op->dst
                     && use->mem.post_step == 0
                     && use->src[0] != op->dst
                     && use->src[1] != op->dst));
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

    /* Default: every vreg gets a slot, then narrow to the register
       pools below. */
    for (int v = 0; v < f->n_vregs; v++)
        f->vreg_to_phys[v] = IR_PR_SPILL;

    /* Param-in-place: read AND write the caller's pushed-arg slot
       directly — the caller pops those slots after return and never
       observes callee writes, so no prologue copy-in or local slot
       is needed.

       ADDR_TAKEN params are safe too: `&param` only has to stay valid
       for the function's lifetime (escaping it is UB), which is
       exactly the window the pushed-arg slot covers. */
    /* The __z88dk_fastcall arg (the last param) arrives in HL, NOT on the
       caller stack — it can't be read in place. emit_prologue stores it to
       a real local slot (or its allocated register), so leave it off the
       in-place list. It's the highest-indexed PARAM vreg (params precede
       temps in creation order). */
    int fc_param = -1;
    if (f->flags & FASTCALL)
        for (int v = 0; v < f->n_vregs; v++)
            if (f->vregs[v].flags & IR_VREG_PARAM) fc_param = v;
    for (int v = 0; v < f->n_vregs; v++) {
        VReg *vr = &f->vregs[v];
        if (!(vr->flags & IR_VREG_PARAM)) continue;
        if (v == fc_param) continue;
        vr->flags |= IR_VREG_PARAM_IN_PLACE;
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
            /* IR_POSTSTEP also DEFINES src[0] (the stepped var) and
               writes its slot unconditionally — never slot-less. */
            if (op->kind == IR_POSTSTEP && op->src[0] >= 0)
                cacheable[op->src[0]] = 0;
            if (op->dst < 0) continue;
            int eligible_kind;
            switch (op->kind) {
            case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
            case IR_LD_STR: case IR_LEA:
            case IR_MOV: case IR_POSTSTEP:
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

    /* PR_DE pool: width-2 vregs whose only use is as src[1] of
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
    int *de_defs = calloc((size_t)f->n_vregs, sizeof(int));
    int *de_uses = calloc((size_t)f->n_vregs, sizeof(int));
    if (!de_defs || !de_uses) { free(de_defs); free(de_uses); return; }
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            int buf[16];
            int n = ir_op_defs(&bb->ops[j], buf,
                               (int)(sizeof buf / sizeof buf[0]));
            for (int k = 0; k < n && k < 16; k++)
                if (buf[k] >= 0 && buf[k] < f->n_vregs) de_defs[buf[k]]++;
            n = ir_op_uses(&bb->ops[j], buf,
                           (int)(sizeof buf / sizeof buf[0]));
            for (int k = 0; k < n && k < 16; k++)
                if (buf[k] >= 0 && buf[k] < f->n_vregs) de_uses[buf[k]]++;
        }
    }
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
            /* Exactly one def and one use function-wide. Multi-def
               vregs (sym-mapped locals) must keep their slot — only
               THIS def would write DE; the other defs/uses go through
               the slot paths, which a PR_DE vreg doesn't have. */
            if (de_defs[v] != 1 || de_uses[v] != 1) continue;
            f->vreg_to_phys[v] = IR_PR_DE;
        }
    }
    free(de_defs);
    free(de_uses);

    /* PR_BC pool (narrow no-call case).

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
            /* l_case / l_long_case walk the table through BC, so a
               PR_BC value can't survive a table-dispatch IR_SWITCH
               (and the helper jumps away — no save/restore point).
               The char route is an inline cp chain: BC-clean. */
            if (o->kind == IR_SWITCH && !(o->sw && o->sw->is_char))
                has_bc_clobber = 1;
            /* Pre-pushed call args (IR_PUSH_ARG) don't disqualify
               PR_BC: gen_call can't wrap such calls in push/pop bc
               (the save would land above the arg block), but it
               restores the tenant post-call by reloading its backing
               slot via emit_bc_reload — stack-layout-neutral. */
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
        /* Use intervals [first_use, last_use] in linear op order —
           when the value actually has to sit in BC. Needed because
           PARAMs are live-from-entry, making ir_live_ranges_overlap
           too conservative for multi-tenant allocation. Write-once
           locals (#318) anchor first_use at the def. */
        int *first_use   = calloc((size_t)f->n_vregs, sizeof(int));
        int *last_use    = calloc((size_t)f->n_vregs, sizeof(int));
        /* def_kind[v] = the OpKind of v's first writing op, or -1 if
           never written. Used by the LOCAL PR_BC eligibility check to
           ensure the producer goes through spill_and_swap_unless_dead
           (only those lowerings know to also write BC for PR_BC dst). */
        int *def_kind    = calloc((size_t)f->n_vregs, sizeof(int));
        /* Loop detection (#317): BB B is "in a loop" if a back-edge
           p→h exists with h.id ≤ B.id ≤ p.id — reliable because the
           builder produces reducible CFGs. One cheap pass. */
        int *bb_in_loop  = calloc((size_t)f->n_bbs, sizeof(int));
        /* bb_loop_lo/hi[b]: [header, tail] bb-id span of the loop
           containing b (b itself if outside any loop). In-loop uses
           extend the PR_BC interval to the whole loop body — else a
           single-static-use vreg in a loop looks like a one-op
           interval and a second tenant later in the same loop would
           pass non-overlap yet clobber BC every iteration (md5
           MDPrint, #349). */
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
            /* succ via accessor (covers IR_SWITCH) — pred[] isn't
               built. A successor with id ≤ ours is a back-edge: mark
               [header..tail] in-loop. */
            int ns = ir_bb_n_succ(bb);
            for (int s = 0; s < ns; s++) {
                int sid = ir_bb_succ_at(bb, s);
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
        /* Per-BB global op-index range (bb_last_op inclusive). Empty
           BBs get first == last + 1 — never matches, harmless. */
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
            /* In-loop uses/defs must hold BC across every iteration,
               so their interval is the whole loop body; straight-line
               ops use the per-op `global` index. */
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
                    /* Anchor the interval at the def (BC ownership
                       starts there) and record the producer kind for
                       the PR_BC LOCAL eligibility check. */
                    if (def_kind[d] < 0) def_kind[d] = (int)bb->ops[j].kind;
                    if (first_use[d] < 0 || eff_first < first_use[d])
                        first_use[d] = eff_first;
                    if (eff_last > last_use[d]) last_use[d] = eff_last;
                }
                /* IR_POSTSTEP writes its stepped var via src[0], not dst
                   (dst holds the old value). Count that write — else a
                   post-inc/dec'd param/local looks write-free and lands
                   in PR_BC, where the in-place slot step doesn't update
                   BC and later reads see the stale register (while(k--)
                   read 4 every iteration). */
                if (bb->ops[j].kind == IR_POSTSTEP) {
                    int sv = bb->ops[j].src[0];
                    if (sv >= 0 && sv < f->n_vregs) write_count[sv]++;
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
             - PARAM_IN_PLACE vregs that are never written (`write_count==0`):
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
                /* Greedy: a candidate takes BC if its use interval
                   doesn't overlap any already-allocated PR_BC vreg's. */
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

    /* PR_DEHL pool: long (width=4) vregs whose slot write is dead —
       same eligibility shape as PR_HL but for the DEHL register pair.
       Eliminates the 4-byte frame slot entirely (PR_HL only skips the
       write; PR_DEHL prevents allocation). The lowerer's
       commutative-swap pass normalises ADD's src[0]↔src[1] at lowering
       time so the PR_DEHL vreg always lands in the first-loaded source
       position for whichever consumer op it feeds. */
    {
        int *dehl_ok = calloc((size_t)f->n_vregs, sizeof(int));
        if (!dehl_ok) return;
        for (int v = 0; v < f->n_vregs; v++) dehl_ok[v] = 1;

        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if ((vr->flags & IR_VREG_PARAM)
                || (vr->flags & IR_VREG_ADDR_TAKEN))
                dehl_ok[v] = 0;
        }
        for (int i = 0; i < f->n_bbs; i++) {
            BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++) {
                const Op *op = &bb->ops[j];
                if (op->kind == IR_CALL && op->call
                    && op->call->ret_vreg >= 0)
                    dehl_ok[op->call->ret_vreg] = 0;
                if (op->kind == IR_HCALL && op->hcall
                    && op->hcall->ret_vreg >= 0)
                    dehl_ok[op->hcall->ret_vreg] = 0;
                if (op->dst < 0) continue;
                int eligible;
                switch (op->kind) {
                case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
                case IR_MOV:
                case IR_ADD: case IR_SUB:
                case IR_AND: case IR_OR: case IR_XOR:
                case IR_SHL: case IR_SHR:
                case IR_NEG: case IR_NOT:
                case IR_CONV_ZX: case IR_CONV_SX:
                    eligible = 1; break;
                default:
                    eligible = 0; break;
                }
                if (f->vregs[op->dst].width != 4 || !eligible
                    || !op_dst_spill_is_dead(bb, j))
                    dehl_ok[op->dst] = 0;
            }
        }
        for (int v = 0; v < f->n_vregs; v++) {
            if (dehl_ok[v] && f->vreg_to_phys[v] == IR_PR_SPILL)
                f->vreg_to_phys[v] = IR_PR_DEHL;
        }
        free(dehl_ok);
    }
}
