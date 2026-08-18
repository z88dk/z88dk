/* ir_lower_regcache.inc.c — part of ir_lower.c, #included (single TU). Do not compile standalone. */

/* Trailing comment marking a memory access to a volatile object. copt matches
   whole lines (copt.c: `return *pat == *ins`), so a stamped line never matches a
   store-then-reload peephole — a volatile load/store must not be optimised away.
   Empty for non-volatile so ordinary accesses stay copt-matchable. Covers
   volatile LOCALS (VREG_VOLATILE, slot-homed); volatile-pointee derefs are
   marked op->mem.volatile_ (handled by ir_match/ir_opt guards + mem_vol_stamp). */
static const char *vol_stamp(const Func *f, int vreg_id)
{
    return (vreg_id >= 0 && vreg_id < f->n_vregs
            && (f->vregs[vreg_id].flags & IR_VREG_VOLATILE))
           ? "\t;volatile" : "";
}

/* As vol_stamp but keyed on a memory op's own volatile flag (op->mem.volatile_)
   — for direct volatile-global (IR_MEM_SYM) and volatile-pointee-deref accesses,
   whose volatility lives on the access, not the dst vreg. Prevents copt from
   folding e.g. `ld a,(_g); ld l,a; ld h,0` → `ld hl,(_g)` (a 16-bit over-read
   of a 1-byte volatile). */
static const char *mem_vol_stamp(const Op *op)
{
    return op->mem.volatile_ ? "\t;volatile" : "";
}

static void emit_bc_reload(FILE *out, const Func *f, int vreg_id, int sp_adj)
{
    /* Rematerialisable constant (NO_SLOT, no slot to read): re-emit `ld bc,K` /
       `ld bc,_sym` instead of a slot reload. Must precede the slot path — a
       remat vreg has no slot, so require_slot would abort. */
    if (emit_remat_word(out, f, vreg_id, "bc")) {
        cache_bc(vreg_id);
        return;
    }
    if (fp_active(f) && !L.cur_frameless) {
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

/* True if vreg_id is homed in PR_BC at the current lowering point (I1 read path;
   ir_home_at). Guards the range, then defers to the accessor. */
static int vreg_in_pr_bc(const Func *f, int vreg_id)
{
    if (!f || !f->vreg_to_phys) return 0;
    if (vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    return ir_home_at(f, vreg_id) == IR_PR_BC;
}

/* True iff any vreg in this function is homed in DE or a DE half. The 8085
   LHLX deref below reads through DE, and a small-offset word deref is one of
   the shapes op_de_clean promises is DE-CLEAN — that promise is what lets a
   DE home stay resident across it. So the LHLX form is only available when
   nothing is homed there, and the promise has nothing to protect. */
static int func_has_de_home(const Func *f)
{
    if (!f || !f->vreg_to_phys) return 1;          /* unknown: assume it does */
    if (g_hc.func_whome >= 0) return 1;
    for (int v = 0; v < f->n_vregs; v++) {
        int p = ir_home_at(f, v);
        /* IR_PR_DEHL is deliberately NOT here: a DE:HL-resident long is a
           short-lived born-and-consumed value, and every user of this predicate
           clobbers HL as well (the base load), so such a long can never be live
           across one. Vetoing whole functions for owning one cost binary-trees
           7 bytes and 0.8% of its cycles by refusing the LHLX deref there. */
        if (p == IR_PR_DE || p == IR_PR_E || p == IR_PR_D) return 1;
    }
    return 0;
}

/* [IR_DEPARK_PROBE] INERT — size the dead-DE frame word load. The 8085
   LDSI/LHLX slot read below parks DE (push/pop) because load_to_hl must hand it
   back untouched; where DE is provably free that park is 22 cycles and 2 bytes
   of pure overhead (42c/5B against 20c/3B). This counts park sites and how many
   a "no DE home, no DE or DEHL belief, no pending spill" gate would accept, and
   which condition blocks the rest — so the acceptance rate is known before any
   codegen moves. Emits nothing: gate-on output is byte-identical. */
static long dp_total, dp_free, dp_blk_home, dp_blk_de, dp_blk_dehl, dp_blk_pend;
static void depark_probe_report(void)
{
    if (!dp_total) return;
    fprintf(stderr, "DEPARKPROBE sites=%ld free=%ld (%.0f%%) blocked:"
            " de_home=%ld de_belief=%ld dehl=%ld pending=%ld\n",
            dp_total, dp_free, 100.0 * (double)dp_free / (double)dp_total,
            dp_blk_home, dp_blk_de, dp_blk_dehl, dp_blk_pend);
}
static int depark_probe_on(void)
{
    static int v = -1;
    if (v < 0) { const char *e = getenv("IR_DEPARK_PROBE");
                 v = e ? atoi(e) : 0;
                 if (v) atexit(depark_probe_report); }
    return v;
}

/* True if vreg_id is a stack-transient spill (IR_PR_STACK): pushed at its def,
   popped at its single use — no frame slot. See ir_stack_spill (ir_alloc). */
static int vreg_is_pr_stack(const Func *f, int vreg_id)
{
    if (!f || !f->vreg_to_phys) return 0;
    if (vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    return ir_home_at(f, vreg_id) == IR_PR_STACK;
}
/* True if vreg_id's value is currently push-parked AND still at TOS (nothing
   pushed on top since the park — cur_sp_adjust unchanged). */
static int stack_parked(int vreg_id)
{
    return vreg_id >= 0 && L.cur_stack_resident == vreg_id
        && L.cur_sp_adjust == L.cur_stack_resident_spadj;
}

static int vreg_in_pr_de(const Func *f, int vreg_id)
{
    if (!f || !f->vreg_to_phys) return 0;
    if (vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    return ir_home_at(f, vreg_id) == IR_PR_DE;
}

/* True if vreg_id is slot-only (IR_PR_SPILL) at the current point (I1 read path).
   Null/out-of-range → 0 (matches the `!f->vreg_to_phys` guards at call sites). */
static int vreg_is_spilled(const Func *f, int vreg_id)
{
    if (!f || !f->vreg_to_phys) return 0;
    if (vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    return ir_home_at(f, vreg_id) == IR_PR_SPILL;
}

/* Width-4 byte-arithmetic fastpath gate. True for integer kinds
   (ADD/SUB bit-identical to integer); false for float/double which
   need FP helpers. */
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
   sp-relative addressing). CPUs that DO have it — gbz80/rabbit/kc160 —
   also have dearer push/pop, so the trick regresses speed there. */
int tos_pushpop_ok(const Func *f)
{
    (void)f;
    return !(IS_RABBIT() || IS_GBZ80() || IS_KC160());
}

/* Same sp+0 trick for the LONG (32-bit) ex-free paths — additionally allowed on
   gbz80. gbz80's push/pop are dear (16T/12T), so for a 16-bit slot the pop/push
   load can lose in a hot loop, which is why the word
   paths keep tos_pushpop_ok. But a 32-bit slot's byte-walk is twice as long
   (`pop hl;pop de` vs an 8-instruction walk), the pop/push is a clear size win,
   and long slots rarely sit in the hottest int loops. rabbit/kc160 keep their
   native sp-relative access. */
int tos_pushpop_noex_ok(const Func *f)
{
    (void)f;
    return !(IS_RABBIT() || IS_KC160());
}

/* True when even in fp-mode the pop/push trick beats the IX access for
   the DEEPEST local (slot_off==0). With cur_sp_adjust==0, SP == that
   slot's address, so `pop hl;push hl` reads it. On z80/z180/z80n
   `ld rr,(ix+d)` is synthetic (6B/38t) so pop/push (2B/21t) wins;
   ez80/kc160 have cheaper native indexed word loads into any pair, so
   stay on the IX path. (Rabbit excluded by tos_pushpop_ok anyway.) */
static int fp_tos_slot(const Func *f, int vreg_id)
{
    return fp_active(f) && tos_pushpop_ok(f)
        && !(IS_EZ80() || IS_KC160())
        && L.cur_sp_adjust == 0
        && slot_off(f, vreg_id) == 0;
}

/* Word DE-home: a width-2 loop-carried accumulator homed in DE reuses the
   byte home-residency machinery (cur_byte_home_vreg/_dirty, bb_byte_out,
   cur_func_ehome, the region span, the BB-loop carry/flush) with
   cur_home_is_word=1 and cur_func_whome set to that vreg. A byte E/D-home and
   a word DE-home never coexist (the allocator gives up the word home when a
   byte E/D-home already claimed DE's low half), so state is shared, not
   duplicated. Width-specific leaf ops dispatch on cur_home_is_word. */

/* True when rematerialising vreg_id into a pair OTHER than HL would use HL as
   scratch. `ld rr,K` (IR_LD_IMM) and `ld rr,_sym` (IR_LD_SYM) leave HL alone,
   but the [remat-LEA] frame-address form recomputes `ld hl,off; add hl,sp` and
   copies out, so it destroys HL. A caller holding a live operand in HL must ask
   before rematerialising into DE or BC. */
static int remat_word_clobbers_hl(const Func *f, int vreg_id)
{
    if (!g_hc.remat_def || vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    const Op *o = g_hc.remat_def[vreg_id];
    return o && o->kind == IR_LEA;
}

/* Rematerialize a width-2 constant vreg (LD_IMM / LD_SYM / LEA) into register
   pair `rp` ("hl"/"de"/"bc"), re-emitting the constant instead of a slot reload.
   Returns 1 if emitted, 0 if vreg isn't rematerializable. Caller updates the
   cache belief for `rp`. The LEA form clobbers HL when `rp` is not "hl" —
   see remat_word_clobbers_hl. */
static int emit_remat_word(FILE *out, const Func *f, int vreg_id, const char *rp)
{
    if (!g_hc.remat_def || vreg_id < 0 || vreg_id >= f->n_vregs) return 0;
    const Op *o = g_hc.remat_def[vreg_id];
    if (!o) return 0;
    if (o->kind == IR_LD_IMM) {
        emit(out, "ld\t%s,%lld", rp, (long long)o->imm);
        return 1;
    }
    /* [remat-LEA] Frame-slot address (&local): recompute at the use instead of
       spilling+reloading, via `ld hl,slot_off+cur_sp_adjust; add hl,sp` then a move
       to de/bc (portable `ld d,h;ld e,l` — gbz80 has no `ex de,hl`). Clobbers ONLY
       the target pair; the address is sp-relative and cur_sp_adjust is tracked, so
       fp works the same as sp. (An ez80-fp `lea rr,ix+d` form existed but was a
       byte-for-tick loss — ez80-fp is excluded from remat marking; see ir_lower.c.) */
    if (o->kind == IR_LEA && o->src[0] >= 0 && o->src[0] < f->n_vregs) {
        int src = o->src[0];
        emit(out, "ld\thl,%d",
             slot_off(f, src) + L.cur_sp_adjust + (int)o->imm);
        emit(out, "add\thl,sp");
        if (!strcmp(rp, "hl"))
            return 1;                                /* HL = addr; caller cache_hl */
        if (!strcmp(rp, "de")) { emit_hl_to_de(out); }
        else                   { emit_hl_to_bc(out); }
        invalidate_hl_cache();                       /* HL overwritten by the recompute */
        return 1;
    }
    /* LD_SYM: &sym (+offset) — mirror gen_ld_sym's symbol formatting. */
    const char *pfx = ir_sym_prefix(o->mem.sym);
    if (o->mem.offset)
        emit(out, "ld\t%s,%s%s+%d", rp, pfx, ir_sym_name(o->mem.sym),
             o->mem.offset);
    else
        emit(out, "ld\t%s,%s%s", rp, pfx, ir_sym_name(o->mem.sym));
    return 1;
}

/* Read an index-register-homed word (idx2/idx3) into a gp pair `rr`, cheaply
   where the CPU allows:
     - ez80: `lea <rr>,<idx>` (offset-0 form: rr = idx) — one ED op (3 cyc), any
       gp pair, no stack traffic.
     - rabbit: `ld hl,<idx>` (4 cyc single op) — HL ONLY (there is no `ld de,xy`),
       vs the dear rabbit push/pop (~19 cyc). A DE read falls back to push/pop.
     - else: `push <idx>; pop <rr>`.
   Cheapens the READ side of every IX/IY residency home (reduction pack, idx3,
   Tier A temp-pack). */
static void emit_idx_word_to_reg(FILE *out, const Func *f, int vreg_id,
                                 const char *rr)
{
    if (IS_EZ80()) {
        emit(out, "lea\t%s,%s", rr, vreg_idx_name(f, vreg_id));
    } else if (IS_RABBIT() && !strcmp(rr, "hl")) {
        emit(out, "ld\thl,%s", vreg_idx_name(f, vreg_id));
    } else {
        emit(out, "push\t%s", vreg_idx_name(f, vreg_id));
        emit(out, "pop\t%s", rr);
    }
}

/* Write HL into an index-register home (idx2/idx3). rabbit has `ld <idx>,hl`
   (4 cyc single op) vs its dear push/pop (~19); every other CPU — including ez80,
   which has no `lea` reverse — uses `push hl; pop <idx>`. Mirror of
   emit_idx_word_to_reg for the WRITE side. */
static void emit_hl_to_idx_word(FILE *out, const Func *f, int vreg_id)
{
    if (IS_RABBIT()) {
        emit(out, "ld\t%s,hl", vreg_idx_name(f, vreg_id));
    } else {
        emit(out, "push\thl");
        emit(out, "pop\t%s", vreg_idx_name(f, vreg_id));
    }
}

static void load_to_hl_adj(FILE *out, const Func *f, int vreg_id, int sp_adj)
{
    /* Stack-transient spill (IR_PR_STACK): the value was parked at TOS by a
       `push` at its def; pop it here (its single use). Checked FIRST — before the
       HL-cache hit — so a stale cache_hl(dst) left by a direct-store producer
       can't skip the balancing pop (which would leak the pushed word). Valid only
       when it is actually TOS: sp_adj==0 and it's the resident park (the allocator
       forbids calls / other stack ops between def and use). */
    if (vreg_is_pr_stack(f, vreg_id) && stack_parked(vreg_id) && sp_adj == 0) {
        ss_note_reload(f, vreg_id);
        emit_sp(out, -2, "pop\thl");
        L.cur_stack_resident = -1;
        hl_about_to_change(vreg_id);
        return;
    }
    /* HL cache hit: no-op. Some callers call us unconditionally, and for
       PR_HL vregs (no slot) the slot read at the bottom would land at sp-1
       and read garbage below the frame — so return early here.

       sp_adj is deliberately NOT tested. It only positions a SLOT read; a
       register cache is a value cache, so if HL holds the vreg the stack
       position is irrelevant. Requiring sp_adj==0 here (copied from the
       IR_PR_STACK check above, where it IS required because the pop is only
       valid at TOS) made a live HL cache fall through to a slot read. That was
       invisible while the slot existed, and aborted once the dead-store pass
       correctly elided it — libsrc fix16_atanh, a chain of fastcall results
       where the value never needs memory at all. */
    if (hl_has(vreg_id)) { ss_note_cache_read(f, vreg_id); return; }
    /* Every path below clobbers HL. If a width-2 spill is pending in HL,
       flush/discard it here while HL still holds it. */
    pending_spill_resolve();
    /* Word DE-home resident: copy the running sum DE→HL (`ld l,e; ld h,d`),
       leaving DE = home intact (a read never evicts the home). */
    if (g_hc.home_is_word && vreg_id == g_hc.func_whome && vreg_id >= 0
        && byte_home_holds(vreg_id) && f->vregs[vreg_id].width == 2
        && sp_adj == 0) {
        ss_note_cache_read(f, vreg_id);
        emit_de_to_hl(out);
        hl_about_to_change(vreg_id);   /* HL = home copy; DE still = home */
        return;
    }
    /* PR_BC hit: copy from BC. 2 instructions vs the 6 the slot-read
       path emits. Width guarded defensively (ir_alloc enforces width=2
       for PR_BC). */
    if (bc_has(vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit(out, "ld\thl,bc");
        hl_about_to_change(vreg_id);
        return;
    }
    /* DE hit: copy DE→HL non-destructively (`ld l,e; ld h,d`, DE preserved —
       mirrors the BC path). Without this a DE-resident value needed in HL fell
       through to a slot reload (e.g. a call result cached in DE by gen_call). */
    if (de_has(vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit_de_to_hl(out);
        hl_about_to_change(vreg_id);
        return;
    }
    /* idx2 resident in the spare index register: `push <idx>;pop hl`. */
    /* Alt-bank invariant materialize (rare — a non-branch-fused compare read):
       `exx; push <altpair>; exx; pop hl` brings it into HL without disturbing
       the alt home (push in the alt bank, pop in the main). */
    if (vreg_in_exx(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit(out, "exx");
        emit(out, "push\t%s", exx_pair(f));
        emit(out, "exx");
        emit(out, "pop\thl");
        hl_about_to_change(vreg_id);
        return;
    }
    if (vreg_in_idx2(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit_idx_word_to_reg(out, f, vreg_id, "hl");
        hl_about_to_change(vreg_id);
        return;
    }
    /* PR_BC miss (another PR_BC tenant occupies BC): reload from slot,
       then `ld hl,bc`. Cost ≤ the regular slot read. */
    if (vreg_in_pr_bc(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        emit_bc_reload(out, f, vreg_id, sp_adj);
        emit(out, "ld\thl,bc");
        hl_about_to_change(vreg_id);
        return;
    }
    int width = f->vregs[vreg_id].width;
    /* Index-half home widened to HL: read the half via A (ld l,iyl is illegal —
       DD reinterprets both operands), zero-extend. Always valid; no slot. */
    if (width == 1) {
        PhysReg ih = idxhalf_phys(f, vreg_id);
        if (ih != IR_PR_NONE) {
            emit(out, "ld\ta,%s", idxhalf_reg(ih));
            emit(out, "ld\tl,a");
            emit(out, "ld\th,0");
            hl_about_to_change(vreg_id);
            return;
        }
    }
    /* A-cache hit for byte vregs: a dead-skipped byte producer left the
       value ONLY in A (no slot store), so the slot read below would return
       garbage. */
    if (width == 1 && a_has(vreg_id)) {
        emit(out, "ld\tl,a");
        emit(out, "ld\th,0");
        hl_about_to_change(vreg_id);
        return;
    }
    /* Rematerialize a constant/address instead of reloading its slot: a
       loop-invariant `ld hl,<const>` (10T) beats `ld hl,(ix+d)` (19T) and
       spills nothing. Cache-miss only (every register hit was checked above).
       sp_adj is irrelevant — the constant is position-independent. */
    if (width == 2 && emit_remat_word(out, f, vreg_id, "hl")) {
        rec_note(REC_REMAT, vreg_id);   /* B4: recovered by rematerialisation */
        hl_about_to_change(vreg_id);
        return;
    }
    /* Past every register-cache hit: a real slot read follows → record
       it for the dead-store analysis. */
    ss_note_reload(f, vreg_id);
    require_slot(f, vreg_id);
    int off = slot_off(f, vreg_id) + sp_adj + L.cur_sp_adjust;
    /* FP-relative fast path. IX captures sp at function entry, so its
       offset to any slot is invariant under push/pop — sp_adj is
       irrelevant for IX addressing. */
    if (fp_active(f)) {
        /* Deepest slot, no pushes outstanding: pop/push reads it from SP
           cheaper than synthetic ld hl,(ix+d). By-coincidence only. Gated on
           sp_adj==0: an outstanding caller push (sp_adj>0) moves the slot to
           sp+sp_adj — use IX addressing instead. */
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
    /* Top-of-stack fast path: a slot at sp+0 read whole with `pop hl;
       push hl` — 2 ops vs ~6, no address compute. sp-mode only. */
    if (width == 2 && off == 0 && !fp_active(f) && tos_pushpop_ok(f)) {
        emit(out, "pop\thl");
        emit(out, "push\thl");
        hl_about_to_change(vreg_id);
        return;
    }
    if (width == 1) {
        /* Reuse a cached slot address instead of recomputing; sp_adj must be
           0 — the byte helpers cache at the canonical sp. */
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
       preserve DE (load_binop_operands caches src1 there; clobbering it
       miscompiles, and no cache-based dead-DE test is sound). Park DE on
       the stack across the load: 5B/42c vs the 8B/44c add-hl-sp byte walk,
       no A-clobber — a strict win even with the push/pop. The balanced
       push/pop leaves cur_sp_adjust untouched; just shift the slot offset
       +2 for the in-flight push. */
    if ((IS_8085()) && off >= 0 && off + 2 <= 255) {
        if (depark_probe_on()) {
            const char *why = "FREE";
            dp_total++;
            if      (func_has_de_home(f))  { dp_blk_home++; why = "de_home"; }
            else if (L.rs.de >= 0)         { dp_blk_de++;   why = "de_belief"; }
            else if (L.rs.dehl >= 0)       { dp_blk_dehl++; why = "dehl"; }
            else if (L.pending_spill_v >= 0) { dp_blk_pend++; why = "pending"; }
            else                             dp_free++;
            if (depark_probe_on() == 2)
                fprintf(stderr, "DEPARKSITE %s v%d off=%d %s\n",
                        f && f->fn ? ir_sym_name(f->fn) : "?", vreg_id, off, why);
        }
        /* NB no "DE is dead here, skip the park" shortcut: the register cache
           has no BYTE-level DE tracking (rs.a/bc/de/hl only), so a value staged
           in E or D alone — `ld a,(hl); ld e,a` before a store — is live with
           NOTHING in the cache to say so, and dropping the park corrupted it
           (rle, bitfieldbench). A belief-based test cannot be sound here, which
           is what the comment above means; a sound version needs either a
           caller-supplied "DE is dead for this load" hint at the sites that know
           it, or real liveness. IR_DEPARK_PROBE sizes the prize: 19% of corpus
           park sites, 46% of binary-trees'. */
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

/* Load 16-bit value into DE (binop second operand). Cache-aware: DE hit
   is a no-op; HL hit uses `ex de,hl`; else load via HL then ex de,hl.
   After: rs.de = vreg_id; HL holds whatever DE was (junk). */
static void load_to_de(FILE *out, const Func *f, int vreg_id)
{
    /* Stack-transient spill parked at TOS: pop straight into DE (its single use).
       Checked FIRST — before the DE-cache hit — so a stale cache_de(dst) can't
       skip the balancing pop. Doesn't disturb HL. See load_to_hl_adj. */
    if (vreg_is_pr_stack(f, vreg_id) && stack_parked(vreg_id)) {
        ss_note_reload(f, vreg_id);
        emit_sp(out, -2, "pop\tde");
        L.cur_stack_resident = -1;
        cache_de(vreg_id);
        return;
    }
    if (L.rs.de == vreg_id && vreg_id >= 0) {
        ss_note_cache_read(f, vreg_id);
        return;
    }
    /* idx2 resident: `push <idx>;pop de` recovers it (HL untouched) —
       cheaper than the per-iteration slot reload. */
    if (vreg_in_exx(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit(out, "exx");
        emit(out, "push\t%s", exx_pair(f));
        emit(out, "exx");
        emit(out, "pop\tde");
        cache_de(vreg_id);
        return;
    }
    if (vreg_in_idx2(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        ss_note_cache_read(f, vreg_id);
        emit_idx_word_to_reg(out, f, vreg_id, "de");
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
    /* Rematerialize a constant/address into DE instead of a slot read (cache
       miss; not in DE/BC above). Skip when live in HL — the ex de,hl path
       below is cheaper. */
    if (f->vregs[vreg_id].width == 2 && L.rs.hl != vreg_id
        && emit_remat_word(out, f, vreg_id, "de")) {
        rec_note(REC_REMAT, vreg_id);   /* B4: recovered by rematerialisation */
        cache_de(vreg_id);
        return;
    }
    /* FP-relative direct-to-DE: 6 bytes (synthetic `ld de,(ix+d)`) but
       preserves HL — worth the 1-byte difference vs the byte-walk form
       (which clobbers HL and invalidates downstream cache hits).
       Gate on an ix-addressable frame location: slot_off >= 0 covers both a
       real local slot AND a PARAM_IN_PLACE param (at param_caller_off, above
       IX) — a register-only vreg has slot_off == -1 and slot_ix_off would
       synthesise a bogus below-frame offset. Also skip when the value is live
       in HL: the ex de,hl path below is cheaper. */
    if (fp_active(f) && f->vregs[vreg_id].width == 2
        && L.rs.hl != vreg_id
        && slot_off(f, vreg_id) >= 0) {
        /* Deepest slot at TOS: pop de;push de beats synthetic ld de,(ix+d)
           and likewise preserves HL. Real local slots only (params sit above
           IX, never at TOS). */
        if (f->vreg_spill_slot && f->vreg_spill_slot[vreg_id] >= 0
            && fp_tos_slot(f, vreg_id)) {
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
        /* The wanted value is in HL. If it is the pending spill, flushing
           it writes the slot AND leaves it in DE (store_hl's internal
           `ex de,hl`) — the swap's exact result — so resolve instead of
           swapping. */
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
       through (hl), skipping load_to_hl's trailing `ld l,a`. Saves 1 byte
       vs load_to_hl + ex de,hl. HL is clobbered. */
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
        if (off == 0 && !fp_active(f) && tos_pushpop_ok(f) && f->frame_size >= 2) {
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
           pending spill first (the equal case was handled by the swap
           path above). */
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
    /* Byte → DE directly (zero-extend: E=byte, D=0), mirroring load_to_hl's
       width-1 widening but WITHOUT the HL detour (`ld l,..; ld h,0; ex de,hl`)
       — saves the swap and, for the A-cache / fp-ix cases, leaves HL intact
       (so load_to_de_preserve_hl needs no push/pop). A signed byte reaches DE
       already CONV_SX'd to a wider vreg, so a width-1 read is always zero-extend. */
    if (f->vregs[vreg_id].width == 1) {
        if (a_has(vreg_id)) {                    /* byte already in A */
            ss_note_cache_read(f, vreg_id);
            emit(out, "ld\te,a");
            emit(out, "ld\td,0");
            cache_de(vreg_id);
            return;
        }
        if (fp_active(f) && slot_off(f, vreg_id) >= 0) {
            int ix_off = slot_ix_off(f, vreg_id);
            if (fp_offset_fits(ix_off)) {         /* (ix+d) → E, D=0; HL untouched */
                ss_note_reload(f, vreg_id);
                emit(out, "ld\te,(%s%+d)", frame_reg(), ix_off);
                emit(out, "ld\td,0");
                cache_de(vreg_id);
                return;
            }
        }
    }
    load_to_hl(out, f, vreg_id);
    emit(out, "ex\tde,hl");
    swap_hl_de_caches();
}

/* Same as load_to_de but preserves HL by wrapping the load in push/pop
   (2 extra bytes), letting the caller keep a cached value in HL. */
static void load_to_de_preserve_hl(FILE *out, const Func *f, int vreg_id)
{
    /* Stack-transient parked at TOS: `pop de` takes it, leaving HL untouched —
       exactly this function's contract. Checked FIRST (before the DE-cache hit)
       so a stale cache_de(dst) can't skip the balancing pop. (The generic push-hl
       path below would shove HL on top of the park and pop the wrong word.) */
    if (vreg_is_pr_stack(f, vreg_id) && stack_parked(vreg_id)) {
        ss_note_reload(f, vreg_id);
        emit_sp(out, -2, "pop\tde");
        L.cur_stack_resident = -1;
        cache_de(vreg_id);
        return;
    }
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
    /* Byte via A-cache or an (ix+d) slot loads straight into E/D without
       touching HL (see load_to_de's width-1 path) — no push/pop needed. */
    if (f->vregs[vreg_id].width == 1
        && (a_has(vreg_id)
            || (fp_active(f) && slot_off(f, vreg_id) >= 0
                && fp_offset_fits(slot_ix_off(f, vreg_id))))) {
        load_to_de(out, f, vreg_id);
        return;
    }
    emit_sp(out, 2, "push\thl");
    load_to_de(out, f, vreg_id);
    L.cur_sp_adjust -= 2;
    emit(out, "pop\thl");
    /* HL is restored to its prior value — cache stands. */
}

/* Store HL to a vreg's frame slot. Wrapper sets the [IR_DEADSTORE] write context
   (save/restore — nests via pending_spill_resolve) so every slot_off it makes is
   attributed to the write count. */
static void store_hl_impl(FILE *out, const Func *f, int vreg_id);
static void store_hl(FILE *out, const Func *f, int vreg_id)
{
    int save = slot_write_ctx; slot_write_ctx = 1;
    store_hl_impl(out, f, vreg_id);
    slot_write_ctx = save;
}
static void store_hl_impl(FILE *out, const Func *f, int vreg_id)
{
    /* [IR_DEADSTORE word] Dead slot store (see store_hl_keep_hl_impl). This
       helper's contract is DE=value / HL=junk, so the store collapses to the
       single `ex de,hl` that moves the value into place; cache DE for the
       readers. A caller that wanted HL back emits its own `ex de,hl` and copt
       #284 cancels the pair. */
    if (vreg_id >= 0 && (f->vregs[vreg_id].flags & IR_VREG_DEAD_SPILL)) {
        emit(out, "ex\tde,hl");
        swap_hl_de_caches();
        /* ASSERT the belief, do not merely swap it. This helper's contract is
           that the value arrives in HL, but the CACHE need not already say so
           — and after the swap the DE belief is then whatever rs.hl happened
           to hold, which may be nothing. With the slot still present that did
           not matter, because every reader could fall back to it. With the
           slot elided the readers have nowhere to go and abort. The keep_hl
           variant below always got this right because it calls cache_hl
           outright. (libsrc asctime, regis/tek401x drawto.) */
        cache_de(vreg_id);
        return;
    }
    /* Stack-transient (IR_PR_STACK): park HL on the stack, don't slot-store to
       the -1 sentinel (which the sp fallback turns into a write at sp-1).
       Defensive catch-all for producers that reach store_hl directly rather than
       commit_hl_word/spill_and_swap (which already park). The single use pops it;
       load_to_* check the park before any cache, so a caller's later cache_hl(v)
       can't skip the pop. */
    if (vreg_id >= 0 && vreg_is_pr_stack(f, vreg_id)) {
        emit_sp(out, 2, "push\thl");
        L.cur_stack_resident = vreg_id;
        L.cur_stack_resident_spadj = L.cur_sp_adjust;
        return;
    }
    if (fp_active(f)) {
        /* Deepest slot at TOS: discard the word (inc sp x2) and push the
           value — cheaper than synthetic ld (ix+d),hl, same contract
           (DE=value, HL=junk). By-coincidence only. */
        if (fp_tos_slot(f, vreg_id)) {
            emit(out, "ex\tde,hl");
            emit(out, "inc\tsp");
            emit(out, "inc\tsp");
            emit(out, "push\tde");
            return;
        }
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            /* Honour the store_hl contract (DE=value, HL=junk after) —
               many sites end with `store_hl; ex de,hl` to restore HL. */
            emit(out, "ld\t(%s%+d),hl%s", frame_reg(), ix_off,
                 vol_stamp(f, vreg_id));
            emit(out, "ex\tde,hl");
            return;
        }
    }
    int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
    /* Rabbit/kc160 native sp-relative store: ld (sp+N),hl then the
       contract ex de,hl (DE=value, HL=junk) — mirrors the fp path. */
    if (off >= 0 && off <= sp_rel_max(f)) {
        emit(out, "ld\t(sp+%d),hl%s", off, vol_stamp(f, vreg_id));
        emit(out, "ex\tde,hl");
        return;
    }
    /* Top-of-stack: discard the slot word (inc sp x2) and push the value.
       Honours the contract (DE=value, HL=junk). sp-mode only, 4 ops vs the
       6-op byte walk. */
    if (off == 0 && !fp_active(f) && tos_pushpop_ok(f) && f->frame_size >= 2) {
        emit(out, "ex\tde,hl");        /* DE = value */
        emit(out, "inc\tsp");
        emit(out, "inc\tsp");
        emit(out, "push\tde");
        return;
    }
    /* 8085: LDSI + SHLX. `ld de,sp+N` points DE at the slot, SHLX stores HL
       through it; the trailing ex de,hl restores the contract (DE=value,
       HL=junk). 4 bytes vs the 6-byte byte walk. Clobbering DE is
       consistent — the byte walk's leading `ex de,hl` destroys it too. */
    if ((IS_8085()) && off >= 0 && off <= 255) {
        emit(out, "ld\tde,sp+%d", off);
        emit(out, "ld\t(de),hl");
        emit(out, "ex\tde,hl");
        return;
    }
    emit(out, "ex\tde,hl");        /* DE = value */
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e%s", vol_stamp(f, vreg_id));
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),d");
}

/* HL-native store: same slot write as store_hl but leaves the value in HL
   (DE=junk), NOT DE. store_hl's "DE=value" contract forces a gratuitous
   `ex de,hl` that HL-wanting callers undo with a second `ex de,hl` (the value
   is ALREADY in HL and every slot write here preserves it) — a DE round-trip
   copt then has to clean up. This is the store for callers that want HL after:
   the value stays put, the ex de,hl pair never exists. The old-TOS discard uses
   `pop de` (dead DE) not `inc sp; inc sp` (1B/2T cheaper). DE cache dropped. */
/* Write-context wrapper, mirroring store_hl's: this helper IS a store, so every
   slot_off/slot_ix_off it makes must be attributed to the WRITE count. Without
   it a call-result spill (its main caller, ir_lower_call.inc.c) looked "never
   written but read" to the IR_DEADSTORE read/write split, hiding every dead
   call-result store. */
static int store_hl_keep_hl_impl(FILE *out, const Func *f, int vreg_id);
static int store_hl_keep_hl(FILE *out, const Func *f, int vreg_id)
{
    int save = slot_write_ctx; slot_write_ctx = 1;
    int r = store_hl_keep_hl_impl(out, f, vreg_id);
    slot_write_ctx = save;
    return r;
}
static int store_hl_keep_hl_impl(FILE *out, const Func *f, int vreg_id)
{
    /* [IR_DEADSTORE word] Slot written but never read (read/write split,
       coalescing-checked; ir_assign_slots dropped the slot on the re-lower).
       The value is already in HL and this helper's contract is HL=value, so the
       store simply disappears — cache HL so every reader is served from it
       (same BB, or the next via bb_hl_out). Width-2 only; set only on the
       re-lower. */
    if (vreg_id >= 0 && (f->vregs[vreg_id].flags & IR_VREG_DEAD_SPILL)) {
        /* The store is dead, but its REGISTER side effects are not. The real
           path reaches the slot through HL, so it first moves the value to DE
           (`ex de,hl`) and restores HL from there — leaving a SECOND copy in
           DE that the code after it may be compiled against. Dropping the
           store alone removes that copy, and a consumer needing the value
           twice (asctime's `dayofweek(...)*3`, which is `add hl,hl` then
           `add hl,de`) then has nowhere to get the second one: HL has been
           consumed and the slot is gone.

           So reproduce the register effects, not just the memory one. This is
           2 bytes against the 6+ the store cost, and it keeps the elided
           render's register state identical to the render the deadness was
           measured on — which is what makes "rd=0 last time" still true. */
        emit_hl_to_de(out);
        cache_de(vreg_id);
        cache_hl(vreg_id);
        return 1;
    }
    /* No frame slot to store into. Dead-frame elision drops every slot and
       re-lowers, so a store can outlive its slot; the value is register-only
       from here. Emitting the offset anyway would address sp+(-1) — below the
       frame — or, when a stale offset survived as 0, the return address. The
       elision only runs once frame_fully_dead proves no slot is read, so the
       store is dead by construction and keeping the value in HL is complete.
       Mirrors the IR_VREG_DEAD_SPILL case above. */
    if (vreg_id >= 0 && slot_off(f, vreg_id) < 0
        && !(f->vregs[vreg_id].flags & IR_VREG_PARAM_IN_PLACE)) {
        cache_hl(vreg_id);
        return 1;
    }
    if (vreg_id >= 0 && vreg_is_pr_stack(f, vreg_id)) {
        emit_sp(out, 2, "push\thl");            /* HL preserved by push */
        L.cur_stack_resident = vreg_id;
        L.cur_stack_resident_spadj = L.cur_sp_adjust;
        return 1;
    }
    if (fp_active(f)) {
        if (fp_tos_slot(f, vreg_id)) {
            emit(out, "pop\tde");               /* discard old TOS word (DE dead) */
            emit(out, "push\thl");              /* store; HL preserved */
            invalidate_de_cache();
            return 1;
        }
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 1)) {
            emit(out, "ld\t(%s%+d),hl%s", frame_reg(), ix_off,
                 vol_stamp(f, vreg_id));         /* HL preserved — no ex */
            return 1;
        }
    }
    int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
    if (off >= 0 && off <= sp_rel_max(f)) {
        emit(out, "ld\t(sp+%d),hl%s", off, vol_stamp(f, vreg_id));  /* HL preserved */
        return 1;
    }
    if (off == 0 && !fp_active(f) && tos_pushpop_ok(f) && f->frame_size >= 2) {
        emit(out, "pop\tde");                   /* discard old TOS (DE dead) */
        emit(out, "push\thl");                  /* store; HL preserved */
        invalidate_de_cache();
        return 1;
    }
    if ((IS_8085()) && off >= 0 && off <= 255) {
        emit(out, "ld\tde,sp+%d", off);         /* DE = &slot (dead after) */
        emit(out, "ld\t(de),hl");               /* HL preserved */
        invalidate_de_cache();
        return 1;
    }
    /* z80 sp-mode large-offset byte walk: HL is needed for the slot address, so
       stage the value in DE and LEAVE it there — forcing it back to HL would
       cost the very `ex de,hl` we are eliminating. Return 0 so the caller caches
       DE. Identical cost to store_hl's fallback. */
    emit(out, "ex\tde,hl");        /* DE = value; HL scratch for the address */
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),e%s", vol_stamp(f, vreg_id));
    emit(out, "inc\thl");
    emit(out, "ld\t(hl),d");
    invalidate_hl_cache();         /* HL holds the slot address, not the value */
    return 0;                      /* value left in DE */
}

/* Byte-home residency state. Defined here (ahead of the byte
   load/store emitters that read them); helper functions live further down. */
/* Home-resident loop: the bb-id span [lo,hi] of a loop the slot-backed E/D
   home stays register-resident across (compute_home_region proves every body
   op preserves E and the home is live-in at the header). Within it the
   per-iteration spill is suppressed and residency is ASSERTED at the header
   (the single forward pass can't carry E in over the unlowered back-edge).
   -1 = no such loop. */
/* Word DE-home only: id of a dedicated loop-exit block (reached ONLY from the
   resident region) at whose entry the home is flushed ONCE — hoisting the
   flush off the per-iteration header path. -1 = not applicable → fall back to
   the per-iter header flush. */

/* Windowed A-carry safety gate (RESIDENCY_HANDOVER first increment). Caching A
   after a slot read (so a chained reader — same BB or, via bb_a_out, the next
   compare-arm BB — elides the reload) is sound only while A's belief cannot go
   stale. The whole-function `wc<=1` gate is the conservative superset. Relax it
   to a per-op reaching check: it is ALSO safe to cache when the vreg is
   READ-ONLY for the remainder of the current BB — i.e. no later op in this BB
   rewrites it (dst==v or a POSTSTEP on v). Any such later write (e.g. an
   `inc (ix+d)` loop-counter poststep that bypasses A) would leave the A cache
   pointing at a stale value; the read-only-to-BB-end window forbids exactly
   that. Cross-BB carry is separately gated by bb_a_out (consensus + live_in),
   and the A cache is reset at every BB entry, so within-BB read-only suffices. */
static int a_cache_carry_safe(const Func *f, int vreg_id)
{
    (void)f;
    if (L.vreg_wc && L.vreg_wc[vreg_id] <= 1) return 1;   /* never rewritten */
    /* Widened window (IR_A_CARRY): also safe when the VREG is READ-ONLY for the
       rest of this BB (no later dst==v / POSTSTEP on v). Historically this alone
       was UNSOUND — it ignores PHYSICAL A being clobbered between the cache_a and
       the reuse (a class of direct `ld a,…` inline emits). It is sound ONLY paired
       with the vemit invalidate-by-default A tracker (also gated on IR_A_CARRY),
       which drops rs.a
       across any A-value-changing line. Cross-BB carry stays gated by bb_a_out;
       the A-cache resets at every BB entry, so within-BB read-only suffices. */
    if (!a_carry_enabled()) return 0;
    if (!cur_bb) return 0;                                /* no context → refuse */
    for (int j = cur_op_idx + 1; j < cur_bb->n_ops; j++) {
        const Op *o = &cur_bb->ops[j];
        if (o->dst == vreg_id) return 0;
        if (o->kind == IR_POSTSTEP && o->src[0] == vreg_id) return 0;
    }
    return 1;
}

/* Load 8-bit value from a vreg's frame slot into A. Cache-aware:
   if A already holds the wanted vreg, skip the slot read. */
static void load_byte_to_a(FILE *out, const Func *f, int vreg_id)
{
    /* AF-parked NO_SLOT byte (store_a_byte pushed it): pop it back. LIFO — only
       the top entry, and only while still at TOS (cur_sp_adjust unchanged since
       the park). Checked before the A-cache so the push always balances. */
    if (L.af_park_depth > 0
        && L.af_park_vreg[L.af_park_depth - 1] == vreg_id
        && L.cur_sp_adjust == L.af_park_spadj[L.af_park_depth - 1]) {
        emit_sp(out, -2, "pop\taf");
        L.af_park_depth--;
        cache_a(vreg_id);
        return;
    }
    /* Stack-transient word parked at TOS: pop into HL, low byte → A. Before the
       A-cache hit so a stale a_has can't skip the pop. */
    if (vreg_is_pr_stack(f, vreg_id) && stack_parked(vreg_id)) {
        ss_note_reload(f, vreg_id);
        emit_sp(out, -2, "pop\thl");
        L.cur_stack_resident = -1;
        emit(out, "ld\ta,l");
        cache_a(vreg_id);
        return;
    }
    if (a_has(vreg_id)) return;
    /* Index-half home: always valid (slotless, never clobbered) — read direct. */
    PhysReg ih = idxhalf_phys(f, vreg_id);
    if (ih != IR_PR_NONE) {
        emit(out, "ld\ta,%s", idxhalf_reg(ih));
        cache_a(vreg_id);
        return;
    }
    /* Byte home (PR_C/E/D/B): when the register currently holds this vreg,
       read it directly (C-home: always; E/D-home: when not clobbered). */
    PhysReg bh = byte_home_phys(f, vreg_id);
    if (bh != IR_PR_NONE && byte_home_holds(vreg_id)) {
        emit(out, "ld\ta,%s", byte_home_reg(bh));
        cache_a(vreg_id);
        return;
    }
    /* Byte values held in HL/DE keep the meaningful byte in the low
       register (L / E). Honour those caches so a producer that left the
       byte in HL (no spill) is still readable. */
    if (hl_has(vreg_id)) { ss_note_cache_read(f, vreg_id); emit(out, "ld\ta,l"); return; }
    if (de_has(vreg_id)) { ss_note_cache_read(f, vreg_id); emit(out, "ld\ta,e"); return; }
    /* A word resident in BC keeps its low byte in C — read it directly.
       Without this a byte-extract of a BC-homed value (e.g. `i & 15` where the
       induction var i rides BC) fell to a SLOT read of a slot the BC home never
       writes → stale value (all-'a' fill bug). Mirrors the DE case. */
    if (bc_has(vreg_id)) { ss_note_cache_read(f, vreg_id); emit(out, "ld\ta,c"); return; }
    /* idx2-homed word: the whole vreg lives in the spare index register with NO
       stack slot, so the slot read below would address a NO_SLOT (-1) offset
       below sp — garbage. Recover the word into HL (push/pop works on every CPU
       that has idx2, incl. rabbit/kc160 which lack index-half byte access) and
       take the low byte. z80/z80n never reach here for a byte-read counter —
       idx2_counter_hostile_use keeps it out of idx2 there; on ez80/kc160/rabbit
       the gate is off, so this is the byte-read that was mis-lowered. */
    if (vreg_in_idx2(f, vreg_id) && f->vregs[vreg_id].width == 2) {
        emit_idx_word_to_reg(out, f, vreg_id, "hl");
        emit(out, "ld\ta,l");
        invalidate_hl_cache();
        cache_a(vreg_id);
        return;
    }
    /* [IR_BYTE_REMAT] Rematerialise a single-use global byte load into A. */
    {
        const Op *br = byte_remat_of(f, vreg_id);
        if (br) {
            char s[80]; byte_remat_symstr(s, sizeof s, br);
            emit(out, "ld\ta,(%s)", s);
            cache_a(vreg_id);
            return;
        }
    }
    /* A REMAT word (LD_IMM / LD_SYM / LEA) has NO SLOT by construction — its
       readers re-materialise it. The byte reads below would address its absent
       slot: slot_off returns -1, so sp-mode emitted `ld hl,-1; add hl,sp;
       ld a,(hl)` and read BELOW the stack. Re-materialise into HL and take the
       low byte. Only surfaces where the value is read a BYTE at a time — the
       word paths (load_to_hl/de/bc) already call emit_remat_word. */
    if (vreg_id >= 0 && f->vregs[vreg_id].width == 2
        && vreg_is_remat(f, vreg_id)) {
        if (emit_remat_word(out, f, vreg_id, "hl")) {
            emit(out, "ld\ta,l");
            return;
        }
    }
    /* Past the register-cache hits: a slot read follows (fp or sp). */
    ss_note_reload(f, vreg_id);
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off)) {
            emit(out, "ld\ta,(%s%+d)%s", frame_reg(), ix_off,
                 vol_stamp(f, vreg_id));
            /* A now holds the byte — cache it (non-volatile only) so a chained
               read (e.g. the same char tested in an if/switch chain, incl.
               across BBs via bb_a_out) reloads nothing. */
            if (!(f->vregs[vreg_id].flags & IR_VREG_VOLATILE)
                && a_cache_carry_safe(f, vreg_id)) cache_a(vreg_id);
            return;
        }
    }
    /* The sp-rel slot read clobbers HL with the slot address. Reuse the
       cached slot address (exact or within 2 bytes via inc/dec hl) instead
       of recomputing; emit_byte_slot_addr advertises it for the next access.
       NOTE: a slot-backed home is NOT re-homed into E on a read — the home
       register is (re)established only by a WRITE (store_a_byte). Re-homing
       on a read would put the value in E during a DE-clobbering op that
       reads it (e.g. `a + *p` promoted to `add hl,de`), corrupting E. */
    pending_spill_resolve();
    emit_byte_slot_addr(out, f, vreg_id);
    emit(out, "ld\ta,(hl)%s", vol_stamp(f, vreg_id));
    if (!(f->vregs[vreg_id].flags & IR_VREG_VOLATILE)
                && a_cache_carry_safe(f, vreg_id)) cache_a(vreg_id);
}

/* Store A to a vreg's 8-bit frame slot. Clobbers HL+E. Wrapper sets the
   [IR_DEADSTORE] write context (save/restore — nests via pending_spill_resolve)
   so every slot_off it makes counts as a write, not a read. */
static void store_a_byte_impl(FILE *out, const Func *f, int vreg_id);
static void store_a_byte(FILE *out, const Func *f, int vreg_id)
{
    int save = slot_write_ctx; slot_write_ctx = 1;
    store_a_byte_impl(out, f, vreg_id);
    slot_write_ctx = save;
}
static void store_a_byte_impl(FILE *out, const Func *f, int vreg_id)
{
    /* [IR_DEADSTORE] Dead spill: the slot is written but never read (proven by
       the read/write split, coalescing-checked). Skip the store entirely — A
       already holds the value; cache it so every use (same BB, or the next via
       bb_a_out) reads it from A. ir_assign_slots dropped the slot, so there is
       nothing to write; the frame shrinks and deadframe may go frameless. Set
       only on the re-lower (first render never has it), width-1 only. */
    if (f->vregs[vreg_id].flags & IR_VREG_DEAD_SPILL) {
        cache_a(vreg_id);
        return;
    }
    /* Index-half home: write the half, keep A cached. Slotless + clobber-free
       so no slot store, no dirty tracking — the value simply rides the half. */
    PhysReg ih = idxhalf_phys(f, vreg_id);
    if (ih != IR_PR_NONE) {
        emit(out, "ld\t%s,a", idxhalf_reg(ih));
        cache_a(vreg_id);
        return;
    }
    /* Byte home: keep the value in the home register, elide the slot store.
       - C/B (slotless): rides the register for the whole function.
       - E/D (slot-backed): mark DIRTY — spilled to the slot before a
         DE-clobbering op or at a BB end (byte_home_flush). */
    PhysReg bh = byte_home_phys(f, vreg_id);
    if (bh != IR_PR_NONE) {
        emit(out, "ld\t%s,a", byte_home_reg(bh));
        byte_home_note(vreg_id);
        if (byte_home_slotbacked(bh)) L.cur_byte_home_dirty = 1;
        cache_a(vreg_id);   /* A still holds the value — next read elides */
        return;
    }
    /* No real slot (NO_SLOT byte, slot_off == -1): the value in A must survive
       whatever clobbers A before its use (e.g. a store whose address load uses
       `ld a,(hl+)`). Park it with `push af` — a real, interrupt-safe stack slot —
       NOT the old `ld (ix-(frame+1)),a` / sp-1 write below sp. load_byte_to_a's
       AF-park path pops it. cur_sp_adjust holds +2 so sp-relative slot reads in
       between stay correct (fp ix-relative reads are unaffected). LIFO-nested. */
    if (slot_off(f, vreg_id) < 0 && L.af_park_depth < 4) {
        emit_sp(out, 2, "push\taf");
        L.af_park_vreg[L.af_park_depth]  = vreg_id;
        L.af_park_spadj[L.af_park_depth] = L.cur_sp_adjust;
        L.af_park_depth++;
        L.rs.a = -1;   /* value now lives at TOS; readers must go through the pop */
        return;
    }
    /* A still physically holds the stored byte after any of the slot-store paths
       below (none clobbers A). Advertise it so an immediately-following
       load_byte_to_a(v) elides the reload AT SOURCE — the byte analog of inc1
       (what copt #269/#R2 recover post-hoc). Slot-backed here ⇒ recoverable, and
       the default-on A-invalidator drops rs.a if a later op value-changes A, so
       the belief can't go stale. Gated on a_carry_enabled() (IR_A_CARRY=0 =
       pre-tracker, byte-identical) and !VOLATILE (a volatile must reload). */
    int a_stays = a_carry_enabled()
                  && !(f->vregs[vreg_id].flags & IR_VREG_VOLATILE);
    if (fp_active(f)) {
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off)) {
            emit(out, "ld\t(%s%+d),a%s", frame_reg(), ix_off,
                 vol_stamp(f, vreg_id));
            if (a_stays) cache_a(vreg_id);
            return;
        }
    }
    /* Address cache live ⇒ no pending spill (a cached address implies
       rs.hl==-1), and inc/dec hl all preserve A — so store A directly via
       emit_byte_slot_addr, no E-stash. The address survives sp moves (absolute
       slot address is fixed), so no spadj match required. */
    if (L.cur_hl_addr_off >= 0) {
        emit_byte_slot_addr(out, f, vreg_id);
        emit(out, "ld\t(hl),a%s", vol_stamp(f, vreg_id));
        if (a_stays) cache_a(vreg_id);
        return;
    }
    /* No address cache: flush any pending spill (while HL still holds it),
       then materialize the slot address. `ld hl,off; add hl,sp` and the
       flush both leave A untouched, so store A directly — no E-stash. */
    pending_spill_resolve();
    int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "ld\t(hl),a%s", vol_stamp(f, vreg_id));
    /* HL clobbered with the slot address — drop stale cache claims (a
       caller may have cached the deref base in HL), then advertise HL as
       this slot's address for the next same-slot access. */
    invalidate_hl_cache();
    cache_hl_slot_addr(f, vreg_id);
    if (a_stays) cache_a(vreg_id);
}

/* Load 4-byte (long) value from a vreg's frame slot into DEHL.
   DE = high half, HL = low half. Slot layout little-endian:
   slot+0..1 = low, slot+2..3 = high. Clobbers BC (low-half scratch).
   `sp_adj` compensates for caller pushes since the slot offset was last
   canonical. Pass 0 if sp is at its frame-entry position. */

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

/* ---- IR_TRANSIENT_WHY (inert probe, BYTEWISE_LONG_PLAN inc 0) ----------------
   Sizes the stack-transient long churn (the `pop hl;pop de … push de;push hl`
   whole-value materialise + re-park) that could instead be an in-place (ix±d)
   byte-ALU. Logged at the four TOS pop/push sites in load_to_dehl_adj / store_dehl,
   where cur_sp_adjust and the slot offset are EXACT (an IR-level probe can't know
   cur_sp_adjust). "ix-range" = the transient's (ix+d..ix+d+3) fits ±128 ⇒ directly
   addressable in place. IR_TRANSIENT_WHY=1 counts; =2 also logs each site. */
static int  tw_on = -1;
static long tw_L_fp, tw_L_fp_in, tw_L_sp, tw_S_fp, tw_S_fp_in, tw_S_sp;
/* consumer(load)/producer(store) op-kind buckets via lower_cur_op. A load whose
   consumer is an in-place ALU is the CONVERTIBLE win (the DEHL materialise could
   be a byte-ALU at (ix+d)); push/ret/call/stmem are genuine whole-value uses. */
enum { TWB_ALU, TWB_PUSH, TWB_RET, TWB_CALL, TWB_STMEM, TWB_OTHER, TWB_N };
static const char *tw_bnames[TWB_N] = { "alu","push","ret","call","stmem","other" };
static long tw_L_bkt[TWB_N], tw_S_bkt[TWB_N];
/* store→reload round-trip: a transient store of V immediately followed (next
   churn) by a transient load of V — the pop/push cycle a slot-resident in-place
   op would have avoided entirely. */
static int  tw_last_store_vreg = -1;
static long tw_roundtrip;
static int tw_bucket(int kind)
{
    switch (kind) {
      case IR_ADD: case IR_SUB: case IR_AND: case IR_OR: case IR_XOR: return TWB_ALU;
      case IR_PUSH_ARG: return TWB_PUSH;
      case IR_RET:      return TWB_RET;
      case IR_CALL: case IR_HCALL: return TWB_CALL;
      case IR_ST_MEM:   return TWB_STMEM;
      default:          return TWB_OTHER;
    }
}
static void tw_report(void)
{
    fprintf(stderr,
        "IR_TRANSIENT_WHY: load fp=%ld(ixr %ld) sp=%ld | store fp=%ld(ixr %ld) sp=%ld"
        " | fp addressable=%ld/%ld | store->reload round-trips=%ld\n",
        tw_L_fp, tw_L_fp_in, tw_L_sp, tw_S_fp, tw_S_fp_in, tw_S_sp,
        tw_L_fp_in + tw_S_fp_in, tw_L_fp + tw_S_fp, tw_roundtrip);
    fprintf(stderr, "  load-consumer :");
    for (int i = 0; i < TWB_N; i++) fprintf(stderr, " %s=%ld", tw_bnames[i], tw_L_bkt[i]);
    fprintf(stderr, "\n  store-producer:");
    for (int i = 0; i < TWB_N; i++) fprintf(stderr, " %s=%ld", tw_bnames[i], tw_S_bkt[i]);
    fprintf(stderr, "\n  ==> in-place-ALU convertible (load-consumer=alu, ix-range): "
                    "see load-consumer alu vs fp-addressable\n");
}
static void tw_log(int vreg, int is_store, int is_fp, int off, int in_range)
{
    if (tw_on < 0) {
        const char *e = getenv("IR_TRANSIENT_WHY");
        tw_on = e ? atoi(e) : 0;
        if (tw_on > 0) atexit(tw_report);
    }
    if (!tw_on) return;
    int b = lower_cur_op ? tw_bucket(lower_cur_op->kind) : TWB_OTHER;
    if (is_store) {
        if (is_fp) { tw_S_fp++; if (in_range) tw_S_fp_in++; } else tw_S_sp++;
        tw_S_bkt[b]++;
        tw_last_store_vreg = vreg;
    } else {
        if (is_fp) { tw_L_fp++; if (in_range) tw_L_fp_in++; } else tw_L_sp++;
        tw_L_bkt[b]++;
        if (vreg == tw_last_store_vreg) tw_roundtrip++;
        tw_last_store_vreg = -1;
    }
    if (tw_on >= 2)
        fprintf(stderr, "  tw %s/%s v%d off=%d ixr=%d cons=%s\n",
                is_store ? "S" : "L", is_fp ? "fp" : "sp", vreg, off, in_range,
                lower_cur_op ? tw_bnames[b] : "?");
}

/* Publish the DEHL cache after a long load that left the high half in DE and
   the low half in HL. The cache invariant is "BC = low half when rs.dehl is
   set", so normally stash BC=HL and claim dehl=vreg_id: a later load_to_dehl
   hit recovers HL via `ld hl,bc`. When the caller signalled no_bc (a
   byte-direct unary chain — IR_NOT/IR_NEG — that walks H/L/E/D through A and
   never reads BC), skip the stash AND don't publish the BC-implying claim, or
   that later `ld hl,bc` would read stale BC. */
static void publish_dehl_from_hl(FILE *out, int vreg_id, int no_bc)
{
    if (!no_bc)
        emit(out, "ld\tbc,hl");
    hl_about_to_change(vreg_id);
    if (no_bc) L.rs.dehl = -1;
    else       cache_dehl(vreg_id);
}

static void load_to_dehl_adj(FILE *out, const Func *f, int vreg_id, int sp_adj)
{
    int no_hl = L.la.cur_load_to_dehl_no_hl;
    L.la.cur_load_to_dehl_no_hl = 0;
    /* Capture + reset the no-BC-stash request up front: every early return
       below must consume it, else it leaks into the NEXT load_to_dehl and
       wrongly suppresses that load's BC stash. */
    int no_bc = L.la.cur_load_to_dehl_no_bc;
    L.la.cur_load_to_dehl_no_bc = 0;
    /* The long-load emits below all clobber HL. Flush a pending width-2
       spill first. The no-emit returns are safe: the no_hl cache-hit means
       the caller overwrites HL itself, and the rs.hl==vreg_id hit can't
       coincide with a width-2 pending (different widths). */
    pending_spill_resolve();
    if (dehl_has(vreg_id)) {
        /* Cache hit: DE has high half, BC has low half. Recover HL with
           `ld hl,bc` (~12 T-states) vs ~120 for a full slot read. Skip the
           recovery when no_hl is set (caller overwrites HL) OR when
           rs.hl == vreg_id (HL already holds the low half from a prior
           cache_dehl_no_spill). */
        /* Lazy-spill pass 1: a genuine register serve, NOT a slot reload — the
           value is in DE:BC (the cache invariant, invalidated at every BB
           boundary so this is precise within the BB). Recording it lets a
           preceding width-4 spill store be proven dead. */
        ss_note_cache_read(f, vreg_id);
        if (!no_hl && L.rs.hl != vreg_id) {
            emit(out, "ld\thl,bc");
        }
        if (!no_hl) hl_about_to_change(vreg_id);
        return;
    }
    /* Narrower-than-long vreg read AS a long: load it at its OWN width and
       sign-extend into DEHL — the C integer widening (char/int → long) — rather
       than reading `width` valid bytes plus (4-width) garbage bytes past its
       (narrower) slot. This makes a kind/width-split vreg (kind LONG but width 2,
       e.g. a long-typed `x+r` whose int operands leave it width-2) read back
       correctly wherever it is later used as a long, instead of pulling a
       neighbouring slot's bytes in as the high half. */
    if (f->vregs[vreg_id].width == 2) {
        int save = L.cur_sp_adjust;
        L.cur_sp_adjust += sp_adj;              /* sp-rel slot at sp+sp_adj (fp: ignored) */
        load_to_hl(out, f, vreg_id);            /* HL = the 2 valid bytes */
        L.cur_sp_adjust = save;
        emit(out, "push\taf");                  /* preserve caller's A/flags */
        emit(out, "ld\ta,h");
        emit(out, "rlca");
        emit(out, "sbc\ta,a");                  /* A = 0x00 / 0xFF (sign of HL) */
        emit(out, "ld\te,a");
        emit(out, "ld\td,a");                   /* DE = sign extension */
        emit(out, "pop\taf");
        publish_dehl_from_hl(out, vreg_id, no_bc);
        return;
    }
    if (f->vregs[vreg_id].width == 1) {
        int save = L.cur_sp_adjust;
        L.cur_sp_adjust += sp_adj;
        load_byte_to_a(out, f, vreg_id);        /* A = the byte */
        L.cur_sp_adjust = save;
        emit(out, "ld\tl,a");
        emit(out, "rlca");
        emit(out, "sbc\ta,a");
        emit(out, "ld\th,a");
        emit(out, "ld\te,a");
        emit(out, "ld\td,a");                   /* DEHL = sign-extended byte */
        invalidate_a_cache();
        publish_dehl_from_hl(out, vreg_id, no_bc);
        return;
    }
    /* FP-relative long load. sp_adj is irrelevant for the IX-addressed
       path below, but NOT for the TOS pop/push trick (sp-relative): with
       sp_adj>0 the slot is at sp+sp_adj, so the trick would pop the
       just-pushed value — fall through to IX addressing there. */
    if (fp_active(f)) {
        /* Deepest slot at TOS: pop hl;pop de beats the synthetic long
           ld (4x ld r,(ix+d) = 12B/76t vs 6B/50t). By-coincidence only. */
        if (sp_adj == 0 && fp_tos_slot(f, vreg_id)) {
            { int ixo = slot_ix_off(f, vreg_id);
              tw_log(vreg_id, 0, 1, ixo,
                     fp_offset_fits(ixo) && fp_offset_fits(ixo + 3)); }
            ss_note_reload(f, vreg_id);
            emit(out, "pop\thl");           /* HL = low half (bytes 0-1) */
            emit(out, "pop\tde");           /* DE = high half (bytes 2-3) */
            emit(out, "push\tde");
            emit(out, "push\thl");
            publish_dehl_from_hl(out, vreg_id, no_bc);
            return;
        }
        int ix_off = slot_ix_off(f, vreg_id);
        if (fp_offset_fits(ix_off) && fp_offset_fits(ix_off + 3)) {
            ss_note_reload(f, vreg_id);   /* defensive: width-2 never here */
            emit(out, "ld\thl,(%s%+d)", frame_reg(), ix_off);
            emit(out, "ld\tde,(%s%+d)", frame_reg(), ix_off + 2);
            /* Set BC=HL (low) so the DEHL cache invariant (BC = low half
               when rs.dehl is set) holds, then publish. publish_dehl_from_hl
               skips the stash when the caller won't read BC. */
            publish_dehl_from_hl(out, vreg_id, no_bc);
            return;
        }
    }
    ss_note_reload(f, vreg_id);       /* defensive: width-2 never here */
    require_slot(f, vreg_id);
    int off = slot_off(f, vreg_id) + sp_adj + L.cur_sp_adjust;
    /* Top-of-stack long load: a slot at sp+0 read whole with `pop hl;
       pop de` (HL=low, DE=high), the two pushes put it back — no address
       compute, no 4-byte walk. sp-mode + tos_pushpop_ok only. */
    if (off == 0 && !fp_active(f) && tos_pushpop_noex_ok(f)) {
        tw_log(vreg_id, 0, 0, off, off + 2 <= sp_rel_max(f));
        emit(out, "pop\thl");           /* HL = low half (bytes 0-1) */
        emit(out, "pop\tde");           /* DE = high half (bytes 2-3) */
        emit(out, "push\tde");
        emit(out, "push\thl");
        publish_dehl_from_hl(out, vreg_id, no_bc);
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
        /* HL now holds the low half — advertise it so rs.hl is honest
           (else a stale tenant leaks into bb_hl_out and a merge carry
           trusts HL holding the wrong vreg). */
        hl_about_to_change(vreg_id);
        cache_dehl(vreg_id);
        return;
    }
    /* 8085 sp-relative long load: LDSI + LHLX per half, the extended-op
       analogue of the Rabbit/kc160 path above. Read the LOW half first so it
       can go straight to BC (the DEHL cache invariant) while DE is still free
       to address the high half — 52c/9B against the byte walk's 66c/11B, and
       60c/11B against 74c/13B when HL has to end up holding the low half.
       A is untouched either way. LDSI's offset is an unsigned byte. */
    if (IS_8085() && !opt_disabled("lhlx-long") && off >= 0 && off + 2 <= 255) {
        emit(out, "ld\tde,sp+%d", off);
        emit(out, "ld\thl,(de)");    /* HL = low half */
        emit(out, "ld\tbc,hl");      /* BC = low half (cache invariant) */
        emit(out, "ld\tde,sp+%d", off + 2);
        emit(out, "ld\thl,(de)");    /* HL = high half */
        emit(out, "ex\tde,hl");      /* DE = high half, HL = the address */
        if (!no_hl)
            emit(out, "ld\thl,bc");  /* HL = low half */
        hl_about_to_change(no_hl ? -1 : vreg_id);
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
    /* Keep rs.hl honest: HL holds the low half (!no_hl) or junk (no_hl).
       Else a stale tenant feeds bb_hl_out and makes an if/else (or ||/&&)
       merge carry trust HL holding a vreg it didn't — e.g. `return
       (long_v || 0)` returning 0 on the short-circuit edge (sp-mode). */
    hl_about_to_change(no_hl ? -1 : vreg_id);
    cache_dehl(vreg_id);
}

static void load_to_dehl(FILE *out, const Func *f, int vreg_id)
{
    load_to_dehl_adj(out, f, vreg_id, 0);
}

/* Store 4-byte (long) value DEHL to a vreg's frame slot. Leaves the
   value in DEHL after the store; high half stays in DE. Clobbers BC. */
/* One-shot flag: when set, load_to_dehl_adj skips the trailing HL restore
   from BC. Callers set this when the next instruction overwrites HL (e.g.
   `pop hl`). After: BC = low half, DE = high half, HL = junk. */

static void store_dehl(FILE *out, const Func *f, int vreg_id)
{
    /* FP-relative long store. Preserves HL+DE entirely — no BC stash
       needed. PR_BC vregs survive across long stores when FP is on. */
    if (fp_active(f)) {
        /* Deepest slot at TOS: discard the word (pop bc x2) and re-push
           DEHL — beats the synthetic long store. HL+DE kept, BC=low
           (contract). By-coincidence only. */
        if (fp_tos_slot(f, vreg_id)) {
            { int ixo = slot_ix_off(f, vreg_id);
              tw_log(vreg_id, 1, 1, ixo,
                     fp_offset_fits(ixo) && fp_offset_fits(ixo + 3)); }
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
            /* Rabbit has a native `ld (ix+d),hl` (2 bytes) but NOT the DE form,
               which z80asm synthesises as two `ld (ix+d),r` = 6 bytes. Swapping
               the halves around the store costs 4 (ex + native + ex) and is
               faster too. ez80/kc160 have both natively at 3 bytes, so they take
               the direct form; plain z80 synthesises either way. */
            if (IS_RABBIT()) {
                emit(out, "ex\tde,hl");
                emit(out, "ld\t(%s%+d),hl", frame_reg(), ix_off + 2);
                emit(out, "ex\tde,hl");
            } else {
                emit(out, "ld\t(%s%+d),de", frame_reg(), ix_off + 2);
            }
            /* DEHL cache contract: BC = low half so a later load_to_dehl_adj
               cache hit recovers HL via `ld hl,bc`. Dead when the next op
               clobbers BC first — store_dehl_cached then drops the claim. */
            if (!L.la.cur_store_dehl_bc_dead)
                emit(out, "ld\tbc,hl");
            return;
        }
    }
    int off = slot_off(f, vreg_id) + L.cur_sp_adjust;
    /* Top-of-stack long store: overwrite the sp+0 slot in place — discard
       its 4 bytes (`pop bc; pop bc`, BC clobbered by contract) and re-push
       DEHL. No address compute, no 4-byte walk, and HL stays valid (low
       half) afterwards. sp-mode + tos_pushpop_ok only. */
    if (off == 0 && !fp_active(f) && tos_pushpop_noex_ok(f)) {
        tw_log(vreg_id, 1, 0, off, off + 2 <= sp_rel_max(f));
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
    /* 8085 sp-relative long store: SHLX the HIGH half, byte-walk the low one
       DOWNWARDS. Only the high half can go through SHLX — the exit contract is
       DE = high half, and SHLX wants the address in DE, so a second `ld (de),hl`
       would leave DE holding an address instead of the value. Storing the high
       half first and swapping back recovers DE (`ex de,hl` after the store puts
       the value back), and the low half's two bytes go out through HL, which
       reads B and C without disturbing DE. 62c/11B against 74c/13B.
       A is untouched. LDSI's offset is an unsigned byte. */
    if (IS_8085() && !opt_disabled("lhlx-long") && off >= 0 && off + 2 <= 255) {
        emit(out, "ld\tbc,hl");          /* BC = low half (contract) */
        emit(out, "ex\tde,hl");          /* HL = high half */
        emit(out, "ld\tde,sp+%d", off + 2);
        emit(out, "ld\t(de),hl");        /* slot+2..3 = high half */
        emit(out, "ex\tde,hl");          /* DE = high half again (contract) */
        emit(out, "dec\thl");            /* HL = &slot+1 */
        emit(out, "ld\t(hl),b");         /* slot+1 = low half, high byte */
        emit(out, "dec\thl");            /* HL = &slot+0 */
        emit(out, "ld\t(hl),c");         /* slot+0 = low half, low byte */
        return;
    }
    /* Stash low half (HL) into BC so HL is free for slot addressing (BC is
       clobbered by contract). 8 T-states for ld bc,hl vs 21 for the
       push hl ... pop bc round trip. */
    emit(out, "ld\tbc,hl");      /* BC = low (B=hi byte, C=lo byte) */
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");         /* HL = &slot+0 */
    store_byte_adv(out, "c", 0);
    store_byte_adv(out, "b", 0);
    store_byte_adv(out, "e", 0);
    store_byte_adv(out, "d", 1);
    /* HL now points one past slot+3 — junk. store_dehl leaves HL invalid;
       callers needing HL=low must reload via ld l,c; ld h,b. */
}

/* store_dehl + cache wire-up for long-result op sites. After store_dehl:
   HL junk, DE=high, BC=low. Invalidate HL/DE/DEHL then re-cache DEHL=vreg
   so a follow-on load_to_dehl(vreg) recovers via `ld l,c; ld h,b`. */
static void cache_dehl_no_spill(FILE *out, int vreg_id);

static void store_dehl_cached(FILE *out, const Func *f, int vreg_id)
{
    /* Lazy-spill: skip a provably-dead width-4 slot store (its slot is
       overwritten / unread before any reload within the BB — a cross-BB reader
       would have reloaded, keeping it live). The value stays in DE:HL; establish
       the BC=low half of the DEHL cache invariant (a cheap `ld bc,hl` vs the
       ~11-instruction slot walk) so same-BB cache-served readers recover via
       `ld hl,bc`. Mirrors spill_and_swap_unless_dead for width-2. */
    ss_note_store(f, vreg_id);
    if (!L.la.cur_store_dehl_bc_dead && ss_store_dead_here()) {
        /* This IS the no-spill case, so publish it the same way
           cache_dehl_no_spill does rather than hand-rolling a weaker version.
           Both arrive with DE=high and HL=low and write no slot; the only
           difference was that this branch then threw the HL knowledge away
           (invalidate_hl_cache), which forces every later read through
           `ld hl,bc` and therefore makes the `ld bc,hl` stash look mandatory.
           Advertising HL instead lets a same-BB reader take the low half
           straight from the register — and lets the no-bc-stash conditions
           apply here too. */
        cache_dehl_no_spill(out, vreg_id);
        return;
    }
    int bc_dead = L.la.cur_store_dehl_bc_dead;
    store_dehl(out, f, vreg_id);
    invalidate_hl_cache();
    if (bc_dead) {
        /* store_dehl skipped the `ld bc,hl`, so BC != low — don't claim a
           DEHL cache a later hit would recover via `ld hl,bc`. Reads reload
           from the slot. */
        L.rs.bc = -1;
        L.rs.dehl = -1;
    } else {
        cache_dehl(vreg_id);
    }
}

/* Dead-dst long result: dst is dead AND the immediately-following op
   consumes it as its first DEHL load. Skip the 11-instruction slot write;
   stash the low half into BC (already in HL) so the DEHL cache invariant
   holds and the next op's load_to_dehl(dst) hits via `ld l,c; ld h,b`.
   After: DE=high, HL=low, BC=low, cache_dehl(dst). HL cache is NOT
   advertised — its content is half of a long, not an int-class value. */
static void cache_dehl_no_spill(FILE *out, int vreg_id)
{
    /* The `ld bc,hl` stash is wasted when the next consumer is the
       FP-mode byte-direct binop chain — it reads H/L directly and writes
       BC itself at the chain's tail, so subsequent ops still see BC=low. */
    if (!L.la.cur_dehl_dst_no_bc_stash)
        emit(out, "ld\tbc,hl");
    L.la.cur_dehl_dst_no_bc_stash = 0;
    /* HL still holds the long's low half (precondition). Advertise it via
       rs.hl so the next load_to_dehl cache hit can skip its `ld hl,bc`
       recovery (saves 2 bytes per chained long-binop). */
    hl_about_to_change(vreg_id);
    L.rs.de = -1;
    L.rs.dehl = vreg_id;
}

/* Forward decl: defined with the other vreg_is_pr_* helpers below. */
static int vreg_is_pr_dehl(const Func *f, int v);

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
    /* HL was consumed producing the value; claim it for OUR low half so
       the next op doesn't treat a stale tenant as an address. */
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

/* BC cache. Function-lifetime: ir_alloc marks at most one PARAM as PR_BC,
   only in a narrow envelope (no CALL/HCALL, no width-4 vregs), where BC is
   loaded by the prologue and never overwritten. load_to_hl / load_to_de
   short-circuit slot reads with `ld l,c; ld h,b` / `ld e,c; ld d,b`. */
static int bc_has(int v) { return v >= 0 && L.rs.bc == v; }
static void cache_bc(int v) { L.rs.bc = v; }
static void invalidate_bc_cache(void) { L.rs.bc = -1; }

/* Byte (A) value cache. Tracks which width-1 vreg A holds. Set when a
   byte spill is dead-skipped (value stays in A); consumed by the 1→2
   widening lowerers to skip the load_byte_to_a slot read. Heavily
   invalidated: most lowerer paths clear it via invalidate_hl_cache
   (which also clears A). */
static int a_has(int v) { return v >= 0 && L.rs.a == v; }
static void cache_a(int v) { L.rs.a = v; }
static void invalidate_a_cache(void) { L.rs.a = -1; }

/* Byte-register residency. A width-1 vreg pinned to a byte register keeps
   its value there across a loop. `cur_byte_home_vreg` is which home vreg
   currently lives in its register. PR_C/PR_B (no-call BC-clean envelope)
   are slotless and never clobbered, so the value rides for the whole
   function (never dirty). Slot-backed homes (PR_E/PR_D — low/high of DE)
   are clobbered by DE-scratch ops, so the lowerer lazy-spills: a home write
   leaves the value in the register and marks dirty (slot stale); before any
   DE-clobbering op, and before back-edge/merge exits, it is spilled E→slot
   so the slot is coherent at boundaries. bb_byte_out drives the cross-BB
   carry (mirror of bb_hl_out); cur_func_ehome is the function's E/D vreg. */
static PhysReg byte_home_phys(const Func *f, int v)
{
    if (v < 0 || !f || !f->vreg_to_phys) return IR_PR_NONE;
    PhysReg pr = ir_home_at(f, v);
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

/* Index-half byte home (PR_IXL/IXH/IYL/IYH): a SEPARATE, simpler mechanism from
   the E/D/C/B home above. Slotless and clobber-free in the no-call region the
   proposer requires, so the value is ALWAYS in its half from its def — no belief
   variable, no lazy-spill, no cross-BB carry. Recognised purely by vreg_to_phys;
   every byte read/write/ALU path consults this and routes through A (ld a,iyl /
   ld iyl,a) or uses the half as an ALU source (add a,iyl / sub iyl / cp iyl).
   z80/z80n/ez80 only (see cpu_has_index_halves). */
static PhysReg idxhalf_phys(const Func *f, int v)
{
    if (v < 0 || !f || !f->vreg_to_phys) return IR_PR_NONE;
    PhysReg pr = ir_home_at(f, v);
    if (pr == IR_PR_IXL || pr == IR_PR_IXH
        || pr == IR_PR_IYL || pr == IR_PR_IYH)
        return pr;
    return IR_PR_NONE;
}
static const char *idxhalf_reg(PhysReg pr)
{
    switch (pr) {
    case IR_PR_IXL: return "ixl";
    case IR_PR_IXH: return "ixh";
    case IR_PR_IYL: return "iyl";
    case IR_PR_IYH: return "iyh";
    default:        return NULL;
    }
}
/* Is v homed in a clobberable slot-backed byte register (PR_E/PR_D)? */
static int byte_home_is_slotbacked(const Func *f, int v)
{
    return byte_home_slotbacked(byte_home_phys(f, v));
}

/* A width-2 unsigned ordered compare lowered byte-wise (`ld a,c; sub mem; ld
   a,b; sbc a,mem`) instead of `load_binop_operands + sbc hl,de` — shorter AND
   DE/E-clean (so a slot-backed byte home survives the loop test, no spill).
   Eligible iff: ULT/UGE, branch-fused, LHS in BC, RHS in a frame slot (fp:
   both bytes' ix offsets must fit). Shared by gen_cmp and op_de_clean, which
   must agree (identical conditions) so the home isn't needlessly flushed. */
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
    if (!vreg_in_pr_bc(f, s0)) return 0;     /* LHS in BC */
    if (!vreg_is_spilled(f, s1)) return 0;   /* RHS in a slot */
    if (f->vregs[s1].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (fp_active(f)) {
        int ix = slot_ix_off(f, s1);
        if (!fp_offset_fits(ix) || !fp_offset_fits(ix + 1)) return 0;
    }
    return 1;
}

/* Word DE-home DE-clean SIGNED loop test: `i < n` / `i >= n` lowered as
   `<load n→HL>; ld a,(ix+i_lo); sub l; ld a,(ix+i_hi); sbc a,h` + the S^V
   sign correction — A/HL only, so the home in DE survives. Eligible iff:
   fp-mode, signed ordered (LT/GE), LHS (i) in an ix-addressable slot, RHS (n)
   any non-home width-2 vreg loadable to HL, branch-fused. */
static int word_dehome_signed_test_shape_ok(const Func *f, const Op *o)
{
    if (!g_hc.home_is_word || !fp_active(f)) return 0;
    if (o->kind != IR_CMP_LT && o->kind != IR_CMP_GE) return 0;
    int s0 = o->src[0], s1 = o->src[1];
    if (s0 < 0 || s1 < 0 || s0 >= f->n_vregs || s1 >= f->n_vregs) return 0;
    if (f->vregs[s0].width != 2 || f->vregs[s1].width != 2) return 0;
    if (!f->vreg_to_phys || !f->vreg_spill_slot) return 0;
    if (!vreg_is_spilled(f, s0)) return 0;   /* LHS i in a slot */
    if (f->vreg_spill_slot[s0] < 0) return 0;
    if (f->vregs[s0].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (s1 == g_hc.func_whome) return 0;                 /* RHS not the home */
    int ix = slot_ix_off(f, s0);
    if (!fp_offset_fits(ix) || !fp_offset_fits(ix + 1)) return 0;
    return 1;
}

/* A width-2 vreg in a frame slot reachable via (ix+d) in fp mode — a byte at
   (ix+d)/(ix+d+1) can be folded straight into an ALU/compare op instead of
   reloading the whole word into a pair. Ordinary spilled locals + PARAM_IN_PLACE. */
static int op_is_ixd_slot(const Func *f, int v)
{
    if (v < 0 || v >= f->n_vregs) return 0;
    if (!fp_active(f)) return 0;
    if (f->vregs[v].width != 2) return 0;
    if (f->vregs[v].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    /* A rematerialisable constant must be read by re-emitting the constant, not
       via an (ix+d) slot: two remat vregs can share a slot the allocator leaves
       unwritten, or collide onto one slot, so the read returns garbage / the
       wrong operand (`a<b` byte-walked to `ld a,(ix-3); sub (ix-3)` =
       self-compare). Mirror of load_binop_operands'
       both-remat handling; the load path rematerialises correctly. */
    if (g_hc.remat_def && g_hc.remat_def[v]) return 0;
    if (!vreg_is_spilled(f, v)) return 0;
    if (slot_off(f, v) < 0) return 0;
    int ix = slot_ix_off(f, v);
    return fp_offset_fits(ix) && fp_offset_fits(ix + 1);
}

/* Fill lo[]/hi[] with the 8-bit ALU operand for each byte of vreg v, read IN
   PLACE — a register-pair half (c/b, l/h, e/d), an (ix+d) slot, or an idx2 half
   (iyl/iyh). Returns 2 if v is memory/index (folding it saves a pair load/push),
   1 if it's a gp-register pair (cheap either way), 0 if unreadable in place.
   Shared by the compare fold (ir_lower_cmp) and the ALU fold (ir_lower_ops). */
static int cmp_byte_src(const Func *f, int v, int idxhalf_ok,
                        char *lo, char *hi, size_t n)
{
    if (bc_has(v)) { snprintf(lo,n,"c"); snprintf(hi,n,"b"); return 1; }
    if (hl_has(v)) { snprintf(lo,n,"l"); snprintf(hi,n,"h"); return 1; }
    if (de_has(v)) { snprintf(lo,n,"e"); snprintf(hi,n,"d"); return 1; }
    /* Resident word DE-home: the DE regcache belief may be dropped at a region
       header (residency is asserted via byte_home_holds, not cache_de), so
       consult residency directly — the home rides e/d by the region proof. */
    if (g_hc.home_is_word && v == g_hc.func_whome && v >= 0
        && byte_home_holds(v) && f->vregs[v].width == 2) {
        snprintf(lo, n, "e"); snprintf(hi, n, "d"); return 1;
    }
    if (op_is_ixd_slot(f, v)) {
        int ix = slot_ix_off(f, v);
        snprintf(lo, n, "(%s%+d)", frame_reg(), ix);
        snprintf(hi, n, "(%s%+d)", frame_reg(), ix + 1);
        return 2;
    }
    if (idxhalf_ok && vreg_in_idx2(f, v) && f->vregs[v].width == 2) {
        const char *r = vreg_idx_name(f, v);
        snprintf(lo, n, "%sl", r); snprintf(hi, n, "%sh", r);
        return 2;
    }
    return 0;
}

static int cmp_bytewise_ok(const Func *f, const Op *o)
{
    if (g_hc.branch_test_kind == 0) return 0;
    return cmp_bytewise_shape_ok(f, o);
}

/* Slot-vs-slot unsigned word compare lowered byte-wise through A
   (`ld a,(ix+lo0); sub (ix+lo1); ld a,(ix+hi0); sbc a,(ix+hi1)`) instead of two
   synthetic ix pair-loads + `sbc hl,de`. fp only; 12B/76T vs 15B/95T AND
   DE/BC/HL-clean, so a word DE-home rides through a mem-vs-mem loop test.
   ULT/UGE, both operands in ix-addressable slots. (BC-resident LHS case is
   cmp_bytewise_shape_ok; this is the both-in-frame case.) */
static int cmp_bytewise_mem_shape_ok(const Func *f, const Op *o)
{
    if (o->kind != IR_CMP_ULT && o->kind != IR_CMP_UGE) return 0;
    if (!fp_active(f)) return 0;
    int s0 = o->src[0], s1 = o->src[1];
    if (s0 < 0 || s1 < 0 || s0 >= f->n_vregs || s1 >= f->n_vregs) return 0;
    if (f->vregs[s0].width != 2 || f->vregs[s1].width != 2) return 0;
    if (!f->vreg_to_phys) return 0;
    if (!vreg_is_spilled(f, s0)) return 0;   /* both in a slot */
    if (!vreg_is_spilled(f, s1)) return 0;
    if (f->vregs[s0].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (f->vregs[s1].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    /* Remat constants have no reliable slot content — read via rematerialisation,
       not a byte-walk. See op_is_ixd_slot / load_binop_operands. */
    if (g_hc.remat_def && (g_hc.remat_def[s0] || g_hc.remat_def[s1])) return 0;
    int ix0 = slot_ix_off(f, s0), ix1 = slot_ix_off(f, s1);
    if (!fp_offset_fits(ix0) || !fp_offset_fits(ix0 + 1)) return 0;
    if (!fp_offset_fits(ix1) || !fp_offset_fits(ix1 + 1)) return 0;
    return 1;
}

static int cmp_bytewise_mem_ok(const Func *f, const Op *o)
{
    if (g_hc.branch_test_kind == 0) return 0;
    return cmp_bytewise_mem_shape_ok(f, o);
}

/* Is op `o` the word DE-home's accumulate — `home = home OP w`? It lowers to
   `add hl,de; ex de,hl` (try_word_accumulate), re-establishing DE = home
   (DE-clean). Must match try_word_accumulate's conditions exactly so the
   region analysis never disagrees with the emitter. ADD only for now;
   SUB/AND/OR/XOR pending. */
static int is_word_accumulate(const Func *f, const Op *o)
{
    if (!g_hc.home_is_word || g_hc.func_whome < 0) return 0;
    if (o->dst != g_hc.func_whome) return 0;
    if (o->kind != IR_ADD) return 0;
    if (o->src[1] < 0) return 0;                       /* needs a vreg addend */
    if (o->src[0] != o->dst && o->src[1] != o->dst) return 0;
    if (o->dst >= f->n_vregs || f->vregs[o->dst].width != 2) return 0;
    return 1;
}

/* General DE-home (cur_de_home>=0): allocation-based class of a compare operand
   for the (ix+d) fold — 1 = read cheaply from a register half (home e/d, or a
   BC/DE/HL tenant), 2 = read in place from an (ix+d) slot or an idx2 half, 0 =
   not foldable. Keyed on the FIXED physical assignment (the static region proof
   runs before the regcache is populated, so runtime caches are unknown here). */
static int cmp_fold_static_class(const Func *f, int v)
{
    if (v < 0 || v >= f->n_vregs || f->vregs[v].width != 2) return 0;
    if (v == g_hc.func_whome) return 1;              /* home rides DE (e/d) */
    if (!f->vreg_to_phys) return 0;
    int phys = ir_home_at(f, v);
    if (phys == IR_PR_BC || phys == IR_PR_DE || phys == IR_PR_HL) return 1;
    if (op_is_ixd_slot(f, v)) return 2;
    if ((c_cpu == CPU_Z80 || IS_Z80N()) && vreg_in_idx2(f, v)) return 2;
    return 0;
}

/* An int compare inside the general DE-home region that try_cmp_ixd_fold will
   lower DE-clean (reads both operands in place through A, never staging one into
   DE). Requires >=1 operand mem/idx (else the fold defers to `sbc hl,de`, which
   here PRESERVES DE only when the home is the DE operand — handled separately).
   Mirrors try_cmp_ixd_fold's structural gates so the region proof agrees with
   the emitter. Branch-fusion is checked by the callers. */
static int cmp_ixd_fold_de_clean_ok(const Func *f, const Op *o)
{
    /* Fires for the GENERAL DE-home (cur_de_home>=0) and the word-ACCUMULATOR
       home (cur_home_is_word, cur_de_home<0). In the word-acc case the fold is
       only DE-clean when NEITHER operand is the home (a bare loop test on the
       counter etc.) — mirrors try_cmp_ixd_fold's word-acc gate. */
    int word_acc = (g_hc.de_home < 0 && g_hc.home_is_word);
    if (g_hc.de_home < 0 && !word_acc) return 0;
    if (opt_disabled("ixd-fold")) return 0;
    if (!fp_active(f)) return 0;
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180)) return 0;
    switch (o->kind) {
    case IR_CMP_LT: case IR_CMP_LE: case IR_CMP_GT: case IR_CMP_GE:
    case IR_CMP_ULT: case IR_CMP_ULE: case IR_CMP_UGT: case IR_CMP_UGE:
    case IR_CMP_EQ: case IR_CMP_NE: break;
    default: return 0;
    }
    int s0 = o->src[0], s1 = o->src[1];
    if (s0 < 0 || s1 < 0 || s0 == s1) return 0;
    if (word_acc && (s0 == g_hc.func_whome || s1 == g_hc.func_whome)) return 0;
    int c0 = cmp_fold_static_class(f, s0);
    int c1 = cmp_fold_static_class(f, s1);
    if (c0 == 0 || c1 == 0) return 0;
    if (c0 == 1 && c1 == 1) return 0;    /* both gp pairs → sbc hl,de path */
    return 1;
}

/* General DE-home ALU fold: a width-2 ADD/SUB/AND/OR/XOR that try_binop_ixd_fold
   lowers byte-wise through A (`ld a,<lo>; <op> <lo'>; ld l,a; …`) reading both
   operands in place — never staging one into DE — with the result committed to a
   non-home spill slot (DE-preserving in fp). DE-clean, so a general DE-home
   survives it. Mirrors try_binop_ixd_fold's gates so the region proof agrees with
   the emitter. (ADD also has the home-operand / indexed-deref paths handled
   separately; this covers the both-operands-foldable, neither-is-home case, and
   is the ONLY path for AND/OR/XOR.) */
static int binop_ixd_fold_de_clean_ok(const Func *f, const Op *o)
{
    if (opt_disabled("alu-fold")) return 0;
    if (g_hc.de_home < 0 || opt_disabled("ixd-fold")) return 0;
    if (!fp_active(f)) return 0;
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180)) return 0;
    switch (o->kind) {
    case IR_ADD: case IR_SUB: case IR_AND: case IR_OR: case IR_XOR: break;
    default: return 0;
    }
    if (o->dst < 0 || o->dst >= f->n_vregs || f->vregs[o->dst].width != 2) return 0;
    if (o->dst == g_hc.func_whome) return 0;          /* home-def uses ex de,hl */
    if (!f->vreg_to_phys || vreg_in_pr_de(f, o->dst)) return 0; /* dst not DE */
    int s0 = o->src[0], s1 = o->src[1];
    if (s0 < 0 || s1 < 0) return 0;
    int c0 = cmp_fold_static_class(f, s0);
    int c1 = cmp_fold_static_class(f, s1);
    if (c0 == 0 || c1 == 0) return 0;
    if (c0 != 2 && c1 != 2) return 0;    /* need >=1 mem/idx (else add hl,de path) */
    return 1;
}

/* General DE-home indexed word deref address: `dst = base + (idx << k)` (k in
   1..2) with idx riding BC and base rematerializable (LD_IMM/LD_SYM). Lowered
   `ld hl,base; add hl,bc` (2^k times) — HL + BC only, so the home in DE survives.
   Shared by try_de_home_indexed_add (emitter) and op_de_clean (region proof). */
static int de_home_indexed_add_ok(const Func *f, const Op *o)
{
    if (g_hc.de_home < 0 || !g_hc.home_is_word) return 0;
    if (o->kind != IR_ADD) return 0;
    if (o->dst < 0 || o->dst >= f->n_vregs || f->vregs[o->dst].width != 2) return 0;
    if (o->src[0] < 0 || o->src[1] < 0) return 0;
    if (!f->vreg_to_phys) return 0;
    for (int which = 0; which < 2; which++) {
        int sidx = o->src[which], sbase = o->src[which ^ 1];
        const Op *d = find_unique_def(f, sidx);
        if (!d || d->kind != IR_SHL || d->src[1] >= 0) continue;
        if (d->imm < 1 || d->imm > 2) continue;
        int idx = d->src[0];
        if (idx < 0 || idx >= f->n_vregs) continue;
        if (!vreg_in_pr_bc(f, idx)) continue;
        if (!g_hc.remat_def || sbase < 0 || sbase >= f->n_vregs
            || !g_hc.remat_def[sbase]) continue;
        return 1;
    }
    return 0;
}

/* In-place array transform (`a[i] = f(acc)`) inside a word DE-home loop —
   the two DE-clean ops that a write-back through a loop pointer needs:

   1. de_home_clean_bitop_ok: a width-2 AND/OR/XOR of the DE-home (or another
      register/slot operand) with a CONSTANT, result committed to a spill slot.
      gen_bitop's const path reads src0 via load_to_hl (`ld l,e; ld h,d` for the
      home — DE-preserving), masks byte-wise through A, and commits with the fp
      DE-home fastpath (`ld (ix+d),hl`, no ex de,hl). So DE survives — the mask/
      clamp of the accumulator (`v = s & 0x7fff`) stays in-region.
   2. de_home_clean_store_ok: a width-2 store to a BC-resident or rematerialised
      base + const offset, value = the home (read E/D) or a spill slot (read via
      A). try_de_home_clean_store computes the address in HL (DE/BC-clean) and
      writes the value bytes without staging through DE.

   Both fp-only, z80-family, gated by IR_NO_DECLEAN. Mirror the emitters exactly
   so the region proof and codegen agree. */
static int de_home_clean_bitop_ok(const Func *f, const Op *o)
{
    if (opt_disabled("declean")) return 0;
    if (!g_hc.home_is_word || g_hc.func_whome < 0) return 0;
    if (!fp_active(f)) return 0;
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180)) return 0;
    if (o->kind != IR_AND && o->kind != IR_OR && o->kind != IR_XOR) return 0;
    if (o->src[1] >= 0) return 0;                      /* const RHS only */
    if (o->dst < 0 || o->dst >= f->n_vregs || f->vregs[o->dst].width != 2) return 0;
    if (o->dst == g_hc.func_whome) return 0;          /* home-def not this path */
    if (vreg_is_pr_de(f, o->dst)) return 0;            /* dst must land in a slot */
    if (!vreg_is_spilled(f, o->dst)) return 0;
    if (f->vregs[o->dst].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (!fp_offset_fits(slot_ix_off(f, o->dst))
        || !fp_offset_fits(slot_ix_off(f, o->dst) + 1)) return 0;
    int s0 = o->src[0];
    if (s0 < 0 || s0 >= f->n_vregs) return 0;
    /* src0 read by load_to_hl DE-cleanly: the home (ld l,e;ld h,d), a BC tenant
       (ld hl,bc), or a slot reload — all leave DE intact. */
    return 1;
}

/* Value class for a DE-clean store's value operand: 1 = the home (read E/D),
   2 = a spill slot (read via A), 0 = not DE-clean-readable here. Excludes an
   HL-cached value (HL holds the address) — a slot-backed value is read from its
   coherent slot regardless of the HL cache. */
static int de_clean_store_val_class(const Func *f, int v)
{
    if (v < 0 || v >= f->n_vregs || f->vregs[v].width != 2) return 0;
    if (v == g_hc.func_whome) return 1;               /* home → E/D (any mode) */
    if (!fp_active(f)) return 0;                        /* slot read needs HL; sp: HL=addr */
    if (!vreg_is_spilled(f, v)) return 0;
    if (f->vregs[v].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (!op_is_ixd_slot(f, v)) return 0;
    return 2;
}

/* A write-back store's base is reachable DE/BC-clean: BC-resident or a
   rematerialisable constant/address. Shared by the plain and masked stores. */
static int de_clean_store_base_ok(const Func *f, int base)
{
    if (base < 0 || base >= f->n_vregs || !f->vreg_to_phys) return 0;
    return vreg_in_pr_bc(f, base)
        || (g_hc.remat_def && g_hc.remat_def[base]);
}

static int de_home_clean_store_ok(const Func *f, const Op *o)
{
    if (opt_disabled("declean")) return 0;
    if (!g_hc.home_is_word || g_hc.func_whome < 0) return 0;
    /* sp only for the reduction ACCUMULATOR home (general DE-home's sp block);
       the value class further restricts sp to the home value (E/D). */
    if (!fp_active(f) && g_hc.de_home >= 0) return 0;
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180 || IS_EZ80() || IS_808x())) return 0;
    if (o->kind != IR_ST_MEM) return 0;
    if (o->mem.kind != IR_MEM_VREG) return 0;
    if (o->mem.post_step != 0) return 0;
    if (mem_bank_fn(&o->mem) != NULL) return 0;
    if (o->src[0] < 0) return 0;                       /* not a const-imm store */
    if (de_clean_store_val_class(f, o->src[0]) == 0) return 0;
    if (!de_clean_store_base_ok(f, o->mem.base)) return 0;
    /* Value in the same BC register as the base can't happen (two live vregs,
       one phys) — but the val-class already excludes BC-resident values. */
    return 1;
}

/* Masked write-back fusion: a width-2 ST_MEM immediately preceded (same BB) by
   a width-2 AND/OR/XOR of the DE-home with a CONSTANT whose ONLY use is this
   store, to a DE/BC-clean base. Returns that mask op, else NULL. The pair lowers
   to a single DE-clean masked store reading the home from E/D (`ld a,e; and Klo;
   ld (hl),a; …`), so the masked value never rides HL — sidestepping the HL
   conflict when the allocator homes the single-use mask result in HL. Adjacency
   guarantees the home is unchanged between the mask and the store. fp /
   z80-family / IR_NO_DECLEAN gated; mirrors the emitter (try_de_home_mask_store)
   and the AND-side region proof exactly. */
static const Op *fused_mask_store_mask(const Func *f, const Op *store_op)
{
    if (opt_disabled("declean")) return NULL;
    if (!g_hc.home_is_word || g_hc.func_whome < 0) return NULL;
    /* sp only for the reduction accumulator home (reads home E/D, masks via A,
       address ld hl,bc / remat — all DE-clean in sp). */
    if (!fp_active(f) && g_hc.de_home >= 0) return NULL;
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180 || IS_EZ80() || IS_808x())) return NULL;
    if (store_op->kind != IR_ST_MEM || store_op->mem.kind != IR_MEM_VREG) return NULL;
    if (store_op->mem.post_step != 0 || mem_bank_fn(&store_op->mem) != NULL) return NULL;
    int val = store_op->src[0];
    if (val < 0 || val >= f->n_vregs || f->vregs[val].width != 2) return NULL;
    if (!de_clean_store_base_ok(f, store_op->mem.base)) return NULL;
    for (int i = 0; i < f->n_bbs; i++) {
        const BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            if (&bb->ops[j] != store_op) continue;
            if (j == 0) return NULL;                    /* need a preceding op */
            const Op *m = &bb->ops[j - 1];
            if ((m->kind == IR_AND || m->kind == IR_OR || m->kind == IR_XOR)
                && m->dst == val && m->src[1] < 0        /* const RHS */
                && m->src[0] == g_hc.func_whome         /* mask of the home */
                && f->vregs[val].width == 2
                && find_unique_use(f, val) == store_op)  /* val feeds only this */
                return m;
            return NULL;
        }
    }
    return NULL;
}

/* Is op `o` the MASK half of a fused masked write-back (its adjacent successor
   is the store it feeds)? Emit nothing for it — the store does the work. */
static int op_is_fused_mask(const Func *f, const Op *o)
{
    if (o->kind != IR_AND && o->kind != IR_OR && o->kind != IR_XOR) return 0;
    for (int i = 0; i < f->n_bbs; i++) {
        const BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            if (&bb->ops[j] != o) continue;
            if (j + 1 >= bb->n_ops) return 0;
            return fused_mask_store_mask(f, &bb->ops[j + 1]) == o;
        }
    }
    return 0;
}

/* sp-mode word deref that is DE-clean for a reduction ACCUMULATOR home: the
   field value is loaded into HL and consumed immediately by the accumulate
   (`add hl,de`), never spilled — so no `ex de,hl` clobbers the home. In fp the
   deref result spills DE-cleanly (`ld (ix+d),hl`); sp has no such store (the
   slot address needs HL), so a spilled temp would stage through DE. Proven safe:
   dst is a spill (not the home, not PR_DE), single-use, and that use is the very
   next op — a word-accumulate reading dst — so it rides HL straight into the add
   and the store is dead. Accumulator home only (cur_de_home<0); the general
   DE-home's loop temporaries have the separate sp HL-residency block. */
static int sp_accum_deref_hl_carried(const Func *f, const Op *o)
{
    if (fp_active(f)) return 0;
    if (opt_disabled("declean")) return 0;
    /* Only where the sp reduction region can actually form (a DE-clean loop
       compare exists) — else this partial clean-rule perturbs codegen on CPUs
       that never complete the region (a Rabbit regression). Matches
       sp_dehome_loop_cmp_ok's CPU set. */
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180 || IS_EZ80() || IS_808x())) return 0;
    if (g_hc.de_home >= 0) return 0;               /* accumulator home only */
    if (o->kind != IR_LD_MEM || o->dst < 0 || o->dst >= f->n_vregs) return 0;
    if (f->vregs[o->dst].width != 2) return 0;
    if (o->dst == g_hc.func_whome) return 0;
    if (!vreg_is_spilled(f, o->dst)) return 0;
    if (f->vregs[o->dst].flags
        & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM)) return 0;
    for (int i = 0; i < f->n_bbs; i++) {
        const BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            if (&bb->ops[j] != o) continue;
            if (j + 1 >= bb->n_ops) return 0;
            const Op *nx = &bb->ops[j + 1];
            if (nx->kind != IR_ADD) return 0;
            if (nx->src[0] != o->dst && nx->src[1] != o->dst) return 0;
            if (!is_word_accumulate(f, nx)) return 0;
            return find_unique_use(f, o->dst) == nx;
        }
    }
    return 0;
}

/* sp DE-clean loop compare (counter vs slot bound) helpers. Classify a width-2
   operand as a register-half (idx2 IX/IY halves on z80/z80n, or BC) — read
   without touching HL/DE — filling lo/hi mnemonics. */
static int sp_cmp_reghalf(const Func *f, int v, char *lo, char *hi, size_t n)
{
    if (v < 0 || v >= f->n_vregs || f->vregs[v].width != 2) return 0;
    if ((c_cpu == CPU_Z80 || IS_Z80N()) && vreg_in_idx2(f, v)) {
        const char *r = vreg_idx_name(f, v);
        snprintf(lo, n, "%sl", r); snprintf(hi, n, "%sh", r); return 1;
    }
    if (vreg_in_pr_bc(f, v)) {
        snprintf(lo, n, "c"); snprintf(hi, n, "b"); return 1;
    }
    return 0;
}
/* The other operand: an sp-addressable spill slot (the bound), read via (hl). */
static int sp_cmp_slot(const Func *f, int v)
{
    if (v < 0 || v >= f->n_vregs || f->vregs[v].width != 2) return 0;
    if (!vreg_is_spilled(f, v)) return 0;
    if (f->vregs[v].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    return 1;
}

/* A branch-fused int loop test `counter REL bound` inside an sp reduction
   ACCUMULATOR DE-home, where the counter rides an index-half/BC register and the
   bound sits in an sp spill slot. Lowered byte-wise through A (`ld hl,&bound;
   add hl,sp; ld a,ixl; sub (hl); inc hl; ld a,ixh; sbc a,(hl)`) — HL addresses
   the bound, A does the subtract, IX/BC hold the counter — so DE (the running
   sum) survives. The fp analog is try_cmp_ixd_fold (reads (ix+d) in place); sp
   has no (ix+d) so the bound is read via HL. Mirrors try_sp_dehome_loop_cmp. */
static int sp_dehome_loop_cmp_ok(const Func *f, const Op *o)
{
    if (opt_disabled("declean")) return 0;
    if (fp_active(f)) return 0;
    if (!g_hc.home_is_word || g_hc.func_whome < 0 || g_hc.de_home >= 0) return 0;
    /* z80/z80n: counter in an index half or BC. z180/808x: no usable index half
       (z180 traps them, 808x has none), so sp_cmp_reghalf yields only BC — the
       byte compare (`ld a,c; sub (hl); …`; JPO/RAL for the signed test) is valid
       on all of these. Rabbit is EXCLUDED: it dropped the P/V parity flag, so the
       `jp po` signed-compare form is unavailable (and it regressed there). */
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180 || IS_EZ80() || IS_808x())) return 0;
    switch (o->kind) {
    case IR_CMP_LT: case IR_CMP_LE: case IR_CMP_GT: case IR_CMP_GE:
    case IR_CMP_ULT: case IR_CMP_ULE: case IR_CMP_UGT: case IR_CMP_UGE: break;
    default: return 0;
    }
    int s0 = o->src[0], s1 = o->src[1];
    if (s0 < 0 || s1 < 0 || s0 == s1 || s0 >= f->n_vregs || s1 >= f->n_vregs) return 0;
    if (f->vregs[s0].width != 2 || f->vregs[s1].width != 2) return 0;
    if (s0 == g_hc.func_whome || s1 == g_hc.func_whome) return 0;
    char lo[16], hi[16];
    int r0 = sp_cmp_reghalf(f, s0, lo, hi, sizeof lo);
    int r1 = sp_cmp_reghalf(f, s1, lo, hi, sizeof lo);
    return (r0 && sp_cmp_slot(f, s1)) || (r1 && sp_cmp_slot(f, s0));
}

/* Is op `o`'s lowering proven DE-clean — does the slot-backed byte home (in
   E/D) survive it? CONSERVATIVE whitelist (default: assume DE-clobber, force
   a flush): a false dirty only costs a spill, but a false clean miscompiles.
   Clean = byte ALU through A, byte deref, pointer step, byte truth-test
   branch, plain branches, byte-wise loop test. Everything else (16/32-bit
   ops, stores, calls, switches, wide conversions) is a clobber. */
static int op_de_clean(const Func *f, const Op *o)
{
    int dw = (o->dst >= 0 && o->dst < f->n_vregs)
           ? f->vregs[o->dst].width : 0;
    /* Word DE-home: the accumulate and the home's own `ld de,K` init both
       re-establish DE = home; everything else that is DE-clean for the byte
       home (it touches A/HL/BC, never DE) is equally clean here. */
    if (g_hc.home_is_word) {
        if (is_word_accumulate(f, o)) return 1;
        if (o->kind == IR_LD_IMM && o->dst == g_hc.func_whome) return 1;
        /* Int deref (fp): register/sym base, offset>=-3 (inc/dec hl, no DE
           scratch), no post-step, not far/banked, dst not the home. Loads
           into HL/A with a DE-preserving spill, so DE (the home) survives —
           vs the *p++ word form (loads into DE) and wide/offset forms (DE
           scratch), which stay dirty. */
        if (o->kind == IR_LD_MEM && dw == 2
            && (fp_active(f) || sp_accum_deref_hl_carried(f, o))
            && o->dst != g_hc.func_whome
            && o->mem.post_step == 0 && mem_bank_fn(&o->mem) == NULL
            && o->mem.elem != KIND_CPTR
            && (o->mem.kind == IR_MEM_VREG || o->mem.kind == IR_MEM_SYM)
            && o->mem.offset >= -3)        /* any +offset: emit_pair_add_de_clean */
            return 1;
        /* Counter step (i++/i--): width-2 INC/DEC of a non-home vreg — A/HL
           only, DE survives. (The home itself steps via the accumulate.) In sp
           the counter typically rides a spare index (IX) or BC — `inc ix`/`inc bc`
           are DE-clean; only un-gate those register-resident forms (a slot INC in
           sp needs HL for the value+address and would stage through DE). */
        if ((o->kind == IR_INC || o->kind == IR_DEC) && dw == 2
            && o->dst != g_hc.func_whome
            && (fp_active(f)
                || (!opt_disabled("declean") && g_hc.de_home < 0 && f->vreg_to_phys
                    && (c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180 || IS_EZ80() || IS_808x())
                    && (vreg_in_pr_bc(f, o->dst)
                        || vreg_in_idx2(f, o->dst)))))
            return 1;
        /* In-place transform of the accumulator (`v = s & K`; `a[i] = v`): the
           const-mask ALU and the write-back store are both DE-clean (see the
           predicates above). Lets a reduction loop that writes a function of the
           running sum back to the array keep the sum in DE. */
        if (de_home_clean_bitop_ok(f, o))
            return 1;
        if (de_home_clean_store_ok(f, o))
            return 1;
        /* Masked write-back fused pair: the mask (emitted as nothing) and the
           store (emits the fused DE-clean masked store) — see fused_mask_store_mask. */
        if (o->kind == IR_ST_MEM && fused_mask_store_mask(f, o))
            return 1;
        if (op_is_fused_mask(f, o))
            return 1;
        /* IVSR stepped pointer `bc += k` (PR_BC dst, small const step, dst==src0)
           → `inc bc` chain in gen_add — DE-clean. */
        if (o->kind == IR_ADD && dw == 2 && o->src[1] < 0
            && o->dst == o->src[0] && o->dst != g_hc.func_whome
            && o->imm >= 1                 /* any stride: emit_pair_add_de_clean */
            && vreg_in_pr_bc(f, o->dst))
            return 1;
        /* Small const add `dst = src0 + k` (k<=3): `inc hl` chain + the
           DE-preserving fp slot store — DE-clean, so an element pointer
           stepped in-loop (`p += 2`) doesn't revert the region. fp only (sp
           commit_hl_word clobbers DE). Mirror gen_add's condition EXACTLY. */
        if (o->kind == IR_ADD && dw == 2 && o->src[1] < 0 && fp_active(f)
            && o->dst != g_hc.func_whome && o->imm >= 1 && o->imm <= 3
            && !vreg_in_pr_bc(f, o->dst))
            return 1;
        /* DE-clean signed loop test (branch-fused). */
        if ((o->kind == IR_CMP_LT || o->kind == IR_CMP_GE)
            && g_hc.branch_test_kind != 0
            && word_dehome_signed_test_shape_ok(f, o))
            return 1;
        /* Branch-fused int loop test (counter in idx2/BC vs slot, operands not
           the home) lowered by the (ix+d)/idx-half compare fold — A-only, DE
           survives. Covers the word-acc home's i-in-idx2 test. */
        if (g_hc.branch_test_kind != 0 && cmp_ixd_fold_de_clean_ok(f, o))
            return 1;
        /* sp reduction loop test `counter[idx2/BC] REL bound[slot]`: byte-wise
           through A with the bound read via (hl) — DE survives (the fp analog is
           the (ix+d) fold above; sp has no (ix+d)). */
        if (g_hc.branch_test_kind != 0 && sp_dehome_loop_cmp_ok(f, o))
            return 1;
        /* --- General (non-accumulate) DE-home region ops (cur_de_home>=0) --- */
        if (g_hc.de_home >= 0) {
            /* Loop-regalloc walking-pointer home (IR_LOOP_RA): the home is a
               byte pointer in DE. Its own deref (ld a,(de)), store (ld (de),a),
               and step (inc/dec de / POSTSTEP) keep DE = the (stepped) pointer —
               all DE-clean via the gp (de) lowering. A byte deref of ANOTHER
               pointer stays clean via the general switch below (dw==1 → A). */
            if (f->de_home_is_ptr) {
                if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                    && o->mem.kind == IR_MEM_VREG
                    && o->mem.base == g_hc.func_whome
                    && o->mem.offset == 0)
                    return 1;
                /* Fused byte copy-loop (COPY_STEP_BRZ): the DE home is one of
                   the two stepped pointers (src[0]=source, src[1]=dest). It
                   reads/writes/steps that pointer in DE (`ld a,(de); inc de` or
                   `ld (de),a; inc de`) and the OTHER through BC, byte via A —
                   DE stays = the (stepped) home. Clean only when the home IS one
                   of the pointers (else a slot-backed pointer would use DE as
                   HL/DE scratch). */
                if (o->kind == IR_COPY_STEP_BRZ
                    && (o->src[0] == g_hc.func_whome
                        || o->src[1] == g_hc.func_whome))
                    return 1;
                /* A SECOND walking pointer homed in BC alongside the DE home
                   (strcpy: dst `*d++` in BC, src the DE home). A post-step byte
                   store through it takes the gp `ld (bc),a; inc bc` path
                   (guaranteed for st_step in gen_st_mem) — A + BC only, so DE
                   survives. Restricted to post_step: a plain BC store may take
                   the E-stashing fallback, which would clobber the home. */
                if (o->kind == IR_ST_MEM && o->mem.kind == IR_MEM_VREG
                    && o->mem.offset == 0 && o->mem.post_step != 0
                    && o->mem.base >= 0 && o->mem.base < f->n_vregs
                    && vreg_in_pr_bc(f, o->mem.base)
                    && o->src[0] >= 0 && o->src[0] < f->n_vregs
                    && f->vregs[o->src[0]].width == 1)
                    return 1;
                if ((o->kind == IR_INC || o->kind == IR_DEC)
                    && o->dst == g_hc.func_whome)
                    return 1;
                if (o->kind == IR_POSTSTEP && o->src[0] == g_hc.func_whome)
                    return 1;
                /* Byte compare (`*a == *b`, `*a < *b`): operands reach A via
                   `cp`/slot, never staged into DE. Byte operands only. */
                if (o->kind == IR_CMP_EQ || o->kind == IR_CMP_LT
                    || o->kind == IR_CMP_ULT) {
                    int s0 = o->src[0], s1 = o->src[1];
                    int w0 = (s0 >= 0 && s0 < f->n_vregs) ? f->vregs[s0].width : 2;
                    int w1 = (s1 >= 0 && s1 < f->n_vregs) ? f->vregs[s1].width : 1;
                    if (w0 <= 1 && w1 <= 1) return 1;
                }
            }
            /* Branch-fused int compare lowered by try_cmp_ixd_fold: reads both
               operands in place through A, never staging one into DE. */
            if (g_hc.branch_test_kind != 0 && cmp_ixd_fold_de_clean_ok(f, o))
                return 1;
            /* RET of a width<=2 value: the return sits in HL, DE untouched, then
               the function leaves — the home need not survive past it. */
            if (o->kind == IR_RET) {
                int rw = (o->src[0] >= 0 && o->src[0] < f->n_vregs)
                       ? f->vregs[o->src[0]].width : 0;
                return rw <= 2;
            }
            /* Word const shift (mid=(lo+hi)>>1): srl h;rr l — HL only, DE clean. */
            if ((o->kind == IR_SHL || o->kind == IR_SHR) && dw == 2
                && o->src[1] < 0 && o->dst != g_hc.func_whome)
                return 1;
            /* `dst = other + home` (dst != home): try_de_home_operand_add loads
               other→HL and `add hl,de` — the home in DE survives. */
            if (o->kind == IR_ADD && dw == 2 && o->dst != g_hc.func_whome
                && o->src[0] >= 0 && o->src[1] >= 0
                && (o->src[0] == g_hc.func_whome || o->src[1] == g_hc.func_whome))
                return 1;
            /* Indexed word deref address `base + (idx<<k)` via ld hl,base;add hl,bc. */
            if (de_home_indexed_add_ok(f, o))
                return 1;
            /* Home-def `home = src0 +/- imm` (try_de_home_def): computes in HL
               then ex de,hl → re-establishes DE = home. */
            if ((o->kind == IR_ADD || o->kind == IR_SUB)
                && o->dst == g_hc.func_whome && o->src[0] >= 0 && o->src[1] < 0
                && o->imm >= 0 && o->imm <= 4)
                return 1;
            /* Byte-wise ALU fold (ADD/SUB/AND/OR/XOR of foldable operands): reads
               in place through A, result to a non-home spill — DE-clean. */
            if (binop_ixd_fold_de_clean_ok(f, o))
                return 1;
        }
    }
    switch (o->kind) {
    case IR_NOP: case IR_BR:
        return 1;
    case IR_POSTSTEP:                 /* pointer self-step: inc bc / inc hl */
        return 1;
    case IR_BR_ZERO: case IR_BR_COND: {
        int s  = o->src[0];
        int sw = (s >= 0 && s < f->n_vregs) ? f->vregs[s].width : 2;
        if (sw <= 1) return 1;        /* byte → `or a`, DE-clean on all CPUs */
        if (opt_disabled("word-ztest")) return 0;   /* opt-out → baseline */
        /* word → emit_test_zero's `load_to_hl; ld a,h; or l` (or Rabbit4k
           `test`) — HL+A only, DE untouched. This lets a pointer-chase loop
           (`while (p) { acc += p->f; p = p->next; }`) keep its accumulator in
           DE across the null test. FP ONLY: in sp mode a sibling width-2
           counter op (`while (n--)`) loads the counter into DE (`ld e,(hl);
           ld d,(hl); dec de; … ex de,hl`), clobbering the home — and the
           accumulate's `ex de,hl` (`xchg` on 808x) isn't available on gbz80.
           fp keeps such counter ops in (ix+d) (HL-only), so DE survives. */
        return sw == 2 && fp_active(f)
            && (c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180
                || IS_EZ80() || IS_808x());
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
    case IR_CMP_LT: case IR_CMP_GE:
        /* Signed X REL 0 sign-bit test (gen_cmp_lt_ge fastpath): branch-fused,
           loads the top byte + `add a,a` — A/HL only for width<=2, so DE (the
           byte home) survives. width4 uses load_to_dehl (DE scratch) → dirty. */
        if (o->src[1] == -1 && o->imm == 0 && g_hc.branch_test_kind != 0) {
            int sw = (o->src[0] >= 0 && o->src[0] < f->n_vregs)
                   ? f->vregs[o->src[0]].width : 4;
            return sw <= 2;
        }
        return 0;
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
    /* Signed `X REL 0` sign-bit test (CMP_LT/GE vs imm 0 + its branch): the
       fastpath emits `<load top byte>; add a,a; jp` — A/HL only for width<=2,
       so DE survives. Matches the branch-fused shape structurally. */
    if ((o->kind == IR_CMP_LT || o->kind == IR_CMP_GE)
        && o->src[1] == -1 && o->imm == 0 && j + 1 < bb->n_ops) {
        const Op *nxt = &bb->ops[j + 1];
        int sw = (o->src[0] >= 0 && o->src[0] < f->n_vregs)
               ? f->vregs[o->src[0]].width : 4;
        if (sw <= 2 && (nxt->kind == IR_BR_ZERO || nxt->kind == IR_BR_COND)
            && nxt->src[0] == o->dst)
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
        /* Branch consumed by a fused signed `X REL 0` sign-test (see above):
           the compare emitted the jp and this branch renders nothing. */
        if ((prv->kind == IR_CMP_LT || prv->kind == IR_CMP_GE)
            && prv->src[1] == -1 && prv->imm == 0 && prv->dst == o->src[0]) {
            int sw = (prv->src[0] >= 0 && prv->src[0] < f->n_vregs)
                   ? f->vregs[prv->src[0]].width : 4;
            if (sw <= 2) return 1;
        }
        /* Branch consumed by a general DE-home folded int compare. */
        if ((g_hc.de_home >= 0 || g_hc.home_is_word) && prv->dst == o->src[0]
            && cmp_ixd_fold_de_clean_ok(f, prv))
            return 1;
        /* Branch consumed by the sp reduction loop test (fused compare emitted
           the jp; this branch renders nothing). */
        if (prv->dst == o->src[0] && sp_dehome_loop_cmp_ok(f, prv))
            return 1;
        /* Loop-regalloc pointer DE-home: a branch consuming a byte compare
           (`*a == *b`) that op_de_clean proved clean. The compare/branch
           fuse to `cp`/`sub` + `jp cc` — flags-only, so DE (the resident
           pointer) survives even though the compare's result vreg is a
           width-2 int (which would fail the generic BR width<=1 case). */
        if (g_hc.de_home >= 0 && f->de_home_is_ptr
            && (prv->kind == IR_CMP_EQ || prv->kind == IR_CMP_NE
                || prv->kind == IR_CMP_LT || prv->kind == IR_CMP_ULT)
            && prv->dst == o->src[0] && op_de_clean(f, prv))
            return 1;
    }
    /* General DE-home: a branch-fused int compare lowered by try_cmp_ixd_fold
       (recognised structurally — the compare feeds the next branch). */
    if ((g_hc.de_home >= 0 || g_hc.home_is_word) && j + 1 < bb->n_ops
        && cmp_ixd_fold_de_clean_ok(f, o)) {
        const Op *nxt = &bb->ops[j + 1];
        if ((nxt->kind == IR_BR_ZERO || nxt->kind == IR_BR_COND)
            && nxt->src[0] == o->dst)
            return 1;
    }
    /* sp reduction loop test (counter[idx2/BC] REL bound[slot]) + its branch,
       recognised structurally (cur_branch_test_kind unset in the region proof). */
    if (j + 1 < bb->n_ops && sp_dehome_loop_cmp_ok(f, o)) {
        const Op *nxt = &bb->ops[j + 1];
        if ((nxt->kind == IR_BR_ZERO || nxt->kind == IR_BR_COND)
            && nxt->src[0] == o->dst)
            return 1;
    }
    return op_de_clean(f, o);
}

/* Identify a loop the slot-backed byte home stays register-resident across,
   returning its bb-id span [lo,hi] (-1,-1 if none). Conservative — any unmet
   criterion means no region, codegen unchanged:
     - a back-edge defines a loop; span [lo,hi] = union of in-loop BBs;
     - `home` is live-in at the header (lo);
     - EVERY op in [lo..hi] is op_de_clean_static (byte-ALU writes
       re-establish E, all other body ops preserve it).
   The preheader leaves the home in E and no body op clobbers it, so it is in
   E throughout — letting the header ASSERT residency the forward pass can't
   carry in over the back-edge, and suppressing the per-iteration spill. */
/* True iff every op in BBs [lo..hi] is DE-clean and home is live-in at lo. */
static int home_span_valid(const Func *f, int home, int lo, int hi)
{
    const BB *hdr = &f->bbs[lo];
    if (!hdr->live_in || !ir_bitset_get((const BitSet *)hdr->live_in, home))
        return 0;
    /* The region must define `home` in-loop: that def re-establishes DE/E =
       home each iteration. A span that merely carries the home through without
       a def (e.g. an outer-loop step block reached from a nested inner loop
       that clobbered DE) is NOT a residency loop — its exit-flush would write
       junk DE, not the home. Require >=1 def of home. */
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

