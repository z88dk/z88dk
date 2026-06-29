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
#include <limits.h>
#include <string.h>

/* Word DE-home tentative-pick undo: the picker evicts other PR_DE tenants to
   give the home exclusive DE, which is a net loss if the home's loop doesn't
   end up DE-clean (no resident region forms). Region formation can only be
   decided once slots are assigned (after ir_alloc), so the picker saves the
   pre-pick allocation here; the lowerer checks the region and, if none forms,
   restores this and re-slots — reverting the function to baseline. */
static int *word_home_prepick;

int *ir_alloc_take_word_home_prepick(void)
{
    int *p = word_home_prepick;
    word_home_prepick = NULL;
    return p;
}

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
        /* __sdcccall(1) params (flagged VOLATILE by ir_build) are NOT on the
           caller stack — register args arrive in A/HL/DE, and even the
           stacked remainder is placed into local slots by emit_prologue.
           Reading them "in place" would alias the return address / a
           still-pending stacked slot, so give them real local slots. */
        if ((f->flags & SDCCCALL1) && (vr->flags & IR_VREG_VOLATILE)) continue;
        vr->flags |= IR_VREG_PARAM_IN_PLACE;
    }

    /* `cacheable[v]` is 1 iff every def of v is in an op whose lowerer
       path runs through spill_and_swap_unless_dead
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
            case IR_ADD: case IR_SUB: case IR_RSUB:
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
       PR_SPILL with the dynamic DE cache (rs.de) handling
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
            case IR_ADD: case IR_SUB: case IR_RSUB:
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
            case IR_ADD: case IR_SUB: case IR_RSUB:
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
            /* Inline asm is opaque — it may clobber BC, and unlike a call
               the lowerer has no save/restore point around it. A PR_BC
               LOCAL has no backing slot, so it couldn't be reloaded after
               the asm anyway (emit_bc_reload would read a bogus offset).
               Disqualify PR_BC for the whole function. */
            if (o->kind == IR_ASM)
                has_bc_clobber = 1;
            /* Wide-accumulator float/long-long ops (IR_ACC_*) call helpers
               (dadd/dmul/l_int2long_s_float/…) that clobber BC, and — unlike
               IR_CALL/IR_HCALL — gen_acc_* emit NO push bc/pop bc around them.
               A PR_BC LOCAL has no backing slot, so emit_bc_reload after the
               clobber would read a bogus below-frame offset. Disqualify. */
            if (o->kind == IR_ACC_BINOP || o->kind == IR_ACC_UNOP
                || o->kind == IR_ACC_CMP)
                has_bc_clobber = 1;
            /* Pre-pushed call args (IR_PUSH_ARG): gen_call can't wrap such
               calls in push/pop bc (the save would land above the arg block),
               so it restores the PR_BC tenant by reloading its backing slot
               via emit_bc_reload. That works for a PARAM (caller slot) but
               NOT a slotless write-once LOCAL — handled by the per-candidate
               `is_param || !has_prepushed_call` guard below, not here. */
        }
    }
    /* A pre-pushed-arg call restores the PR_BC tenant via emit_bc_reload
       (slot read), which a slotless LOCAL candidate can't satisfy. */
    int has_prepushed_call = 0;
    for (int i = 0; i < f->n_bbs && !has_prepushed_call; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++)
            if (f->bbs[i].ops[j].kind == IR_CALL && f->bbs[i].ops[j].call
                && f->bbs[i].ops[j].call->pre_pushed > 0) {
                has_prepushed_call = 1;
                break;
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
            int is_induct = (vr->flags & IR_VREG_INDUCTION) != 0;
            /* Slotless (non-PARAM) candidate + a pre-pushed-arg call =
               unreloadable across that call (emit_bc_reload reads -1). */
            if (!is_param && has_prepushed_call) continue;
            if (is_param) {
                if (write_count[v] > 0) continue;
            } else if (is_induct) {
                /* IVSR stepped pointer: a pre-header init + exactly one
                   in-loop self-step, both lowered through the BC-stamping
                   producer path (MOV / ADD-imm). write_count==2 — the
                   only twice-written PR_BC case, admitted solely on the
                   IVSR-set INDUCTION flag. Held in BC, the deref reads it
                   for free and the step is `ld l,c;ld h,b; add hl,de; ld
                   bc,hl` — no slot round-trip per iteration. */
                if (write_count[v] != 2) continue;
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
                case IR_ADD: case IR_SUB: case IR_RSUB:
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
                    int is_induct = (vr->flags & IR_VREG_INDUCTION) != 0;
                    if (!is_param && has_prepushed_call) continue;
                    if (is_param) {
                        if (write_count[v] > 0) continue;
                    } else if (is_induct) {
                        if (write_count[v] != 2) continue;   /* init + step */
                    } else {
                        if (write_count[v] != 1) continue;
                        int k = def_kind[v];
                        int prod_ok = 0;
                        switch (k) {
                        case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
                        case IR_MOV:
                        case IR_ADD: case IR_SUB: case IR_RSUB:
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
        /* idx2: ONE width-2 read-only PARAM read inside a loop and still
           spilled — held in the spare index register (f->idx2_reg, opposite
           the frame pointer), read via `push <idx>;pop de` at the compare.
           Gated call/asm/acc-free: those clobber the spare reg (the frame
           reg survives via the prologue push, the spare one doesn't). */
        if (f->idx2_reg != IR_PR_NONE && !f->uses_acc && !f->is_interrupt) {
            int idx2_safe = 1;
            for (int i = 0; i < f->n_bbs && idx2_safe; i++)
                for (int j = 0; j < f->bbs[i].n_ops; j++) {
                    OpKind k = f->bbs[i].ops[j].kind;
                    if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) {
                        idx2_safe = 0;
                        break;
                    }
                }
            /* Exclude deref'd/stepped pointers: a fused `*p++` writes its
               base via LD_MEM/ST_MEM post_step (invisible to write_count),
               so it looks invariant yet would advance the slot, not the reg.
               An idx2 bound is only ever compared. */
            int *is_base = calloc((size_t)f->n_vregs, sizeof(int));
            if (is_base) {
                for (int i = 0; i < f->n_bbs; i++)
                    for (int j = 0; j < f->bbs[i].n_ops; j++) {
                        const Op *o = &f->bbs[i].ops[j];
                        if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                            && o->mem.kind == IR_MEM_VREG
                            && o->mem.base >= 0 && o->mem.base < f->n_vregs)
                            is_base[o->mem.base] = 1;
                        if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                            && o->src[0] < f->n_vregs)
                            is_base[o->src[0]] = 1;
                    }
                int best = -1;
                for (int v = 0; idx2_safe && v < f->n_vregs; v++) {
                    const VReg *vr = &f->vregs[v];
                    if (vr->width != 2) continue;
                    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) continue;
                    if (!(vr->flags & IR_VREG_PARAM)) continue;
                    if (write_count[v] != 0) continue;        /* invariant */
                    if (is_base[v]) continue;                 /* not a deref'd ptr */
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                    if (use_count[v] < 4) continue;           /* used in a loop */
                    if (best < 0 || use_count[v] > use_count[best]) best = v;
                }
                if (best >= 0) f->vreg_to_phys[best] = f->idx2_reg;
                free(is_base);
            }
        }
        /* Byte-register residency (Plan B, Phase 1 — C-home only).
           Keep a hot loop-carried width-1 accumulator in C instead of a
           frame slot. C is the low half of BC; in this block's envelope
           (!has_long && !has_bc_clobber) BC is preserved-by-construction,
           so a byte in C is rock-solid for the whole function — TRUE
           residency: the value rides C for the whole function with NO slot
           store (the lowerer's store_a_byte emits `ld c,a` and returns;
           every byte read funnels through load_byte_to_a, home-aware).
           Three gates make this audit-free + correct: NO calls (sidesteps
           the PR_BC call save/restore, keyed on a word PR_BC tenant); BC
           FREE (no word vreg took IR_PR_BC); and DEF-BEFORE-USE — the
           value's first def must strictly precede its first read (else a
           read would consult an unestablished home). Unlike PR_BC this
           admits a WRITE-MANY vreg (the accumulator is the point). One
           occupant. */
        if (c_byte_resident && !getenv("IR_NO_BYTE_RESIDENT")) {
            int has_call = 0, bc_taken = 0;
            for (int i = 0; i < f->n_bbs && !has_call; i++)
                for (int j = 0; j < f->bbs[i].n_ops; j++) {
                    OpKind k = f->bbs[i].ops[j].kind;
                    if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) {
                        has_call = 1; break;
                    }
                }
            for (int v = 0; v < f->n_vregs && !bc_taken; v++)
                if (f->vreg_to_phys[v] == IR_PR_BC) bc_taken = 1;
            /* first_def/first_read in global op order (def-before-use). */
            int *first_def  = calloc((size_t)f->n_vregs, sizeof(int));
            int *first_read = calloc((size_t)f->n_vregs, sizeof(int));
            if (!has_call && first_def && first_read) {
                for (int v = 0; v < f->n_vregs; v++) {
                    first_def[v] = INT_MAX; first_read[v] = INT_MAX;
                }
                int g = 0;
                for (int i = 0; i < f->n_bbs; i++) {
                    BB *bb = &f->bbs[i];
                    for (int j = 0; j < bb->n_ops; j++, g++) {
                        const Op *o = &bb->ops[j];
                        int u[16];
                        int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                        for (int k = 0; k < nu; k++)
                            if (u[k] >= 0 && u[k] < f->n_vregs
                                && g < first_read[u[k]])
                                first_read[u[k]] = g;
                        if (o->dst >= 0 && o->dst < f->n_vregs
                            && g < first_def[o->dst])
                            first_def[o->dst] = g;
                        if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                            && o->src[0] < f->n_vregs
                            && g < first_def[o->src[0]])
                            first_def[o->src[0]] = g;
                    }
                }
                int best = -1;
                for (int v = 0; v < f->n_vregs; v++) {
                    const VReg *vr = &f->vregs[v];
                    if (vr->width != 1) continue;
                    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                        continue;
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                    /* Must actually be touched in a loop body — the
                       use-count weighting (×4 in-loop) clears this when the
                       vreg is loop-carried. Cold byte locals stay in slots. */
                    if (use_count[v] < 8) continue;
                    if (write_count[v] < 1) continue;
                    /* Def must DOMINATE every read so the home is always
                       established first. Sufficient + cheap: the first def
                       lands in the entry block (bb0, global index <
                       bb0.n_ops — global indices number bb0 first) AND
                       strictly precedes the first read. bb0 dominates all
                       blocks, so a read can never run before this def.
                       (Rejects conditionally-initialised bytes — they keep
                       their slot.) */
                    if (first_def[v] >= f->bbs[0].n_ops) continue;
                    if (first_def[v] >= first_read[v]) continue;  /* def-first */
                    if (best < 0 || use_count[v] > use_count[best]) best = v;
                }
                /* C-home (slotless TRUE residency) when BC is free; else
                   E-home (low half of DE, slot-backed lazy-spill — Plan B
                   Phase 2) where DE-scratch ops clobber it across the loop
                   test, so it carries a backing slot and the lowerer spills
                   E→slot before any DE-clobbering op. */
                if (best >= 0)
                    f->vreg_to_phys[best] = bc_taken ? IR_PR_E : IR_PR_C;
            }
            free(first_def);
            free(first_read);
        }
        /* Word (int) accumulator residency (DE-home) — word analog of the
           byte E-home above, INDEPENDENT of c_byte_resident. Keep a hot
           loop-carried width-2 accumulator in the DE pair across its loop
           instead of a frame slot; the lowerer accumulates via `add hl,de;
           ex de,hl` (addend through HL) so DE stays live with no per-iter
           slot store. Same gates as the byte E-home: NO calls (DE survives
           by construction), def-DOMINATES-use (home established first), hot +
           write-many (a real loop accumulator). The home OWNS DE: any other
           PR_DE tenant (e.g. a single-use addend the transient pass parked in
           DE) is demoted to SPILL so its def can't clobber the home — it
           reloads through HL at the accumulate. Skipped when a byte E/D-home
           already claimed DE's low half. One occupant. */
        if (c_word_resident && !getenv("IR_NO_WORD_RESIDENT")) {
            int wd_call = 0, de_half_taken = 0;
            for (int i = 0; i < f->n_bbs && !wd_call; i++)
                for (int j = 0; j < f->bbs[i].n_ops; j++) {
                    OpKind k = f->bbs[i].ops[j].kind;
                    if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) {
                        wd_call = 1; break;
                    }
                }
            for (int v = 0; v < f->n_vregs && !de_half_taken; v++)
                if (f->vreg_to_phys[v] == IR_PR_E || f->vreg_to_phys[v] == IR_PR_D)
                    de_half_taken = 1;
            int *wd_def  = calloc((size_t)f->n_vregs, sizeof(int));
            int *wd_read = calloc((size_t)f->n_vregs, sizeof(int));
            int *wd_base = calloc((size_t)f->n_vregs, sizeof(int));
            int *wd_acc  = calloc((size_t)f->n_vregs, sizeof(int));
            if (!wd_call && !de_half_taken && wd_def && wd_read && wd_base && wd_acc) {
                for (int v = 0; v < f->n_vregs; v++) {
                    wd_def[v] = INT_MAX; wd_read[v] = INT_MAX;
                }
                int g = 0;
                for (int i = 0; i < f->n_bbs; i++) {
                    BB *bb = &f->bbs[i];
                    for (int j = 0; j < bb->n_ops; j++, g++) {
                        const Op *o = &bb->ops[j];
                        int u[16];
                        int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                        for (int k = 0; k < nu; k++)
                            if (u[k] >= 0 && u[k] < f->n_vregs && g < wd_read[u[k]])
                                wd_read[u[k]] = g;
                        if (o->dst >= 0 && o->dst < f->n_vregs && g < wd_def[o->dst])
                            wd_def[o->dst] = g;
                        if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                            && o->src[0] < f->n_vregs && g < wd_def[o->src[0]])
                            wd_def[o->src[0]] = g;
                        /* deref'd / stepped pointers are not accumulators */
                        if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                            && o->mem.kind == IR_MEM_VREG
                            && o->mem.base >= 0 && o->mem.base < f->n_vregs)
                            wd_base[o->mem.base] = 1;
                        if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                            && o->src[0] < f->n_vregs)
                            wd_base[o->src[0]] = 1;
                        /* A true reduction accumulator is redefined as
                           `v = v OP w` with w a VREG (sum += a[i]) — not an
                           induction variable (`i = i + const` / INC, whose
                           other operand is an immediate). Distinguishes the
                           accumulator from the loop counter (both are hot,
                           multi-def width-2). */
                        switch (o->kind) {
                        case IR_ADD: case IR_SUB: case IR_RSUB:
                        case IR_AND: case IR_OR:  case IR_XOR:
                            if (o->dst >= 0 && o->dst < f->n_vregs
                                && o->src[1] >= 0
                                && (o->src[0] == o->dst || o->src[1] == o->dst))
                                wd_acc[o->dst] = 1;
                            break;
                        default: break;
                        }
                    }
                }
                int wbest = -1;
                for (int v = 0; v < f->n_vregs; v++) {
                    const VReg *vr = &f->vregs[v];
                    if (vr->width != 2) continue;
                    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                     | IR_VREG_PARAM)) continue;
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                    if (wd_base[v]) continue;             /* not a deref'd ptr */
                    if (!wd_acc[v]) continue;             /* reduction acc, not IV */
                    if (use_count[v] < 8) continue;       /* hot, in a loop */
                    if (write_count[v] < 2) continue;     /* init + per-iter redef */
                    if (wd_def[v] >= f->bbs[0].n_ops) continue;  /* def in entry bb0 */
                    if (wd_def[v] >= wd_read[v]) continue;       /* def-first */
                    if (wbest < 0 || use_count[v] > use_count[wbest]) wbest = v;
                }
                if (wbest >= 0) {
                    /* Save the pre-pick allocation so the lowerer can revert
                       this function to baseline if no resident region forms. */
                    free(word_home_prepick);
                    word_home_prepick = malloc((size_t)f->n_vregs * sizeof(int));
                    if (word_home_prepick)
                        memcpy(word_home_prepick, f->vreg_to_phys,
                               (size_t)f->n_vregs * sizeof(int));
                    for (int v = 0; v < f->n_vregs; v++)
                        if (v != wbest && f->vreg_to_phys[v] == IR_PR_DE)
                            f->vreg_to_phys[v] = IR_PR_SPILL;
                    f->vreg_to_phys[wbest] = IR_PR_DE;
                    f->word_home_vreg = wbest;
                }
            }
            free(wd_def);
            free(wd_read);
            free(wd_base);
            free(wd_acc);
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
                case IR_ADD: case IR_SUB: case IR_RSUB:
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
