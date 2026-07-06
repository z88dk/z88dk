/* ir_lower_analysis.inc.c — part of ir_lower.c, #included (single TU). Do not compile standalone. */

/* Max BB id in the natural loop of back-edge latch->header: the header plus
   every block that can reach the latch without passing through the header
   (backward reachability over preds). Returns latch's id if any body block is
   numbered below the header (that block would sit outside a [header..hi] span
   — reject by not widening, leaving the caller's conservative latch-id hi).
   Used to widen a residency span past a diamond arm numbered above the latch. */
static int natural_loop_max_id(const Func *f, int header, int latch,
                               const int *bb_alias)
{
    int n = f->n_bbs;
    if (n <= 0 || header < 0 || latch < 0) return latch;
    char *body = calloc((size_t)n, 1);
    int *stk = malloc((size_t)n * sizeof(int));
    if (!body || !stk) { free(body); free(stk); return latch; }
    int sp = 0;
    body[header] = 1;
    if (latch != header) { body[latch] = 1; stk[sp++] = latch; }
    while (sp > 0) {
        int x = stk[--sp];
        for (int p = 0; p < n; p++) {              /* preds of x */
            if (body[p]) continue;
            const BB *pb = &f->bbs[p];
            int pns = ir_bb_n_succ(pb), is_pred = 0;
            for (int s = 0; s < pns; s++) {
                int sid = ir_bb_succ_at(pb, s);
                if (sid < 0 || sid >= n) continue;
                if (bb_alias && bb_alias[sid] >= 0) sid = bb_alias[sid];
                if (sid == x) { is_pred = 1; break; }
            }
            if (is_pred) { body[p] = 1; stk[sp++] = p; }
        }
    }
    int hi = latch, bad = 0;
    for (int b = 0; b < n; b++) {
        if (!body[b]) continue;
        if (b < header) { bad = 1; break; }        /* body below header — bail */
        if (b > hi) hi = b;
    }
    free(body); free(stk);
    return bad ? latch : hi;
}

static void compute_home_region(const Func *f, int home,
                                const int *bb_alias, int *out_lo, int *out_hi)
{
    *out_lo = -1; *out_hi = -1;
    if (home < 0 || home >= f->n_vregs || f->n_bbs <= 0) return;

    /* Examine each back-edge's loop span [header..latch] INDEPENDENTLY (a
       union would merge disjoint loops and pull in unrelated dirty blocks).
       The latch's target is alias-resolved so a trampoline header maps to the
       real header. Pick the WIDEST all-DE-clean span with the home live-in at
       its header; spans over-reaching into a dirty block fail validation. */
    int best_lo = -1, best_hi = -1, best_w = -1;
    for (int i = 0; i < f->n_bbs; i++) {
        const BB *bb = &f->bbs[i];
        int ns = ir_bb_n_succ(bb);
        for (int s = 0; s < ns; s++) {
            int sid = ir_bb_succ_at(bb, s);
            if (sid < 0 || sid >= f->n_bbs) continue;
            if (bb_alias && bb_alias[sid] >= 0) sid = bb_alias[sid];
            if (sid > i) continue;                 /* forward edge */
            int lo = sid, hi = i;
            if (lo < 0 || hi >= f->n_bbs || lo > hi) continue;
            /* Extend hi to cover the whole natural-loop body: a diamond's
               else-arm (or any body block) can be numbered ABOVE the latch
               (merge/latch id < arm id), so the contiguous [sid..latch] span
               would exclude it and residency would break at the merge. Widen
               to the max id of blocks that reach the latch without passing the
               header; home_span_valid then vets every block in [lo,hi] (incl.
               any non-loop interloper, which must be DE-clean too). */
            int nat_hi = natural_loop_max_id(f, lo, i, bb_alias);
            if (nat_hi > hi) hi = nat_hi;
            if (hi - lo <= best_w) continue;       /* not wider than best */
            if (!home_span_valid(f, home, lo, hi))
                continue;
            /* The leaving-edge entry-flush captures the exit value only if the
               source BB doesn't redefine the home before the exit branch.
               Reject the span if any region-leaving-edge source writes it. */
            int exit_bad = 0;
            for (int b = lo; b <= hi && !exit_bad; b++) {
                const BB *eb = &f->bbs[b];
                int leaves = 0, ns2 = ir_bb_n_succ(eb);
                for (int s2 = 0; s2 < ns2; s2++) {
                    int t = ir_bb_succ_at(eb, s2);
                    if (t < 0 || t >= f->n_bbs) continue;
                    if (bb_alias && bb_alias[t] >= 0) t = bb_alias[t];
                    if (t < lo || t > hi) { leaves = 1; break; }
                }
                if (!leaves) continue;
                for (int j = 0; j < eb->n_ops && !exit_bad; j++) {
                    int defs[8];
                    int nd = ir_op_defs(&eb->ops[j], defs, 8);
                    for (int k = 0; k < nd; k++)
                        if (defs[k] == home) { exit_bad = 1; break; }
                }
            }
            if (exit_bad)
                continue;
            best_lo = lo; best_hi = hi; best_w = hi - lo;
        }
    }
    *out_lo = best_lo; *out_hi = best_hi;
}

/* Load src[0]→HL and src[1]→DE in the order that doesn't clobber HL.
   Caller can then emit a binary op on HL,DE.

   Four cases:
   1. src[1] == -1: literal-fold — RHS is op->imm, emit `ld de,K`.
   2. cache hit on src[0]: preserve-HL load for src[1]'s slot.
   3. cache hit on src[1] (and not src[0]): swap into DE via `ex de,hl`
      (1 instr) then frame-load src[0], saving load_to_de's 6-instr frame
      load. Common case: a prior binop's result (HL-cached) is the next
      binop's RHS (e.g. `crc ^= shifted`).
   4. default: load_to_de(src[1]) (clobbers HL), then load_to_hl(src[0]).
*/
static void load_binop_operands(FILE *out, const Func *f, const Op *op)
{
    if (op->src[1] < 0) {
        /* Literal RHS — doesn't touch HL. */
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
           it in DE, the swap's intent. */
        if (L.lazy_spill_on && L.pending_spill_v == op->src[1]) {
            pending_spill_flush();   /* DE := src1, slot written, HL junk */
            cache_de(op->src[1]);
            load_to_hl(out, f, op->src[0]);
            return;
        }
        /* Swap into DE (HL↔DE). After: DE has src[1], HL has whatever DE
           held — caller wants src[0] in HL, so reload it. */
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
           operands from scratch since the src0 DE-cache may be gone. */
        if (L.lazy_spill_on && L.pending_spill_v >= 0) {
            pending_spill_resolve();
            invalidate_de_cache();
            load_to_de(out, f, op->src[1]);
            cache_de(op->src[1]);
            load_to_hl(out, f, op->src[0]);
            return;
        }
        /* DE has src[0], want it in HL: ex de,hl moves it, then load src[1]
           into DE. load_to_de uses HL as scratch, so use the HL-preserving
           push/pop variant. */
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

/* Sole choke point for an HL clobber/load. When a width-2 spill is pending
   in HL and HL is about to take a different tenant, resolve it (flush if
   live, discard if dead) BEFORE the physical clobber. The `!= v_new` guard
   lets a def re-advertise its own dst, or a carry re-assert the same vreg,
   without spuriously flushing. */
static void hl_about_to_change(int v_new)
{
    if (L.lazy_spill_on && L.pending_spill_v >= 0 && L.pending_spill_v != v_new)
        pending_spill_resolve();
    L.rs.hl = v_new;
    L.cur_hl_addr_off = -1;    /* HL no longer holds a cached slot address */
}

/* HL now holds v's slot address (after `ld hl,off;add hl,sp`): set the
   address belief, clear the value one. Not via hl_about_to_change (that
   clears the address belief). Pending spill already resolved (addr ⇒ none). */
static void cache_hl_slot_addr(const Func *f, int v)
{
    L.rs.hl = -1;
    L.cur_hl_addr_off = slot_off(f, v);
    L.cur_hl_addr_spadj = L.cur_sp_adjust;
}

/* Materialize &slot(v) into HL for an sp-rel byte access, reusing a cached
   slot address: exact → nothing; near → inc/dec hl (preserves A); else
   ld hl,off;add hl,sp. Cold path clobbers HL → caller resolves any pending
   spill first. Updates the cache. */
static void emit_byte_slot_addr(FILE *out, const Func *f, int v)
{
    if (L.cur_hl_addr_off >= 0 && L.cur_hl_addr_spadj == L.cur_sp_adjust) {
        int d = slot_off(f, v) - L.cur_hl_addr_off;
        /* inc/dec hl (6T z80 / 5-6T 808x) beats the 21T/4B `ld hl,nn;add
           hl,sp` for deltas ≤3. gbz80's recompute is the 12T/2B `ld hl,sp+d`
           and its inc hl is 8T, so only delta 1 wins there. gbz80 is the
           only target lacking ex de,hl → use that as the discriminator. */
        int cap = (!IS_GBZ80()) ? 3 : 1;
        if (d == 0) return;                       /* exact hit */
        if (d >= 1 && d <= cap) {
            while (d-- > 0) emit(out, "inc\thl");
            cache_hl_slot_addr(f, v);
            return;
        }
        if (d <= -1 && d >= -cap) {
            while (d++ < 0) emit(out, "dec\thl");
            cache_hl_slot_addr(f, v);
            return;
        }
    }
    emit(out, "ld\thl,%d", slot_off(f, v) + L.cur_sp_adjust);
    emit(out, "add\thl,sp");
    cache_hl_slot_addr(f, v);
}

/* Spill a dirty slot-backed byte home (E/D) to its slot, leaving the register
   unchanged (value now in both → clean). No-op for a clean/slotless/absent
   home. Clobbers HL in sp-mode. Called before any DE-clobbering op and at
   every BB end so the slot is coherent. */
static void byte_home_flush(FILE *out, const Func *f)
{
    int v = L.cur_byte_home_vreg;
    if (v < 0 || !L.cur_byte_home_dirty) return;
    PhysReg pr = byte_home_phys(f, v);
    if (!byte_home_slotbacked(pr)) return;
    const char *r = byte_home_reg(pr);
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, v);
        if (fp_offset_fits(ix_off)) {
            emit(out, "ld\t(%s%+d),%s", frame_reg(), ix_off, r);
            L.cur_byte_home_dirty = 0;
            return;
        }
    }
    /* sp-mode: slot-address math clobbers HL (not E/D, so `r` survives).
       Resolve pending HL spill + drop HL value cache. PRESERVE the A-cache:
       the flush never touches A, but the triggering dirty op may still read a
       cache_a'd temp; invalidate_hl_cache clears A, so save/restore it. */
    pending_spill_resolve();
    invalidate_hl_keep_a();
    emit_byte_slot_addr(out, f, v);
    emit(out, "ld\t(hl),%s", r);
    L.cur_byte_home_dirty = 0;
}


/* Load the slot-backed home into its register (E/D) at a resident-loop
   preheader exit so the header can assert residency: the preheader's home def
   may have been clobbered (e.g. an `end = base+len` add hl,de after init),
   leaving the home only in its coherent slot. Returns 1 on success, 0 if it
   couldn't be done without clobbering a live carry (caller then leaves
   residency unasserted → per-iteration reload, still correct). */
static int rehome_byte_home(FILE *out, const Func *f)
{
    int v = L.cur_func_ehome;
    if (v < 0 || v >= f->n_vregs) return 0;
    PhysReg bh = byte_home_phys(f, v);
    if (!byte_home_slotbacked(bh)) return 0;
    if (L.cur_byte_home_vreg == v) return 1;          /* already resident */
    const char *r = byte_home_reg(bh);
    if (fp_active(f)) {
        int off = slot_ix_off(f, v);
        if (!fp_offset_fits(off)) return 0;
        emit(out, "ld\t%s,(%s%+d)", r, frame_reg(), off);  /* ld e,(ix+d) */
    } else {
        /* sp-mode needs HL for the slot address. Preserve HL with push/pop —
           it may carry a value into the loop. Offset adds 2 for the push
           lowering sp; the pop restores HL exactly, so cache beliefs hold. */
        emit(out, "push\thl");
        emit(out, "ld\thl,%d", slot_off(f, v) + L.cur_sp_adjust + 2);
        emit(out, "add\thl,sp");
        emit(out, "ld\t%s,(hl)", r);                /* ld e,(hl) */
        emit(out, "pop\thl");
    }
    byte_home_note(v);
    L.cur_byte_home_dirty = 0;                         /* loaded from coherent slot */
    return 1;
}

/* Flush the word DE-home (the running sum, in DE) to its 2-byte backing slot
   so the slot is coherent for a read / return / cross-BB reload. Mirror of
   byte_home_flush, but writes both bytes (E=low, D=high). DE is preserved. */
static void word_home_flush(FILE *out, const Func *f)
{
    int v = L.cur_byte_home_vreg;
    if (v < 0 || v != L.cur_func_whome || !L.cur_byte_home_dirty) return;
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, v);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            emit(out, "ld\t(%s%+d),e", frame_reg(), ix_off);
            emit(out, "ld\t(%s%+d),d", frame_reg(), ix_off + 1);
            L.cur_byte_home_dirty = 0;
            return;
        }
    }
    /* sp-mode: slot-address math clobbers HL (DE, the value, is untouched).
       Preserve the A-cache — the triggering op may still read a cache_a'd
       temp; invalidate_hl_cache clears A. */
    pending_spill_resolve();
    invalidate_hl_keep_a();
    emit(out, "ld\thl,%d", slot_off(f, v) + L.cur_sp_adjust);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e");
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),d");
    L.cur_byte_home_dirty = 0;
}

/* Word DE-home region-exit flush — emitted ONCE at a dedicated loop-exit
   block (reached ONLY from the resident region), replacing the header's
   per-iteration entry flush. Correct without a reload: compute_home_region
   proves the home rides physical DE across the region and no leaving-edge
   source redefines it before the branch, so DE = the final accumulator on
   every region-leaving edge. fp-only (the word DE-home forms only in fp). */
static void word_home_exit_flush(FILE *out, const Func *f)
{
    int v = L.cur_func_whome;
    if (v < 0 || !fp_active(f)) return;
    int off = slot_ix_off(f, v);
    if (!fp_offset_fits(off) || !fp_offset_fits(off + 1)) return;
    emit(out, "ld\t(%s%+d),e", frame_reg(), off);
    emit(out, "ld\t(%s%+d),d", frame_reg(), off + 1);
}

/* Byte E/D-home region-exit flush — emitted ONCE at a dedicated loop-exit
   block (reached ONLY from the resident region), replacing the header's
   per-iteration entry flush. The region proof keeps the home in its register
   across every leaving edge (no leaving-edge redef before the branch), so the
   register = the final value here. Runs at the exit block's entry, where the
   pending spill is already cleared and the cache-carry has not yet applied. */
static void byte_home_exit_flush(FILE *out, const Func *f)
{
    int v = L.cur_func_ehome;
    if (v < 0) return;
    PhysReg pr = byte_home_phys(f, v);
    if (!byte_home_slotbacked(pr)) return;
    const char *r = byte_home_reg(pr);
    if (fp_active(f)) {
        int off = slot_ix_off(f, v);
        if (!fp_offset_fits(off)) return;
        emit(out, "ld\t(%s%+d),%s", frame_reg(), off, r);
        return;
    }
    /* sp-mode: address the slot via HL (the byte reg E/D is untouched by the
       HL math). Free to clobber HL here — the cache-carry below re-establishes
       it. */
    emit(out, "ld\thl,%d", slot_off(f, v) + L.cur_sp_adjust);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),%s", r);
    invalidate_hl_cache();
}

/* Reload the word DE-home into DE from its (coherent) slot, preserving HL —
   so an addend already loaded in HL by the accumulate survives. Mirror of
   rehome_byte_home for the full pair. Returns 1 once DE holds the home. */
static int rehome_word_home(FILE *out, const Func *f)
{
    int v = L.cur_func_whome;
    if (v < 0 || v >= f->n_vregs) return 0;
    if (L.cur_byte_home_vreg == v) return 1;          /* already resident */
    if (fp_active(f)) {
        int off = slot_ix_off(f, v);
        if (!fp_offset_fits(off) || !fp_offset_fits(off + 1)) return 0;
        emit(out, "ld\te,(%s%+d)", frame_reg(), off);
        emit(out, "ld\td,(%s%+d)", frame_reg(), off + 1);
    } else {
        emit(out, "push\thl");
        emit(out, "ld\thl,%d", slot_off(f, v) + L.cur_sp_adjust + 2);
        emit(out, "add\thl,sp");
        emit(out, "ld\te,(hl)");
        emit(out, "inc\thl");
        emit(out, "ld\td,(hl)");
        emit(out, "pop\thl");
    }
    byte_home_note(v);
    cache_de(v);                                    /* DE physically = home */
    L.cur_byte_home_dirty = 0;                        /* loaded from coherent slot */
    return 1;
}

/* Width-aware home dispatchers — pick the byte (E/D) or word (DE) variant per
   cur_home_is_word, so the shared BB-loop residency logic serves both. */
static int home_is_slotbacked(const Func *f, int v)
{
    if (L.cur_home_is_word) return v >= 0 && v == L.cur_func_whome;
    return byte_home_is_slotbacked(f, v);
}
static void home_flush(FILE *out, const Func *f)
{
    if (L.cur_home_is_word) word_home_flush(out, f);
    else                  byte_home_flush(out, f);
}
/* A DE-clobbering op is about to run: flush the dirty home (slot now
   coherent) then drop the belief — the register no longer reliably holds the
   value after the op. A later read reloads from the (now coherent) slot. */
static void home_clobber(FILE *out, const Func *f)
{
    if (L.cur_byte_home_vreg < 0) return;
    if (!home_is_slotbacked(f, L.cur_byte_home_vreg)) return;
    home_flush(out, f);
    L.cur_byte_home_vreg = -1;
}
static int home_rehome(FILE *out, const Func *f)
{
    if (L.cur_home_is_word) return rehome_word_home(out, f);
    return rehome_byte_home(out, f);
}

/* Sole choke point for the `ex de,hl` cache swap: HL and DE trade tenants.
   The value leaving HL survives in DE, so this is distinct from
   hl_about_to_change (a clobber). Callers emit the `ex de,hl` themselves. */
static void swap_hl_de_caches(void)
{
    int tmp = L.rs.hl;
    L.rs.hl = L.rs.de;
    L.rs.de = tmp;
}

/* Invalidate the HL cache. Use around any op that clobbers HL opaquely:
   calls, ret, branches, the variable shift loop, indirect mem loads, etc.
   Also invalidates DE by default — almost every HL-invalidating emit also
   writes DE (long arith stages through DE, literal-fold's `ld de,K`, calls).
   Sites that DO preserve DE save+restore rs.de around this call. */
static void invalidate_hl_cache(void)
{
    hl_about_to_change(-1);
    invalidate_de_cache();   /* clears rs.de + rs.dehl */
    L.rs.a = -1;
    L.rs.fa = -1;
    L.rs.i64_acc = -1;
}

/* Both HL and BC clobbered (16-bit ops through HL that also stash via BC,
   calls, etc.). */
static void invalidate_hl_bc(void) { invalidate_hl_cache(); invalidate_bc_cache(); }

/* HL clobbered but DE provably preserved (DSUB / `sbc hl,de` leave DE intact):
   drop the full HL-cache set, then re-assert the surviving DE tenant. */
static void invalidate_hl_keep_de(void) {
    int saved_de = L.rs.de;
    invalidate_hl_cache();
    L.rs.de = saved_de;
}

/* HL clobbered but A provably preserved (sp-mode slot-address math touches
   only HL; the triggering op may still consume a cache_a'd byte operand):
   drop the full HL-cache set, then re-assert the surviving A tenant. */
static void invalidate_hl_keep_a(void) {
    int saved_a = L.rs.a;
    invalidate_hl_cache();
    L.rs.a = saved_a;
}

/* Apply an emit_c clobber mask via the invalidate_* routines. Non-HL bits
   are pure field clears (order-independent); only CLOB_HL can emit (its
   pending-spill flush), and it runs first. */
static void apply_clobbers(Clobber c)
{
    if (c & CLOB_HL) invalidate_hl_cache();
    if (c & CLOB_DE) invalidate_de_cache();
    if (c & CLOB_A)  invalidate_a_cache();
    if (c & CLOB_BC) invalidate_bc_cache();
}

/* Current BB being lowered (set per-op by lower_func). Read by the AND-mask +
   shift-test peephole to inspect successor BBs' first ops. */
static const BB *cur_bb;

/* ---- Lazy spill (store-on-clobber) helpers -------------------------
   Defined here (not at the cache helpers) because the flush needs store_hl,
   the de-cache invalidator, cur_bb and the per-op liveness. */

/* Is the pending vreg still live entering the op being lowered? Conservative
   default (assume live → flush) when liveness context is unavailable, so an
   unknown state never drops a live store. */
static int pending_spill_live(void)
{
    if (L.pending_spill_v < 0) return 0;
    if (!cur_bb) return 1;
    const BitSet *li = ir_op_live_in(cur_bb, cur_op_idx);
    if (!li) return 1;
    return ir_bitset_get(li, L.pending_spill_v);
}

/* Emit the deferred slot store. Precondition: HL holds pending_spill_v.
   After: slot written, HL junk, DE cache dropped, nothing pending. Clears
   pending_spill_v before emitting so a re-entrant choke-point call can't
   double-flush. */
static void pending_spill_flush(void)
{
    if (L.pending_spill_v < 0) return;
    int v = L.pending_spill_v;
    L.pending_spill_v = -1;
    store_hl(cur_lazy_out, cur_lazy_func, v);
    L.rs.hl = -1;
    invalidate_de_cache();
}

/* Resolve a pending spill at a point where HL is about to be clobbered:
   flush it if the value is still live (needed from a later slot read),
   else discard it (dead or about to be redefined → the store was dead). */
static void pending_spill_resolve(void)
{
    if (L.pending_spill_v < 0) return;
    if (pending_spill_live())
        pending_spill_flush();
    else
        L.pending_spill_v = -1;
}

/* Skip-and-cache list for the AND 0x8000 + BR + SHL-in-both-succs fastpath.
   Both succs' leading IR_SHL ops would re-shift a value the fused `add hl,hl`
   already produced. Record their (bb_id, op_idx); the per-op loop elides the
   SHL and advertises rs.hl to its dst. Small cap (unrolled CRC loop: 2/iter ×
   8 = 16 max). */
#define SHL_SKIP_CAP 32
static struct { int bb_id, op_idx, cache_vreg, is_byte; } shl_skip[SHL_SKIP_CAP];

/* True iff v lives in the spare index register (the idx2 loop-invariant
   resident). f->idx2_reg is IR_PR_IX / IR_PR_IY / IR_PR_NONE. */
static int vreg_in_idx2(const Func *f, int v)
{
    if (v < 0 || !f || !f->vreg_to_phys || f->idx2_reg == IR_PR_NONE)
        return 0;
    return f->vreg_to_phys[v] == f->idx2_reg;
}

/* The spare index register's assembler name ("ix"/"iy"), or NULL if none. */
static const char *idx2_reg_name(const Func *f)
{
    if (!f || f->idx2_reg == IR_PR_IX) return "ix";
    if (f->idx2_reg == IR_PR_IY) return "iy";
    return NULL;
}

/* True iff v is allocator-pinned to a register pool (PR_HL/DE/BC/DEHL or
   the spare index register) — no frame slot is ever touched. */
static int vreg_in_register_pool(const Func *f, int v)
{
    if (v < 0 || !f || !f->vreg_to_phys) return 0;
    PhysReg pr = f->vreg_to_phys[v];
    return pr == IR_PR_HL || pr == IR_PR_DE
        || pr == IR_PR_BC || pr == IR_PR_DEHL
        || vreg_in_idx2(f, v);
}

/* Can a byte result for vreg `v` stay only in A (cache_a) instead of being
   stored? Yes when it's dead-after-next-use or lives in a word pool — EXCEPT
   a slot-backed byte home (PR_E/PR_D), which must be written to its register
   (store_a_byte → `ld e,a`) so the home belief stays consistent: leaving a
   loop-carried accumulator only in A would lose it at the next clobber. */
static int byte_dst_cache_ok(const Func *f, int v)
{
    if (byte_home_is_slotbacked(f, v)) return 0;
    /* Index-half home (IXL/IXH/IYL/IYH): reads go through the half register
       (`ld a,iyl`), NOT the A-cache — so the value MUST be written to the half
       at every def. Leaving it only in A (cur_dst_dead byte immediately
       consumed by a WIDENING read, which reloads the half) reads a never-written
       home. Force the store, same as a slot-backed home. */
    if (idxhalf_phys(f, v) != IR_PR_NONE) return 0;
    return L.la.cur_dst_dead || vreg_in_register_pool(f, v);
}

/* Byte result is in A: keep it live in the A-cache (claim dst) when dst's next
   read is A-serviceable, else spill to dst's home/slot. */
static void commit_a_byte(FILE *out, const Func *f, int v)
{
    if (byte_dst_cache_ok(f, v))
        cache_a(v);
    else
        store_a_byte(out, f, v);
}

/* ---- Static lazy spill — reaching-reloads dead-store elimination -------
   Behind IR_LAZY_SPILL. Pass 1 lowers eagerly and records, per op, the
   deferrable-vreg slot accesses the lowerer makes — ground truth, since
   deferral changes only stores, never which loads cache-hit. A backward
   slot-liveness dataflow marks a spill store DEAD iff no reload of its slot
   is reachable before the next store. Pass 2 elides dead stores; the value
   rides to its readers in HL via bb_hl_out. Keys on the lowerer's OWN
   behaviour, not an IR-level deadness guess, so it survives the fused-add-
   hl-hl artifact.

   SOUND-BY-CONSTRUCTION reload (GEN) set, computed in ss_compute_dead:

       { deferrable v in uses(op) : v NOT proven cache-served } ∪ explicit

   EVERY deferrable source is assumed reloaded UNLESS pass 1 recorded a
   genuine cache hit (ss_op_cacheread). So a missed hook only leaves a store
   un-elided (lost opt) — never elides a live store. Discipline is INVERTED:
     - cacheread MUST be precise (over-recording would hide a real reload);
     - reload/store hooks may be incomplete — a belt-and-suspenders backstop,
       not the safety mechanism.
   uses(op) comes from the reliable ir_op_uses. */

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
    if (L.ss_phase != 1 || L.ss_cur_g < 0 || !vreg_slot_deferrable(f, v)) return;
    int *slot = &L.ss_op_reload[L.ss_cur_g * 2];
    if (slot[0] == v || slot[1] == v) return;       /* dedup */
    if (slot[0] < 0) { slot[0] = v; return; }
    if (slot[1] < 0) { slot[1] = v; return; }
    L.ss_pinned = 1;          /* >2 distinct reloads in one op — bail safely */
}
static void ss_note_store(const Func *f, int v)
{
    if (L.ss_phase != 1 || L.ss_cur_g < 0 || !vreg_slot_deferrable(f, v)) return;
    L.ss_op_store[L.ss_cur_g] = v;
}
/* Pass-1 hook at a GENUINE cache hit (loader early returns serving v from
   HL/DE/BC/A with no slot read). MUST be precise — this proves a use is NOT a
   reload, so a false positive would hide a real reload. Under-recording only
   forgoes optimisation. */
static void ss_note_cache_read(const Func *f, int v)
{
    if (L.ss_phase != 1 || L.ss_cur_g < 0 || !vreg_slot_deferrable(f, v)) return;
    int *slot = &L.ss_op_cacheread[L.ss_cur_g * 2];
    if (slot[0] == v || slot[1] == v) return;       /* dedup */
    if (slot[0] < 0) { slot[0] = v; return; }
    if (slot[1] < 0) { slot[1] = v; return; }
    L.ss_pinned = 1;          /* >2 cache-served vregs in one op — bail safely */
}
/* Pass-2: is the store at the current op dead (slot never reloaded before
   the next store)? */
static int ss_store_dead_here(void)
{
    return L.ss_phase == 2 && L.ss_cur_g >= 0 && L.ss_store_dead
        && L.ss_store_dead[L.ss_cur_g];
}

/* Set the GEN (reload) bits for op (b,j) into `work`: every deferrable source
   is a reload UNLESS pass 1 proved it cache-served (op_cacheread), plus the
   explicit slot reloads. An unrecorded cache-hit just leaves the vreg in GEN
   (store kept). */
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

/* Backward slot-liveness over the CFG. Returns a [total_ops] array:
   dead[g]==1 iff the spill store at op g writes a slot no reload reads before
   the next store — so the store is dead and the value reaches readers in HL.
   Per op the store KILLs its vreg and the GEN set (ss_gen_op) re-adds
   reloaded vregs; dead iff not slot-live immediately after. Caller frees. */
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
            /* All successors incl. IR_SWITCH targets + default — NOT the raw
               succ[0..1] pair (omitting them would make a default-arm-only
               read look slot-dead and elide its store). */
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

/* Skip store_hl + trailing swap-back `ex de,hl` when dst is dead. Used by the
   binop/LD_IMM pattern `<value in HL>; store_hl; ex de,hl; cache_hl` — on
   dead-dst emit nothing (HL already holds the value). Also fires for
   register-pool vregs: nothing to spill. */
static void spill_and_swap_unless_dead(FILE *out, const Func *f, int vreg)
{
    if (L.la.cur_dst_dead) return;
    /* Pooled vreg: no slot. PR_HL is the caller's job (cache_hl tops it up).
       PR_BC needs an HL→BC copy so later loads hit the BC short-circuit;
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
        /* Dead spill: skip store AND swap-back — HL holds the value, caller's
           cache_hl(dst) advertises it, reaches readers via the HL carry. */
        return;
    }
    /* Word DE-home resident (fp): store HL straight to slot with NO `ex de,hl`
       staging — preserves DE (the running sum) so the spill is DE-clean and
       the home stays resident across the body. sp-mode needs HL for the slot
       address, so it falls through to store_hl. */
    if (L.cur_home_is_word && byte_home_holds(L.cur_func_whome) && fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            emit(out, "ld\t(%s%+d),hl", frame_reg(), ix_off);
            return;
        }
    }
    store_hl(out, f, vreg);
    /* store_hl leaves DE=value, HL=dead slot address; recover HL=value. Only
       gbz80 emulates `ex de,hl` — there a one-way DE->HL copy is equivalent
       (old HL dead) and far cheaper (2 ops vs push/pop x4). */
    if (!IS_GBZ80()) {
        emit(out, "ex\tde,hl");
    } else {
        emit(out, "ld\th,d");
        emit(out, "ld\tl,e");
    }
    invalidate_de_cache();
}

/* Word result is in HL: spill-and-swap to v's slot unless dead, then advertise
   HL = v. */
static void commit_hl_word(FILE *out, const Func *f, int v)
{
    spill_and_swap_unless_dead(out, f, v);
    cache_hl(v);
}

/* Word result is in HL, dst v is a PR_DE-pool vreg: swap into DE and advertise
   DE = v. Raw ex de,hl — only reached on EX_DE_HL paths. */
static void commit_hl_to_de(FILE *out, int v)
{
    emit(out, "ex\tde,hl");
    invalidate_hl_cache();
    cache_de(v);
}

/* Commit a word result in HL to dst v: into the DE home if v is a PR_DE-pool
   vreg, else spill-and-swap + cache HL. */
static void commit_hl_result(FILE *out, const Func *f, int v)
{
    if (vreg_is_pr_de(f, v)) commit_hl_to_de(out, v);
    else                     commit_hl_word(out, f, v);
}

/* DE-staged spill: value is already in DE — write it to vreg's slot and leave
   HL holding it (via ex de,hl). Used by the IR_LD_IMM `ld de,K` fastpath:
   staging in DE up front skips store_hl's initial `ex de,hl`, saving 1B/4T vs
   `ld hl,K + store_hl + ex de,hl`. */
static void spill_de_unless_dead(FILE *out, const Func *f, int vreg)
{
    if (L.la.cur_dst_dead || vreg_in_register_pool(f, vreg)) {
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
    int off = slot_off(f, vreg) + L.cur_sp_adjust;
    /* Deepest slot at TOS: discard the old word (inc sp x2), push from DE,
       then ex de,hl for the HL=value contract. 4 ops vs the 6-op byte walk,
       no address compute. */
    if (fp_tos_slot(f, vreg)
        || (off == 0 && !fp_active(f) && tos_pushpop_ok(f))) {
        emit(out, "inc\tsp");
        emit(out, "inc\tsp");
        emit(out, "push\tde");
        emit(out, "ex\tde,hl");
        invalidate_de_cache();
        return;
    }
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e");
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),d");
    emit(out, "ex\tde,hl");
    invalidate_de_cache();
}

/* Emit a forward conditional skip over the next `skip_bytes` of code via
   an ASMPC-relative jump. `jr` is 2 bytes; on 8080/8085 (no relative jump)
   z80asm rewrites `jr` to a 3-byte `jp`, so the relative target needs one
   extra byte. We emit `jp` explicitly there with the adjusted offset.
   (A label would be cleaner but disturbs the copt peephole patterns that
   match these ASMPC skips.) */
static void emit_skip(FILE *out, const Func *f, const char *cc, int skip_bytes)
{
    (void)f;
    if (!IS_808x())
        emit(out, "jr\t%s,ASMPC+%d", cc, 2 + skip_bytes);
    else
        emit(out, "jp\t%s,ASMPC+%d", cc, 3 + skip_bytes);
}

/* Materialise carry flag to HL = 0 or 1. hl_one_when_carry chooses whether
   HL=1 means carry-set or carry-clear. */
static void carry_to_bool(FILE *out, const Func *f, int hl_one_when_carry)
{
    emit(out, "ld\thl,0");
    emit_skip(out, f, hl_one_when_carry ? "nc" : "c", 1);
    emit(out, "inc\tl");
}

/* After `sbc hl,de` for a signed compare: bit 7 of H plus the V flag encode
   the signed-ordered result. Rotate the correct sign bit into CF for
   carry_to_bool. PO (no overflow) → sign of H is correct; PE (overflow) →
   inverted, so XOR 0x80. Then RLA moves bit 7 into CF. */
static void signed_result_to_carry(FILE *out)
{
    int n = L.cmp_label_counter++;
    emit(out, "ld\ta,h");
    emit(out, "jp\tpo,L_f%d_cmp_ok_%d", L.func_emit_idx, n);
    emit(out, "xor\t0x80");
    fprintf(out, "L_f%d_cmp_ok_%d:\n", L.func_emit_idx, n);
    emit(out, "rla");           /* CF = bit 7 of A (correct sign bit) */
    /* CF=1 means src0-src1 < 0 (signed) → src0 < src1. */
}

/* gbz80/808x lack a usable overflow flag, so the S^V correction can't run.
   Flip both operands' sign bits first: the unsigned borrow of (a^0x8000) vs
   (b^0x8000) equals signed a<b. Emits before `sbc hl,de`; returns 1 when it
   flipped (caller skips signed_result_to_carry). Clobbers A and D. */
static int signed_cmp_signflip(FILE *out, const Func *f, int is_signed)
{
    if (!is_signed || (!(IS_808x() || IS_GBZ80()))) return 0;
    emit(out, "ld\ta,h"); emit(out, "xor\t0x80"); emit(out, "ld\th,a");
    emit(out, "ld\ta,d"); emit(out, "xor\t0x80"); emit(out, "ld\td,a");
    invalidate_de_cache();
    return 1;
}

