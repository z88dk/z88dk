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
