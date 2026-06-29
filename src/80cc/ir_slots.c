/*
 * ir_slots.c — frame-slot assignment for the IR lowerer.
 *
 * Split out of ir_lower.c (it touches only Func / VReg pools and the
 * ir_analysis use/def helpers — none of the lowerer's register-cache
 * state). ir_alloc decides which vregs need a slot (phys == IR_PR_SPILL);
 * this greedily coalesces non-interfering same-width spill vregs into
 * shared frame slots and sets f->vreg_spill_slot[] + f->frame_size.
 */

#include "ir_lower.h"
#include "ir_analysis.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

extern int c_framepointer_is_ix;   /* -1 = no frame pointer (sp mode) */

/* True iff the sp+0 pop/push fastpath could ever fire in this function:
   sp-mode (no IX frame pointer, or one not actually used) AND a CPU
   without cheap sp-relative addressing. Mirrors !fp_active(f) &&
   tos_pushpop_ok(f) in ir_lower.c. When false, seeding the hottest vreg
   at offset 0 buys nothing, so we leave the slot layout untouched. */
static int sp0_fastpath_possible(const Func *f)
{
    int fp_active = (c_framepointer_is_ix != -1) && !f->is_naked
                  && !f->uses_acc;
    if (fp_active) return 0;
    return !(f->features & (IR_FEAT_ADD_SP_IMM
                          | IR_FEAT_SP_REL_HL
                          | IR_FEAT_SP_REL_PAIRS));
}

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
        /* Clobberable byte homes (PR_E/PR_D — low/high of DE, hit by
           DE-scratch ops) carry a backing slot: the lazy-spill lowerer
           spills the home register there before a DE-clobbering op and
           reloads after. (PR_C/PR_B stay slotless — the no-clobber
           envelope keeps them resident for the whole function.) */
        if (f->vreg_to_phys
            && (f->vreg_to_phys[v] == IR_PR_E
                || f->vreg_to_phys[v] == IR_PR_D))
            needs_slot[v] = 1;
        /* The word DE-home (a multi-def PR_DE accumulator) is likewise
           slot-backed: it rides DE across its loop but the loop test / a
           DE-scratch op clobbers DE, so the lowerer spills DE→slot and
           reloads. Ordinary single-def PR_DE transients stay slotless. */
        if (v == f->word_home_vreg && f->vreg_to_phys
            && f->vreg_to_phys[v] == IR_PR_DE)
            needs_slot[v] = 1;
        /* Read-only param lives in the caller's pushed-arg slot;
           slot_off returns that caller offset directly. */
        if (f->vregs[v].flags & IR_VREG_PARAM_IN_PLACE)
            needs_slot[v] = 0;
    }

    /* Spill-slot coalescing: per-op interference. Walk each BB
       backward from live_out, tracking live just AFTER each op; each
       def interferes with the after-op live set. Same-width only.
       Params and addr-taken vregs keep their own slots — the prologue
       depends on a fixed param location, escaped addresses can outlive
       the IR-visible lifetime. */
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
        memset(live, 0, (size_t)row_words * sizeof(uint32_t));   /* live = live_out */
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
    /* A slot-backed byte home (PR_E/PR_D) lives in its register across the
       loop; the lowerer reloads it from this backing slot after any clobber.
       But the IR sees the home as DEAD between its SSA-temp redefinitions, so
       the packer would coalesce an unrelated temp into the home's slot —
       then a post-clobber reload reads that temp. Force the home to interfere
       with EVERY other slotted vreg so its backing slot is exclusive. */
    for (int v = 0; v < n_vregs; v++) {
        if (!f->vreg_to_phys) break;
        if (f->vreg_to_phys[v] != IR_PR_E && f->vreg_to_phys[v] != IR_PR_D)
            continue;
        for (int w = 0; w < n_vregs; w++)
            if (w != v) INTERF_SET(v, w);
    }
    /* Same exclusivity for the word DE-home's backing slot. */
    if (f->word_home_vreg >= 0 && f->word_home_vreg < n_vregs && f->vreg_to_phys
        && f->vreg_to_phys[f->word_home_vreg] == IR_PR_DE) {
        int v = f->word_home_vreg;
        for (int w = 0; w < n_vregs; w++)
            if (w != v) INTERF_SET(v, w);
    }
    free(live);
    #undef LIVE_GET
    #undef LIVE_SET
    #undef LIVE_CLEAR

    /* Hotness seed: the sp+0 pop/push fastpath (z80/z180/ez80/808x,
       sp-mode) only fires on the slot at frame offset 0, and ONLY when
       no pushes are outstanding (cur_sp_adjust==0 — otherwise the access
       falls back to the generic ld hl,N;add hl,sp path regardless of
       offset). So we score each spillable width-2 vreg by its count of
       *fastpath-eligible* accesses and seed the winner at offset 0.

       cur_sp_adjust resets to 0 at each BB start (the lowerer rebalances
       the stack at BB boundaries) and goes nonzero between an arg push
       and its call, and between a long-stack push and its pop. We mirror
       that with a per-BB push-depth counter; accesses while depth>0 are
       not eligible and don't count. Non-interfering width-2 vregs still
       first-fit into offset 0 below — they get the fastpath too. */
    int hot = -1;
    if (n_vregs > 0 && sp0_fastpath_possible(f)) {
        long *use_cnt = calloc((size_t)n_vregs, sizeof(long));
        if (!use_cnt) {
            fputs("ir_lower: out of memory (use_cnt)\n", stderr);
            abort();
        }
        for (int b = 0; b < f->n_bbs; b++) {
            BB *bb = &f->bbs[b];
            int depth = 0;   /* outstanding pushes ~ cur_sp_adjust != 0 */
            for (int j = 0; j < bb->n_ops; j++) {
                Op *op = &bb->ops[j];
                /* Accesses see the depth at op entry (any value loaded is
                   read before this op's own push, and a call reads its
                   slot args while the prior pushes are still live). */
                if (depth == 0) {
                    int tmp[16];
                    int nu = ir_op_uses(op, tmp, 16);
                    for (int k = 0; k < nu; k++)
                        if (tmp[k] >= 0 && tmp[k] < n_vregs) use_cnt[tmp[k]]++;
                    int nd = ir_op_defs(op, tmp, 16);
                    for (int k = 0; k < nd; k++)
                        if (tmp[k] >= 0 && tmp[k] < n_vregs) use_cnt[tmp[k]]++;
                }
                switch (op->kind) {
                case IR_PUSH_ARG:       depth++; break;
                case IR_PUSH_DEHL_LONG: depth++; break;
                case IR_POP_DEHL_LONG:  if (depth > 0) depth--; break;
                case IR_CALL:           depth = 0; break;  /* pops pre-pushed args */
                default: break;
                }
            }
        }
        /* Both width-2 (pop hl;push hl) and width-4 (pop hl;pop de;...)
           have a sp+0 fastpath; only one vreg can own offset 0. Score by
           raw clean-access count, width-2 and width-4 competing equally:
           a width-4 hit saves a bit more per access, but a width-2 slot
           at offset 0 is SHARED among all non-interfering width-2 vregs
           (so its value is really the sum of theirs) while width-4 there
           serves only width-4 vregs. Those roughly cancel, and raw count
           lets a dominant inner-loop accumulator (often the wide one) win
           offset 0 without displacing a hotter narrow var elsewhere. */
        long best = 0;
        for (int v = 0; v < n_vregs; v++) {
            if (!needs_slot[v]) continue;
            VReg *vr = &f->vregs[v];
            int width = (vr->width > 0) ? vr->width : 2;
            if (width != 2 && width != 4) continue;
            /* Skip pinned vregs: addr-taken liveness is under-approximated
               (escaped addresses outlive IR lifetime) so slot 0 must stay
               a normal shareable local slot. Params keep their own slots
               in pass 0 as before. */
            if (vr->flags & (IR_VREG_PARAM | IR_VREG_ADDR_TAKEN)) continue;
            if (use_cnt[v] > best) { best = use_cnt[v]; hot = v; }
        }
        free(use_cnt);
    }

    /* Greedy slot allocator. slot_members[s] = bitmap of vregs in slot s.
       slot_width[s] = byte width. A new vreg can join slot s iff it
       doesn't interfere with any current member of s. */
    uint32_t *slot_members = NULL;
    int      *slot_width   = NULL;
    char     *slot_excl    = NULL;   /* slot holds a pinned (param/addr-taken)
                                        vreg → never share it: its live range
                                        is under-approximated (an escaped &v
                                        outlives the IR-visible lifetime; a
                                        param slot is fixed by the prologue) */
    int       slot_cap     = 0;
    int       slot_n       = 0;
    int       offset       = 0;
    #define SLOT_ROW(s) (&slot_members[(s) * row_words])

    /* Place the hot vreg first so it lands at offset 0. */
    if (hot >= 0 && row_words > 0) {
        int hot_w = (f->vregs[hot].width > 0) ? f->vregs[hot].width : 2;
        slot_cap = 16;
        slot_members = calloc((size_t)slot_cap * row_words, sizeof(uint32_t));
        slot_width   = malloc((size_t)slot_cap * sizeof(int));
        slot_excl    = calloc((size_t)slot_cap, sizeof(char));
        if (!slot_members || !slot_width || !slot_excl) {
            fputs("ir_lower: out of memory (slot tables)\n", stderr);
            abort();
        }
        slot_width[0] = hot_w;   /* hot is never pinned (see best-loop skip) */
        slot_n = 1;
        f->vreg_spill_slot[hot] = 0;
        offset = hot_w;
        SLOT_ROW(0)[hot >> 5] |= (uint32_t)1 << (hot & 31);
    }

    /* Pass 0: params and addr-taken — own slot each, vreg-id order.
       Pass 1: others — first-fit across existing same-width slots. */
    for (int pass = 0; pass < 2; pass++) {
        for (int v = 0; v < n_vregs; v++) {
            if (v == hot) continue;   /* already seeded at offset 0 */
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
                    if (slot_excl[s]) continue;   /* pinned-vreg slot, never share */
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
                    slot_excl    = realloc(slot_excl,
                        (size_t)slot_cap * sizeof(char));
                    if ((!slot_members && row_words > 0) || !slot_width
                        || !slot_excl) {
                        fputs("ir_lower: out of memory (slot tables)\n",
                              stderr);
                        abort();
                    }
                    memset(slot_excl + slot_n, 0,
                           (size_t)(slot_cap - slot_n) * sizeof(char));
                    if (row_words > 0)
                        memset(SLOT_ROW(slot_n), 0,
                               (size_t)(slot_cap - slot_n) * row_words
                               * sizeof(uint32_t));
                }
                chosen = slot_n++;
                slot_width[chosen] = width;
                slot_excl[chosen]  = (pass == 0);   /* pinned vregs run in pass 0 */
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
    free(slot_excl);
    free(interf);
    free(needs_slot);
}
