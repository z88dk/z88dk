/* ir_lower_regcache.inc.c — part of ir_lower.c, #included (single TU). Do not compile standalone. */
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
    require_slot(f, vreg_id);
    int off = slot_off(f, vreg_id) + L.cur_sp_adjust + sp_adj;
    /* kc160 native ld bc,(sp+d): BC=value, HL untouched (no invalidate). */
    if (IS_KC160() && off >= 0 && off <= sp_rel_max(f)) {
        emit(out, "ld\tbc,(sp+%d)", off);
        cache_bc(vreg_id);
        return;
    }
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    if (IS_EZ80()) {
        emit(out, "ld\tbc,(hl)");   /* ez80: BC = *HL (HL preserved) */
    } else {
        load_byte_adv(out, "c", 0);
        load_byte_adv(out, "b", 1);
    }
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

/* Max positive sp displacement for `ld r,(sp+d)` on this target, or -1
   if the target has no sp-relative pair access. Rabbit's N is an
   unsigned byte (0..255); kc160's d is a signed byte (0..127). */
static int sp_rel_max(const Func *f)
{
    (void)f;
    if (!(IS_RABBIT() || IS_KC160())) return -1;
    return (IS_RABBIT()) ? 255 : 127;
}

/* Number of `add sp,d` ops (each d in [-128,127]) to move sp by delta. */
static int sp_add_chunks(int delta)
{
    int n = 0, rem = delta;
    while (rem) { int s = rem < 0 ? (rem < -128 ? -128 : rem)
                                  : (rem > 127 ? 127 : rem);
                  rem -= s; n++; }
    return n;
}

/* Emit a chain of `add sp,d` totalling delta (preserves all registers). */
static void emit_add_sp_chain(FILE *out, int delta)
{
    int rem = delta;
    while (rem) { int s = rem < 0 ? (rem < -128 ? -128 : rem)
                                  : (rem > 127 ? 127 : rem);
                  emit(out, "add\tsp,%d", s); rem -= s; }
}

/* True when a chained `add sp,delta` is available and no larger than the
   ld hl,delta / add hl,sp / ld sp,hl fallback (5 bytes) plus hl_extra
   bytes the caller spends preserving HL around that fallback. The chain
   also preserves all registers, so the caller can drop the preservation. */
static int use_add_sp(const Func *f, int delta, int hl_extra)
{
    (void)f;
    return (IS_RABBIT() || IS_GBZ80())
        && delta != 0
        && sp_add_chunks(delta) * 2 <= 5 + hl_extra;
}

/* Load a vreg's frame-slot value into HL with optional sp adjustment,
   zero-extending byte-width vregs to 16 bits. `sp_adj` compensates for
   pushes that shifted sp since the canonical slot offsets were set;
   pass 0 if sp is at its frame-entry position. */
/* The sp+0 push/pop slot trick wins only where a slot access otherwise
   needs the `ld hl,N; add hl,sp` byte-walk (z80/z180/ez80/808x — no cheap
   sp-relative addressing). CPUs that DO have it — gbz80 (`ld hl,sp+d`),
   rabbit/kc160 (`ld hl,(sp+N)`) — also have dearer push/pop, so the trick
   regresses speed there; keep them on their native byte-walk. */
int tos_pushpop_ok(const Func *f)
{
    (void)f;
    return !(IS_RABBIT() || IS_GBZ80() || IS_KC160());
}

/* True when even in fp-mode the pop/push trick beats the IX access for
   the DEEPEST local (slot_off==0). With cur_sp_adjust==0, SP == body base
   == ix-frame_size == that slot's address, so `pop hl;push hl` reads it.
   On z80/z180/z80n `ld rr,(ix+d)` is synthetic (two ld r,(ix+d) = 6B/38t)
   so pop/push (2B/21t) wins; ez80/kc160 have native indexed word loads into
   any pair (incl. ld de/bc,(ix+d)) that are cheaper, so leave them on the IX
   path. (Rabbit has only `ld hl,(ix+d)` — de/bc stay synthetic — so it does
   NOT qualify; tos_pushpop_ok already excludes it regardless.) */
static int fp_tos_slot(const Func *f, int vreg_id)
{
    return fp_active(f) && tos_pushpop_ok(f)
        && !(IS_EZ80() || IS_KC160())
        && L.cur_sp_adjust == 0
        && slot_off(f, vreg_id) == 0;
}

/* Word DE-home: when this function has a width-2 loop-carried accumulator
   homed in the DE pair (allocator's f->word_home_vreg, --word-resident), the
   shared home-residency machinery (cur_byte_home_vreg/_dirty, bb_byte_out,
   cur_func_ehome, the region span, the BB-loop carry/flush) is reused with
   cur_home_is_word=1 and cur_func_whome set to that vreg. A byte E/D-home and
   a word DE-home never coexist (the allocator gives up the word home when a
   byte E/D-home already claimed DE's low half), so the state is shared, not
   duplicated. The width-specific leaf ops (flush/rehome = 2 bytes, the
   accumulate, the DE→HL read) dispatch on cur_home_is_word. */

static void load_to_hl_adj(FILE *out, const Func *f, int vreg_id, int sp_adj)
{
    /* HL cache hit: HL already holds the wanted vreg. No-op. Most
       callers guard with `if (!hl_has(...))` themselves, but a few
       (e.g. IR_ST_MEM's MEM_VREG path for width-2 stores) call us
       unconditionally — and for PR_HL vregs (cacheable, no slot
       allocated), the slot read at the bottom would land at sp-1
       (slot_off returns -1) and read garbage below the frame, so
       return early when the value is already cached in HL. */
    if (hl_has(vreg_id) && sp_adj == 0) { ss_note_cache_read(f, vreg_id); return; }
    /* Every path below clobbers HL (with vreg_id, or with a slot
       address). If a width-2 spill is pending in HL, flush/discard it
       here, while HL still holds it. Dormant
       until the deferral step sets pending_spill_v. */
    pending_spill_resolve();
    /* Word DE-home resident: the running sum lives in DE — copy it to HL with
       `ld l,e; ld h,d`, leaving DE = home intact (a read never evicts the
       home). Serves accumulate addends, returns, and any other use. */
    if (L.cur_home_is_word && vreg_id == L.cur_func_whome && vreg_id >= 0
        && byte_home_holds(vreg_id) && f->vregs[vreg_id].width == 2
        && sp_adj == 0) {
        ss_note_cache_read(f, vreg_id);
        emit(out, "ld\tl,e");
        emit(out, "ld\th,d");
        hl_about_to_change(vreg_id);   /* HL = home copy; DE still = home */
        return;
    }
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
    /* idx2 resident in the spare index register: `push <idx>;pop hl`. */
    if (vreg_in_idx2(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit(out, "push\t%s", idx2_reg_name(f));
        emit(out, "pop\thl");
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
    require_slot(f, vreg_id);
    int off = slot_off(f, vreg_id) + sp_adj + L.cur_sp_adjust;
    /* FP-relative fast path. IX captures sp at function entry, so its
       offset to any slot is invariant under push/pop activity — sp_adj
       is irrelevant for IX addressing. */
    if (fp_active(f)) {
        /* Deepest slot, no pushes outstanding: pop/push reads it from SP
           cheaper than the synthetic ld hl,(ix+d). By-coincidence only —
           we don't reorder slots to land a hot var here. Gated on sp_adj==0:
           the pop/push is sp-relative, so an outstanding caller push (sp_adj>0)
           means the slot moved to sp+sp_adj — use IX addressing instead. */
        if (sp_adj == 0 && width == 2 && fp_tos_slot(f, vreg_id)) {
            emit(out, "pop\thl");
            emit(out, "push\thl");
            hl_about_to_change(vreg_id);
            return;
        }
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
    /* Top-of-stack fast path: a slot at sp+0 is read whole with
       `pop hl; push hl` — no address compute, no byte walk (2 ops vs
       ~6). SP/memory round-trip unchanged. sp-mode only (fp uses ix,
       handled above and returned). */
    if (width == 2 && off == 0 && !fp_active(f) && tos_pushpop_ok(f)) {
        emit(out, "pop\thl");
        emit(out, "push\thl");
        hl_about_to_change(vreg_id);
        return;
    }
    if (width == 1) {
        /* Reuse a cached slot address (e.g. crc<<1 then widen) instead of
           recomputing; sp_adj must be 0 — the byte helpers cache at the
           canonical sp (pending already resolved above). */
        if (sp_adj == 0) {
            emit_byte_slot_addr(out, f, vreg_id);
        } else {
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
        }
        emit(out, "ld\tl,(hl)");       /* read the byte straight into L … */
        emit(out, "ld\th,0");          /* … zero-extend; no detour through A */
        hl_about_to_change(vreg_id);   /* HL now holds the value, not the addr */
        return;
    }
    /* Rabbit/kc160 native sp-relative load: one ld hl,(sp+N) vs the
       add-hl-sp + byte ops below. Range-limited per target; also avoids
       the A-clobber the byte path has. */
    if (off >= 0 && off <= sp_rel_max(f)) {
        emit(out, "ld\thl,(sp+%d)", off);
        hl_about_to_change(vreg_id);
        return;
    }
    /* 8085: LDSI + LHLX. `ld de,sp+N` points DE at the slot, LHLX loads
       the word. LHLX needs the address in DE, but load_to_hl MUST
       preserve DE — load_binop_operands caches src1 there before loading
       src0 here, and several store/spill paths leave a live value in DE
       uncached for the contract's swap-back, so no cache-based dead-DE
       test is sound (clobbering it miscompiles; a true register-liveness
       pass would be needed). Park DE on the stack across the load:
       5 bytes/42 cyc vs the 8-byte/44-cyc add-hl-sp byte walk, no
       A-clobber — a strict win even with the push/pop. The balanced
       push/pop runs with nothing between, so cur_sp_adjust is untouched;
       just shift the slot offset +2 for the in-flight push. */
    if ((IS_8085()) && off >= 0 && off + 2 <= 255) {
        emit(out, "push\tde");
        emit(out, "ld\tde,sp+%d", off + 2);
        emit(out, "ld\thl,(de)");
        emit(out, "pop\tde");
        hl_about_to_change(vreg_id);
        return;
    }
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\ta,(hl+)");
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
   load via HL then ex de,hl. After: rs.de = vreg_id; HL
   holds whatever DE was (junk to the caller). */
static void load_to_de(FILE *out, const Func *f, int vreg_id)
{
    if (L.rs.de == vreg_id && vreg_id >= 0) {
        ss_note_cache_read(f, vreg_id);
        return;
    }
    /* idx2 resident: the loop-invariant lives in the spare index register.
       `push <idx>;pop de` recovers it (HL untouched) — cheaper than the
       per-iteration slot reload. */
    if (vreg_in_idx2(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit(out, "push\t%s", idx2_reg_name(f));
        emit(out, "pop\tde");
        cache_de(vreg_id);
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
    /* Only when the vreg actually has a spill slot — a register-only vreg
       (e.g. a compare result cached in HL with no slot) has
       vreg_spill_slot == -1, and slot_ix_off would then synthesise a bogus
       below-frame offset (`ld de,(ix-9)`). It must fall through to the
       HL/cache paths below. Also skip when the value is already live in HL:
       the ex de,hl path below is a register move, cheaper than the 6-byte
       (ix±d) slot read — HL-preservation is moot when HL holds this vreg. */
    if (fp_active(f) && f->vregs[vreg_id].width == 2
        && L.rs.hl != vreg_id
        && f->vreg_spill_slot && f->vreg_spill_slot[vreg_id] >= 0) {
        /* Deepest slot at TOS: pop de;push de beats synthetic ld de,(ix+d)
           and likewise preserves HL. By-coincidence only. */
        if (fp_tos_slot(f, vreg_id)) {
            ss_note_reload(f, vreg_id);
            emit(out, "pop\tde");
            emit(out, "push\tde");
            cache_de(vreg_id);
            return;
        }
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            ss_note_reload(f, vreg_id);
            emit(out, "ld\tde,(%s%+d)", frame_reg(), ix_off);
            cache_de(vreg_id);
            return;
        }
    }
    if (L.rs.hl == vreg_id && vreg_id >= 0) {
        /* Served from HL (no slot read) — record the cache hit. */
        ss_note_cache_read(f, vreg_id);
        /* The wanted value is in HL. If it is the pending spill (I1:
           pending_spill_v == rs.hl == vreg_id), flushing it writes
           the slot AND leaves it in DE (store_hl's internal `ex de,hl`)
           — the swap's exact result — so resolve instead of swapping.
           Dormant until the deferral step. */
        if (L.lazy_spill_on && L.pending_spill_v == vreg_id) {
            pending_spill_flush();   /* DE := vreg_id, slot written */
            cache_de(vreg_id);
            return;
        }
        emit(out, "ex\tde,hl");
        /* HL ↔ DE swap: caches swap too. cur_hl now has what DE held
           (the old rs.de or -1); cur_de gets what HL held. */
        swap_hl_de_caches();
        return;
    }
    /* sp-rel direct-to-DE byte walk for width=2. Writes E,D directly
       through (hl) without the trailing `ld l,a` that load_to_hl
       needs to assemble HL from a temp byte. Saves 1 byte vs
       load_to_hl + ex de,hl. HL is clobbered (same as the ex de,hl
       form when DE held junk — common). */
    if (f->vregs[vreg_id].width == 2) {
        int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
        /* kc160 native ld de,(sp+d): DE=value, HL untouched — better
           than the byte walk, and leaves a pending HL spill intact. */
        if (IS_KC160()
            && off >= 0 && off <= sp_rel_max(f)) {
            ss_note_reload(f, vreg_id);
            emit(out, "ld\tde,(sp+%d)", off);
            cache_de(vreg_id);
            return;
        }
        /* Rabbit HL-only: ld hl,(sp+N); ex de,hl. Clobbers HL (same as
           the byte walk), so flush a pending spill first. */
        if ((IS_RABBIT() || IS_KC160())
            && off >= 0 && off <= sp_rel_max(f)) {
            pending_spill_resolve();
            ss_note_reload(f, vreg_id);
            emit(out, "ld\thl,(sp+%d)", off);
            emit(out, "ex\tde,hl");
            hl_about_to_change(-1);
            cache_de(vreg_id);
            return;
        }
        /* Top-of-stack: `pop de; push de` reads the whole word and
           leaves HL (and any pending spill) intact — better than the
           byte walk, which clobbers HL. sp-mode only. */
        if (off == 0 && !fp_active(f) && tos_pushpop_ok(f)) {
            ss_note_reload(f, vreg_id);
            emit(out, "pop\tde");
            emit(out, "push\tde");
            cache_de(vreg_id);
            return;
        }
        /* 8085: LDSI + LHLX. `ld de,sp+N` points DE at the slot, LHLX
           loads the word into HL, ex de,hl lands it in DE. 4 bytes vs
           the 7-byte byte walk; like it, clobbers HL. */
        if ((IS_8085()) && off >= 0 && off <= 255) {
            pending_spill_resolve();
            ss_note_reload(f, vreg_id);
            emit(out, "ld\tde,sp+%d", off);
            emit(out, "ld\thl,(de)");
            emit(out, "ex\tde,hl");
            hl_about_to_change(-1);
            cache_de(vreg_id);
            return;
        }
        /* sp-rel byte walk clobbers HL with the slot address — flush a
           pending spill first (here vreg_id != pending_spill_v; the
           equal case was handled by the swap path above). Dormant. */
        pending_spill_resolve();
        ss_note_reload(f, vreg_id);
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        if (IS_EZ80()) {
            emit(out, "ld\tde,(hl)");   /* ez80: DE = *HL (HL preserved) */
        } else {
            load_byte_adv(out, "e", 0);
            load_byte_adv(out, "d", 1);
        }
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
    if (L.rs.de == vreg_id && vreg_id >= 0) return;
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
    /* kc160 native ld de,(sp+d) preserves HL on its own — no push/pop. */
    if (IS_KC160() && f->vregs[vreg_id].width == 2) {
        int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
        if (off >= 0 && off <= sp_rel_max(f)) {
            ss_note_reload(f, vreg_id);
            emit(out, "ld\tde,(sp+%d)", off);
            cache_de(vreg_id);
            return;
        }
    }
    /* Rabbit: park HL in DE across the load — ex de,hl; ld hl,(sp+d);
       ex de,hl. DE ends with the value, HL restored, no stack touch. */
    if ((IS_RABBIT() || IS_KC160()) && f->vregs[vreg_id].width == 2) {
        int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
        if (off >= 0 && off <= sp_rel_max(f)) {
            ss_note_reload(f, vreg_id);
            emit(out, "ex\tde,hl");
            emit(out, "ld\thl,(sp+%d)", off);
            emit(out, "ex\tde,hl");
            cache_de(vreg_id);
            return;
        }
    }
    emit(out, "push\thl");
    L.cur_sp_adjust += 2;
    load_to_de(out, f, vreg_id);
    L.cur_sp_adjust -= 2;
    emit(out, "pop\thl");
    /* HL is restored to its prior value — cache stands. */
}

/* Store HL to a vreg's frame slot. */
static void store_hl(FILE *out, const Func *f, int vreg_id)
{
    if (fp_active(f)) {
        /* Deepest slot at TOS: discard the word (inc sp x2) and push the
           value — cheaper than synthetic ld (ix+d),hl, same contract
           (DE=value, HL=junk after). By-coincidence only. */
        if (fp_tos_slot(f, vreg_id)) {
            emit(out, "ex\tde,hl");
            emit(out, "inc\tsp");
            emit(out, "inc\tsp");
            emit(out, "push\tde");
            return;
        }
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
    int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
    /* Rabbit/kc160 native sp-relative store: ld (sp+N),hl then the
       contract ex de,hl (DE=value, HL=junk) — mirrors the fp path. */
    if (off >= 0 && off <= sp_rel_max(f)) {
        emit(out, "ld\t(sp+%d),hl", off);
        emit(out, "ex\tde,hl");
        return;
    }
    /* Top-of-stack: discard the slot word (inc sp x2) and push the
       value. Honors the contract (DE=value, HL=junk after) and is
       clobber-free. sp-mode only, 4 ops vs the 6-op byte walk. */
    if (off == 0 && !fp_active(f) && tos_pushpop_ok(f)) {
        emit(out, "ex\tde,hl");        /* DE = value */
        emit(out, "inc\tsp");
        emit(out, "inc\tsp");
        emit(out, "push\tde");
        return;
    }
    /* 8085: LDSI + SHLX. `ld de,sp+N` points DE at the slot (1 op, no
       add-hl-sp), SHLX stores HL through it; the trailing ex de,hl
       restores the store_hl contract (DE=value, HL=junk). 4 bytes vs
       the 6-byte byte walk. Clobbering DE is consistent — the byte
       walk's leading `ex de,hl` destroys the prior DE too. */
    if ((IS_8085()) && off >= 0 && off <= 255) {
        emit(out, "ld\tde,sp+%d", off);
        emit(out, "ld\t(de),hl");
        emit(out, "ex\tde,hl");
        return;
    }
    emit(out, "ex\tde,hl");        /* DE = value */
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e");
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),d");
}

/* Byte-home residency state. Defined here (ahead of the byte
   load/store emitters that read them); the comment block + helper functions
   live further down with the rest of the cache helpers. */
/* Home-resident loop: the bb-id span [lo,hi] of a loop the slot-backed E/D
   home stays register-resident across — proven (compute_home_region) so that
   every body op preserves E and the home is live-in at the header. Within it
   the per-iteration spill is suppressed and residency is ASSERTED at the
   header (the single forward pass can't carry E in from the unlowered
   back-edge). -1 = no such loop in this function. */
/* Word DE-home only: the id of a dedicated loop-exit block (reached ONLY from
   the resident region) at whose entry the home is flushed ONCE — hoisting the
   flush off the per-iteration header path. -1 = not applicable (multi-target
   exit, non-fp, or a slot too far for ix-relative store) → fall back to the
   per-iter header flush. */

/* Load 8-bit value from a vreg's frame slot into A. Cache-aware:
   if A already holds the wanted vreg (set by a prior IR_LD_MEM_VREG
   width=1 dead-skip or similar), skip the slot read entirely. */
static void load_byte_to_a(FILE *out, const Func *f, int vreg_id)
{
    if (a_has(vreg_id)) return;
    /* Byte home (PR_C/E/D/B): when the register currently holds this vreg,
       read it directly (C-home: always; E/D-home: when not clobbered). */
    PhysReg bh = byte_home_phys(f, vreg_id);
    if (bh != IR_PR_NONE && byte_home_holds(vreg_id)) {
        emit(out, "ld\ta,%s", byte_home_reg(bh));
        cache_a(vreg_id);
        return;
    }
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
    /* The sp-rel slot read clobbers HL with the slot address. Reuse the
       cached slot address (exact or within 2 bytes via inc/dec hl —
       same or adjacent byte slots) instead of
       recomputing; pending spill resolved here for the cold path.
       emit_byte_slot_addr advertises the address for the next access.
       NOTE: a slot-backed home is NOT re-homed into E on a read — the home
       register is (re)established only by a WRITE (store_a_byte). Re-homing
       on a read would put the value in E during a DE-clobbering op that
       reads it (e.g. `a + *p` promoted to an int `add hl,de`), where the op
       then corrupts E. */
    pending_spill_resolve();
    emit_byte_slot_addr(out, f, vreg_id);
    emit(out, "ld\ta,(hl)");
}

/* Store A to a vreg's 8-bit frame slot. Clobbers HL+E. */
static void store_a_byte(FILE *out, const Func *f, int vreg_id)
{
    /* Byte home: keep the value in the home register, elide the slot store.
       - C/B (slotless): the no-call/BC-clean envelope never clobbers the
         register, so the value rides it for the whole function; reads
         funnel through load_byte_to_a (home-aware), the slot is never used.
       - E/D (slot-backed): mark DIRTY — the value is in the register only;
         it gets spilled to the slot before a DE-clobbering op or at a BB
         end (byte_home_flush). */
    PhysReg bh = byte_home_phys(f, vreg_id);
    if (bh != IR_PR_NONE) {
        emit(out, "ld\t%s,a", byte_home_reg(bh));
        byte_home_note(vreg_id);
        if (byte_home_slotbacked(bh)) L.cur_byte_home_dirty = 1;
        cache_a(vreg_id);   /* A still holds the value — next read elides */
        return;
    }
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off)) {
            emit(out, "ld\t(%s%+d),a", frame_reg(), ix_off);
            return;
        }
    }
    /* Address cache live ⇒ no pending spill (a cached address implies
       rs.hl==-1), and inc/dec hl / ld+add all preserve A — so store
       A directly via emit_byte_slot_addr (exact/near/recompute), no E-stash. */
    if (L.cur_hl_addr_off >= 0 && L.cur_hl_addr_spadj == L.cur_sp_adjust) {
        emit_byte_slot_addr(out, f, vreg_id);
        emit(out, "ld\t(hl),a");
        return;
    }
    /* No address cache: flush any pending spill (while HL still holds it),
       then materialize the slot address. `ld hl,off; add hl,sp` and the
       flush both leave A untouched, so store A directly — no E-stash. */
    pending_spill_resolve();
    int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),a");
    /* HL clobbered with the slot address — drop stale cache claims (a
       caller may have cached the deref base in HL), then advertise HL as
       this slot's address for the next same-slot access. */
    invalidate_hl_cache();
    cache_hl_slot_addr(f, vreg_id);
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
    int off = slot_off(f, v) + L.cur_sp_adjust;
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
        emit(out, "ld\ta,(hl+)");        /* A = byte 2 */
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
    int off = slot_off(f, v) + L.cur_sp_adjust;
    switch (byte_shift) {
    case 1:
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\ta,(hl+)");        /* A = byte 0 */
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
    int no_hl = L.la.cur_load_to_dehl_no_hl;
    L.la.cur_load_to_dehl_no_hl = 0;
    /* Capture + reset the no-BC-stash request up front: every early return
       below (incl. the cache-hit) must consume it, else it leaks into the
       NEXT load_to_dehl and wrongly suppresses that load's BC stash. */
    int no_bc = L.la.cur_load_to_dehl_no_bc;
    L.la.cur_load_to_dehl_no_bc = 0;
    /* The long-load emits below (`ld hl,bc` cache recover, `ld hl,(ix)`,
       the sp-rel slot walk) all clobber HL. Flush a pending width-2
       spill first (dormant for now). The
       no-emit returns are safe: the no_hl cache-hit means the caller
       overwrites HL itself, and the rs.hl==vreg_id hit can't
       coincide with a width-2 pending (different widths). */
    pending_spill_resolve();
    if (dehl_has(vreg_id)) {
        /* Cache hit: DE still has high half, BC has low half. Recover
           HL with 2 instructions (~12 T-states) vs ~120 for a full
           slot read. sp_adj is irrelevant — data is in registers.
           Skip the recovery when no_hl flag is set (caller is about
           to overwrite HL) OR when rs.hl == vreg_id (HL already
           holds the low half from a previous cache_dehl_no_spill that
           preserved HL). */
        if (!no_hl && L.rs.hl != vreg_id) {
            emit(out, "ld\thl,bc");
        }
        if (!no_hl) hl_about_to_change(vreg_id);
        return;
    }
    /* FP-relative long load. sp_adj is irrelevant for the IX-addressed
       path below (fixed frame base), but NOT for the TOS pop/push trick,
       which is sp-relative: when the caller has pushed since the slot was
       canonical (sp_adj>0 — e.g. the long compare stages src1 on the stack
       before loading src0), the slot is now at sp+sp_adj, not sp+0, so the
       trick would pop the just-pushed value. Fall through to IX addressing
       there. */
    if (fp_active(f)) {
        /* Deepest slot at TOS: pop hl;pop de beats the synthetic long
           ld (4x ld r,(ix+d) = 12B/76t vs 6B/50t). By-coincidence only. */
        if (sp_adj == 0 && fp_tos_slot(f, vreg_id)) {
            ss_note_reload(f, vreg_id);
            emit(out, "pop\thl");           /* HL = low half (bytes 0-1) */
            emit(out, "pop\tde");           /* DE = high half (bytes 2-3) */
            emit(out, "push\tde");
            emit(out, "push\thl");
            {
                int nb = no_bc;
                if (!nb)
                    emit(out, "ld\tbc,hl"); /* BC = low half (cache invariant) */
                hl_about_to_change(vreg_id);
                /* When the BC=low stash is skipped, BC does NOT back the DEHL
                   cache — so don't publish the (BC-implying) dehl claim, or a
                   later cache-hit `ld hl,bc` reads stale BC. */
                if (nb) L.rs.dehl = -1;
                else    cache_dehl(vreg_id);
            }
            return;
        }
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 3)) {
            ss_note_reload(f, vreg_id);   /* defensive: width-2 never here */
            emit(out, "ld\thl,(%s%+d)", frame_reg(), ix_off);
            emit(out, "ld\tde,(%s%+d)", frame_reg(), ix_off + 2);
            /* BC is untouched — set it to HL (low) so the DEHL cache
               invariant (BC = low half when rs.dehl is set) holds.
               Then publish the cache: subsequent load_to_dehl(v) hits
               and emits `ld hl,bc` with correct BC. Skip the stash
               when the caller signals it won't read BC — typically a
               byte-direct unary chain (IR_NOT/IR_NEG) that walks
               H/L/E/D through A. */
            {
                int nb = no_bc;
                if (!nb)
                    emit(out, "ld\tbc,hl");
                /* HL really does hold the low half here — advertise it
                   so downstream byte-direct chains can read from L/H
                   directly instead of going through BC. */
                hl_about_to_change(vreg_id);
                /* BC=low stash skipped ⇒ don't assert the BC-backed dehl
                   claim (a later cache-hit would `ld hl,bc` stale BC). */
                if (nb) L.rs.dehl = -1;
                else    cache_dehl(vreg_id);
            }
            return;
        }
    }
    ss_note_reload(f, vreg_id);       /* defensive: width-2 never here */
    require_slot(f, vreg_id);
    int off = slot_off(f, vreg_id) + sp_adj + L.cur_sp_adjust;
    /* Top-of-stack long load: a slot at sp+0 is read whole with
       `pop hl; pop de` (HL=low half, DE=high half) and the two pushes
       put it back — no address compute, no 4-byte walk. sp-mode +
       z80/z180/ez80/808x only (tos_pushpop_ok), off==0 ⇒ cur_sp_adjust
       also 0. */
    if (off == 0 && !fp_active(f) && tos_pushpop_ok(f)) {
        emit(out, "pop\thl");           /* HL = low half (bytes 0-1) */
        emit(out, "pop\tde");           /* DE = high half (bytes 2-3) */
        emit(out, "push\tde");
        emit(out, "push\thl");
        {
            int nb = no_bc;
            if (!nb)
                emit(out, "ld\tbc,hl"); /* BC = low half (cache invariant) */
            hl_about_to_change(vreg_id);
            /* BC=low stash skipped ⇒ don't assert the BC-backed dehl claim. */
            if (nb) L.rs.dehl = -1;
            else    cache_dehl(vreg_id);
        }
        return;
    }
    /* Rabbit/kc160 native sp-relative long load. DE=high half (native
       ld de,(sp+d) on kc160; ld hl,(sp+N+2)+ex de,hl on Rabbit), HL+BC
       =low half (BC keeps the dehl-cache invariant). Both halves in
       range (off+2). */
    if (off >= 0 && off + 2 <= sp_rel_max(f)) {
        if (IS_KC160()) {
            emit(out, "ld\tde,(sp+%d)", off + 2);
        } else {
            emit(out, "ld\thl,(sp+%d)", off + 2);
            emit(out, "ex\tde,hl");
        }
        emit(out, "ld\thl,(sp+%d)", off);
        emit(out, "ld\tbc,hl");
        /* HL now holds the low half — advertise it so rs.hl is
           honest (else a stale prior tenant leaks into bb_hl_out and a
           merge carry trusts HL holding the wrong vreg). */
        hl_about_to_change(vreg_id);
        cache_dehl(vreg_id);
        return;
    }
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    load_byte_adv(out, "c", 0);     /* C = byte 0 */
    load_byte_adv(out, "b", 0);     /* B = byte 1 — BC = low half */
    load_byte_adv(out, "e", 0);     /* E = byte 2 */
    load_byte_adv(out, "d", 1);     /* D = byte 3 — DE = high half */
    if (!no_hl) {
        emit(out, "ld\thl,bc");     /* HL = BC = low half */
    }
    /* Keep rs.hl honest: HL holds the low half (low-half tenant
       when !no_hl) or junk (no_hl). The fp / TOS / cache-hit paths above
       all do this via hl_about_to_change; the generic sp walk must too,
       else rs.hl stays stale at the previous tenant. A stale tenant
       would feed bb_hl_out and make an if/else (or ||/&&) merge
       carry trust HL holding a vreg it didn't — e.g. `return (long_v ||
       0)` returning 0 on the short-circuit edge (sp-mode only). */
    hl_about_to_change(no_hl ? -1 : vreg_id);
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
   `ld hl,K`). After: BC = low half, DE = high half, HL = junk. */

static void store_dehl(FILE *out, const Func *f, int vreg_id)
{
    /* FP-relative long store. Preserves HL+DE entirely — no BC stash
       needed. PR_BC vregs survive across long stores when FP is on. */
    if (fp_active(f)) {
        /* Deepest slot at TOS: discard the word (pop bc x2) and re-push
           DEHL — beats the synthetic long store (4x ld (ix+d),r). HL+DE
           kept, BC=low (contract). By-coincidence only. */
        if (fp_tos_slot(f, vreg_id)) {
            emit(out, "pop\tbc");
            emit(out, "pop\tbc");
            emit(out, "push\tde");
            emit(out, "push\thl");
            emit(out, "ld\tbc,hl");
            return;
        }
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 3)) {
            emit(out, "ld\t(%s%+d),hl", frame_reg(), ix_off);
            emit(out, "ld\t(%s%+d),de", frame_reg(), ix_off + 2);
            /* DEHL cache contract: BC = low half after store_dehl, so a
               later load_to_dehl_adj cache hit recovers HL via `ld hl,bc`.
               Dead when the next op clobbers BC before any such hit —
               store_dehl_cached then drops the cache claim so reads reload
               via (ix+d). */
            if (!L.la.cur_store_dehl_bc_dead)
                emit(out, "ld\tbc,hl");
            return;
        }
    }
    int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
    /* Top-of-stack long store: overwrite the sp+0 slot in place by
       discarding its 4 bytes (`pop bc; pop bc`, BC is clobbered by
       contract anyway) and re-pushing DEHL. No address compute, no
       4-byte walk, and HL stays valid (low half) afterwards — strictly
       better than the generic path that leaves HL junk. sp-mode +
       z80/z180/ez80/808x only; off==0 ⇒ cur_sp_adjust also 0. */
    if (off == 0 && !fp_active(f) && tos_pushpop_ok(f)) {
        emit(out, "pop\tbc");           /* drop old low half */
        emit(out, "pop\tbc");           /* drop old high half */
        emit(out, "push\tde");          /* write high half (bytes 2-3) */
        emit(out, "push\thl");          /* write low half (bytes 0-1) */
        emit(out, "ld\tbc,hl");         /* BC = low half (contract) */
        return;
    }
    /* Rabbit/kc160 native sp-relative long store: low half from HL, high
       half from DE (native ld (sp+d),de on kc160; ex-de-hl on Rabbit).
       Ends DE=high, BC=low (the contract). */
    if (off >= 0 && off + 2 <= sp_rel_max(f)) {
        emit(out, "ld\t(sp+%d),hl", off);
        emit(out, "ld\tbc,hl");
        if (IS_KC160()) {
            emit(out, "ld\t(sp+%d),de", off + 2);
        } else {
            emit(out, "ex\tde,hl");
            emit(out, "ld\t(sp+%d),hl", off + 2);
            emit(out, "ex\tde,hl");
        }
        return;
    }
    /* Stash low half (HL) into BC so HL is free for slot addressing.
       The store_dehl contract already declares BC clobbered, so this
       is the cheapest path (8 T-states for ld bc,hl versus 21
       for the equivalent push hl ... pop bc round trip). */
    emit(out, "ld\tbc,hl");          /* BC = low (B=hi byte, C=lo byte) */
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");         /* HL = &slot+0 */
    store_byte_adv(out, "c", 0);
    store_byte_adv(out, "b", 0);
    store_byte_adv(out, "e", 0);
    store_byte_adv(out, "d", 1);
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
   `ld l,c; ld h,b`. */
static void store_dehl_cached(FILE *out, const Func *f, int vreg_id)
{
    int bc_dead = L.la.cur_store_dehl_bc_dead;
    store_dehl(out, f, vreg_id);
    invalidate_hl_cache();
    if (bc_dead) {
        /* store_dehl skipped the `ld bc,hl`, so BC != low — don't claim a
           DEHL cache that a later hit would recover via `ld hl,bc`. The
           value is safely in the slot; reads reload via (ix+d). */
        L.rs.bc = -1;
        L.rs.dehl = -1;
    } else {
        cache_dehl(vreg_id);
    }
}

/* Forward decl: defined with the rest of the per-op lookahead state.
   Read by cache_dehl_no_spill (just below) to skip the BC stash when
   the next op is the FP byte-direct binop chain. */

/* Forward decl: same family. Read by load_to_dehl_adj's FP-mode path
   to skip the BC stash when the caller doesn't read BC — typically
   a byte-direct unary chain reading H/L/E/D through A. */

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
       directly (using the rs.hl advertise below). Skip the
       stash; chained byte-direct binops write BC themselves at
       the chain's tail, so subsequent ops still see BC = low. */
    if (!L.la.cur_dehl_dst_no_bc_stash)
        emit(out, "ld\tbc,hl");
    L.la.cur_dehl_dst_no_bc_stash = 0;
    /* HL still holds the long's low half (precondition of this
       function — caller's compute left HL = low). Advertise it via
       rs.hl so the next load_to_dehl on cache hit can skip
       its `ld hl,bc` recovery (saves 2 bytes per chained long-binop). */
    hl_about_to_change(vreg_id);
    L.rs.de = -1;
    L.rs.dehl = vreg_id;
}

/* Forward decl: cur_dehl_dst_dead_safe lives with the other lookahead
   flags further down. lower_func sets it before each op. */

/* Forward decl: defined with the other vreg_is_pr_* helpers below. */
static int vreg_is_pr_dehl(const Func *f, int v);

/* Dispatch wrapper for the 19+ "compute long; spill to dst's slot;
   publish cache" sites in lower_op. When the lookahead in lower_func
   has determined that the slot write would be dead (cur_dehl_dst_dead
   _safe), we emit the 2-instruction `ld b,h; ld c,l + cache` shape
   instead of the full 11-instruction store_dehl. */
/* Push a width-4 result (in DEHL) to the data stack instead of a frame
   slot. `ld bc,hl` stashes the low half so the pushed image is [low][high]
   (low on top) — identical to a normal stacked-arg push — and the DEHL
   cache invariant (BC=low) holds after cache_dehl. Records the pending
   push for the consumer (a long bitop's fused-(hl) path, or gen_hcall's
   stacked-arg skip). */
static void emit_dehl_stack_push(FILE *out, int vreg_id)
{
    emit(out, "ld\tbc,hl");
    emit(out, "push\tde");
    emit(out, "push\tbc");
    L.cur_sp_adjust += 4;
    L.la.cur_dehl_inline_push = vreg_id;
    L.la.cur_dehl_inline_push_base_sp = L.cur_sp_adjust;
    /* HL was consumed producing the value; any prior tenant claim is
       stale. Claim HL for OUR low half so the next op doesn't treat the
       value as an address. */
    invalidate_hl_cache();
    hl_about_to_change(vreg_id);
    cache_dehl(vreg_id);
}

static void store_dehl_finalize(FILE *out, const Func *f, int vreg_id)
{
    if (L.la.cur_dehl_dst_dead_safe || vreg_is_pr_dehl(f, vreg_id)) {
        cache_dehl_no_spill(out, vreg_id);
    } else if (L.la.cur_dehl_push_to_stack
               && L.la.cur_dehl_inline_push < 0
               && L.la.cur_stack_long_top < 0) {
        emit_dehl_stack_push(out, vreg_id);
    } else {
        store_dehl_cached(out, f, vreg_id);
    }
    L.la.cur_dehl_push_to_stack = 0;
}

/* Load 16-bit value from a raw sp-relative offset into HL.
   Used by the param-init prologue to read caller-pushed args from
   above the local frame. */
static void load_sp_off_to_hl(FILE *out, int sp_off)
{
    emit(out, "ld\thl,%d", sp_off);
    emit(out, "add\thl,sp");
    emit(out, "ld\ta,(hl+)");
    emit(out, "ld\th,(hl)");
    emit(out, "ld\tl,a");
}

/* ----- Op dispatch ------------------------------------------------------ */

/* Returns 1 if rs.hl matches `v` (and v >= 0). The caller uses
   this to skip a redundant load_to_hl. */
static int hl_has(int v)
{
    return v >= 0 && L.rs.hl == v;
}

static int de_has(int v)
{
    return v >= 0 && L.rs.de == v;
}

/* Any DE change invalidates the long-DEHL cache (DE holds the high
   half — clobbering it breaks the cache). */
static void cache_de(int v) { L.rs.de = v; L.rs.dehl = -1; }
static void invalidate_de_cache(void) { L.rs.de = -1; L.rs.dehl = -1; }

static int dehl_has(int v) { return v >= 0 && L.rs.dehl == v; }
static void cache_dehl(int v) { L.rs.dehl = v; }

/* BC cache. Function-lifetime: ir_alloc marks at most one PARAM as
   PR_BC and only in a narrow safety envelope (no CALL/HCALL, no
   width-4 vregs). Within that envelope BC is loaded by the prologue
   and never overwritten by body emits. load_to_hl / load_to_de
   short-circuit slot reads with `ld l,c; ld h,b` / `ld e,c; ld d,b`. */
static int bc_has(int v) { return v >= 0 && L.rs.bc == v; }
static void cache_bc(int v) { L.rs.bc = v; }
static void invalidate_bc_cache(void) { L.rs.bc = -1; }

/* Byte (A) value cache. Tracks which width-1 vreg the accumulator
   currently holds. Set by IR_LD_MEM_VREG width=1 when the byte spill
   is dead-skipped (the byte stays in A). Consumed by the CONV_ZX /
   CONV_SX / CONV_BYTE_TO_HIGH 1→2 lowerers — they skip the
   `load_byte_to_a` slot read when A already has src[0]. Heavily
   invalidated: every `ld a,*` clobbers it, every byte op clobbers it.
   Most lowerer paths conservatively invalidate via invalidate_hl_cache
   (which now also clears A). */
static int a_has(int v) { return v >= 0 && L.rs.a == v; }
static void cache_a(int v) { L.rs.a = v; }
static void invalidate_a_cache(void) { L.rs.a = -1; }

/* Byte-register residency. A width-1 vreg the allocator
   pinned to a byte register (PR_C in the no-call BC-clean envelope) keeps
   its value there across the loop. `cur_byte_home_vreg` is which home vreg
   currently lives in its register; the home is a READ-cache over a real
   backing slot that store_a_byte write-throughs to, so the slot is always
   coherent and the belief inherits the cache_a deadness contract (stale
   only for dead values). Belief persists across BBs — in this envelope the
   home register is never scratch, so it tracks the same updates as the
   slot. */
/* cur_byte_home_vreg / _dirty / bb_byte_out / cur_func_ehome are defined
   ahead of load_byte_to_a. Slot-backed homes (PR_E/PR_D — low/high of DE)
   are clobbered by DE-scratch ops, so the lowerer lazy-spills: a home write
   leaves the value in the register and marks dirty (slot stale); before any
   DE-clobbering op, and before back-edge/merge exits, the value is spilled
   E→slot so the slot is coherent at boundaries. bb_byte_out drives the
   cross-BB carry (mirror of bb_hl_out); cur_func_ehome is the function's
   E/D vreg. PR_C/PR_B stay slotless (never dirty). */
static PhysReg byte_home_phys(const Func *f, int v)
{
    if (v < 0 || !f || !f->vreg_to_phys) return IR_PR_NONE;
    PhysReg pr = f->vreg_to_phys[v];
    if (pr == IR_PR_C || pr == IR_PR_E || pr == IR_PR_D || pr == IR_PR_B)
        return pr;
    return IR_PR_NONE;
}
static int byte_home_slotbacked(PhysReg pr)   /* clobberable → lazy-spill */
{
    return pr == IR_PR_E || pr == IR_PR_D;
}
static const char *byte_home_reg(PhysReg pr)
{
    switch (pr) {
    case IR_PR_C: return "c";
    case IR_PR_E: return "e";
    case IR_PR_D: return "d";
    case IR_PR_B: return "b";
    default:      return NULL;
    }
}
static int  byte_home_holds(int v) { return v >= 0 && L.cur_byte_home_vreg == v; }
static void byte_home_note(int v)  { L.cur_byte_home_vreg = v; }
/* Is v homed in a clobberable slot-backed byte register (PR_E/PR_D)? */
static int byte_home_is_slotbacked(const Func *f, int v)
{
    return byte_home_slotbacked(byte_home_phys(f, v));
}

/* cur_branch_test_kind is fully defined below (tentative def — same object);
   declared here so cmp_bytewise_ok / op_de_clean can see it. */

/* A width-2 unsigned ordered compare lowered byte-wise (`ld a,c; sub mem; ld
   a,b; sbc a,mem`) instead of `load_binop_operands + sbc hl,de` — shorter AND
   DE/E-clean (so a slot-backed byte home survives the loop test, no spill).
   Eligible iff: ULT/UGE, branch-fused, LHS (src0) lives in BC, RHS (src1) in
   a frame slot (fp: ix-rel offset of both bytes must fit). Shared by gen_cmp
   (which emits it) and op_de_clean (which must agree so the home isn't
   needlessly flushed) — identical conditions ⇒ they never disagree. */
static int fp_active(const Func *f);
static int fp_offset_fits(int off);
static int slot_ix_off(const Func *f, int vreg_id);
/* The byte-wise compare's structural eligibility (everything except the
   runtime branch-fusion flag) — so the static home-region analysis can test
   it before lowering sets cur_branch_test_kind. */
static int cmp_bytewise_shape_ok(const Func *f, const Op *o)
{
    if (o->kind != IR_CMP_ULT && o->kind != IR_CMP_UGE) return 0;
    int s0 = o->src[0], s1 = o->src[1];
    if (s0 < 0 || s1 < 0 || s0 >= f->n_vregs || s1 >= f->n_vregs) return 0;
    if (f->vregs[s0].width != 2 || f->vregs[s1].width != 2) return 0;
    if (!f->vreg_to_phys) return 0;
    if (f->vreg_to_phys[s0] != IR_PR_BC) return 0;     /* LHS in BC */
    if (f->vreg_to_phys[s1] != IR_PR_SPILL) return 0;  /* RHS in a slot */
    if (f->vregs[s1].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (fp_active(f)) {
        int ix = slot_ix_off(f, s1);
        if (!fp_offset_fits(ix) || !fp_offset_fits(ix + 1)) return 0;
    }
    return 1;
}

/* Word DE-home DE-clean SIGNED loop test: `i < n` / `i >= n` lowered as
   `<load n→HL>; ld a,(ix+i_lo); sub l; ld a,(ix+i_hi); sbc a,h` + the S^V
   sign correction — A/HL only, so the home in DE survives the test (the loop's
   only DE-clobber for the index_walk shape). Eligible iff: fp-mode, signed
   ordered (LT/GE), LHS (i) in an ix-addressable slot, RHS (n) any width-2 vreg
   loadable to HL (idx2/BC/slot — all DE-clean in fp) other than the home.
   Branch-fused only (the compare emits its own jp). */
static int word_dehome_signed_test_shape_ok(const Func *f, const Op *o)
{
    if (!L.cur_home_is_word || !fp_active(f)) return 0;
    if (o->kind != IR_CMP_LT && o->kind != IR_CMP_GE) return 0;
    int s0 = o->src[0], s1 = o->src[1];
    if (s0 < 0 || s1 < 0 || s0 >= f->n_vregs || s1 >= f->n_vregs) return 0;
    if (f->vregs[s0].width != 2 || f->vregs[s1].width != 2) return 0;
    if (!f->vreg_to_phys || !f->vreg_spill_slot) return 0;
    if (f->vreg_to_phys[s0] != IR_PR_SPILL) return 0;   /* LHS i in a slot */
    if (f->vreg_spill_slot[s0] < 0) return 0;
    if (f->vregs[s0].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (s1 == L.cur_func_whome) return 0;                 /* RHS not the home */
    int ix = slot_ix_off(f, s0);
    if (!fp_offset_fits(ix) || !fp_offset_fits(ix + 1)) return 0;
    return 1;
}

static int cmp_bytewise_ok(const Func *f, const Op *o)
{
    if (L.la.cur_branch_test_kind == 0) return 0;
    return cmp_bytewise_shape_ok(f, o);
}

/* Slot-vs-slot unsigned word compare lowered byte-wise through A
   (`ld a,(ix+lo0); sub (ix+lo1); ld a,(ix+hi0); sbc a,(ix+hi1)`) instead of two
   synthetic ix pair-loads + `sbc hl,de`. fp only; 12B/76T vs 15B/95T AND
   DE/BC/HL-clean, so a word DE-home rides through a mem-vs-mem loop test (the
   matrix/struct/deref inner-pointer compare `p < end`). ULT/UGE, both operands
   in ix-addressable slots. The BC-resident LHS case is cmp_bytewise_shape_ok;
   this is the both-in-frame case. */
static int cmp_bytewise_mem_shape_ok(const Func *f, const Op *o)
{
    if (o->kind != IR_CMP_ULT && o->kind != IR_CMP_UGE) return 0;
    if (!fp_active(f)) return 0;
    int s0 = o->src[0], s1 = o->src[1];
    if (s0 < 0 || s1 < 0 || s0 >= f->n_vregs || s1 >= f->n_vregs) return 0;
    if (f->vregs[s0].width != 2 || f->vregs[s1].width != 2) return 0;
    if (!f->vreg_to_phys) return 0;
    if (f->vreg_to_phys[s0] != IR_PR_SPILL) return 0;   /* both in a slot */
    if (f->vreg_to_phys[s1] != IR_PR_SPILL) return 0;
    if (f->vregs[s0].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (f->vregs[s1].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    int ix0 = slot_ix_off(f, s0), ix1 = slot_ix_off(f, s1);
    if (!fp_offset_fits(ix0) || !fp_offset_fits(ix0 + 1)) return 0;
    if (!fp_offset_fits(ix1) || !fp_offset_fits(ix1 + 1)) return 0;
    return 1;
}

static int cmp_bytewise_mem_ok(const Func *f, const Op *o)
{
    if (L.la.cur_branch_test_kind == 0) return 0;
    return cmp_bytewise_mem_shape_ok(f, o);
}

/* Is op `o` the word DE-home's accumulate — `home = home OP w` with w a
   vreg? It lowers to `add hl,de; ex de,hl` (try_word_accumulate), which
   re-establishes DE = home, so it preserves the home (DE-clean). Must agree
   with try_word_accumulate exactly (same conditions) so the region analysis
   never disagrees with the emitter. ADD only for now (the only reduction the
   ptrbench/word_resident kernels use); SUB/AND/OR/XOR are pending. */
static int is_word_accumulate(const Func *f, const Op *o)
{
    if (!L.cur_home_is_word || L.cur_func_whome < 0) return 0;
    if (o->dst != L.cur_func_whome) return 0;
    if (o->kind != IR_ADD) return 0;
    if (o->src[1] < 0) return 0;                       /* needs a vreg addend */
    if (o->src[0] != o->dst && o->src[1] != o->dst) return 0;
    if (o->dst >= f->n_vregs || f->vregs[o->dst].width != 2) return 0;
    return 1;
}

/* Is op `o`'s lowering proven DE-clean — i.e. does the slot-backed byte
   home (in E/D) survive it? CONSERVATIVE whitelist (default: assume the op
   clobbers DE, forcing a flush): misclassifying a clean op dirty only costs
   a spill, but the reverse would miscompile. Clean = byte ALU through A
   (dst width 1), a byte deref (ld a,(bc)/(hl)), a pointer step (inc bc/hl),
   a byte truth-test branch (or a), plain branches, and a byte-wise unsigned
   loop test (cmp_bytewise_ok). Everything else — 16/32-bit ops (sbc hl,de,
   add hl,de, ex de,hl, load_to_de), stores, calls, switches, conversions
   from wide — is treated as a clobber. */
static int op_de_clean(const Func *f, const Op *o)
{
    int dw = (o->dst >= 0 && o->dst < f->n_vregs)
           ? f->vregs[o->dst].width : 0;
    /* Word DE-home: the accumulate and the home's own `ld de,K` init both
       re-establish DE = home; everything else that is DE-clean for the byte
       home (it touches A/HL/BC, never DE) is equally clean here. */
    if (L.cur_home_is_word) {
        if (is_word_accumulate(f, o)) return 1;
        if (o->kind == IR_LD_IMM && o->dst == L.cur_func_whome) return 1;
        /* Int deref (fp): register/sym base, |offset|<=3 (inc/dec hl, no DE
           scratch), no post-step, not a far/banked load, dst is not the home.
           Loads into HL/A; commit_hl_word's spill is the DE-preserving slot
           store (spill_and_swap_unless_dead). So DE (the home) survives — vs
           the *p++ word form (loads into DE) and wide/offset>3 forms (DE
           scratch), which stay dirty. */
        if (o->kind == IR_LD_MEM && dw == 2 && fp_active(f)
            && o->dst != L.cur_func_whome
            && o->mem.post_step == 0 && mem_bank_fn(&o->mem) == NULL
            && o->mem.elem != KIND_CPTR
            && (o->mem.kind == IR_MEM_VREG || o->mem.kind == IR_MEM_SYM)
            && o->mem.offset >= -3)        /* any +offset: emit_pair_add_de_clean */
            return 1;
        /* Counter step (i++/i--): width-2 INC/DEC of a non-home vreg lowers to
           `ex (sp),hl` (TOS) or load_to_hl + the DE-preserving slot store — A/HL
           only, DE survives. (fp; the home itself is stepped via the accumulate,
           not INC.) */
        if ((o->kind == IR_INC || o->kind == IR_DEC) && dw == 2 && fp_active(f)
            && o->dst != L.cur_func_whome)
            return 1;
        /* IVSR stepped pointer `bc += k` (PR_BC dst, small const step, dst==src0)
           → `inc bc` chain in gen_add — DE-clean. */
        if (o->kind == IR_ADD && dw == 2 && o->src[1] < 0
            && o->dst == o->src[0] && o->dst != L.cur_func_whome
            && o->imm >= 1                 /* any stride: emit_pair_add_de_clean */
            && f->vreg_to_phys && f->vreg_to_phys[o->dst] == IR_PR_BC)
            return 1;
        /* Small const add `dst = src0 + k` (k<=3, any home): gen_add lowers it
           to `inc hl` chain + the DE-preserving fp slot store — DE-clean, so a
           slot/HL-resident element pointer stepped inside the loop (`p += 2`)
           no longer reverts the resident region. fp only (sp commit_hl_word
           clobbers DE). Mirror gen_add's condition EXACTLY. */
        if (o->kind == IR_ADD && dw == 2 && o->src[1] < 0 && fp_active(f)
            && o->dst != L.cur_func_whome && o->imm >= 1 && o->imm <= 3
            && !(f->vreg_to_phys && f->vreg_to_phys[o->dst] == IR_PR_BC))
            return 1;
        /* DE-clean signed loop test (branch-fused). */
        if ((o->kind == IR_CMP_LT || o->kind == IR_CMP_GE)
            && L.la.cur_branch_test_kind != 0
            && word_dehome_signed_test_shape_ok(f, o))
            return 1;
    }
    switch (o->kind) {
    case IR_NOP: case IR_BR:
        return 1;
    case IR_POSTSTEP:                 /* pointer self-step: inc bc / inc hl */
        return 1;
    case IR_BR_ZERO: case IR_BR_COND: {
        int s  = o->src[0];
        int sw = (s >= 0 && s < f->n_vregs) ? f->vregs[s].width : 2;
        return sw <= 1;               /* byte test → `or a`; wider uses HL/DE */
    }
    case IR_AND: case IR_OR: case IR_XOR: case IR_ADD: case IR_SUB:
    case IR_RSUB: case IR_INC: case IR_DEC: case IR_NOT: case IR_NEG:
    case IR_MOV: case IR_LD_IMM:
        return dw == 1;               /* byte result computed in A */
    case IR_SHL: case IR_SHR:
        return dw == 1 && o->src[1] < 0;  /* const-count byte shift only */
    case IR_CONV_TRUNC: {
        /* width1<-width1 truncation is load_byte_to_a + store_a_byte — an
           A-only byte copy (slot address via HL), never touching DE/E. The
           narrowed `crc ^= *data` idiom lowers to one of these. */
        int sw = (o->src[0] >= 0 && o->src[0] < f->n_vregs)
               ? f->vregs[o->src[0]].width : 2;
        return dw == 1 && sw == 1;
    }
    case IR_LD_MEM:
        return dw == 1;               /* byte deref → A */
    case IR_CMP_ULT: case IR_CMP_UGE:
        /* byte-wise loop test: A-only, DE-clean — BC-vs-slot or slot-vs-slot */
        return cmp_bytewise_ok(f, o) || cmp_bytewise_mem_ok(f, o);
    default:
        return 0;                     /* assume DE-clobbering */
    }
}

/* DE-cleanliness for the STATIC home-region analysis (runs before lowering, so
   cur_branch_test_kind is unset). Recognises the fused byte-wise loop test
   structurally — a CMP_ULT/UGE consumed by the immediately-following branch,
   and that branch itself — both of which lower to the A+BC-only
   `ld a,c; sub mem; ld a,b; sbc a,mem; jp` form. Everything else defers to
   the runtime op_de_clean. */
static int op_de_clean_static(const Func *f, const BB *bb, int j)
{
    const Op *o = &bb->ops[j];
    if ((o->kind == IR_CMP_ULT || o->kind == IR_CMP_UGE)
        && j + 1 < bb->n_ops) {
        const Op *nxt = &bb->ops[j + 1];
        if ((nxt->kind == IR_BR_ZERO || nxt->kind == IR_BR_COND)
            && nxt->src[0] == o->dst
            && (cmp_bytewise_shape_ok(f, o) || cmp_bytewise_mem_shape_ok(f, o)))
            return 1;
    }
    /* Word DE-home signed loop test (CMP_LT/GE + the branch on its result):
       both lower to the A/HL-only DE-clean form. cur_branch_test_kind is unset
       here, so match structurally via the shape predicate. */
    if ((o->kind == IR_CMP_LT || o->kind == IR_CMP_GE) && j + 1 < bb->n_ops) {
        const Op *nxt = &bb->ops[j + 1];
        if ((nxt->kind == IR_BR_ZERO || nxt->kind == IR_BR_COND)
            && nxt->src[0] == o->dst
            && word_dehome_signed_test_shape_ok(f, o))
            return 1;
    }
    if ((o->kind == IR_BR_ZERO || o->kind == IR_BR_COND) && j > 0) {
        const Op *prv = &bb->ops[j - 1];
        if ((prv->kind == IR_CMP_ULT || prv->kind == IR_CMP_UGE)
            && prv->dst == o->src[0]
            && (cmp_bytewise_shape_ok(f, prv) || cmp_bytewise_mem_shape_ok(f, prv)))
            return 1;
        if ((prv->kind == IR_CMP_LT || prv->kind == IR_CMP_GE)
            && prv->dst == o->src[0]
            && word_dehome_signed_test_shape_ok(f, prv))
            return 1;
    }
    return op_de_clean(f, o);
}

/* Identify a loop the slot-backed byte home stays register-resident across,
   returning its bb-id span [lo,hi] via the out-params (-1,-1 if none).
   Conservative — when any criterion is unmet there is no region and codegen
   is unchanged:
     - some back-edge defines a loop; take the union span [lo,hi] of every
       in-loop BB (id-range model, mirrors ir_alloc's loop detection);
     - `home` is live-in at the header (lo);
     - EVERY op in BBs [lo..hi] is op_de_clean_static (so no body op clobbers
       E — byte-ALU writes re-establish it, all other body ops preserve it).
   Given the preheader leaves the home in E (its def stores E) and no body op
   clobbers E, the home is in E throughout the region — which lets the header
   ASSERT residency the single forward pass can't carry in over the back-edge,
   and lets the per-iteration spill be suppressed. */
/* True iff every op in BBs [lo..hi] is DE-clean and home is live-in at lo. */
static int home_span_valid(const Func *f, int home, int lo, int hi)
{
    const BB *hdr = &f->bbs[lo];
    if (!hdr->live_in || !ir_bitset_get((const BitSet *)hdr->live_in, home))
        return 0;
    /* The region must UPDATE the home in-loop (an accumulate / byte-ALU write
       of `home`). That in-region def is what re-establishes DE/E = home each
       iteration; a span that merely carries the home THROUGH without a def
       (e.g. an outer-loop step block reached from a nested inner loop that
       clobbered DE) is NOT a residency loop — its exit-flush would write
       whatever junk DE holds, not the home. Require ≥1 def of home. */
    int home_def = 0;
    for (int b = lo; b <= hi && !home_def; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            int defs[8];
            int nd = ir_op_defs(&bb->ops[j], defs, 8);
            for (int k = 0; k < nd; k++)
                if (defs[k] == home) { home_def = 1; break; }
            if (home_def) break;
        }
    }
    if (!home_def) return 0;
    for (int b = lo; b <= hi; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++)
            if (!op_de_clean_static(f, bb, j))
                return 0;
    }
    return 1;
}

