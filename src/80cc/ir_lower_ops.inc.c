/* ir_lower_ops.inc.c — part of ir_lower.c, #included (single TU). Do not compile standalone. */
static int gen_nop(FILE *out, Func *f, const Op *op)
{
    (void)out; (void)f; (void)op;
    return 0;
}

static int gen_ld_imm(FILE *out, Func *f, const Op *op)
{
    int dst_w = (op->dst >= 0) ? f->vregs[op->dst].width : 2;
    if (dst_w == 4) {
        /* Long literal: load DEHL = K, then spill 4 bytes. */
        uint32_t k = (uint32_t)op->imm;
        emit(out, "ld\thl,%u", (unsigned)(k & 0xffff));
        emit(out, "ld\tde,%u", (unsigned)((k >> 16) & 0xffff));
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (dst_w == 1) {
        /* Byte literal: load A and spill byte-sized. The generic path
           below writes TWO bytes into a 1-byte slot (overrun). Consumers
           hit the A-cache via load_byte_to_a / load_to_hl's width-1 path. */
        emit(out, "ld\ta,%d", (int)(op->imm & 0xff));
        commit_a_byte(out, f, op->dst);
        return 0;
    }
    /* idx2 counter init: `ld <idx>,K` (the loop counter's pre-header init). */
    if (op->dst >= 0 && vreg_in_idx2(f, op->dst)) {
        emit(out, "ld\t%s,%lld", idx2_reg_name(f), (long long)op->imm);
        return 0;
    }
    /* PR_DE dst: emit `ld de,K` directly — no HL detour, spill, or
       swap. The consumer hits load_binop_operands's de_has src[1]. */
    if (op->dst >= 0 && f->vreg_to_phys
        && f->vreg_to_phys[op->dst] == IR_PR_DE) {
        emit(out, "ld\tde,%lld", (long long)op->imm);
        cache_de(op->dst);
        /* Word DE-home init (sum = K): value in DE only, slot stale —
           mark resident + dirty so the first DE-clobber / BB exit flushes
           it (else a later reload reads garbage). */
        if (L.cur_home_is_word && op->dst == L.cur_func_whome) {
            byte_home_note(op->dst);
            L.cur_byte_home_dirty = 1;
        }
        return 0;
    }
    /* PR_BC dst: `ld bc,K` and stamp the cache. Downstream readers
       hit the `ld l,c; ld h,b` short-circuit in load_to_hl/de. */
    if (op->dst >= 0 && f->vreg_to_phys
        && f->vreg_to_phys[op->dst] == IR_PR_BC) {
        emit(out, "ld\tbc,%lld", (long long)op->imm);
        cache_bc(op->dst);
        return 0;
    }
    /* Stage in DE when we're going to spill: skips the initial
       `ex de,hl` of store_hl. On dead-dst, falls back to the plain
       HL load (we need HL=K for any cache-served consumer). */
    if (L.la.cur_dst_dead) {
        emit(out, "ld\thl,%lld", (long long)op->imm);
    } else {
        emit(out, "ld\tde,%lld", (long long)op->imm);
        spill_de_unless_dead(out, f, op->dst);
    }
    cache_hl(op->dst);
    return 0;
}

static int gen_ld_sym(FILE *out, Func *f, const Op *op)
{
    /* dst ← &sym + offset. Address-of: just an immediate-load. */
    if (op->mem.sym == NULL) {
        fputs("ir_lower: IR_LD_SYM with NULL sym\n", stderr);
        return -1;
    }
    if (ns_sym_bails(op->mem.sym))
        return -1;   /* __addressmod address-of: not yet supported */
    /* A __LIB__ function decays to its address with NO leading underscore
       (classic lib symbols are unprefixed); ordinary globals (incl. arrays/
       structs) keep the `_`. ir_sym_prefix encodes that rule. */
    const char *pfx = ir_sym_prefix(op->mem.sym);
    if (op->mem.offset)
        emit(out, "ld\thl,%s%s+%d",
             pfx, ir_sym_name(op->mem.sym), op->mem.offset);
    else
        emit(out, "ld\thl,%s%s", pfx, ir_sym_name(op->mem.sym));
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_ld_str(FILE *out, Func *f, const Op *op)
{
    /* dst ← &literal_queue + imm. The per-TU label `i_<litlab>` is the
       start of the queue; `op->imm` is the byte offset of the string
       within it. */
    emit(out, "ld\thl,i_%d+%lld", litlab, (long long)op->imm);
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_lea(FILE *out, Func *f, const Op *op)
{
    if (op->src[0] < 0) {
        fputs("ir_lower: IR_LEA with no src\n", stderr);
        return -1;
    }
    emit_acc_slot_addr(out, f, op->src[0], 0);
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_mov(FILE *out, Func *f, const Op *op)
{
    int dst_w = (op->dst >= 0) ? f->vregs[op->dst].width : 2;
    if (dst_w > 4) {
        /* Wide (5/6/8-byte) slot-to-slot copy via the accumulator:
           dload(src); dstore(dst). Reuses the FA-residency cache. */
        if (*wide_acc_cell(f, op->src[0]) != op->src[0]) {
            emit_acc_slot_addr(out, f, op->src[0], 0);
            emit(out, "call\t%s", acc_prim(f, op->src[0], "load"));
        }
        emit_acc_slot_addr(out, f, op->dst, 0);
        emit_acc_store_hl(out, f, op->dst);
        invalidate_hl_bc();
        *wide_acc_cell(f, op->dst) = op->dst;
        return 0;
    }
    if (dst_w == 4) {
        /* Long slot-to-slot copy. */
        load_to_dehl(out, f, op->src[0]);
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (dst_w == 1) {
        /* Byte dst: store ONE byte via A. store_hl always writes TWO bytes
           and overruns a 1-byte slot. A MOV with a wider source (e.g.
           `c = c ^ x`, c char: the int-promoted XOR is width 2) takes the
           source's low byte. */
        int src_w = f->vregs[op->src[0]].width;
        if (src_w == 1) {
            load_byte_to_a(out, f, op->src[0]);
        } else if (src_w == 4) {
            load_to_dehl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
            invalidate_hl_cache();
        } else {
            load_to_hl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
        }
        commit_a_byte(out, f, op->dst);
        return 0;
    }
    if (vreg_is_pr_de(f, op->dst)) {
        load_to_de(out, f, op->src[0]);
        cache_de(op->dst);
        return 0;
    }
    if (L.rs.hl != op->src[0] || L.rs.hl < 0)
        load_to_hl(out, f, op->src[0]);
    commit_hl_word(out, f, op->dst);
    return 0;
}

/* In-place step (i++/i--) of a width-2 local homed at the TOS word, via
   `ex (sp),hl` (absent on gbz80): swap the counter into HL, step, swap back.
   HL round-trips through TOS (prior content restored), DE untouched — vs the
   generic pop/push + `inc sp;inc sp;push de` dance. Returns 1 if handled.
   Gated: real TOS slot, value not already in HL, no pending HL-carry spill. */
static int try_tos_step_xthl(FILE *out, Func *f, const Op *op, int is_inc)
{
    if (IS_GBZ80()) return 0;   /* XTHL absent on gbz80 only */
    int v = op->dst;
    if (v < 0 || op->src[0] != v) return 0;          /* in-place self-step */
    if (f->vregs[v].width != 2) return 0;
    if (L.la.cur_dst_dead) return 0;                      /* dead → no store at all */
    if (vreg_in_register_pool(f, v)) return 0;       /* must be a real slot */
    if (hl_has(v)) return 0;                         /* value is in HL, not TOS */
    /* Home must be the topmost stack word right now. */
    int at_tos = fp_active(f) ? fp_tos_slot(f, v)
               : (tos_pushpop_ok(f) && L.cur_sp_adjust == 0 && slot_off(f, v) == 0);
    if (!at_tos) return 0;
    /* A value riding the HL carry would be swapped onto the counter's TOS
       slot — flush it to its own slot first. */
    if (L.lazy_spill_on && L.pending_spill_v >= 0)
        pending_spill_resolve();
    ss_note_reload(f, v);      /* reads the slot (first swap) */
    ss_note_store(f, v);       /* writes it back (second swap) */
    emit(out, "ex\t(sp),hl");
    emit(out, is_inc ? "inc\thl" : "dec\thl");
    emit(out, "ex\t(sp),hl");
    /* HL physically restored to its pre-op content; the counter now lives
       only at its TOS slot. Drop a stale DE claim on it; leave HL junk. */
    if (de_has(v)) invalidate_de_cache();
    invalidate_hl_cache();
    return 1;
}

/* Register-direct in-place unary op on the resident byte home: `sla e`,
   `inc e`, `dec e` for `home OP= 1` — one instruction vs the `ld a,e; OP a;
   ld e,a` triple. Returns 1 if emitted. Fires only when the home is live in
   its register NOW (so the op acts on the live value) and there's no fused
   branch test on the result (the through-A finalize handles that). `cb_only`
   ops (the CB shifts) need CB-prefix support (absent on 808x); inc/dec are
   all-CPU. */
static int try_inplace_home_unop(FILE *out, const Func *f, const Op *op,
                                 const char *mnem, int cb_only)
{
    if (op->dst < 0 || op->dst != op->src[0]) return 0;
    if (L.la.cur_branch_test_kind != 0) return 0;
    if (cb_only && IS_808x()) return 0;
    if (!byte_home_holds(op->dst)) return 0;
    PhysReg pr = byte_home_phys(f, op->dst);
    if (pr == IR_PR_NONE) return 0;
    emit(out, "%s\t%s", mnem, byte_home_reg(pr));
    if (byte_home_slotbacked(pr)) L.cur_byte_home_dirty = 1;
    invalidate_a_cache();   /* result is in the home reg, not A */
    return 1;
}

static int gen_inc(FILE *out, Func *f, const Op *op)
{
    /* width-1: increment in A and store ONE byte. store_hl writes TWO
       bytes — clobbering the adjacent packed char slot. */
    if (op->dst >= 0 && f->vregs[op->dst].width == 1) {
        if (try_inplace_home_unop(out, f, op, "inc", 0)) return 0;
        load_byte_to_a(out, f, op->src[0]);
        emit(out, "inc\ta");
        commit_a_byte(out, f, op->dst);
        return 0;
    }
    /* idx2 stepping counter (register residency): the counter lives in the
       spare index register — step in place with `inc <idx>` (2 bytes, no
       memory) instead of the TOS ex(sp) dance. */
    if (op->dst == op->src[0] && vreg_in_idx2(f, op->dst)) {
        emit(out, "inc\t%s", idx2_reg_name(f));
        if (hl_has(op->dst)) invalidate_hl_cache();
        if (de_has(op->dst)) invalidate_de_cache();
        return 0;
    }
    if (try_tos_step_xthl(out, f, op, 1)) return 0;
    if (!hl_has(op->src[0]))
        load_to_hl(out, f, op->src[0]);
    emit(out, "inc\thl");
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_dec(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 1) {   /* see gen_inc */
        if (try_inplace_home_unop(out, f, op, "dec", 0)) return 0;
        load_byte_to_a(out, f, op->src[0]);
        emit(out, "dec\ta");
        commit_a_byte(out, f, op->dst);
        return 0;
    }
    if (op->dst == op->src[0] && vreg_in_idx2(f, op->dst)) {
        emit(out, "dec\t%s", idx2_reg_name(f));
        if (hl_has(op->dst)) invalidate_hl_cache();
        if (de_has(op->dst)) invalidate_de_cache();
        return 0;
    }
    if (try_tos_step_xthl(out, f, op, 0)) return 0;
    if (!hl_has(op->src[0]))
        load_to_hl(out, f, op->src[0]);
    emit(out, "dec\thl");
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_br(FILE *out, Func *f, const Op *op)
{
    (void)f;
    /* HL state at the destination is captured by bb_hl_out in
       lower_func — no need to invalidate here. */
    emit(out, "jp\tL_f%d_bb_%d", L.func_emit_idx, op->label);
    return 0;
}

/* Set Z iff `src` is zero, any width. width 1/2 tests HL; width 4 ORs all
   of DEHL (a bare `ld a,h;or l` misses a value whose low 16 bits are zero,
   e.g. 3.0 = 0x40400000); width 8 ORs the 8 slot bytes. Wide forms clobber
   A (and HL for width 8). For the implicit truth test of `if(x)`/`x && y`;
   an explicit `x != 0` is fused into the preceding compare instead. */
static void emit_test_zero(FILE *out, Func *f, int src)
{
    int w = (src >= 0 && src < f->n_vregs) ? f->vregs[src].width : 2;
    if (w == 1) {
        /* Byte truth-test: the value fits in 8 bits (the narrow pass only
           routes a byte-mask AND / byte vreg here), so `or a` on the low
           byte sets Z for the whole value — no `ld h,0` widen. */
        if (!a_has(src)) load_byte_to_a(out, f, src);
        emit(out, "or\ta");
        return;
    }
    if (w <= 2) {
        /* r4k `test hl`/`test bc`: one-op zero test (reg OR 0 → Z), no A
           clobber. `test bc` avoids the BC→HL move for a BC-resident value;
           HL/A caches stay valid (test modifies no register). */
        if (IS_RABBIT4K()) {
            if (!hl_has(src) && L.rs.bc == src) {
                emit(out, "test\tbc");
                return;
            }
            if (!hl_has(src)) load_to_hl(out, f, src);
            emit(out, "test\thl");
            return;
        }
        if (!hl_has(src)) load_to_hl(out, f, src);
        emit(out, "ld\ta,h");
        emit(out, "or\tl");
        return;
    }
    if (w == 4) {
        load_to_dehl(out, f, src);
        emit(out, "ld\ta,l");
        emit(out, "or\th");
        emit(out, "or\te");
        emit(out, "or\td");          /* Z iff all 4 bytes zero */
        return;
    }
    /* width 5/6/8 (5/6-byte acc-double, long long, 8-byte double): OR all
       `w` slot bytes — using a fixed 8 would over-read a 5/6-byte double. */
    emit_acc_slot_addr(out, f, src, 0);  /* HL = &slot */
    emit(out, "ld\ta,(hl)");
    for (int i = 1; i < w; i++) {
        emit(out, "inc\thl");
        emit(out, "or\t(hl)");
    }
    invalidate_hl_cache();
}

static int gen_br_zero(FILE *out, Func *f, const Op *op)
{
    emit_test_zero(out, f, op->src[0]);
    emit(out, "jp\tz,L_f%d_bb_%d", L.func_emit_idx, op->label);
    /* For width<=2, HL still holds the tested value (`or l` doesn't touch
       HL) so rs.hl stays valid for the next op; wider forms managed
       their own caches in emit_test_zero. */
    return 0;
}

static int gen_br_cond(FILE *out, Func *f, const Op *op)
{
    emit_test_zero(out, f, op->src[0]);
    emit(out, "jp\tnz,L_f%d_bb_%d", L.func_emit_idx, op->label);
    return 0;
}

static int gen_extract_byte(FILE *out, Func *f, const Op *op)
{
    /* dst = byte k of width-4 src[0] (k = imm, 0..3). DEHL cache hit:
       one register copy (L=b0 H=b1 E=b2 D=b3). Slot-resident: one
       byte load from slot+k (little-endian layout). */
    int x = op->src[0];
    int k = (int)op->imm;
    if (dehl_has(x)) {
        /* DEHL-cache invariant: BC = low half, DE = high half; HL only
           holds the low half when rs.hl advertises it. In sp mode the
           producer's spill walks HL through the slot (HL = slot+3 after),
           so bytes 0/1 MUST come from C/B — reading L/H returns slot-address
           bytes. (fp unaffected: ix-rel spills preserve HL.) */
        static const char *hl_for_byte[4] = { "l", "h", "e", "d" };
        static const char *bc_for_byte[4] = { "c", "b", "e", "d" };
        const char **rb = (L.rs.hl == x) ? hl_for_byte
                                             : bc_for_byte;
        emit(out, "ld\ta,%s", rb[k & 3]);
    } else if (fp_active(f)
               && fp_offset_fits(slot_ix_off(f, x) + k)) {
        emit(out, "ld\ta,(%s%+d)", frame_reg(), slot_ix_off(f, x) + k);
    } else {
        int off = slot_off(f, x) + L.cur_sp_adjust + k;
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\ta,(hl)");
        invalidate_hl_cache();
    }
    int dw = (op->dst >= 0 && op->dst < f->n_vregs)
           ? f->vregs[op->dst].width : 1;
    if (dw == 2) {
        /* Zero-extended into HL (the table-index shape). */
        emit(out, "ld\tl,a");
        emit(out, "ld\th,0");
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    commit_a_byte(out, f, op->dst);
    return 0;
}

static int gen_rotl(FILE *out, Func *f, const Op *op)
{
    /* Long rotate-left by a constant (ir_opt_fuse_rotl). One
       cache-served read of the source, then a byte permutation of
       D/E/H/L (rot 8 = 5-inst cycle, rot 16 = ex de,hl, rot 24 =
       reverse cycle) plus at most 4 single-bit rotates in whichever
       direction is shorter. Only the live registers move — no count
       loops, no shift-temp spills, no 4-byte OR. */
    int w = (op->dst >= 0 && op->dst < f->n_vregs)
          ? f->vregs[op->dst].width : 2;
    if (w != 4) {
        fprintf(stderr, "ir_lower: IR_ROTL width %d unsupported\n", w);
        return -1;
    }
    int n = (int)(op->imm & 31);
    /* load_to_dehl recovers HL from BC (DEHL invariant is BC=low, HL not
       guaranteed — permuting junk HL would corrupt the result). */
    load_to_dehl(out, f, op->src[0]);
    int byte_rot = n >> 3;
    int bits = n & 7;
    int right = 0;
    if (bits > 4) {
        /* e.g. rot 7 = byte-rot 8 then bit-rot RIGHT 1. */
        byte_rot = (byte_rot + 1) & 3;
        right = 8 - bits;
        bits = 0;
    }
    switch (byte_rot) {
    case 1:                              /* (b3 b2 b1 b0) <- rotl8 */
        emit(out, "ld\ta,d");
        emit(out, "ld\td,e");
        emit(out, "ld\te,h");
        emit(out, "ld\th,l");
        emit(out, "ld\tl,a");
        break;
    case 2:                              /* rotl16: swap halves */
        emit(out, "ex\tde,hl");
        break;
    case 3:                              /* rotr8 */
        emit(out, "ld\ta,l");
        emit(out, "ld\tl,h");
        emit(out, "ld\th,e");
        emit(out, "ld\te,d");
        emit(out, "ld\td,a");
        break;
    }
    for (int i = 0; i < bits; i++) {
        /* 32-bit left rotate by 1: shift left, wrap bit31 into bit0
           (L bit0 is 0 after the shift; inc sets it). */
        emit(out, "add\thl,hl");
        emit(out, "rl\te");
        emit(out, "rl\td");
        emit_skip(out, f, "nc", 1);
        emit(out, "inc\tl");
    }
    for (int i = 0; i < right; i++) {
        /* 32-bit right rotate by 1: shift right, wrap bit0 into
           bit31 (set 7,d is 2 bytes). */
        emit(out, "srl\td");
        emit(out, "rr\te");
        emit(out, "rr\th");
        emit(out, "rr\tl");
        emit_skip(out, f, "nc", 2);
        emit(out, "set\t7,d");
    }
    /* DEHL physically permuted: every prior register claim is stale
       (incl. BC's low-half mirror). */
    invalidate_hl_bc();
    store_dehl_finalize(out, f, op->dst);
    return 0;
}

/* Inlined const-count memset (IR_MEMSET): src[0] = dst pointer,
   src[1] = fill byte value, imm = count (>0). Loads the fill byte
   into E (load_to_de leaves the low byte there) and the dst pointer into
   HL (load_to_hl preserves DE).

   Small counts (<=8): unroll `ld (hl),e; inc hl`. Uses E (not A, not B)
   so it neither disturbs a byte-cache nor clobbers a PR_BC tenant. HL is
   left junk → invalidate.

   Mid counts (9..255): a `djnz` fill loop (`ld b,N; ld (hl),e; inc hl;
   djnz`). 6 bytes — 3 smaller than the ldir form — at the cost of 5 T/
   byte (26 vs 21), so the size win runs ~42 T at N=9 up to ~1.3k T near
   N=255. Chosen for size, since avoiding the library call is the point.

   Large counts (>=256, B can't hold the count): overlapping-`ldir` fill
   — store the byte once at dst, then `ld d,h; ld e,l; inc de; ld bc,N-1;
   ldir` copies it forward (each step reads the byte just written), a
   constant 9 bytes.

   Both clobber BC/DE/HL: DE is a reload-safe cache (cleared below); a
   live PR_BC tenant is saved/restored around the loop (djnz writes B). */
static int gen_memset(FILE *out, Func *f, const Op *op)
{
    int n = (int)op->imm;
    if (n <= 0) return 0;
    load_to_de(out, f, op->src[1]);   /* DE = fill value; E = low byte */
    load_to_hl(out, f, op->src[0]);   /* HL = dst (preserves DE) */
    if (n <= 8) {
        for (int i = 0; i < n; i++) {
            emit(out, "ld\t(hl),e");
            if (i < n - 1) emit(out, "inc\thl");
        }
        invalidate_hl_cache();
        return 0;
    }
    int bc_live = (L.rs.bc >= 0);
    int save_bc = L.rs.bc;
    if (bc_live) emit(out, "push\tbc");
    if (n < 256) {
        int lbl = L.cmp_label_counter++;
        emit(out, "ld\tb,%d", n);
        fprintf(out, "L_f%d_memset_loop_%d:\n", L.func_emit_idx, lbl);
        emit(out, "ld\t(hl),e");
        emit(out, "inc\thl");
        emit(out, "djnz\tL_f%d_memset_loop_%d", L.func_emit_idx, lbl);
    } else {
        emit(out, "ld\t(hl),e");      /* dst[0] = fill */
        emit(out, "ld\td,h");
        emit(out, "ld\te,l");
        emit(out, "inc\tde");         /* DE = dst+1, HL = dst */
        emit(out, "ld\tbc,%d", n - 1);
        emit(out, "ldir");
    }
    if (bc_live) emit(out, "pop\tbc");
    invalidate_hl_cache();            /* HL/DE/DEHL/A all junk now */
    if (bc_live) L.rs.bc = save_bc; /* pop restored BC */
    return 0;
}

/* Inlined const-count memcpy (IR_MEMCPY): src[0] = dst pointer,
   src[1] = src pointer, imm = count (>0). Loads dst into DE and src into
   HL (load_to_hl preserves DE).

   Tiny counts (<=3): unroll `ldi` (16T/2B per byte) when BC is free — it
   beats the A-based `ld a,(hl); ld (de),a; inc hl; inc de` (26T/4B) on both
   time and size. `ldi` clobbers BC (dec bc), so when a PR_BC tenant is live
   fall back to the A-based copy (a tiny copy isn't worth a push/pop bc).

   Larger counts: `ld bc,N; ldir` (HL=src → DE=dst). Clobbers BC/DE/HL;
   DE is a reload-safe cache (cleared below); a live PR_BC tenant is
   saved/restored. HL/DE are left junk → invalidate. */
/* Block-copy `n` bytes from (HL) to (DE). Precondition: HL=src, DE=dst.
   Clobbers HL/DE/A (caches invalidated); a live PR_BC tenant is saved and
   restored. CPU-portable: z80 unrolls `ldi` (or `ldir` for n>3); 808x+gbz80
   have no `ldi`/`ldir`, so tiny counts use the A-based byte loop and larger
   counts emit `ldir`, which z80asm lowers to the __z80asm__ldir lib helper.
   Shared by gen_memcpy and gen_push_struct. */
static void emit_block_copy(FILE *out, Func *f, int n)
{
    (void)f;
    if (n <= 0) return;
    if (n <= 3) {
        if (L.rs.bc < 0 && (!(IS_808x() || IS_GBZ80()))) {
            for (int i = 0; i < n; i++) emit(out, "ldi");
        } else {
            for (int i = 0; i < n; i++) {
                emit(out, "ld\ta,(hl)");
                emit(out, "ld\t(de),a");
                if (i < n - 1) {
                    emit(out, "inc\thl");
                    emit(out, "inc\tde");
                }
            }
        }
        invalidate_hl_cache();        /* clears HL/DE/A caches */
        return;
    }
    int bc_live  = (L.rs.bc >= 0);
    int save_bc  = L.rs.bc;
    if (bc_live) emit(out, "push\tbc");
    emit(out, "ld\tbc,%d", n);
    emit(out, "ldir");
    if (bc_live) emit(out, "pop\tbc");
    invalidate_hl_cache();
    if (bc_live) L.rs.bc = save_bc;
}

static int gen_memcpy(FILE *out, Func *f, const Op *op)
{
    int n = (int)op->imm;
    if (n <= 0) return 0;
    load_to_de(out, f, op->src[0]);   /* DE = dst */
    load_to_hl(out, f, op->src[1]);   /* HL = src (preserves DE) */
    emit_block_copy(out, f, n);
    return 0;
}

/* IR_PUSH_STRUCT: allocate imm bytes on the data stack and block-copy the
   struct (address in src[0]) into it, so byte i lands at sp+i (natural order,
   exact size) — matches sccz80's struct-arg push (codegen.c:1041-1050) and
   SDCC sdcccall(0). For n>3 the copy uses `ldir`; on 808x/gbz80 z80asm lowers
   that to a __z80asm__ldir call whose return address sits below the freshly
   allocated region, so it doesn't clobber the copied bytes. */
static int gen_push_struct(FILE *out, Func *f, const Op *op)
{
    int size = (int)op->imm;
    if (size <= 0) return 0;
    load_to_hl(out, f, op->src[0]);   /* HL = struct source address */
    emit(out, "ex\tde,hl");           /* DE = source */
    emit(out, "ld\thl,%d", -size);
    emit(out, "add\thl,sp");
    emit(out, "ld\tsp,hl");           /* sp = allocated top; HL = dst */
    emit(out, "ex\tde,hl");           /* HL = source, DE = dst */
    emit_block_copy(out, f, size);
    L.cur_sp_adjust += size;
    invalidate_hl_bc();
    return 0;
}

/* Inlined __builtin_strcpy (IR_STRCPY): src[0] = dst, src[1] = src.
   DE = dst, HL = src, then a NUL-terminated copy loop:
   `xor a; L: cp (hl); ldi; jr nz,L` — cp sets Z when *src==0 (ldi
   leaves Z untouched, only touching P/V), so the NUL is copied and the
   loop exits. `ldi` decrements BC: a live PR_BC tenant is saved/
   restored. Returns dst (the dst vreg reaches its readers via its slot;
   HL/DE/A left junk → invalidate). */
static int gen_strcpy(FILE *out, Func *f, const Op *op)
{
    int lbl = L.cmp_label_counter++;
    load_to_de(out, f, op->src[0]);   /* DE = dst */
    load_to_hl(out, f, op->src[1]);   /* HL = src (preserves DE) */
    int bc_live = (L.rs.bc >= 0);
    int save_bc = L.rs.bc;
    if (bc_live) emit(out, "push\tbc");
    emit(out, "xor\ta");
    fprintf(out, "L_f%d_strcpy_%d:\n", L.func_emit_idx, lbl);
    emit(out, "cp\t(hl)");
    emit(out, "ldi");
    emit(out, "jr\tnz,L_f%d_strcpy_%d", L.func_emit_idx, lbl);
    if (bc_live) emit(out, "pop\tbc");
    invalidate_hl_cache();
    if (bc_live) L.rs.bc = save_bc;
    return 0;
}

/* Inlined __builtin_strchr (IR_STRCHR): dst = result, src[0] = string,
   src[1] = char vreg (or -1 + imm for a literal char). HL = string,
   E = search char, then a scan loop:
       L: ld a,(hl); cp e; jr z,END   ; match → HL points at it
          and a; inc hl; jr nz,L      ; not NUL → keep scanning
          ld h,a; ld l,h              ; hit NUL (a==0) → HL = NULL
       END:
   Pure read (no memory write); result HL stored to dst. */
static int gen_strchr(FILE *out, Func *f, const Op *op)
{
    int start = L.cmp_label_counter++;
    int end   = L.cmp_label_counter++;
    if (op->src[1] >= 0) {
        load_to_de(out, f, op->src[1]);   /* E = search char (low byte) */
        load_to_hl(out, f, op->src[0]);   /* HL = string (preserves DE) */
    } else {
        load_to_hl(out, f, op->src[0]);   /* HL = string */
        emit(out, "ld\te,%d", (int)(op->imm & 0xff));
        invalidate_de_cache();            /* E no longer caches a vreg */
    }
    fprintf(out, "L_f%d_strchr_%d:\n", L.func_emit_idx, start);
    emit(out, "ld\ta,(hl)");
    emit(out, "cp\te");
    emit(out, "jr\tz,L_f%d_strchr_%d", L.func_emit_idx, end);
    emit(out, "and\ta");
    emit(out, "inc\thl");
    emit(out, "jr\tnz,L_f%d_strchr_%d", L.func_emit_idx, start);
    emit(out, "ld\th,a");                 /* a==0 here → HL = 0 (NULL) */
    emit(out, "ld\tl,h");
    fprintf(out, "L_f%d_strchr_%d:\n", L.func_emit_idx, end);
    /* Result is in HL (rs.hl still claims the string vreg — stale, but
       the finalize below overwrites it). The loop clobbered A and (const
       path) E → drop those claims. */
    L.rs.a = -1;
    invalidate_de_cache();
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_poststep(FILE *out, Func *f, const Op *op)
{
    /* dst = old value of src[0]; src[0] += imm (+1 / -1). The stepped
       var is always slot-resident (the allocator pins POSTSTEP's
       src[0] to a slot). Leaves HL = the OLD value, dst cached. */
    int x  = op->src[0];
    int up = (op->imm > 0);
    if (fp_active(f)
        && fp_offset_fits(slot_ix_off(f, x))
        && fp_offset_fits(slot_ix_off(f, x) + 1)) {
        int d = slot_ix_off(f, x);
        if (!hl_has(x)) {
            ss_note_reload(f, x);
            emit(out, "ld\tl,(%s%+d)", frame_reg(), d);
            emit(out, "ld\th,(%s%+d)", frame_reg(), d + 1);
        }
        emit(out, up ? "inc\thl" : "dec\thl");
        emit(out, "ld\t(%s%+d),l", frame_reg(), d);
        emit(out, "ld\t(%s%+d),h", frame_reg(), d + 1);
        emit(out, up ? "dec\thl" : "inc\thl");   /* HL = old */
    } else {
        /* Arithmetic in DE, single stack calc, no ex-shuffles. When
           DE holds a live cached value, pay push/pop (11+10T) to keep
           the DE / DEHL caches valid — usually cheaper than the
           downstream reload they'd otherwise eat. */
        int de_live = (L.rs.de >= 0 || L.rs.dehl >= 0);
        int save_de = L.rs.de, save_dehl = L.rs.dehl;
        if (de_live)
            emit(out, "push\tde");
        ss_note_reload(f, x);
        int off = slot_off(f, x) + L.cur_sp_adjust + (de_live ? 2 : 0);
        emit(out, "ld\thl,%d", off);
        emit(out, "add\thl,sp");
        emit(out, "ld\te,(hl)");
        emit(out, "inc\thl");
        emit(out, "ld\td,(hl)");        /* DE = old, HL = &x.hi */
        emit(out, up ? "inc\tde" : "dec\tde");
        emit(out, "ld\t(hl),d");
        emit(out, "dec\thl");
        emit(out, "ld\t(hl),e");         /* x = new */
        emit(out, up ? "dec\tde" : "inc\tde");
        emit(out, "ex\tde,hl");          /* HL = old */
        if (de_live)
            emit(out, "pop\tde");
        /* x changed; HL claims stale. invalidate_hl also clears the
           DE/DEHL caches — restore them when we preserved DE. */
        invalidate_hl_cache();
        if (de_live) {
            L.rs.de   = save_de;
            L.rs.dehl = save_dehl;
        }
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    /* fp path: x changed in memory; any HL/DE claim on x is stale. */
    invalidate_hl_cache();
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_switch(FILE *out, Func *f, const Op *op)
{
    const SwitchInfo *sw = op->sw;
    if (!sw || sw->n_cases <= 0) {
        emit(out, "jp\tL_f%d_bb_%d", L.func_emit_idx,
             sw ? sw->default_bb : 0);
        return 0;
    }

    int is_long = (op->src[0] >= 0 && op->src[0] < f->n_vregs
                   && f->vregs[op->src[0]].width == 4);
    int is_ll   = (op->src[0] >= 0 && op->src[0] < f->n_vregs
                   && f->vregs[op->src[0]].width == 8);

    /* long long (8-byte) dispatch: load the scrutinee into __i64_acc
       (l_i64_load), then l_i64_case with a `defw target ; <8-byte value>`
       table. l_i64_case reads __i64_acc, pops its return address as the
       table pointer, and on no-match continues past the defw 0 terminator
       into the `jp default`. */
    if (is_ll) {
        emit_acc_slot_addr(out, f, op->src[0], 0);
        emit(out, "call\tl_i64_load");
        emit(out, "call\tl_i64_case");
        for (int i = 0; i < sw->n_cases; i++) {
            emit(out, "defw\tL_f%d_bb_%d", L.func_emit_idx, sw->target_bb[i]);
            emit(out, "defw\t%d", (int)(sw->values[i]        & 0xFFFF));
            emit(out, "defw\t%d", (int)((sw->values[i] >> 16) & 0xFFFF));
            emit(out, "defw\t%d", (int)((sw->values[i] >> 32) & 0xFFFF));
            emit(out, "defw\t%d", (int)((sw->values[i] >> 48) & 0xFFFF));
        }
        emit(out, "defw\t0");
        emit(out, "jp\tL_f%d_bb_%d", L.func_emit_idx, sw->default_bb);
        return 0;
    }

    if (sw->is_char && !is_long) {
        /* Inline cp chain — cp is cheap and the table's call/terminator
           overhead doesn't pay for byte compares. */
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
        emit(out, "ld\ta,l");
        for (int i = 0; i < sw->n_cases; i++) {
            int k = (int)(sw->values[i] & 0xFF);
            if (k == 0) emit(out, "and\ta");
            else        emit(out, "cp\t%d", k);
            emit(out, "jp\tz,L_f%d_bb_%d", L.func_emit_idx,
                 sw->target_bb[i]);
        }
        emit(out, "jp\tL_f%d_bb_%d", L.func_emit_idx, sw->default_bb);
        return 0;
    }

    /* Table dispatch. The helper pops its return address as the table
       pointer, so the defw table MUST immediately follow the call. On
       no-match the helper jumps to the byte after the defw 0
       terminator — the `jp default` continuation. Entry layout:
         l_case:      defw target ; defw value
         l_long_case: defw target ; defw value_lo ; defw value_hi */
    if (is_long) {
        load_to_dehl(out, f, op->src[0]);
        emit(out, "call\tl_long_case");
        for (int i = 0; i < sw->n_cases; i++) {
            emit(out, "defw\tL_f%d_bb_%d", L.func_emit_idx,
                 sw->target_bb[i]);
            emit(out, "defw\t%d", (int)(sw->values[i] & 0xFFFF));
            emit(out, "defw\t%d", (int)((sw->values[i] >> 16) & 0xFFFF));
        }
    } else {
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
        emit(out, "call\tl_case");
        for (int i = 0; i < sw->n_cases; i++) {
            emit(out, "defw\tL_f%d_bb_%d", L.func_emit_idx,
                 sw->target_bb[i]);
            emit(out, "defw\t%d", (int)(sw->values[i] & 0xFFFF));
        }
    }
    emit(out, "defw\t0");
    emit(out, "jp\tL_f%d_bb_%d", L.func_emit_idx, sw->default_bb);
    return 0;
}

static int gen_ret_misdispatched(FILE *out, Func *f, const Op *op)
{
    (void)out; (void)f; (void)op;
    /* lower_func dispatches IR_RET directly to lower_ret(). */
    fputs("ir_lower: IR_RET dispatched through lower_op\n", stderr);
    return -1;
}

static int gen_critical_enter(FILE *out, Func *f, const Op *op)
{
    (void)op;
    /* Rabbit has no di/ei — raise the IP priority to mask interrupts. */
    emit(out, (IS_RABBIT()) ? "ipset\t3" : "di");
    return 0;
}

static int gen_critical_leave(FILE *out, Func *f, const Op *op)
{
    (void)op;
    emit(out, (IS_RABBIT()) ? "ipres" : "ei");
    return 0;
}

/* BC tenant saved below a pre-pushed arg block (op->imm==1 on the
   call's first IR_PUSH_ARG). Stack of saved rs.bc values —
   nested calls pair LIFO with their gen_call pops. */
#define BC_ARGS_SAVE_MAX 8
static int bc_args_save_stack[BC_ARGS_SAVE_MAX];
static int bc_args_save_depth;

static int func_has_pr_bc(const Func *f)
{
    if (!f->vreg_to_phys) return 0;
    for (int i = 0; i < f->n_vregs; i++)
        if (f->vreg_to_phys[i] == IR_PR_BC) return 1;
    return 0;
}

static int gen_push_arg(FILE *out, Func *f, const Op *op)
{
    /* Call-arg push at the producer (emitted right after the arg's
       producing op, so the HL/DEHL cache is hot — for PR_HL/PR_DEHL arg
       temps with no slot the cache hit is the ONLY way to reach the value).
       cur_sp_adjust keeps intervening slot offsets correct; gen_call
       rebalances it. */
    if (op->imm == 1 && func_has_pr_bc(f)
        && bc_args_save_depth < BC_ARGS_SAVE_MAX) {
        /* First push of this call: save the PR_BC tenant BELOW the
           arg block (a save in gen_call would land above the args).
           gen_call's matching pop restores it after the cleanup. */
        emit(out, "push\tbc");
        bc_args_save_stack[bc_args_save_depth++] = L.rs.bc;
        L.cur_sp_adjust += 2;
    }
    int v = op->src[0];
    int w = (v >= 0 && v < f->n_vregs) ? f->vregs[v].width : 2;
    if (w == 4) {
        load_to_dehl(out, f, v);
        emit(out, "push\tde");
        emit(out, "push\thl");
        L.cur_sp_adjust += 4;
    } else {
        if (!hl_has(v)) load_to_hl(out, f, v);
        emit(out, "push\thl");
        L.cur_sp_adjust += 2;
    }
    return 0;
}

static int gen_push_dehl_long(FILE *out, Func *f, const Op *op)
{
    /* The long value to save must currently be in DEHL — ir_opt
       inserts the PUSH immediately after a long-producing op so DEHL
       is hot. We rely on the cache: if dehl_has(src[0]) we skip the
       load (free push); otherwise we load it first. */
    if (op->src[0] < 0) {
        fputs("ir_lower: IR_PUSH_DEHL_LONG with no src vreg\n", stderr);
        return -1;
    }
    if (!dehl_has(op->src[0])) {
        load_to_dehl(out, f, op->src[0]);
        emit(out, "push\tde");       /* high half */
        emit(out, "push\thl");       /* low half — popped first */
    } else {
        /* DEHL-cache hit. The invariant is BC = low half; HL only holds
           the low half when rs.hl advertises it (e.g. after
           cache_dehl_no_spill). The fp byte-direct dead-dst binop path
           caches with BC=low and HL=junk — pushing HL there would push
           garbage as the low half, so push BC unless rs.hl matches. */
        emit(out, "push\tde");       /* high half */
        emit(out, "push\t%s",
             (L.rs.hl == op->src[0]) ? "hl" : "bc");
    }
    L.cur_sp_adjust += 4;
    /* Option B: advertise the vreg as stack-resident so a later
       long-binop consumer (OR/AND/XOR/ADD/SUB) can absorb it directly
       via its stack-resident fastpath, eliding both the POP and a
       fresh slot spill of the intermediate result. */
    L.la.cur_stack_long_top = op->src[0];
    return 0;
}

static int gen_pop_dehl_long(FILE *out, Func *f, const Op *op)
{
    /* Restore the saved long into DEHL. Must be paired with a matching
       IR_PUSH_DEHL_LONG; the stack frame at this point must have the
       saved value on top. */
    if (L.cur_sp_adjust < 4) {
        fprintf(stderr,
            "ir_lower: IR_POP_DEHL_LONG with insufficient stack "
            "(cur_sp_adjust=%d)\n", L.cur_sp_adjust);
        return -1;
    }
    emit(out, "pop\thl");            /* low half (pushed last) */
    emit(out, "pop\tde");            /* high half */
    L.cur_sp_adjust -= 4;
    if (L.la.cur_stack_long_top == op->src[0])
        L.la.cur_stack_long_top = -1;
    if (op->src[0] >= 0) {
        /* DEHL invariant wants BC = low half: mirror HL → BC. The pops
           physically clobbered HL and DE — drop stale tenant claims BEFORE
           re-advertising DEHL, else e.g. gen_st_mem's DEHL-hit path
           stale-hits hl_has(base) and stores through itself as the address. */
        emit(out, "ld\tbc,hl");
        invalidate_hl_cache();
        cache_dehl(op->src[0]);
    } else {
        invalidate_hl_bc();
    }
    return 0;
}

static int gen_asm(FILE *out, Func *f, const Op *op)
{
    if (op->asm_text) {
        /* Raw passthrough — text is one or more newline-separated
           lines the user wrote inside __asm{}. Emit verbatim. */
        fputs(op->asm_text, out);
        if (op->asm_text[0]
            && op->asm_text[strlen(op->asm_text) - 1] != '\n')
            fputc('\n', out);
    }
    /* Inline asm is opaque — assume full register/cache clobber. */
    invalidate_hl_bc();
    /* asm-as-expression: capture the result the asm left in the return
       register(s) into op->dst, mirroring a call return — HL for width<=2,
       DEHL for width 4. No HL->DEHL widening: a width-4 context trusts the
       asm to have filled DEHL. (Statement-level asm has dst<0 and is left
       exactly as before.) */
    if (op->dst >= 0) {
        int w = f->vregs[op->dst].width;
        invalidate_de_cache();   /* asm clobbered DE too; clean before store */
        if (w == 4)
            store_dehl_cached(out, f, op->dst);
        else if (w == 1) {
            emit(out, "ld\ta,l");
            if (L.la.cur_dst_dead || vreg_in_register_pool(f, op->dst))
                cache_a(op->dst);
            else
                store_a_byte(out, f, op->dst);
        } else
            store_hl(out, f, op->dst);
    }
    return 0;
}

static int gen_neg(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        /* Long NEG: DEHL = 0 - src[0], done as ~x + 1 byte-wise to
           avoid l_long_sub for a trivial constant LHS. */
        load_to_dehl(out, f, op->src[0]);
        emit(out, "ld\ta,l"); emit(out, "cpl");
        emit(out, "add\ta,1");        /* +1, sets carry if a was 0xff */
        emit(out, "ld\tl,a");
        emit(out, "ld\ta,h"); emit(out, "cpl");
        emit(out, "adc\ta,0");
        emit(out, "ld\th,a");
        emit(out, "ld\ta,e"); emit(out, "cpl");
        emit(out, "adc\ta,0");
        emit(out, "ld\te,a");
        emit(out, "ld\ta,d"); emit(out, "cpl");
        emit(out, "adc\ta,0");
        emit(out, "ld\td,a");
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    /* HL = -src[0]. Rabbit r4k negates HL in place; else load src to DE
       and sbc HL=0,DE. */
    if (IS_RABBIT4K()) {
        if (!hl_has(op->src[0]))
            load_to_hl(out, f, op->src[0]);
        emit(out, "neg\thl");
    } else {
        load_to_de(out, f, op->src[0]);
        emit(out, "ld\thl,0");
        emit(out, "or\ta");
        emit(out, "sbc\thl,de");
    }
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_not(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        /* Fused load+cpl: walk HL through the source slot reading
           each byte into A, complement, write into the target
           register. Avoids the separate full DEHL load + 4× byte
           cpl chain (~16T saved per occurrence). Gated on a slot
           read (no DEHL cache hit, no FP mode). */
        if (!fp_active(f) && !dehl_has(op->src[0])) {
            int off = slot_off(f, op->src[0]) + L.cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,(hl)"); emit(out, "cpl");
            emit(out, "ld\tc,a");           /* C = ~byte0 */
            emit(out, "inc\thl");
            emit(out, "ld\ta,(hl)"); emit(out, "cpl");
            emit(out, "ld\tb,a");           /* B = ~byte1 */
            emit(out, "inc\thl");
            emit(out, "ld\ta,(hl)"); emit(out, "cpl");
            emit(out, "ld\te,a");           /* E = ~byte2 */
            emit(out, "inc\thl");
            emit(out, "ld\ta,(hl)"); emit(out, "cpl");
            emit(out, "ld\td,a");           /* D = ~byte3 */
            emit(out, "ld\thl,bc");         /* HL = low half */
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Long ~: cpl each byte of DEHL. The chain reads H/L/E/D
           only — no BC use. Tell load_to_dehl's FP path to skip
           its BC stash (saves 2B). store_dehl_finalize at the
           tail handles re-publishing BC for the new dst. */
        L.la.cur_load_to_dehl_no_bc = 1;
        load_to_dehl(out, f, op->src[0]);
        emit(out, "ld\ta,l"); emit(out, "cpl"); emit(out, "ld\tl,a");
        emit(out, "ld\ta,h"); emit(out, "cpl"); emit(out, "ld\th,a");
        emit(out, "ld\ta,e"); emit(out, "cpl"); emit(out, "ld\te,a");
        emit(out, "ld\ta,d"); emit(out, "cpl"); emit(out, "ld\td,a");
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    /* Bitwise complement: HL = ~src[0]. */
    if (!hl_has(op->src[0]))
        load_to_hl(out, f, op->src[0]);
    emit(out, "ld\ta,h");
    emit(out, "cpl");
    emit(out, "ld\th,a");
    emit(out, "ld\ta,l");
    emit(out, "cpl");
    emit(out, "ld\tl,a");
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_conv_zx(FILE *out, Func *f, const Op *op)
{
    int src_w = f->vregs[op->src[0]].width;
    int dst_w = f->vregs[op->dst].width;
    if (dst_w == 1) {
        /* Zero-extend whose result is only consumed at byte width
           (ir_opt_narrow_byte narrowed the dst): the low byte of the
           source IS the result — a byte copy through A, no widening. */
        load_byte_to_a(out, f, op->src[0]);
        return finalize_byte_result(out, f, op, 1);
    }
    if (src_w == 1 && dst_w == 2) {
        load_byte_to_a(out, f, op->src[0]);
        /* PR_DE: write into E,D directly. Same instruction count
           as L,H but no spill follows. */
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ld\te,a");
            emit(out, "ld\td,0");
            cache_de(op->dst);
            return 0;
        }
        emit(out, "ld\tl,a");
        emit(out, "ld\th,0");
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    if (src_w == 1 && dst_w == 4) {
        /* Char → long zero-extend: A into L, clear H/E/D. */
        load_byte_to_a(out, f, op->src[0]);
        emit(out, "ld\tl,a");
        emit(out, "ld\th,0");
        emit(out, "ld\tde,0");
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (src_w == 2 && dst_w == 4) {
        /* Int → long zero-extend: load HL, clear DE. */
        load_to_hl(out, f, op->src[0]);
        emit(out, "ld\tde,0");
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (src_w == 4 && dst_w == 4) {     /* identity (same-width zero-extend) */
        load_to_dehl(out, f, op->src[0]);
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (src_w == 2 && dst_w == 2) {     /* identity */
        load_to_hl(out, f, op->src[0]);
        store_hl(out, f, op->dst);
        return 0;
    }
    fprintf(stderr, "ir_lower: CONV_ZX %d→%d not supported\n", src_w, dst_w);
    return -1;
}

static int gen_conv_sx(FILE *out, Func *f, const Op *op)
{
    int src_w = f->vregs[op->src[0]].width;
    int dst_w = f->vregs[op->dst].width;
    if (dst_w == 1) {
        /* Sign-extend whose result is only consumed at byte width
           (ir_opt_narrow_byte narrowed the dst): the low byte of the
           source IS the result — a byte copy through A, the high-byte
           sign-fill is dead. Mirrors the gen_conv_zx dst_w==1 path. */
        load_byte_to_a(out, f, op->src[0]);
        return finalize_byte_result(out, f, op, 1);
    }
    if (src_w == 1 && dst_w == 2) {
        load_byte_to_a(out, f, op->src[0]);
        /* PR_DE: write into E,D. The rlca/sbc-a-a sign-extend
           trick is unchanged — it leaves the extended byte in A,
           we just store to D instead of H. */
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ld\te,a");
            emit(out, "rlca");
            emit(out, "sbc\ta,a");
            emit(out, "ld\td,a");
            cache_de(op->dst);
            return 0;
        }
        emit(out, "ld\tl,a");
        /* Sign-extend A into H via the rlca/sbc-a-a trick:
           rlca rotates bit 7 into CF; sbc a,a fills A with 0 or -1. */
        emit(out, "rlca");
        emit(out, "sbc\ta,a");
        emit(out, "ld\th,a");
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    if (src_w == 1 && dst_w == 4) {
        /* Char → long sign-extend: A's bit 7 fills H, E, D. */
        load_byte_to_a(out, f, op->src[0]);
        emit(out, "ld\tl,a");
        emit(out, "rlca");
        emit(out, "sbc\ta,a");           /* A = 0 or 0xff */
        emit(out, "ld\th,a");
        emit(out, "ld\te,a");
        emit(out, "ld\td,a");
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (src_w == 2 && dst_w == 4) {
        /* Int → long sign-extend: H's bit 7 fills DE. */
        load_to_hl(out, f, op->src[0]);
        emit(out, "ld\ta,h");
        emit(out, "rlca");
        emit(out, "sbc\ta,a");
        emit(out, "ld\te,a");
        emit(out, "ld\td,a");
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    if (src_w == 2 && dst_w == 2) {
        load_to_hl(out, f, op->src[0]);
        store_hl(out, f, op->dst);
        return 0;
    }
    if (src_w == 4 && dst_w == 4) {
        /* Same-width long sign-extend = identity; copy through DEHL. */
        load_to_dehl(out, f, op->src[0]);
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    fprintf(stderr, "ir_lower: CONV_SX %d→%d not supported\n", src_w, dst_w);
    return -1;
}

static int gen_conv_trunc(FILE *out, Func *f, const Op *op)
{
    int src_w = f->vregs[op->src[0]].width;
    int dst_w = f->vregs[op->dst].width;
    if ((src_w == 1 || src_w == 2) && dst_w == 1) {
        /* 2→1 narrow, or 1→1 no-op trunc (e.g. `(signed char)(char_expr)`
           where the expr was already evaluated at byte width, or a
           narrowed binop feeding `c = c<op>x`). Either way the low byte
           is the result; copy it through A. A width-1 src stays in A
           (no HL widening) and hits the producer's A-cache. */
        if (src_w == 1) {
            load_byte_to_a(out, f, op->src[0]);
        } else {
            load_to_hl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
        }
        store_a_byte(out, f, op->dst);
        return 0;
    }
    if (src_w == 2 && dst_w == 2) {
        load_to_hl(out, f, op->src[0]);
        store_hl(out, f, op->dst);
        return 0;
    }
    if (src_w == 4 && dst_w == 2) {
        /* Long → int: just take the low half (HL of DEHL). */
        load_to_dehl(out, f, op->src[0]);
        store_hl(out, f, op->dst);
        invalidate_hl_cache();
        return 0;
    }
    if (src_w == 4 && dst_w == 1) {
        /* Long → char: take low byte of low half. */
        load_to_dehl(out, f, op->src[0]);
        emit(out, "ld\ta,l");
        store_a_byte(out, f, op->dst);
        invalidate_hl_cache();
        return 0;
    }
    fprintf(stderr, "ir_lower: CONV_TRUNC %d→%d not supported\n", src_w, dst_w);
    return -1;
}

static int gen_conv_byte_to_high(FILE *out, Func *f, const Op *op)
{
    int src_w = f->vregs[op->src[0]].width;
    int dst_w = f->vregs[op->dst].width;
    if (src_w == 1 && dst_w == 2) {
        load_byte_to_a(out, f, op->src[0]);
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ld\td,a");
            emit(out, "ld\te,0");
            cache_de(op->dst);
            return 0;
        }
        emit(out, "ld\th,a");
        emit(out, "ld\tl,0");
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    fprintf(stderr, "ir_lower: CONV_BYTE_TO_HIGH %d→%d not supported\n",
            src_w, dst_w);
    return -1;
}

/* z80n constant 16-bit shift via `bsla/bsrl de,b`. Fires only when it
   does NOT grow code vs the unrolled form: SHL unrolls to N `add hl,hl`
   (1B each), SHR to N `srl h;rr l` (2B each), both with a ld-pair
   reduction at >=8 (cost N-6 there). The barrel form adds a fixed
   `ld b,N` + `ex de,hl` + `bsxa de,b` (+ `ex de,hl` unless dst is PR_DE)
   on top of the shared load_to_hl. So it wins for SHR N>=3 and SHL N>=6
   (and high counts) where add-hl-hl's cheapness no longer dominates.
   bsxa sets no flags, but the result is a value, never a branch cond.
   Returns 1 if it emitted the shift. */
static int try_const_barrel(FILE *out, Func *f, const Op *op, int is_shr)
{
    if (!(IS_Z80N()) || op->src[1] >= 0)
        return 0;
    int n = (int)op->imm & 0x1f;
    if (n < 1 || n >= 16) return 0;          /* 0 and >=16 handled by caller */
    int unroll = (n >= 8) ? (n - 6) : (is_shr ? 2 * n : n);
    int pr_de  = vreg_is_pr_de(f, op->dst);
    /* +2 when a live BC must be saved around the count load (see below). */
    int barrel = 5 + (pr_de ? 0 : 1) + (L.rs.bc >= 0 ? 2 : 0);
    if (unroll < barrel) return 0;
    load_to_hl(out, f, op->src[0]);
    /* `ld b,N` clobbers B; a live BC tenant (rs.bc>=0) may be
       register-resident with a stale slot, so push/pop it — bsxa sets no
       flags and pop bc doesn't touch them, so K/CF etc. are irrelevant
       here anyway and BC is restored intact. */
    int bc_live = (L.rs.bc >= 0);
    if (bc_live) emit(out, "push\tbc");
    emit(out, "ld\tb,%d", n);
    emit(out, "ex\tde,hl");                  /* DE = value */
    emit(out, is_shr ? "bsrl\tde,b" : "bsla\tde,b");
    if (bc_live) emit(out, "pop\tbc");       /* restore live BC */
    invalidate_hl_cache();
    invalidate_de_cache();
    if (!bc_live) invalidate_bc_cache();
    if (pr_de) { cache_de(op->dst); return 1; }
    emit(out, "ex\tde,hl");                  /* HL = result */
    commit_hl_word(out, f, op->dst);
    return 1;
}

/* 8080/8085 constant long (width-4) shift. Whole-byte shifts are free
   register moves (no CB ops); only the count%8 residual goes to the
   l_lsl_dehl/l_lsr_dehl bit-loop. Without this split a `>>25` would loop
   the helper 25× instead of "drop 3 bytes + >>1".
   DEHL byte layout: L=b0, H=b1, E=b2, D=b3 (D = MSB).
   Caller has already handled count==0 and count>=32. */
static void gen_808x_long_const_shift(FILE *out, Func *f, const Op *op,
                                      int count, int is_shr)
{
    int byte_shift = count / 8;
    int bit_shift  = count % 8;
    /* Whole-byte part. When src isn't in the DEHL cache the slot is
       authoritative, so partial_load_long_{shr,shl} reads ONLY the
       surviving bytes straight into their final DEHL slots (e.g. >>24
       loads just byte 3 into L) — no wasted loads. But when src IS
       cached the slot may be stale (the partial load would read garbage,
       like the z80 path which also gates its partial load on !dehl_has),
       so recover the live value via load_to_dehl and shift the bytes in
       registers. byte_shift==0 needs the whole value either way. */
    if (byte_shift == 0) {
        load_to_dehl(out, f, op->src[0]);
    } else if (!dehl_has(op->src[0])) {
        if (is_shr) partial_load_long_shr(out, f, op->src[0], byte_shift);
        else        partial_load_long_shl(out, f, op->src[0], byte_shift);
    } else {
        /* Cached: DEHL/BC hold src (L=b0,H=b1,E=b2,D=b3). Move whole
           bytes in registers toward LSB (shr) or MSB (shl). */
        load_to_dehl(out, f, op->src[0]);
        if (is_shr) {
            switch (byte_shift) {
            case 1: emit(out,"ld\tl,h"); emit(out,"ld\th,e");
                    emit(out,"ld\te,d"); emit(out,"ld\td,0"); break;
            case 2: emit(out,"ld\tl,e"); emit(out,"ld\th,d");
                    emit(out,"ld\te,0"); emit(out,"ld\td,0"); break;
            case 3: emit(out,"ld\tl,d"); emit(out,"ld\th,0");
                    emit(out,"ld\te,0"); emit(out,"ld\td,0"); break;
            default: break;
            }
        } else {
            switch (byte_shift) {
            case 1: emit(out,"ld\td,e"); emit(out,"ld\te,h");
                    emit(out,"ld\th,l"); emit(out,"ld\tl,0"); break;
            case 2: emit(out,"ld\td,h"); emit(out,"ld\te,l");
                    emit(out,"ld\th,0"); emit(out,"ld\tl,0"); break;
            case 3: emit(out,"ld\td,l"); emit(out,"ld\te,0");
                    emit(out,"ld\th,0"); emit(out,"ld\tl,0"); break;
            default: break;
            }
        }
    }
    /* Residual bit-shift (1..7) via the helper bit-loop. */
    if (bit_shift) {
        emit(out, "ld\ta,%d", bit_shift);
        emit(out, is_shr ? "call\tl_lsr_dehl" : "call\tl_lsl_dehl");
    }
    invalidate_hl_bc();
    store_dehl_finalize(out, f, op->dst);
}

/* ---- Width-1 (8-bit) ALU lowering ---------------------------------
   The byte ops below keep the value in A and never widen to HL — no
   `ld h,0`, no 16-bit form on a known-zero high byte. ir_opt_narrow_byte
   produces the width-1 binops (a promoted int op whose result is only
   truncated back to a byte). */

/* Emit `<prefix><operand>` where the operand is the low byte of vreg m
   and A holds the OTHER operand. `prefix` is the instruction up to the
   operand: "and\t" / "or\t" / "xor\t" / "sub\t" / "add\ta," etc. Does
   not disturb A; may clobber HL (sp-rel slot addressing). */
static void byte_alu_operand(FILE *out, const Func *f,
                             const char *prefix, int m)
{
    if (a_has(m))  { emit(out, "%sa", prefix); return; }
    if (hl_has(m)) { ss_note_cache_read(f, m); emit(out, "%sl", prefix); return; }
    if (de_has(m)) { ss_note_cache_read(f, m); emit(out, "%se", prefix); return; }
    if (bc_has(m)) { ss_note_cache_read(f, m); emit(out, "%sc", prefix); return; }
    ss_note_reload(f, m);
    if (fp_active(f)) {
        int ix = slot_ix_off(f, m);
        if (fp_offset_fits(ix)) {
            emit(out, "%s(%s%+d)", prefix, frame_reg(), ix);
            return;
        }
    }
    pending_spill_resolve();
    int off = slot_off(f, m) + L.cur_sp_adjust;
    emit(out, "ld\thl,%d", off);
    emit(out, "add\thl,sp");
    emit(out, "%s(hl)", prefix);
    hl_about_to_change(-1);
}

/* Commit a width-1 result sitting in A. When the op is the condition of
   an immediately-following BR_ZERO/COND (cur_branch_test_kind set, dst
   dead) the test is fused onto the flags A already carries — the
   producing ALU op set Z (pass want_flags=0); a bare load/copy did not
   (want_flags=1 → `or a`). Otherwise A is cached on a dead/reg dst or
   spilled to the byte slot. */
static int finalize_byte_result(FILE *out, Func *f, const Op *op,
                                int want_flags)
{
    if (L.la.cur_branch_test_kind != 0) {
        if (want_flags) emit(out, "or\ta");
        const char *cc = (L.la.cur_branch_test_kind == IR_BR_ZERO) ? "z" : "nz";
        emit(out, "jp\t%s,L_f%d_bb_%d",
             cc, L.func_emit_idx, L.la.cur_branch_test_label);
        L.la.cur_skip_next_op = 1;
        invalidate_a_cache();
        return 0;
    }
    commit_a_byte(out, f, op->dst);
    return 0;
}

static int gen_shl(FILE *out, Func *f, const Op *op)
{
    int skip_byte = L.la.cur_skip_shl_byte;
    L.la.cur_skip_shl_byte = 0;
    if (op->dst >= 0 && f->vregs[op->dst].width == 1) {
        /* Byte shift+test fuse already did `home<<=1` via `sla <home>`: the
           shifted value is in the home register. In-place SHL → nothing to
           emit (home holds it); fresh-temp SHL → republish the home reg to
           A and advertise it as the temp for the next op. */
        if (skip_byte) {
            if (op->dst != op->src[0]) {
                PhysReg pr = byte_home_phys(f, op->src[0]);
                if (pr != IR_PR_NONE) {
                    emit(out, "ld\ta,%s", byte_home_reg(pr));
                    cache_a(op->dst);
                }
            }
            return 0;
        }
        /* Byte << const, in A (ir_opt_narrow_byte only narrows the
           imm-count form). `add a,a` per bit — CPU-portable (no CB
           shift needed on 8080/8085/gbz80). */
        int count = (int)op->imm & 7;
        /* `home <<= 1` on the resident home → `sla e` (1 op). CB-gated. */
        if (count == 1 && try_inplace_home_unop(out, f, op, "sla", 1))
            return 0;
        if ((int)(op->imm & 0xff) >= 8) {  /* all data shifted out */
            emit(out, "xor\ta");
            return finalize_byte_result(out, f, op, 0);
        }
        load_byte_to_a(out, f, op->src[0]);
        cache_a(op->src[0]);
        for (int k = 0; k < count; k++) emit(out, "add\ta,a");
        return finalize_byte_result(out, f, op, count == 0);
    }
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        if (op->src[1] >= 0) {
            /* Variable-count long shift → l_lsl_dehl helper (DEHL = value,
               A = count, result in DEHL; helper is IX-clean). Stage count
               into HL, copy low byte to A, then load value into DEHL. Mark
               A live first so load_to_dehl's gbz80 byte-walk uses the
               A-preserving `ld r,(hl); inc hl` (not `ld a,(hl+)`, which
               would clobber the count); inert on z80. Drop the A cache
               after (helper clobbers A). */
            if (!hl_has(op->src[1]))
                load_to_hl(out, f, op->src[1]);
            emit(out, "ld\ta,l");
            cache_a(op->src[1]);
            load_to_dehl(out, f, op->src[0]);
            emit(out, "call\tl_lsl_dehl");
            invalidate_a_cache();
            invalidate_hl_bc();
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        int count = (int)op->imm & 0x1f;
        /* In-place long << 1 on a stack slot. Walks the 4 bytes
           via `sla (hl); rl (hl); rl (hl); rl (hl)` from LSB up,
           skipping the DEHL roundtrip. Smaller than 4 × `sla
           (ix+d)`; works in FP mode (sp still valid). */
        if (count == 1
            && op->dst == op->src[0]
            && !L.la.cur_dst_dead
            && !vreg_in_pr_bc(f, op->dst)
            && f->vreg_to_phys
            && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
            int off = slot_off(f, op->dst) + L.cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");        /* HL = &slot[0] (LSB) */
            emit(out, "sla\t(hl)");          /* byte0: low bit=0, hi→C */
            emit(out, "inc\thl");
            emit(out, "rl\t(hl)");           /* byte1: C in low, hi→C */
            emit(out, "inc\thl");
            emit(out, "rl\t(hl)");           /* byte2 */
            emit(out, "inc\thl");
            emit(out, "rl\t(hl)");           /* byte3 */
            invalidate_hl_bc();
            return 0;
        }
        if (count == 0) {
            load_to_dehl(out, f, op->src[0]);
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        if (count >= 32) {
            emit(out, "ld\thl,0");
            emit(out, "ld\tde,0");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* 8080/8085: no CB shifts — byte-boundary split (whole-byte moves
           inline, only count%8 bits via l_lsl_dehl). */
        if (IS_808x()) {
            gen_808x_long_const_shift(out, f, op, count, 0);
            return 0;
        }
        int byte_shift = count / 8;
        int bit_shift  = count % 8;
        /* Partial-load fastpath: for byte_shift ≥ 1 the high bytes
           of the source are discarded. Skip them at load time and
           write the surviving source bytes directly into their
           final target positions. Only fires on a slot read — if
           DEHL is already cached we keep the existing 2-inst cache
           hit + strength-reduced byte shuffle path. */
        if (byte_shift >= 1 && !dehl_has(op->src[0])) {
            partial_load_long_shl(out, f, op->src[0], byte_shift);
            /* DEHL no longer reflects src[0] as a whole; clear the
               caches so a subsequent op can't mistake the shifted
               bytes for the original source. */
            invalidate_hl_cache();
            goto shl_long_bit_shift;
        }
        load_to_dehl(out, f, op->src[0]);
        /* Byte shift left, strength-reduced to a fixed 4-inst sequence
           targeting the final byte positions directly. Layout:
           D=byte3 E=byte2 H=byte1 L=byte0; each byte moves up by
           `byte_shift`, the lowest `byte_shift` bytes become zero. */
        switch (byte_shift) {
        case 0: break;
        case 1: /* D=E E=H H=L L=0 */
            emit(out, "ld\td,e");
            emit(out, "ld\te,h");
            emit(out, "ld\th,l");
            emit(out, "ld\tl,0");
            break;
        case 2: /* D=H E=L H=0 L=0; chain the zero through r,r */
            emit(out, "ld\td,h");
            emit(out, "ld\te,l");
            emit(out, "ld\th,0");
            emit(out, "ld\tl,h");
            break;
        case 3: /* D=L E=0 H=0 L=0; chain the zeros */
            emit(out, "ld\td,l");
            emit(out, "ld\te,0");
            emit(out, "ld\th,e");
            emit(out, "ld\tl,h");
            break;
        default: break; /* count<32 ensures byte_shift∈[0,3] */
        }
    shl_long_bit_shift:
        /* Bit shift left through carry. After a partial load the low
           `byte_shift` bytes are zero, so trim the chain to bytes with
           data. For larger bit_shift, wrap the body in a djnz loop rather
           than unroll — `bit_shift * body_sz > body_sz + 4` is the exact
           size break-even (djnz adds ld b,N + djnz = 4 bytes); strict form
           never grows code. */
        {
        static const int body_sz_shl[4] = { 5, 6, 4, 2 };
        int body_sz = body_sz_shl[byte_shift];
        int use_djnz = (bit_shift * body_sz > body_sz + 4);
        int iters = use_djnz ? 1 : bit_shift;
        int loop_label = 0;
        if (use_djnz) {
            loop_label = L.cmp_label_counter++;
            emit(out, "ld\tb,%d", bit_shift);
            fprintf(out, "L_f%d_shl_loop_%d:\n",
                    L.func_emit_idx, loop_label);
        }
        for (int i = 0; i < iters; i++) {
            switch (byte_shift) {
            case 0: /* all 4 bytes have data */
                emit(out, "add\thl,hl");
                emit(out, "rl\te");
                emit(out, "rl\td");
                break;
            case 1: /* L=0; H,E,D have data */
                emit(out, "sla\th");
                emit(out, "rl\te");
                emit(out, "rl\td");
                break;
            case 2: /* L=H=0; only D,E have data */
                emit(out, "sla\te");
                emit(out, "rl\td");
                break;
            case 3: /* L=H=E=0; only D has data */
                emit(out, "sla\td");
                break;
            }
        }
        if (use_djnz) {
            emit(out, "djnz\tL_f%d_shl_loop_%d",
                 L.func_emit_idx, loop_label);
            invalidate_bc_cache();
        }
        }
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    /* Imm count: unroll. Variable count: loop. */
    if (op->src[1] < 0) {
        int count = (int)op->imm & 0x1f;
        /* Shifts of 16+ produce zero — short-circuit before
           touching src[0]. */
        if (count >= 16) {
            if (vreg_is_pr_de(f, op->dst)) {
                emit(out, "ld\tde,0");
                cache_de(op->dst);
                return 0;
            }
            emit(out, "ld\thl,0");
            commit_hl_word(out, f, op->dst);
            return 0;
        }
        if (try_const_barrel(out, f, op, 0)) return 0;
        /* Partial-load fastpath for int SHL ≥ 8: only the low
           byte of the source survives, and goes into H of the
           result. Read it directly; skip the high byte. Only fires
           on a genuine SLOT read — a register-only vreg (PR_BC/HL/DE,
           vreg_spill_slot == -1) would otherwise read a bogus
           below-frame offset; for those fall through to load_to_hl
           (which copies BC/DE→HL) + the `ld h,l` strength reduction. */
        if (count >= 8 && !hl_has(op->src[0])
            && f->vreg_spill_slot && f->vreg_spill_slot[op->src[0]] >= 0) {
            ss_note_reload(f, op->src[0]);
            if (fp_active(f)) {
                int ix = slot_ix_off(f, op->src[0]);
                if (fp_offset_fits(ix)) {
                    emit(out, "ld\th,(%s%+d)", frame_reg(), ix);
                    emit(out, "ld\tl,0");
                    goto shl_int_bit_remainder;
                }
            }
            int off = slot_off(f, op->src[0]) + L.cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
            emit(out, "ld\th,(hl)");        /* H = byte 0 */
            emit(out, "ld\tl,0");
            goto shl_int_bit_remainder;
        }
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
        /* Shifts of 8+: high byte shifts out entirely → low byte in H, 0
           in L, then extra shifts above 8 are `add hl,hl`. Saves 8 inst vs
           the straight unroll at count==8 (the `byte << 8` promote). */
        int skip = L.la.cur_skip_shl_add_hl;
        L.la.cur_skip_shl_add_hl = 0;
        if (count >= 8) {
            emit(out, "ld\th,l");
            emit(out, "ld\tl,0");
        shl_int_bit_remainder:
            for (int k = 8; k < count; k++) emit(out, "add\thl,hl");
        } else {
            for (int k = skip; k < count; k++) emit(out, "add\thl,hl");
        }
        /* PR_DE dst: wrap with ex de,hl. +4 T-states; saves the
           ~28-T spill. HL becomes junk (old DE). */
        commit_hl_result(out, f, op->dst);
        return 0;
    }
    /* z80n: variable 16-bit shift-left as a flat `bsla de,b` (8T)
       instead of the add-hl-hl;dec;jr loop (~per-bit). bsla sets no
       flags, but the result feeds a value dst, not a branch. */
    if (IS_Z80N()) {
        load_binop_operands(out, f, op);   /* HL=value(src0), DE=count(src1) */
        int bc_live = (L.rs.bc >= 0);  /* `ld b,e` clobbers B — preserve */
        if (bc_live) emit(out, "push\tbc");
        emit(out, "ld\tb,e");              /* B = count low byte */
        emit(out, "ex\tde,hl");            /* DE = value */
        emit(out, "bsla\tde,b");           /* DE = value << B */
        if (bc_live) emit(out, "pop\tbc");
        invalidate_hl_cache();
        invalidate_de_cache();
        if (!bc_live) invalidate_bc_cache();  /* B clobbered */
        if (vreg_is_pr_de(f, op->dst)) {
            cache_de(op->dst);
            return 0;
        }
        emit(out, "ex\tde,hl");            /* HL = result */
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    int n = L.cmp_label_counter++;
    load_binop_operands(out, f, op);    /* HL=src[0], DE=src[1] */
    emit(out, "ld\ta,e");               /* count into A */
    emit(out, "or\ta");
    emit(out, "jr\tz,L_f%d_shift_end_%d", L.func_emit_idx, n);
    fprintf(out, "L_f%d_shift_loop_%d:\n", L.func_emit_idx, n);
    emit(out, "add\thl,hl");
    emit(out, "dec\ta");
    emit(out, "jr\tnz,L_f%d_shift_loop_%d", L.func_emit_idx, n);
    fprintf(out, "L_f%d_shift_end_%d:\n", L.func_emit_idx, n);
    commit_hl_result(out, f, op->dst);
    return 0;
}

/* Add a small constant to HL. |off| <= 3 uses inc/dec hl (1 byte /
   6T each); larger offsets load the scratch pair (BC when DE must be
   preserved, e.g. long loads). */
static void emit_hl_add_offset(FILE *out, int off, int use_bc)
{
    if (off == 0) return;
    if (off > 0 && off <= 3) {
        for (int i = 0; i < off; i++) emit(out, "inc\thl");
        return;
    }
    if (off < 0 && off >= -3) {
        for (int i = 0; i < -off; i++) emit(out, "dec\thl");
        return;
    }
    emit(out, "ld\t%s,%d", use_bc ? "bc" : "de", off);
    emit(out, "add\thl,%s", use_bc ? "bc" : "de");
    /* The scratch pair just got clobbered — drop any cached value living
       there, INCLUDING a long whose halves the DEHL cache splits across
       DE (high) + BC (low), else an offset compute corrupts a
       register-resident long. */
    if (use_bc) { invalidate_bc_cache(); L.rs.dehl = -1; }
    else        invalidate_de_cache();
}

/* Add a constant `k` (any sign) to a register pair while keeping DE intact —
   for a word DE-home body, where DE holds the accumulator and BC the stepped
   base, so neither is free as `add hl,de`/`ld de,k` scratch. Two DE-clean
   forms, both leaving DE (and HL, when pair!=hl) untouched:
     - A free: `ld a,lo; add a,k.lo; ld a,hi; adc a,k.hi` — 6 bytes for ANY k.
     - else  : an inc/dec <pair> chain — |k| bytes, A-clean, any k.
   Because BOTH are DE-clean for any k, op_de_clean can treat the step/offset
   as clean regardless of magnitude (no cap). `a_free` is the caller's belief
   that A holds nothing live (rs.a < 0, or A is about to be reloaded). */
static void emit_pair_add_de_clean(FILE *out, const char *pair, const char *lo,
                                   const char *hi, int k, int a_free)
{
    if (k == 0) return;
    if (a_free && (k > 4 || k < -4)) {           /* A-add wins past the inc range */
        emit(out, "ld\ta,%s", lo);
        emit(out, "add\ta,%d", k & 0xff);
        emit(out, "ld\t%s,a", lo);
        emit(out, "ld\ta,%s", hi);
        emit(out, "adc\ta,%d", (k >> 8) & 0xff);
        emit(out, "ld\t%s,a", hi);
        invalidate_a_cache();
        return;
    }
    const char *op = k > 0 ? "inc" : "dec";
    int n = k > 0 ? k : -k;
    for (int i = 0; i < n; i++) emit(out, "%s\t%s", op, pair);
}

static int gen_ld_mem(FILE *out, Func *f, const Op *op)
{
    emit_ns_switch(out, mem_bank_fn(&op->mem));   /* __addressmod: page in */
    if (op->dst >= 0 && f->vregs[op->dst].width > 4) {
        /* Wide load: address into HL, acc_load→accumulator, store→dst slot. */
        if (op->mem.kind == IR_MEM_POOL) {
            /* Big-constant literal pool: `i_<litlab>` (const.c bigconst). */
            emit(out, "ld\thl,i_%d", op->mem.offset);
        } else if (op->mem.kind == IR_MEM_SYM) {
            if (op->mem.offset)
                emit(out, "ld\thl,_%s+%d", ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\thl,_%s", ir_sym_name(op->mem.sym));
        } else {
            load_to_hl(out, f, op->mem.base);
            emit_hl_add_offset(out, op->mem.offset, 0);  /* base+off (DE free) */
        }
        emit(out, "call\t%s", acc_prim(f, op->dst, "load"));
        if (!wide_acc_result_dead_in_acc(f, op->dst)) {
            emit_acc_slot_addr(out, f, op->dst, 0);
            emit_acc_store_hl(out, f, op->dst);
        }
        invalidate_hl_bc();          /* the acc_load clobbered HL/BC regardless */
        *wide_acc_cell(f, op->dst) = op->dst;
        return 0;
    }
    if (op->mem.kind == IR_MEM_SYM) {
        int dst_w = (op->dst >= 0)
                  ? f->vregs[op->dst].width : 2;
        if (getenv("IR_LDMEM_TRACE"))
            fprintf(stderr, "LD_MEM SYM dst=v%d width=%d\n",
                    op->dst, dst_w);
        if (dst_w == 4) {
            /* Long load from a global, mirror of the long-store path:
               `ld hl,(_sym)` low half, `ld de,(_sym+2)` high half
               (else the read truncates to int). */
            int off = op->mem.offset;
            if (off)
                emit(out, "ld\thl,(_%s+%d)",
                     ir_sym_name(op->mem.sym), off);
            else
                emit(out, "ld\thl,(_%s)", ir_sym_name(op->mem.sym));
            emit(out, "ld\tde,(_%s+%d)",
                 ir_sym_name(op->mem.sym), off + 2);
            /* __far pointer VALUE is 3 bytes in memory: the 4th byte read
               by `ld de,(sym+2)` is garbage (it's sym+3). Zero D to keep
               the DEHL far-ptr invariant (D=0, E=bank, HL=offset). */
            if (op->mem.elem == KIND_CPTR)
                emit(out, "ld\td,0");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        if (dst_w == 1) {
            /* Byte load from a global. Value stays in A; consumers widen
               via load_to_hl's width-1 path / load_byte_to_a. The spill
               MUST be byte-sized (store_a_byte, not store_hl): a word spill
               into a trailing 1-byte slot writes one past the frame and
               clobbers the return address. */
            if (op->mem.offset)
                emit(out, "ld\ta,(_%s+%d)",
                     ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\ta,(_%s)", ir_sym_name(op->mem.sym));
            commit_a_byte(out, f, op->dst);
            return 0;
        }
        /* PR_DE dst: load into DE directly, no spill. */
        if (op->dst >= 0 && f->vreg_to_phys
            && f->vreg_to_phys[op->dst] == IR_PR_DE) {
            if (op->mem.offset)
                emit(out, "ld\tde,(_%s+%d)",
                     ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\tde,(_%s)", ir_sym_name(op->mem.sym));
            cache_de(op->dst);
            return 0;
        }
        if (op->mem.offset)
            emit(out, "ld\thl,(_%s+%d)",
                 ir_sym_name(op->mem.sym), op->mem.offset);
        else
            emit(out, "ld\thl,(_%s)", ir_sym_name(op->mem.sym));
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    if (op->mem.kind == IR_MEM_VREG) {
        /* Fused (long)*p++ fastpath. When the load is a byte-to-long
           zero-extend with a post-inc on the base pointer (set only
           by the OP_CAST char→long path in ir_build), increment p's
           slot in place via `inc (hl)` and read the byte directly —
           skips the byte spill + reload across IR_INC. Needs p
           addressable via sp+K, which excludes PR_BC. */
        int _dst_w = f->vregs[op->dst].width;
        if (_dst_w == 4
            && op->mem.post_step == 1
            && op->mem.base >= 0
            && !vreg_in_pr_bc(f, op->mem.base)) {
            int p_off = slot_off(f, op->mem.base) + L.cur_sp_adjust;
            emit(out, "ld\thl,%d", p_off);
            emit(out, "add\thl,sp");          /* HL = &p */
            emit(out, "inc\t(hl)");            /* ++p.byte0 */
            emit(out, "ld\ta,(hl+)");            /* A = new byte0 */
            emit_skip(out, f, "nz", 1);        /* no carry → skip the inc */
            emit(out, "inc\t(hl)");            /* propagate carry */
            emit(out, "ld\th,(hl)");            /* H = new byte1 */
            emit(out, "ld\tl,a");               /* HL = new p */
            emit(out, "dec\thl");               /* HL = old p */
            emit(out, "ld\tl,(hl)");            /* L = *old_p */
            emit(out, "ld\th,0");
            emit(out, "ld\te,h");
            emit(out, "ld\td,e");               /* DEHL = (long)*old_p */
            /* p's value changed (now p+1); invalidate any cached
               claim on p_vreg. HL holds (0, byte), not a vreg. */
            invalidate_hl_bc();
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Byte `*p++` post-step (ir_match `derefpp`). Deref and bump p in
           one HL tenancy: load p, read the byte, inc/dec HL, write p back
           to its HOME. p may be PR_BC (a loop pointer often is) or spilled;
           both homes are written below. */
        if (_dst_w == 1 && op->mem.post_step != 0 && op->mem.base >= 0) {
            int base = op->mem.base;
            /* PR_BC byte pointer `*p++`/`*p--`: `ld a,(bc); inc/dec bc`
               steps the pointer in place with no HL copy-out/copy-back
               (the old `ld hl,bc; ld a,(hl); inc hl; ld c,l; ld b,h`).
               `ld a,(bc)` is the direct 16-bit indirect byte load; HL/DE
               caches are left untouched. Byte-array stride is ±1. */
            if (vreg_in_pr_bc(f, base)
                && (op->mem.post_step == 1 || op->mem.post_step == -1)) {
                emit(out, "ld\ta,(bc)");               /* A = *p */
                emit(out, op->mem.post_step > 0 ? "inc\tbc" : "dec\tbc");
                cache_bc(base);                        /* BC = p±1 (live base) */
                commit_a_byte(out, f, op->dst);
                return 0;
            }
            if (!hl_has(base))
                load_to_hl(out, f, base);              /* HL = p */
            emit(out, "ld\ta,(hl)");                   /* A = *p */
            emit(out, op->mem.post_step > 0 ? "inc\thl" : "dec\thl");
            if (vreg_in_pr_bc(f, base)) {
                /* p lives in BC — write the bumped pointer back there so
                   the next iteration sees it (a slot store alone would
                   leave BC stale → infinite loop). */
                emit(out, "ld\tc,l");
                emit(out, "ld\tb,h");
                invalidate_hl_cache();
                cache_bc(base);
            } else {
                store_hl(out, f, base);                /* p slot = p±1 */
                invalidate_hl_cache();
                invalidate_de_cache();
                /* store_hl never touches BC — do NOT drop a live PR_BC
                   resident's belief here. It is slotless, so a spurious
                   invalidate forces emit_bc_reload to read a bogus
                   below-frame offset. */
            }
            commit_a_byte(out, f, op->dst);
            return 0;
        }
        /* Word `*p++` post-step (int* idiom; step = ±elemsize). Read the
           word through p into DE, bump HL to p+step, write the bumped
           pointer back to p's HOME (BC if PR_BC — else the slot), then
           move the value into place. DE is the value scratch so BC stays
           free for the PR_BC pointer home (`ld l,e; ld h,d` not `ex de,hl`
           — works on gbz80, which only emulates ex). */
        if (_dst_w == 2 && op->mem.post_step != 0 && op->mem.base >= 0) {
            int base = op->mem.base;
            if (!hl_has(base))
                load_to_hl(out, f, base);              /* HL = p */
            emit(out, "ld\te,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\td,(hl)");                   /* DE = *p, HL = p+1 */
            emit_hl_add_offset(out, op->mem.post_step - 1, 0);  /* HL = p+step */
            if (vreg_in_pr_bc(f, base)) {
                emit(out, "ld\tc,l");
                emit(out, "ld\tb,h");                  /* BC home = p+step */
                invalidate_hl_cache();
                cache_bc(base);
            } else {
                /* Store p+step (HL) to the slot WITHOUT disturbing DE (the
                   loaded value). store_hl's `ex de,hl` would relocate DE
                   (8085/generic-sp destroy it), so emit the DE-clean store
                   inline where one exists; else stage the value on the stack
                   across store_hl. store_hl is BC-clean either way. */
                int stored = 0;
                if (fp_active(f)) {
                    int d = slot_ix_off(f, base);
                    if (fp_offset_fits(d) && fp_offset_fits(d + 1)) {
                        emit(out, "ld\t(%s%+d),hl", frame_reg(), d);
                        stored = 1;
                    }
                } else {
                    int off = slot_off(f, base) + L.cur_sp_adjust;
                    if (off >= 0 && off <= sp_rel_max(f)) {
                        emit(out, "ld\t(sp+%d),hl", off);
                        stored = 1;
                    }
                }
                if (!stored) {
                    emit(out, "push\tde");                 /* save value */
                    L.cur_sp_adjust += 2;
                    store_hl(out, f, base);                /* p slot = p+step */
                    emit(out, "pop\tde");                  /* restore value */
                    L.cur_sp_adjust -= 2;
                }
                invalidate_hl_cache();
            }
            if (op->dst >= 0 && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_DE) {
                cache_de(op->dst);                     /* value preserved in DE */
                return 0;
            }
            emit(out, "ld\tl,e");
            emit(out, "ld\th,d");                      /* HL = value */
            invalidate_de_cache();
            commit_hl_word(out, f, op->dst);
            return 0;
        }
        /* Indirect: base vreg holds the address; load through it.
           Cache-aware: if HL already holds the base, skip the load.
           Common after a post-inc save (`old = data`, then deref). */
        if (!hl_has(op->mem.base))
            load_to_hl(out, f, op->mem.base);
        int dst_w = f->vregs[op->dst].width;
        /* Word DE-home active: reach the field offset DE-clean (DE = home
           accumulator, BC = stepped base, neither free as scratch). A is
           free (the load below clobbers it). Any offset (A-add is
           constant-size), so no struct-size cap. */
        if (L.cur_home_is_word && dst_w == 2 && op->dst != L.cur_func_whome
            && op->mem.offset > 3) {
            emit_pair_add_de_clean(out, "hl", "l", "h", op->mem.offset,
                                   L.rs.a < 0);
        } else {
            /* Width 4 can't clobber DE (needed for the high half) —
               scratch through BC; widths 1/2 use DE. Small offsets
               become inc/dec hl chains. */
            emit_hl_add_offset(out, op->mem.offset, dst_w == 4);
        }
        if (dst_w == 1) {
            /* Byte load into A. If dst is dead-after-next (the
               common `b = *p; foo((int)b)` shape via CONV), keep
               the byte in A and let the CONV's load_byte_to_a
               become a cache hit. cache_a is set; invalidate
               HL/DE since the address load clobbered them. */
            emit(out, "ld\ta,(hl)");
            /* Caching the base here (HL intact when offset==0) looked like
               a free win for a following p++ but regressed via a
               cache-interaction chain; keep the plain invalidate. */
            invalidate_hl_cache();
            commit_a_byte(out, f, op->dst);
        } else if (dst_w == 4) {
            /* Long load: 4 bytes from (hl) into DEHL (DE=high, HL=low). */
            if (IS_GBZ80()) {
                /* gbz80 only emulates `ex de,hl` (808x has native XCHG).
                   Load the low word straight into BC, the high word into DE,
                   then mirror BC into HL — reaching DE=high/HL=low with
                   BC=low (the DEHL cache invariant) already set, no ex. */
                load_byte_adv(out, "c", 0);     /* C = byte 0 */
                load_byte_adv(out, "b", 0);     /* B = byte 1  (BC = LOW) */
                load_byte_adv(out, "e", 0);     /* E = byte 2 */
                load_byte_adv(out, "d", 1);     /* D = byte 3  (DE = HIGH) */
                emit(out, "ld\tl,c");
                emit(out, "ld\th,b");           /* HL = LOW */
            } else {
                emit(out, "ld\te,(hl)");        /* E = byte 0 */
                emit(out, "inc\thl");
                emit(out, "ld\td,(hl)");        /* D = byte 1 */
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl+)");        /* A = byte 2 */
                emit(out, "ld\th,(hl)");        /* H = byte 3 */
                emit(out, "ld\tl,a");           /* HL = bytes 2,3 = HIGH */
                emit(out, "ex\tde,hl");         /* DEHL: DE=HIGH, HL=LOW */
            }
            store_dehl_finalize(out, f, op->dst);
        } else {
            /* PR_DE dst: same byte sequence but writes E/D, no
               spill. HL becomes scratch (slot+1, untracked). */
            if (op->dst >= 0 && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_DE) {
                if (IS_EZ80()) {
                    emit(out, "ld\tde,(hl)");   /* ez80: DE = *HL */
                } else {
                    emit(out, "ld\ta,(hl+)");
                    emit(out, "ld\td,(hl)");
                    emit(out, "ld\te,a");
                }
                invalidate_hl_cache();
                cache_de(op->dst);
                return 0;
            }
            if (IS_EZ80()) {
                emit(out, "ld\thl,(hl)");        /* ez80: HL = *HL */
            } else {
                emit(out, "ld\ta,(hl+)");
                emit(out, "ld\th,(hl)");
                emit(out, "ld\tl,a");
            }
            /* HL holds loaded value. Use spill_and_swap_unless_dead
               to optionally skip the frame write. */
            commit_hl_word(out, f, op->dst);
        }
        return 0;
    }
    fprintf(stderr, "ir_lower: IR_LD_MEM kind %d not yet supported\n",
            (int)op->mem.kind);
    return -1;
}

/* Store a folded constant (const_fold set src[0]=-1) of `w` bytes little-endian
   at (HL), walking HL to base+w-1 (caller invalidates the HL cache). On gbz80 an
   all-equal-byte value (e.g. 0 / 0L) loads A once and stores via `ld (hl+),a`
   (cheaper than repeated `ld (hl),n`). Shared by the MEM_VREG and MEM_SYM folded
   paths; w is 1/2/4 (long) — never a float/double (const_fold gates elem). */
static void emit_folded_imm_store(FILE *out, int w, uint32_t v)
{
    if (IS_GBZ80() && w >= 2) {
        int same = 1;
        for (int i = 1; i < w; i++)
            if (((v >> (8 * i)) & 0xff) != (v & 0xff)) { same = 0; break; }
        if (same) {
            emit(out, "ld\ta,%d", (int)(v & 0xff));
            for (int i = 0; i < w - 1; i++) emit(out, "ld\t(hl+),a");
            emit(out, "ld\t(hl),a");
            invalidate_a_cache();
            return;
        }
    }
    for (int i = 0; i < w; i++) {
        emit(out, "ld\t(hl),%d", (int)((v >> (8 * i)) & 0xff));
        if (i < w - 1) emit(out, "inc\thl");
    }
}

/* May ir_opt_const_fold rewrite a constant store of `width` bytes into the
   immediate form? Byte (`ld (hl),n`) exists and wins on EVERY target (drops the
   value register — no A/E clobber, no DE-cache invalidation — and is compact),
   so it always fires. Word (`ld (hl),lo; inc hl; ld (hl),hi`, leaving PR_DE
   free) is only a win where the register path isn't already cheap: excludes
   ez80/kc160 (native ld (ix+d),rr + cheap slot reloads), Rabbit, and 8085 (SHLX
   `ld (de),hl` stores a word in one op). Consulted before the fold, so non-listed
   targets never see the word imm form (their word-store codegen is unchanged). */
int ir_cpu_const_store_ok(int width)
{
    if (width == 1) return 1;                       /* byte: everywhere */
    return !IS_RABBIT() && !IS_EZ80() && !IS_KC160() && !IS_8085();
}

static int gen_st_mem(FILE *out, Func *f, const Op *op)
{
    emit_ns_switch(out, mem_bank_fn(&op->mem));   /* __addressmod: page in */
    if (op->src[0] >= 0 && f->vregs[op->src[0]].width > 4) {
        /* Wide double store: dload(src)→FA, address into HL, dstore. */
        if (*wide_acc_cell(f, op->src[0]) != op->src[0]) {
            emit_acc_slot_addr(out, f, op->src[0], 0);
            emit(out, "call\t%s", acc_prim(f, op->src[0], "load"));
        }
        if (op->mem.kind == IR_MEM_SYM) {
            if (op->mem.offset)
                emit(out, "ld\thl,_%s+%d", ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\thl,_%s", ir_sym_name(op->mem.sym));
        } else {
            load_to_hl(out, f, op->mem.base);
            emit_hl_add_offset(out, op->mem.offset, 0);  /* base+off (DE free) */
        }
        emit_acc_store_hl(out, f, op->src[0]);
        invalidate_hl_bc();          /* clears both wide-acc cells */
        return 0;
    }
    if (op->mem.kind == IR_MEM_SYM) {
        /* Constant value folded into op->imm (const_fold marks src[0]=-1 on a
           MEM_VREG store; a later pass may fold its &sym+const base into this
           MEM_SYM form, carrying the marker along). Store the immediate direct
           — width from mem.elem, NOT the (now absent) value vreg. */
        if (op->src[0] < 0) {
            int w = kind_scalar_width(op->mem.elem);
            const char *s = ir_sym_name(op->mem.sym);
            int off = op->mem.offset;
            if (off) emit(out, "ld\thl,_%s+%d", s, off);
            else     emit(out, "ld\thl,_%s", s);
            emit_folded_imm_store(out, w, (uint32_t)op->imm);
            invalidate_hl_cache();
            return 0;
        }
        int src_w = (op->src[0] >= 0)
                  ? f->vregs[op->src[0]].width : 2;
        if (src_w == 4) {
            /* Long store to a global. `ld (_sym),hl` writes the
               low half; `ld (_sym+2),de` writes the high half
               (else a long-typed global truncates to int). */
            load_to_dehl(out, f, op->src[0]);
            int off = op->mem.offset;
            if (off)
                emit(out, "ld\t(_%s+%d),hl",
                     ir_sym_name(op->mem.sym), off);
            else
                emit(out, "ld\t(_%s),hl", ir_sym_name(op->mem.sym));
            if (op->mem.elem == KIND_CPTR) {
                /* __far pointer VALUE is 3 bytes in memory: write the
                   bank byte (E) only, never the 4th DEHL byte (D) — that
                   would clobber the adjacent global (sym+3). */
                emit(out, "ld\ta,e");
                emit(out, "ld\t(_%s+%d),a", ir_sym_name(op->mem.sym), off + 2);
                invalidate_a_cache();
                return 0;
            }
            emit(out, "ld\t(_%s+%d),de",
                 ir_sym_name(op->mem.sym), off + 2);
            return 0;
        }
        if (src_w == 1) {
            /* Byte store to a global. `ld a,r; ld (sym),a`. */
            load_byte_to_a(out, f, op->src[0]);
            if (op->mem.offset)
                emit(out, "ld\t(_%s+%d),a",
                     ir_sym_name(op->mem.sym), op->mem.offset);
            else
                emit(out, "ld\t(_%s),a", ir_sym_name(op->mem.sym));
            return 0;
        }
        load_to_hl(out, f, op->src[0]);
        if (op->mem.offset)
            emit(out, "ld\t(_%s+%d),hl",
                 ir_sym_name(op->mem.sym), op->mem.offset);
        else
            emit(out, "ld\t(_%s),hl", ir_sym_name(op->mem.sym));
        return 0;
    }
    if (op->mem.kind == IR_MEM_VREG) {
        /* Constant value folded into op->imm by ir_opt_const_fold. Store the
           immediate straight to memory — no value register, no A/E clobber, no
           DE-cache drop (leaves PR_DE free). Width (1/2/4) from mem.elem. */
        if (op->src[0] < 0) {
            int w = kind_scalar_width(op->mem.elem);
            load_to_hl(out, f, op->mem.base);
            emit_hl_add_offset(out, op->mem.offset, 1);  /* use BC scratch → keep DE */
            emit_folded_imm_store(out, w, (uint32_t)op->imm);
            if (w > 1 || op->mem.offset != 0)
                invalidate_hl_cache();
            return 0;
        }
        /* Indirect store: load value (DE), load address (HL), store. */
        int src_w = f->vregs[op->src[0]].width;
        if (src_w == 1) {
            load_byte_to_a(out, f, op->src[0]);
            emit(out, "ld\te,a");           /* stash byte across HL load */
            /* E (DE's low half) is now the store value, NOT whatever vreg
               the DE cache believed it held (e.g. `arr[i]=v` after `&arr+i`
               left i in DE). Drop the belief, else the next read of that
               vreg picks up the store value. */
            invalidate_de_cache();
            load_to_hl(out, f, op->mem.base);
            emit_hl_add_offset(out, op->mem.offset, 1);
            emit(out, "ld\t(hl),e");
            /* HL walked to base+offset — the cache claim on base is
               stale for offset != 0 (a following [base+k] store would
               inc-walk from the wrong position). */
            if (op->mem.offset != 0)
                invalidate_hl_cache();
        } else if (src_w == 4) {
            int small_off = (op->mem.offset >= -3 && op->mem.offset <= 3);
            int src_slotted = f->vreg_to_phys
                && (f->vreg_to_phys[op->src[0]] == IR_PR_SPILL
                    || (f->vregs[op->src[0]].flags & IR_VREG_PARAM));
            if (dehl_has(op->src[0]) && small_off
                && !vreg_in_pr_bc(f, op->mem.base)) {
                /* DEHL cache hit: DE = high half, BC = low half — HL
                   is free for the address. Zero stack traffic. (PR_BC
                   bases excluded: their reload would clobber the low
                   half in BC. Small offsets only — a scratch-pair add
                   would clobber DE or BC.) */
                if (!hl_has(op->mem.base))
                    load_to_hl(out, f, op->mem.base);
                emit_hl_add_offset(out, op->mem.offset, 0); /* inc/dec only */
                store_byte_adv(out, "c", 0);
                store_byte_adv(out, "b", 0);
                store_byte_adv(out, "e", 0);
                store_byte_adv(out, "d", 1);
                invalidate_hl_cache();
                /* DE/BC untouched — the DEHL cache stays valid. */
            } else if (src_slotted && small_off) {
                /* Value lives in its slot: address into DE, then walk
                   the value bytes through A. No DEHL round-trip, no
                   stack staging. */
                load_to_de(out, f, op->mem.base);
                for (int i = 0; i < op->mem.offset; i++)
                    emit(out, "inc\tde");
                for (int i = 0; i > op->mem.offset; i--)
                    emit(out, "dec\tde");
                if (fp_active(f)
                    && fp_offset_fits(slot_ix_off(f, op->src[0]))
                    && fp_offset_fits(slot_ix_off(f, op->src[0]) + 3)) {
                    int vx = slot_ix_off(f, op->src[0]);
                    for (int i = 0; i < 4; i++) {
                        emit(out, "ld\ta,(%s%+d)", frame_reg(), vx + i);
                        emit(out, "ld\t(de),a");
                        if (i < 3) emit(out, "inc\tde");
                    }
                } else {
                    int voff = slot_off(f, op->src[0]) + L.cur_sp_adjust;
                    emit(out, "ld\thl,%d", voff);
                    emit(out, "add\thl,sp");
                    for (int i = 0; i < 4; i++) {
                        emit(out, "ld\ta,(hl)");
                        emit(out, "ld\t(de),a");
                        if (i < 3) {
                            emit(out, "inc\thl");
                            emit(out, "inc\tde");
                        }
                    }
                    invalidate_hl_cache();
                }
                invalidate_de_cache();
            } else {
                /* Fallback (large offset / cache-miss): stage the value on
                   the stack to free DEHL for the address. sp shifts by 4 —
                   load_to_hl_adj compensates the mem.base offset. */
                load_to_dehl(out, f, op->src[0]);
                emit(out, "push\tde");          /* save HIGH half */
                emit(out, "push\thl");          /* save LOW half */
                load_to_hl_adj(out, f, op->mem.base, 4);
                emit_hl_add_offset(out, op->mem.offset, 1);
                emit(out, "pop\tbc");           /* BC = LOW */
                if (IS_EZ80()) {
                    emit(out, "ld\t(hl),bc");   /* ez80: *HL = BC (HL preserved) */
                    emit(out, "inc\thl");
                    emit(out, "inc\thl");
                    emit(out, "pop\tbc");       /* BC = HIGH */
                    emit(out, "ld\t(hl),bc");
                } else {
                    emit(out, "ld\t(hl),c");
                    emit(out, "inc\thl");
                    emit(out, "ld\t(hl),b");
                    emit(out, "inc\thl");
                    emit(out, "pop\tbc");       /* BC = HIGH */
                    emit(out, "ld\t(hl),c");
                    emit(out, "inc\thl");
                    emit(out, "ld\t(hl),b");
                }
                invalidate_hl_bc();
            }
        } else {
            load_to_hl(out, f, op->src[0]);
            emit(out, "ex\tde,hl");         /* DE = value */
            load_to_hl(out, f, op->mem.base);
            emit_hl_add_offset(out, op->mem.offset, 1);
            if (IS_EZ80()) {
                emit(out, "ld\t(hl),de");   /* ez80: *HL = DE */
            } else {
                emit(out, "ld\t(hl),e");
                emit(out, "inc\thl");
                emit(out, "ld\t(hl),d");
            }
            /* HL = base+offset(+1) — always past the cached base. */
            invalidate_hl_cache();
        }
        return 0;
    }
    fprintf(stderr, "ir_lower: IR_ST_MEM kind %d not yet supported\n",
            (int)op->mem.kind);
    return -1;
}

/* Word DE-home accumulate: `home = home + t` with the running sum riding DE.
   Lowers to `add hl,de; ex de,hl` — the addend goes to HL, the sum stays in
   DE — eliminating the per-iter `ld hl,(slot); add hl,de; ld (slot),hl`. If a
   prior DE-clobber dropped residency, reload the home into DE first (HL is not
   yet loaded, so the reload is free to use it). Returns 1 when handled. */
static int try_word_accumulate(FILE *out, Func *f, const Op *op)
{
    if (!is_word_accumulate(f, op)) return 0;
    int home = op->dst;
    int t = (op->src[0] == home) ? op->src[1] : op->src[0];
    if (!byte_home_holds(home)) {
        /* DE = home from its (coherent, because non-resident ⇒ flushed) slot.
           rehome preserves HL; the offset-fail fallback may clobber HL, but
           the addend is not loaded until after, so that is harmless. */
        if (!rehome_word_home(out, f))
            load_to_de(out, f, home);
    }
    load_to_hl(out, f, t);             /* HL = addend (preserves DE = home) */
    emit(out, "add\thl,de");           /* HL = home + t */
    emit(out, "ex\tde,hl");            /* DE = new home; HL = old home (junk) */
    invalidate_hl_cache();             /* drops HL/DE/A beliefs */
    cache_de(home);                    /* DE now holds the new home */
    byte_home_note(home);              /* residency (re)established */
    L.cur_byte_home_dirty = 1;           /* slot stale → flush before clobber/exit */
    return 1;                          /* handled */
}

/* Publish the DEHL cache after a byte-direct long op wrote its 4 result bytes.
   When dst was dead the bytes went to BC (low) + E/D — no slot store — so claim
   DEHL=dst but with DE INVALID: only the low half is register-backed here, and a
   downstream load_to_dehl hit recovers HL itself. When dst was live the result
   is in its slot, so flush the HL/BC caches. */
static void publish_bytewise_long_dst(int dst, int dst_dead)
{
    if (dst_dead) {
        hl_about_to_change(-1);
        L.rs.de = -1;
        L.rs.dehl = dst;
    } else {
        invalidate_hl_bc();
    }
}

/* FP-mode byte-direct long op for a COMMUTATIVE ALU (ADD / AND / OR / XOR):
   one src comes from the DEHL cache (BC=low, DE=high — or HL=low when the
   producer advertised rs.hl), the other from (ix+d); walk the 4 bytes through
   A. op0/opN are the byte-0 / remaining-byte mnemonics: "add"/"adc" for ADD
   (the carry chain), or mnem/mnem for the logicals (no carry-in). ld a,/ld r,a
   preserve flags so the ADD carry survives across bytes. Returns 1 if it
   emitted the fastpath, 0 if the operands didn't fit (caller falls through). */
static int try_fp_bytewise_commutative(FILE *out, const Func *f, const Op *op,
                                       const char *op0, const char *opN)
{
    int from_dehl = -1, from_slot = -1;
    if (dehl_has(op->src[0]) && !dehl_has(op->src[1])) {
        from_dehl = op->src[0]; from_slot = op->src[1];
    } else if (dehl_has(op->src[1]) && !dehl_has(op->src[0])) {
        from_dehl = op->src[1]; from_slot = op->src[0];
    } else if (!dehl_has(op->src[0]) && !dehl_has(op->src[1])) {
        from_slot = op->src[1];
    }
    if (from_slot < 0) return 0;
    int s1 = slot_ix_off(f, from_slot);
    int s0 = (from_dehl < 0) ? slot_ix_off(f, op->src[0]) : 0;
    int dd = L.la.cur_dst_dead ? 0 : slot_ix_off(f, op->dst);
    int srcs_ok = fp_offset_fits(s1) && fp_offset_fits(s1 + 3)
               && (from_dehl >= 0
                   || (fp_offset_fits(s0) && fp_offset_fits(s0 + 3)));
    int dst_ok = L.la.cur_dst_dead ? 1
               : (fp_offset_fits(dd) && fp_offset_fits(dd + 3));
    if (!(srcs_ok && dst_ok)) return 0;
    /* Prefer H/L for the low half when HL is advertised as holding from_dehl
       (the producer's cache_dehl_no_spill set rs.hl and skipped the `ld bc,hl`
       stash via cur_dehl_dst_no_bc_stash). Fall back to B/C for mid-chain
       consumers where rs.hl got reset by the previous byte-direct emit. */
    int use_hl = (from_dehl >= 0 && L.rs.hl == from_dehl);
    static const char *bc_byte[4] = { "c", "b", "e", "d" };
    static const char *hl_byte[4] = { "l", "h", "e", "d" };
    const char **sb = use_hl ? hl_byte : bc_byte;
    for (int i = 0; i < 4; i++) {
        if (from_dehl >= 0)
            emit(out, "ld\ta,%s", sb[i]);
        else
            emit(out, "ld\ta,(%s%+d)", frame_reg(), s0 + i);
        emit(out, "%s\ta,(%s%+d)", i == 0 ? op0 : opN, frame_reg(), s1 + i);
        if (L.la.cur_dst_dead)
            emit(out, "ld\t%s,a", bc_byte[i]);
        else
            emit(out, "ld\t(%s%+d),a", frame_reg(), dd + i);
    }
    publish_bytewise_long_dst(op->dst, L.la.cur_dst_dead);
    return 1;
}

static int gen_add(FILE *out, Func *f, const Op *op)
{
    if (try_word_accumulate(out, f, op))
        return 0;
    if (op->dst >= 0 && f->vregs[op->dst].width == 1) {
        /* Byte add in A. Commutative — pick the A-resident operand as
           the accumulator when one is already cached. */
        if (op->src[1] == -1) {
            load_byte_to_a(out, f, op->src[0]);
            emit(out, "add\ta,%u", (unsigned)(op->imm & 0xff));
        } else {
            int s0 = op->src[0], s1 = op->src[1];
            if (!a_has(s0) && a_has(s1)) { int t = s0; s0 = s1; s1 = t; }
            load_byte_to_a(out, f, s0);
            cache_a(s0);
            byte_alu_operand(out, f, "add\ta,", s1);
        }
        return finalize_byte_result(out, f, op, 0);
    }
    if (op->dst >= 0 && f->vregs[op->dst].width == 4
        && vreg_kind_is_integer(f, op->dst)) {
        /* Long add. Operand b pushed (HIGH then LOW), then DEHL = a.
           Inline the helper body directly — calling l_long_add would
           clobber IX (helper uses `pop ix` to stash retaddr), which
           breaks frame-pointer mode. */
        if (op->src[1] == -1) {
            /* In-place const ADD on a stack slot: add K's bytes
               directly through A. Skips the DEHL load+store round
               trip. Gated off when dst is dead. */
            uint32_t k = (uint32_t)op->imm;
            if (op->dst == op->src[0]
                && !L.la.cur_dst_dead
                && !dehl_has(op->src[0])
                && L.la.cur_stack_long_top != op->src[0]
                && !vreg_in_pr_bc(f, op->dst)
                && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
                /* dehl_has / stack-top exclusions: the producer may have
                   skipped the slot spill (cache_dehl_no_spill,
                   IR_PUSH_DEHL_LONG) — the slot is then STALE and this
                   in-place RMW would add K to garbage. The const-RHS DEHL
                   path below serves the cached case. */
                int off = slot_off(f, op->dst) + L.cur_sp_adjust;
                uint8_t k0 = (uint8_t)(k & 0xff);
                uint8_t k1 = (uint8_t)((k >> 8) & 0xff);
                uint8_t k2 = (uint8_t)((k >> 16) & 0xff);
                uint8_t k3 = (uint8_t)((k >> 24) & 0xff);
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");        /* HL = &slot */
                emit(out, "ld\ta,(hl)");
                emit(out, "add\ta,%u", (unsigned)k0);
                emit(out, "ld\t(hl),a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)");
                emit(out, "adc\ta,%u", (unsigned)k1);
                emit(out, "ld\t(hl),a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)");
                emit(out, "adc\ta,%u", (unsigned)k2);
                emit(out, "ld\t(hl),a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)");
                emit(out, "adc\ta,%u", (unsigned)k3);
                emit(out, "ld\t(hl),a");
                /* The slot is now current; DEHL/BC don't hold the
                   new value. Invalidate caches so the next op
                   reloads from slot if it needs the value. */
                invalidate_hl_bc();
                return 0;
            }
            /* Const-RHS: skip the push/pop dance. Load LHS into
               DEHL, then materialise each constant half directly
               into BC at the use site. Saves 4 inst + 42T per
               long const-ADD vs the push/pop form. */
            load_to_dehl(out, f, op->src[0]);
            /* DEHL = LHS (D=HI hi byte, E=HI lo byte, H=LO hi byte,
               L=LO lo byte). BC currently holds LHS low half (cache
               invariant) — about to be overwritten. */
            emit(out, "ld\tbc,%u", (unsigned)(k & 0xffff));
            emit(out, "add\thl,bc");                /* HL = LHS_LOW + K_LOW */
            if ((IS_808x() || IS_GBZ80())) {
                /* gbz80/808x: avoid emulated `adc hl,bc` + `ex de,hl`.
                   DE already holds LHS_HIGH; add K_HIGH byte-wise into
                   it, leaving DE=high/HL=low with no swaps. */
                emit(out, "ld\ta,e");
                emit(out, "adc\ta,%u", (unsigned)((k >> 16) & 0xff));
                emit(out, "ld\te,a");
                emit(out, "ld\ta,d");
                emit(out, "adc\ta,%u", (unsigned)((k >> 24) & 0xff));
                emit(out, "ld\td,a");
            } else {
                emit(out, "ex\tde,hl");             /* DE = result LOW, HL = LHS_HIGH */
                emit(out, "ld\tbc,%u",
                     (unsigned)((k >> 16) & 0xffff));
                emit(out, "adc\thl,bc");            /* HL = LHS_HIGH + K_HIGH + C */
                emit(out, "ex\tde,hl");             /* DEHL = result */
            }
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Stack-resident LHS: one src sits on the data stack from
           an earlier IR_PUSH_DEHL_LONG. Read its bytes via (hl)
           while adding the other src from our local save. ADD is
           commutative; carry chains naturally because pop / inc hl
           / ld don't touch flags.
           Valid in FP mode too — the reads are sp-relative and sp
           is live alongside IX. MUST come before the fp byte-direct
           path: that path reads the operand's (ix+d) slot, whose
           write the PUSH elided. */
        {
        int optb_dehl_src = -1;
        if (L.la.cur_stack_long_top >= 0) {
            if (L.la.cur_stack_long_top == op->src[0]
                && op->src[1] != L.la.cur_stack_long_top)
                optb_dehl_src = op->src[1];
            else if (L.la.cur_stack_long_top == op->src[1]
                && op->src[0] != L.la.cur_stack_long_top)
                optb_dehl_src = op->src[0];
        }
        if (optb_dehl_src >= 0) {
            load_to_dehl_adj(out, f, optb_dehl_src, 0);
            emit(out, "push\tde");           /* save src[1] high */
            emit(out, "push\thl");           /* save src[1] low */
            L.cur_sp_adjust += 4;
            emit(out, "ld\thl,4");
            emit(out, "add\thl,sp");          /* HL → src[0].b0 */
            emit(out, "pop\tbc");             /* C=s1.b0, B=s1.b1 */
            L.cur_sp_adjust -= 2;
            emit(out, "ld\ta,c");
            emit(out, "add\ta,(hl)");
            emit(out, "ld\tc,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");
            emit(out, "adc\ta,(hl)");
            emit(out, "ld\tb,a");
            emit(out, "inc\thl");
            emit(out, "pop\tde");             /* E=s1.b2, D=s1.b3 */
            L.cur_sp_adjust -= 2;
            emit(out, "ld\ta,e");
            emit(out, "adc\ta,(hl)");
            emit(out, "ld\te,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,d");
            emit(out, "adc\ta,(hl)");
            emit(out, "ld\td,a");
            emit(out, "ld\thl,bc");           /* HL = result low */
            /* Drop the data-stack frame. */
            emit(out, "pop\tbc");
            emit(out, "pop\tbc");
            L.cur_sp_adjust -= 4;
            L.la.cur_stack_long_top = -1;
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        }
        /* FP-mode byte-direct long ADD (commutative): one src from the DEHL
           cache, the other from (ix+d); add/adc through A (ld a,/ld r,a
           preserve flags so the carry chain survives across bytes). */
        if (fp_active(f)
            && op->src[0] >= 0 && op->src[1] >= 0
            && op->dst >= 0) {
            if (try_fp_bytewise_commutative(out, f, op, "add", "adc"))
                return 0;
        }
        /* Fused load+add: point HL at the RHS slot, do `add (hl)` /
           `adc (hl)` byte-wise with LHS bytes read from D/E (HIGH)
           and B/C (LOW, the DEHL-cache mirror). Only fires when RHS
           is sp-rel and not in the DEHL cache. */
        if (!fp_active(f) && !dehl_has(op->src[1])) {
            if (!dehl_has(op->src[0]))
                load_to_dehl(out, f, op->src[0]);
            /* DEHL = LHS, BC mirrors HL = LHS_LOW (B=b1, C=b0). */
            int off = slot_off(f, op->src[1]) + L.cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");        /* HL = &RHS, BC keeps LHS_LOW */
            emit(out, "ld\ta,c");           /* A = LHS_b0 */
            emit(out, "add\ta,(hl)");       /* A = result_b0, sets C */
            emit(out, "ld\tc,a");            /* C = result_b0 */
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");           /* A = LHS_b1 */
            emit(out, "adc\ta,(hl)");       /* A = result_b1 */
            emit(out, "ld\tb,a");            /* B = result_b1 */
            emit(out, "inc\thl");
            emit(out, "ld\ta,e");           /* A = LHS_b2 */
            emit(out, "adc\ta,(hl)");       /* A = result_b2 */
            emit(out, "ld\te,a");            /* E = result_b2 */
            emit(out, "inc\thl");
            emit(out, "ld\ta,d");           /* A = LHS_b3 */
            emit(out, "adc\ta,(hl)");       /* A = result_b3 */
            emit(out, "ld\td,a");            /* D = result_b3 */
            emit(out, "ld\thl,bc");          /* DEHL = result */
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Non-fused long ADD: stage both srcs through DEHL with a
           stack save in between. src[0]'s load skips its trailing
           `ld l,c; ld h,b` — we pop HL from b.LSW next anyway. */
        load_to_dehl(out, f, op->src[1]);
        emit(out, "push\tde");                  /* HIGH */
        emit(out, "push\thl");                  /* LOW */
        L.la.cur_load_to_dehl_no_hl = 1;
        load_to_dehl_adj(out, f, op->src[0], 4);  /* BC = a.LSW */
        emit(out, "pop\thl");                       /* HL = b.LSW */
        emit(out, "add\thl,bc");                    /* HL = LOW result; DE = a.MSW */
        if ((IS_808x() || IS_GBZ80())) {
            /* gbz80/808x: `adc hl,bc` and `ex de,hl` are emulated. DE
               already holds a.MSW and HL the LOW result, so add the high
               word byte-wise into DE — lands DEHL with no swaps. */
            emit(out, "pop\tbc");                   /* BC = b.MSW */
            emit(out, "ld\ta,e");
            emit(out, "adc\ta,c");
            emit(out, "ld\te,a");
            emit(out, "ld\ta,d");
            emit(out, "adc\ta,b");
            emit(out, "ld\td,a");
        } else {
            emit(out, "ex\tde,hl");                 /* DE = LOW result */
            emit(out, "pop\tbc");                   /* BC = b.MSW */
            emit(out, "adc\thl,bc");                /* HL = a.MSW + b.MSW + C */
            emit(out, "ex\tde,hl");                 /* DEHL = result */
        }
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    /* PR_BC stepped pointer (IVSR induction var) `bc += k`, small k: an
       `inc bc` chain steps it in place — no HL staging, no `ld bc,hl`
       writeback. The value stays advertised in BC for the next
       iteration's deref. HL is left stale (it may have mirrored the
       pre-step pointer), so drop its cache. */
    if (op->src[1] < 0 && op->dst == op->src[0]
        && vreg_in_pr_bc(f, op->dst) && bc_has(op->dst)
        && op->imm >= 1
        && (L.cur_home_is_word || op->imm <= 4)) {
        /* Normally an inc-bc chain only up to 4 (past that `ld de,k; add hl,de`
           is fewer T). With a word DE-home active DE isn't free, so step the
           pointer DE-clean for ANY stride: A-add (constant 6 bytes) when A is
           free, else the inc chain — the resident region it unlocks outweighs
           the step cost. */
        emit_pair_add_de_clean(out, "bc", "c", "b", (int)op->imm,
                               L.cur_home_is_word && L.rs.a < 0);
        invalidate_hl_cache();
        cache_bc(op->dst);
        return 0;
    }
    /* z80n const RHS: `add hl,nn` instead of `ld de,nn; add hl,de`.
       Same size, 5T cheaper, and — the real win — leaves DE intact so
       a value cached there survives. Standalone 16-bit add: this op
       sets NO flags, but a width-2 add's carry-out is never consumed
       (the multi-word carry chains live in the width-4 path above and
       must keep add/adc hl,bc). */
    if ((IS_Z80N()) && op->src[1] < 0) {
        load_to_hl(out, f, op->src[0]);
        emit(out, "add\thl,%u", (unsigned)((uint32_t)op->imm & 0xffffu));
        commit_hl_result(out, f, op->dst);
        return 0;
    }
    /* Small positive const add `dst = src0 + k` (k<=3): an `inc hl` chain
       instead of `ld de,k; add hl,de`. Fewer bytes/T for k<=3, and — the
       lever — DE-clean, so a word DE-home (a loop accumulator) rides
       through a stepped element/pointer walk (`sum += *p; p += 2`) instead
       of the step's `add hl,de` reverting the resident region. Matched in
       op_de_clean (fp only: the sp-mode commit clobbers DE). Excludes the
       PR_BC stepped-pointer form (handled above) and z80n (add hl,nn). */
    if (op->src[1] < 0 && op->imm >= 1 && op->imm <= 3) {
        load_to_hl(out, f, op->src[0]);
        for (long i = 0; i < (long)op->imm; i++) emit(out, "inc\thl");
        commit_hl_result(out, f, op->dst);
        return 0;
    }
    /* Commutative chain (a+b+c+d, field sums): src0 already in HL, src1 in
       a frame slot. load_binop_operands would push/pop HL to free it for
       slot addressing; instead move src0 to DE (`ex de,hl`) and load src1
       into the freed HL — `add hl,de` still gives src0+src1. Saves the
       push/pop per term. Gated to where load_to_de_preserve_hl would push:
       needs ex de,hl (not gbz80), src1 not already cheap-to-DE, not inside
       a word DE-home region (DE is the home), no pending HL spill. */
    if (op->src[1] >= 0 && hl_has(op->src[0]) && L.pending_spill_v < 0
        && !L.cur_home_is_word && !IS_GBZ80() && !IS_RABBIT() && !IS_KC160()
        && !de_has(op->src[1]) && !bc_has(op->src[1])
        && !(vreg_in_pr_bc(f, op->src[1]) && fp_active(f))) {
        emit(out, "ex\tde,hl");            /* DE = src0 (running value) */
        swap_hl_de_caches();
        load_to_hl(out, f, op->src[1]);    /* HL = src1 (preserves DE) */
        emit(out, "add\thl,de");
        commit_hl_result(out, f, op->dst);
        return 0;
    }
    load_binop_operands(out, f, op);
    emit(out, "add\thl,de");
    /* PR_DE dst: commit moves HL→DE via ex de,hl (+4 T), saving the ~28-T
       spill (dst is next op's src[1], so cur_dst_dead can't help). */
    commit_hl_result(out, f, op->dst);
    return 0;
}

static int gen_sub(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 1) {
        /* Byte sub in A. Not commutative: A = src[0] - src[1]. If only
           src[1] is A-resident, spill it to its slot first so loading
           src[0] into A can't strand it (no slot otherwise). */
        if (op->src[1] == -1) {
            load_byte_to_a(out, f, op->src[0]);
            emit(out, "sub\t%u", (unsigned)(op->imm & 0xff));
        } else {
            if (a_has(op->src[1]) && !a_has(op->src[0]))
                store_a_byte(out, f, op->src[1]);
            load_byte_to_a(out, f, op->src[0]);
            cache_a(op->src[0]);
            byte_alu_operand(out, f, "sub\t", op->src[1]);
        }
        return finalize_byte_result(out, f, op, 0);
    }
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        if (op->src[1] == -1) {
            uint32_t k = (uint32_t)op->imm;
            /* In-place const SUB on a stack slot (mirror of the ADD
               form). `sub` clears carry on entry; later bytes sbc. */
            if (op->dst == op->src[0]
                && !L.la.cur_dst_dead
                && !vreg_in_pr_bc(f, op->dst)
                && f->vreg_to_phys
                && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
                int off = slot_off(f, op->dst) + L.cur_sp_adjust;
                uint8_t k0 = (uint8_t)(k & 0xff);
                uint8_t k1 = (uint8_t)((k >> 8) & 0xff);
                uint8_t k2 = (uint8_t)((k >> 16) & 0xff);
                uint8_t k3 = (uint8_t)((k >> 24) & 0xff);
                emit(out, "ld\thl,%d", off);
                emit(out, "add\thl,sp");
                emit(out, "ld\ta,(hl)");
                emit(out, "sub\t%u", (unsigned)k0);
                emit(out, "ld\t(hl),a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)");
                emit(out, "sbc\ta,%u", (unsigned)k1);
                emit(out, "ld\t(hl),a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)");
                emit(out, "sbc\ta,%u", (unsigned)k2);
                emit(out, "ld\t(hl),a");
                emit(out, "inc\thl");
                emit(out, "ld\ta,(hl)");
                emit(out, "sbc\ta,%u", (unsigned)k3);
                emit(out, "ld\t(hl),a");
                invalidate_hl_bc();
                return 0;
            }
            /* Const-RHS: keep LHS in DEHL and load each K half
               into BC at the use site. No push/pop needed. */
            load_to_dehl(out, f, op->src[0]);
            /* DEHL = LHS (HL = LOW, DE = HIGH). */
            if ((IS_808x() || IS_GBZ80())) {
                /* gbz80/808x: no native 16-bit subtract (sbc hl,bc is
                   emulated) and ex de,hl is emulated. Subtract all 4
                   const bytes via sub/sbc a, landing HL=low/DE=high. */
                emit(out, "ld\ta,l");
                emit(out, "sub\t%u", (unsigned)(k & 0xff));
                emit(out, "ld\tl,a");
                emit(out, "ld\ta,h");
                emit(out, "sbc\ta,%u", (unsigned)((k >> 8) & 0xff));
                emit(out, "ld\th,a");
                emit(out, "ld\ta,e");
                emit(out, "sbc\ta,%u", (unsigned)((k >> 16) & 0xff));
                emit(out, "ld\te,a");
                emit(out, "ld\ta,d");
                emit(out, "sbc\ta,%u", (unsigned)((k >> 24) & 0xff));
                emit(out, "ld\td,a");
            } else {
                emit(out, "ld\tbc,%u", (unsigned)(k & 0xffff));
                emit(out, "or\ta");                     /* clear carry */
                emit(out, "sbc\thl,bc");                /* HL = LHS_LOW - K_LOW */
                emit(out, "ex\tde,hl");                 /* DE = result LOW, HL = LHS_HIGH */
                emit(out, "ld\tbc,%u",
                     (unsigned)((k >> 16) & 0xffff));
                emit(out, "sbc\thl,bc");                /* HL = LHS_HIGH - K_HIGH - borrow */
                emit(out, "ex\tde,hl");                 /* DEHL = result */
            }
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* FP-mode byte-direct long SUB fastpath. SUB is NOT
           commutative; we need src[0] - src[1]. Two sub-cases:
             a) src[0] in DEHL, src[1] in slot →
                ld a,<dehl byte>; sub/sbc a,(ix+s1+i); ld dst,a
             b) both in slots →
                ld a,(ix+s0+i); sub/sbc a,(ix+s1+i); ld dst,a
           src[1]-in-DEHL with src[0] in slot would need
           `ld a,(ix+s0+i); sub <dehl reg>` which works for the
           first byte but `sbc a,<reg>` for the carry chain —
           also works. So we can handle that too. */
        if (fp_active(f)
            && op->src[0] >= 0 && op->src[1] >= 0
            && op->dst >= 0) {
            int swap = 0;  /* if 1, src[1] is in dehl (rare) */
            int from_dehl = -1, from_slot = -1;
            if (dehl_has(op->src[0]) && !dehl_has(op->src[1])) {
                from_dehl = op->src[0]; from_slot = op->src[1];
            } else if (dehl_has(op->src[1])
                       && !dehl_has(op->src[0])) {
                /* DEHL has the subtrahend; A holds the minuend
                   from (ix+s0+i), and we subtract the DEHL reg
                   byte. Works the same opcode-wise. */
                from_dehl = op->src[1]; from_slot = op->src[0];
                swap = 1;
            } else if (!dehl_has(op->src[0])
                       && !dehl_has(op->src[1])) {
                from_slot = op->src[1];
            }
            if (from_slot >= 0) {
                int s_minuend = (swap || from_dehl < 0)
                              ? slot_ix_off(f, op->src[0]) : 0;
                int s_subtra = (!swap && from_dehl < 0)
                             ? slot_ix_off(f, op->src[1])
                             : (swap ? 0 : 0);
                /* Walking offset of the (ix+d) operand: that's
                   always the slot src — could be subtrahend or
                   minuend depending on `swap`. Recompute. */
                int slot_off_ix = slot_ix_off(f, from_slot);
                int s0 = (from_dehl >= 0 && !swap)
                       ? -1                 /* minuend from DEHL */
                       : (swap ? slot_ix_off(f, op->src[0])
                               : slot_ix_off(f, op->src[0]));
                int dd = L.la.cur_dst_dead
                       ? 0 : slot_ix_off(f, op->dst);
                int srcs_ok = fp_offset_fits(slot_off_ix)
                           && fp_offset_fits(slot_off_ix + 3)
                           && (from_dehl >= 0
                               || (fp_offset_fits(s0)
                                   && fp_offset_fits(s0 + 3)));
                int dst_ok = L.la.cur_dst_dead
                    ? 1
                    : (fp_offset_fits(dd)
                       && fp_offset_fits(dd + 3));
                /* swap path also needs s_minuend reachable. */
                if (swap)
                    srcs_ok = srcs_ok
                           && fp_offset_fits(s_minuend)
                           && fp_offset_fits(s_minuend + 3);
                (void)s_subtra;
                if (srcs_ok && dst_ok) {
                    /* See ADD fastpath: prefer H/L for low half
                       when rs.hl matches from_dehl. Saves
                       the producer's ld bc,hl when paired with
                       the cur_dehl_dst_no_bc_stash lookahead. */
                    int use_hl = (from_dehl >= 0
                                  && L.rs.hl == from_dehl);
                    static const char *bc_byte[4] =
                        { "c", "b", "e", "d" };
                    static const char *hl_byte[4] =
                        { "l", "h", "e", "d" };
                    const char **sb = use_hl ? hl_byte : bc_byte;
                    for (int i = 0; i < 4; i++) {
                        /* Load minuend (src[0]) into A. */
                        if (from_dehl >= 0 && !swap)
                            emit(out, "ld\ta,%s", sb[i]);
                        else if (swap)
                            emit(out, "ld\ta,(%s%+d)",
                                 frame_reg(), s_minuend + i);
                        else
                            emit(out, "ld\ta,(%s%+d)",
                                 frame_reg(), s0 + i);
                        /* Subtract subtrahend (src[1]). */
                        if (swap) {
                            /* src[1] in DEHL — use reg form. */
                            if (i == 0)
                                emit(out, "sub\t%s", sb[i]);
                            else
                                emit(out, "sbc\ta,%s", sb[i]);
                        } else {
                            int off = slot_off_ix + i;
                            if (i == 0)
                                emit(out, "sub\t(%s%+d)",
                                     frame_reg(), off);
                            else
                                emit(out, "sbc\ta,(%s%+d)",
                                     frame_reg(), off);
                        }
                        if (L.la.cur_dst_dead)
                            emit(out, "ld\t%s,a",
                                 bc_byte[i]);
                        else
                            emit(out, "ld\t(%s%+d),a",
                                 frame_reg(), dd + i);
                    }
                    publish_bytewise_long_dst(op->dst, L.la.cur_dst_dead);
                    return 0;
                }
            }
        }
        /* Fused load+sub: HL points at RHS slot, byte-wise sub/sbc
           through (hl) with LHS bytes from D/E/B/C. `sub` has no
           carry-in so the first byte sets borrow for the sbc chain. */
        if (!fp_active(f) && !dehl_has(op->src[1])) {
            if (!dehl_has(op->src[0]))
                load_to_dehl(out, f, op->src[0]);
            int off = slot_off(f, op->src[1]) + L.cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");        /* HL = &RHS */
            emit(out, "ld\ta,c");
            emit(out, "sub\t(hl)");         /* A = LHS_b0 - RHS_b0, sets C=borrow */
            emit(out, "ld\tc,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");
            emit(out, "sbc\ta,(hl)");
            emit(out, "ld\tb,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,e");
            emit(out, "sbc\ta,(hl)");
            emit(out, "ld\te,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,d");
            emit(out, "sbc\ta,(hl)");
            emit(out, "ld\td,a");
            emit(out, "ld\thl,bc");
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Non-fused long SUB: push a (HIGH/LOW), load b into DEHL,
           inline the helper body. l_long_sub would clobber IX.
           b's load skips HL recovery — we pop HL from a.LSW next. */
        load_to_dehl(out, f, op->src[0]);
        emit(out, "push\tde");
        emit(out, "push\thl");
        L.la.cur_load_to_dehl_no_hl = 1;
        load_to_dehl_adj(out, f, op->src[1], 4);    /* BC = b.LSW */
        emit(out, "pop\thl");                       /* HL = a.LSW */
        if ((IS_808x() || IS_GBZ80())) {
            /* gbz80/808x: sbc hl,bc and ex de,hl are emulated. Subtract
               byte-wise (a - b) — b is BC=low/DE=high, a's high half is
               the next stack word — landing HL=low/DE=high, no swaps. */
            emit(out, "ld\ta,l");
            emit(out, "sub\tc");                    /* a_b0 - b_b0 */
            emit(out, "ld\tl,a");
            emit(out, "ld\ta,h");
            emit(out, "sbc\ta,b");                  /* a_b1 - b_b1 */
            emit(out, "ld\th,a");                   /* HL = LOW result */
            emit(out, "pop\tbc");                   /* BC = a.MSW */
            emit(out, "ld\ta,c");
            emit(out, "sbc\ta,e");                  /* a_b2 - b_b2 */
            emit(out, "ld\te,a");
            emit(out, "ld\ta,b");
            emit(out, "sbc\ta,d");                  /* a_b3 - b_b3 */
            emit(out, "ld\td,a");                   /* DE = HIGH result */
        } else {
            emit(out, "or\ta");                     /* clear carry */
            emit(out, "sbc\thl,bc");                /* HL = a-b LOW */
            emit(out, "ex\tde,hl");                 /* DE = LOW, HL = b.MSW */
            emit(out, "ld\tbc,hl");                 /* BC = b.MSW */
            emit(out, "pop\thl");                   /* HL = a.MSW */
            emit(out, "sbc\thl,bc");                /* HL = a-b MSW */
            emit(out, "ex\tde,hl");                 /* DEHL = result */
        }
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    load_binop_operands(out, f, op);
    if (IS_RABBIT()) {
        emit(out, "sub\thl,de");        /* Rabbit native (r2k+), DE preserved */
    } else if ((IS_808x() || IS_GBZ80())) {
        /* gbz80/808x: `sbc hl,de` is emulated (push/pop x4 + helper).
           Subtract byte-wise; write straight into DE when that's the dst
           (skips the ex de,hl that the sbc-path would need). */
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ld\ta,l");
            emit(out, "sub\te");
            emit(out, "ld\te,a");
            emit(out, "ld\ta,h");
            emit(out, "sbc\ta,d");
            emit(out, "ld\td,a");
            cache_de(op->dst);
            return 0;
        }
        emit(out, "ld\ta,l");
        emit(out, "sub\te");
        emit(out, "ld\tl,a");
        emit(out, "ld\ta,h");
        emit(out, "sbc\ta,d");
        emit(out, "ld\th,a");
    } else {
        emit(out, "and\ta");
        emit(out, "sbc\thl,de");
    }
    /* PR_DE dst: same swap as IR_ADD. */
    commit_hl_result(out, f, op->dst);
    return 0;
}

/* dst = imm - src[0]  (reverse subtract; `const - var`). Loads only the
   variable — the constant is the immediate, so no const-in-HL and no
   push/pop to preserve it across the var load. Width 2. */
static int gen_rsub(FILE *out, Func *f, const Op *op)
{
    uint16_t k = (uint16_t)op->imm;
    if (!(IS_808x() || IS_GBZ80())) {
        /* Native 16-bit subtract: DE = var, HL = imm, HL -= DE. */
        load_to_de(out, f, op->src[0]);
        emit(out, "ld\thl,%u", (unsigned)k);
        emit(out, "or\ta");
        emit(out, "sbc\thl,de");
    } else {
        /* gbz80/808x: byte-wise imm - var. Land straight in DE when
           that's the dst (skips the emulated ex de,hl). */
        load_to_hl(out, f, op->src[0]);
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ld\ta,%u", (unsigned)(k & 0xff));
            emit(out, "sub\tl");
            emit(out, "ld\te,a");
            emit(out, "ld\ta,%u", (unsigned)((k >> 8) & 0xff));
            emit(out, "sbc\ta,h");
            emit(out, "ld\td,a");
            cache_de(op->dst);
            return 0;
        }
        emit(out, "ld\ta,%u", (unsigned)(k & 0xff));
        emit(out, "sub\tl");
        emit(out, "ld\tl,a");
        emit(out, "ld\ta,%u", (unsigned)((k >> 8) & 0xff));
        emit(out, "sbc\ta,h");
        emit(out, "ld\th,a");
    }
    commit_hl_result(out, f, op->dst);
    return 0;
}

/* Byte shift+test fuse — the byte/E-home analog of the word `add hl,hl`
   peephole. The crc8/LFSR bit-step `crc = (crc & 0x80) ? (crc<<1)^P : crc<<1`
   lowers to AND-0x80 + branch with BOTH successors leading with `crc<<1`.
   `sla e` does the shift AND sets CF = old bit-7 (= the test), so emit it
   once here and skip the per-arm SHL — reaching sdcc's
   `sla e; jr nc,+; ld a,e; xor P; ld e,a; +:`. Requires the home resident
   in its register (so `sla` acts on the live value) and CB shifts; otherwise
   the caller falls back to the through-A `add a,a` bit test. Returns 1 if it
   fired (the AND op and its branch are then fully emitted). */
static int try_byte_shift_test_fuse(FILE *out, const Func *f, const Op *op)
{
    if (IS_808x()) return 0;
    if (!byte_home_holds(op->src[0])) return 0;
    PhysReg pr = byte_home_phys(f, op->src[0]);
    if (pr == IR_PR_NONE) return 0;
    if (!cur_bb || cur_bb->succ[0] < 0 || cur_bb->succ[1] < 0) return 0;
    if (L.la.shl_skip_n + 2 > SHL_SKIP_CAP) return 0;

    int skip_id = L.la.cur_branch_test_label;            /* bit7==0 → crc<<1 only */
    int poly_id = (cur_bb->succ[0] == skip_id)
                  ? cur_bb->succ[1] : cur_bb->succ[0];
    const BB *bb_skip = NULL, *bb_poly = NULL;
    for (int bi = 0; bi < f->n_bbs; bi++) {
        if (f->bbs[bi].id == skip_id) bb_skip = &f->bbs[bi];
        if (f->bbs[bi].id == poly_id) bb_poly = &f->bbs[bi];
    }
    if (!bb_skip || !bb_poly || bb_skip->n_ops == 0 || bb_poly->n_ops == 0)
        return 0;
    const Op *s = &bb_skip->ops[0], *p = &bb_poly->ops[0];
    /* skip arm: in-place `crc <<= 1`; poly arm: `t = crc << 1` (then `^P`). */
    if (!(s->kind == IR_SHL && s->src[0] == op->src[0] && s->src[1] == -1
          && s->imm == 1 && s->dst == op->src[0]))
        return 0;
    if (!(p->kind == IR_SHL && p->src[0] == op->src[0] && p->src[1] == -1
          && p->imm == 1))
        return 0;

    emit(out, "sla\t%s", byte_home_reg(pr));        /* home<<=1, CF=old bit7 */
    if (byte_home_slotbacked(pr)) L.cur_byte_home_dirty = 1;
    invalidate_a_cache();
    const char *cc = (L.la.cur_branch_test_kind == IR_BR_ZERO) ? "nc" : "c";
    emit(out, "jp\t%s,L_f%d_bb_%d", cc, L.func_emit_idx, skip_id);
    for (int k = 0; k < 2; k++) {
        const BB *b = k ? bb_poly : bb_skip;
        shl_skip[L.la.shl_skip_n].bb_id = b->id;
        shl_skip[L.la.shl_skip_n].op_idx = 0;
        shl_skip[L.la.shl_skip_n].cache_vreg = op->src[0];
        shl_skip[L.la.shl_skip_n].is_byte = 1;
        L.la.shl_skip_n++;
    }
    L.la.cur_skip_next_op = 1;   /* the BR_ZERO is now the emitted jp */
    return 1;
}

/* Bitwise ops — z80 only operates on A, so do it byte-by-byte. */
static int gen_bitop(FILE *out, Func *f, const Op *op)
{
    const char *mnem = (op->kind == IR_AND) ? "and"
                     : (op->kind == IR_OR)  ? "or"
                     :                        "xor";

    if (op->dst >= 0 && f->vregs[op->dst].width == 1) {
        /* Byte bitwise in A — no widening, no high-byte work.
           All three are commutative; prefer the A-resident operand. */
        char pfx[8];
        snprintf(pfx, sizeof pfx, "%s\t", mnem);
        if (op->src[1] == -1) {
            unsigned m = (unsigned)(op->imm & 0xff);
            /* crc8/LFSR bit-step: fuse the bit-7 test with the common
               `crc<<1` shift into `sla e; jp` (skips the per-arm SHL).
               Falls through to the through-A bit test when the home isn't
               resident, CB is absent, or the arms don't match. */
            if (op->kind == IR_AND && m == 0x80 && L.la.cur_branch_test_kind != 0
                && try_byte_shift_test_fuse(out, f, op))
                return 0;
            load_byte_to_a(out, f, op->src[0]);
            /* Single-bit test feeding a branch: bit 7 via `add a,a`, bit 0
               via `rrca` (bit→CF), branch on carry — 1B/4T vs `and mask` +
               Z-branch, CPU-portable. Safe: cur_branch_test_kind ⇒ the AND
               result is dead after the branch (only CF is read). */
            if (op->kind == IR_AND && L.la.cur_branch_test_kind != 0
                && (m == 0x80 || m == 0x01)) {
                emit(out, m == 0x80 ? "add\ta,a" : "rrca");
                const char *cc =
                    (L.la.cur_branch_test_kind == IR_BR_ZERO) ? "nc" : "c";
                emit(out, "jp\t%s,L_f%d_bb_%d", cc, L.func_emit_idx,
                     L.la.cur_branch_test_label);
                L.la.cur_skip_next_op = 1;
                invalidate_a_cache();
                return 0;
            }
            emit(out, "%s%u", pfx, m);
        } else {
            int s0 = op->src[0], s1 = op->src[1];
            if (!a_has(s0) && a_has(s1)) { int t = s0; s0 = s1; s1 = t; }
            load_byte_to_a(out, f, s0);
            cache_a(s0);
            byte_alu_operand(out, f, pfx, s1);
        }
        return finalize_byte_result(out, f, op, 0);
    }
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        /* Long AND-mask + immediately-following BR_ZERO/COND fastpath
           (`(crc & 1UL) ? ...` bit-test). When the mask hits exactly one
           of the 4 bytes, byte-AND that byte and branch on Z — vs the full
           DEHL load + 4-byte AND + spill + reload + or + jp. */
        if (op->kind == IR_AND
            && op->src[1] == -1
            && L.la.cur_branch_test_kind != 0) {
            uint32_t kk = (uint32_t)op->imm;
            uint8_t b4[4];
            b4[0] = (uint8_t)(kk & 0xff);
            b4[1] = (uint8_t)((kk >> 8) & 0xff);
            b4[2] = (uint8_t)((kk >> 16) & 0xff);
            b4[3] = (uint8_t)((kk >> 24) & 0xff);
            int nz_idx = -1, nz_count = 0;
            for (int i = 0; i < 4; i++) {
                if (b4[i] != 0) { nz_idx = i; nz_count++; }
            }
            if (nz_count == 1) {
                /* Single non-zero byte. Read it without disturbing
                   the rest of the long. When dehl_has(src), the
                   cache invariant is: BC = low half (B=byte1,
                   C=byte0), DE = high half (D=byte3, E=byte2).
                   HL may or may not be physically valid after a
                   store_dehl (it gets clobbered by slot stores),
                   so always pull byte0/byte1 from BC, not HL.
                   Slot layout: slot+i = byte i. */
                static const char *dehl_byte_regs[4] =
                    { "c", "b", "e", "d" };
                int emitted = 0;
                if (dehl_has(op->src[0])) {
                    emit(out, "ld\ta,%s", dehl_byte_regs[nz_idx]);
                    emitted = 1;
                } else if (fp_active(f)) {
                    int ix_off = slot_ix_off(f, op->src[0])
                               + nz_idx;
                    if (fp_offset_fits(ix_off)) {
                        emit(out, "ld\ta,(%s%+d)",
                             frame_reg(), ix_off);
                        emitted = 1;
                    }
                } else {
                    int off = slot_off(f, op->src[0])
                            + L.cur_sp_adjust + nz_idx;
                    emit(out, "ld\thl,%d", off);
                    emit(out, "add\thl,sp");
                    emit(out, "ld\ta,(hl)");
                    hl_about_to_change(-1);
                    emitted = 1;
                }
                if (emitted) {
                    emit(out, "and\t%u",
                         (unsigned)b4[nz_idx]);
                    const char *cc =
                        (L.la.cur_branch_test_kind == IR_BR_ZERO)
                            ? "z" : "nz";
                    emit(out, "jp\t%s,L_f%d_bb_%d",
                         cc, L.func_emit_idx,
                         L.la.cur_branch_test_label);
                    L.la.cur_skip_next_op = 1;
                    return 0;
                }
            }
        }
        /* Long bitwise — byte-wise through A. Literal-RHS variant
           can skip identity bytes (0xff for AND, 0x00 for OR/XOR)
           and zero-store for AND-with-0. Variable-RHS variant
           saves src[0] DEHL on stack, loads src[1] DEHL, then
           combines byte by byte while popping the saved src[0]. */
        if (op->src[1] == -1) {
            uint32_t kk = (uint32_t)op->imm;
            uint8_t b[4];
            b[0] = (uint8_t)(kk & 0xff);
            b[1] = (uint8_t)((kk >> 8) & 0xff);
            b[2] = (uint8_t)((kk >> 16) & 0xff);
            b[3] = (uint8_t)((kk >> 24) & 0xff);
            uint8_t identity = (op->kind == IR_AND) ? 0xff : 0x00;
            static const char *regs[4] = { "l", "h", "e", "d" };
            /* Fuse the op straight into the store walk: read each value
               byte, apply the immediate, store via (hl+) — skipping the
               register write-back AND the separate store_dehl walk. The
               result lives only in its slot afterwards (caches
               invalidated), which is provably fine when no adjacent op
               wants it register-resident (!dst_dead_safe). Gated to the
               case where store_dehl would otherwise emit the generic sp
               byte walk: not fp (ix store is 2 ops), not the sp+0 TOS
               pop/push trick, not a Rabbit/kc160 native sp-rel store.
               In sp-mode load_to_dehl leaves BC=low (C=b0,B=b1), DE=high
               (E=b2,D=b3) — the no-bc-stash skip only fires under fp. */
            if (!fp_active(f) && !L.la.cur_dehl_dst_dead_safe
                && !L.la.cur_dehl_push_to_stack && op->dst >= 0
                && !vreg_is_pr_dehl(f, op->dst)
                && !vreg_is_pr_de(f, op->dst)
                && !vreg_in_pr_bc(f, op->dst)) {
                require_slot(f, op->dst);
                int doff = slot_off(f, op->dst) + L.cur_sp_adjust;
                /* The sp+0 TOS pop/push store beats the fused byte walk on
                   the z80 family (measured: crc +0.2% if fused), but on
                   808x its dearer push/pop loses to the fused walk
                   (8080 crc -1.2%), so let 808x fuse even at sp+0. */
                int tos  = (doff == 0 && tos_pushpop_ok(f) && !IS_808x());
                int sprel = (doff >= 0 && doff + 2 <= sp_rel_max(f));
                if (doff >= 0 && !tos && !sprel) {
                    static const char *vb[4] = { "c", "b", "e", "d" };
                    load_to_dehl(out, f, op->src[0]);
                    emit(out, "ld\thl,%d", doff);
                    emit(out, "add\thl,sp");
                    for (int i = 0; i < 4; i++) {
                        emit(out, "ld\ta,%s", vb[i]);
                        if (b[i] != identity)
                            emit(out, "%s\t%u", mnem, (unsigned)b[i]);
                        emit(out, i < 3 ? "ld\t(hl+),a" : "ld\t(hl),a");
                    }
                    invalidate_hl_bc();
                    invalidate_de_cache();   /* clears rs.de AND rs.dehl */
                    return 0;
                }
            }
            load_to_dehl(out, f, op->src[0]);
            for (int i = 0; i < 4; i++) {
                if (b[i] == identity) continue;
                if (op->kind == IR_AND && b[i] == 0) {
                    emit(out, "ld\t%s,0", regs[i]);
                    continue;
                }
                /* Single-bit shortcut: OR one bit → `set n,r`, AND one bit
                   clear → `res n,r` (XOR has no toggle-bit op). set/res are
                   CB-prefix, absent on 808x; the fallback below is all-CPU. */
                uint8_t v = b[i];
                uint8_t bit_mask = (op->kind == IR_AND)
                                 ? (uint8_t)(~v & 0xff)
                                 : v;
                if ((!IS_808x()) &&
                    op->kind != IR_XOR &&
                    bit_mask != 0 &&
                    (bit_mask & (bit_mask - 1)) == 0) {
                    int bit = 0;
                    while ((bit_mask >> bit) != 1) bit++;
                    emit(out, "%s\t%d,%s",
                         (op->kind == IR_AND) ? "res" : "set",
                         bit, regs[i]);
                    continue;
                }
                emit(out, "ld\ta,%s", regs[i]);
                emit(out, "%s\t%u", mnem, (unsigned)b[i]);
                emit(out, "ld\t%s,a", regs[i]);
            }
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* Stack-resident LHS variant: one src sits on the data
           stack from an earlier IR_PUSH_DEHL_LONG. Read its bytes
           via (hl) on the stack while the other src (from DEHL)
           goes through A. Skips the POP+reload+re-push the generic
           path would otherwise force.
           Valid in FP mode too (sp-relative reads) — and must come
           before the fp byte-direct path, which would read the
           stale (ix+d) slot the PUSH elided the write to. */
        int optb_dehl_src = -1;
        if (L.la.cur_stack_long_top >= 0) {
            if (L.la.cur_stack_long_top == op->src[0]
                && op->src[1] != L.la.cur_stack_long_top)
                optb_dehl_src = op->src[1];
            else if (L.la.cur_stack_long_top == op->src[1]
                && op->src[0] != L.la.cur_stack_long_top)
                optb_dehl_src = op->src[0];
        }
        if (optb_dehl_src >= 0) {
            load_to_dehl_adj(out, f, optb_dehl_src, 0);
            emit(out, "push\tde");           /* save src[1] high */
            emit(out, "push\thl");           /* save src[1] low */
            L.cur_sp_adjust += 4;
            /* Stack low→high: [s1.b0, s1.b1, s1.b2, s1.b3,
                                s0.b0, s0.b1, s0.b2, s0.b3]
               Address src[0].b0 at sp+4. */
            emit(out, "ld\thl,4");
            emit(out, "add\thl,sp");
            emit(out, "pop\tbc");            /* C=s1.b0, B=s1.b1 */
            L.cur_sp_adjust -= 2;
            emit(out, "ld\ta,c");
            emit(out, "%s\t(hl)", mnem);
            emit(out, "ld\te,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");
            emit(out, "%s\t(hl)", mnem);
            emit(out, "inc\thl");
            emit(out, "ld\td,a");
            emit(out, "pop\tbc");            /* C=s1.b2, B=s1.b3 */
            L.cur_sp_adjust -= 2;
            emit(out, "ld\ta,c");
            emit(out, "%s\t(hl)", mnem);
            emit(out, "inc\thl");
            emit(out, "ld\tc,a");
            emit(out, "ld\ta,b");
            emit(out, "%s\t(hl)", mnem);
            /* Normalise to canonical DEHL (HL=low, DE=high). On gbz80
               ex de,hl is a 56T push/pop emulation; build the layout
               directly instead (A=b3, C=b2, D=b1, E=b0 here). */
            if (IS_GBZ80()) {
                emit(out, "ld\th,d");          /* H = b1 */
                emit(out, "ld\tl,e");          /* L = b0  -> HL = low */
                emit(out, "ld\td,a");          /* D = b3 */
                emit(out, "ld\te,c");          /* E = b2  -> DE = high */
            } else {
                emit(out, "ld\th,a");
                emit(out, "ld\tl,c");
                emit(out, "ex\tde,hl");           /* DEHL = result */
            }
            /* Drop the data-stack frame. */
            emit(out, "pop\tbc");
            emit(out, "pop\tbc");
            L.cur_sp_adjust -= 4;
            L.la.cur_stack_long_top = -1;
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        /* FP-mode byte-direct: walk bytes through A using either
           (ix+d) or DEHL registers:
             ld a,(ix+s0+i)   OR   ld a,<reg from dehl>
             <op> a,(ix+s1+i) OR   <op> a,<reg from dehl>
             ld <dest>,a      (dest = (ix+d+i) live / dehl reg dead)
           AND/OR/XOR are commutative — either src can occupy DEHL,
           the other walks via (ix+d). */
        if (fp_active(f)
            && (op->kind == IR_AND || op->kind == IR_OR
                || op->kind == IR_XOR)
            && op->src[0] >= 0 && op->src[1] >= 0
            && op->dst >= 0) {
            if (try_fp_bytewise_commutative(out, f, op, mnem, mnem))
                return 0;
        }
        /* Variable RHS. The cache-hit path (dehl_has(src[0]))
           can skip load_to_dehl's HL recovery if we stage the
           low-half push from BC (which the cache invariant
           guarantees holds src[0].low) — saves 2 bytes vs the
           recovered HL + push hl form.
           Commutative swap FIRST: if only src[1] is DEHL-cached,
           consume it as the staged operand — loading the uncached
           src[0] first clobbers the cache, and src[1]'s SLOT may be
           stale (an explicit IR_POP materialises registers only;
           the matching PUSH elided the spill). */
        int bsrc0 = op->src[0], bsrc1 = op->src[1];
        if (!dehl_has(bsrc0) && dehl_has(bsrc1)) {
            int t = bsrc0; bsrc0 = bsrc1; bsrc1 = t;
        }
        int src0_cached = dehl_has(bsrc0);
        if (!src0_cached)
            load_to_dehl(out, f, bsrc0);
        emit(out, "push\tde");
        if (src0_cached)
            emit(out, "push\tbc");
        else
            emit(out, "push\thl");
        /* Fused load+op: point HL at the RHS slot and `<op> (hl)` directly
           with LHS bytes popped off the stack, folding the full DEHL load
           into the byte-op chain. Fires only when RHS is sp-rel (not fp,
           where computing HL from IX costs more) and not DEHL-cached.
           Inline-push variant: src[1] was pushed by store_dehl_finalize
           (chain-OR accumulate), sitting at sp+4 after the two pushes above;
           pop it BEFORE store_dehl_finalize so a chained dst push lands at
           sp+0. */
        int src1_inline_pushed = (!fp_active(f)
                                  && L.la.cur_dehl_inline_push == bsrc1
                                  && L.cur_sp_adjust == L.la.cur_dehl_inline_push_base_sp);
        if (!fp_active(f) && (!dehl_has(bsrc1) || src1_inline_pushed)) {
            int off = src1_inline_pushed ? 4
                    : slot_off(f, bsrc1) + 4 + L.cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
            emit(out, "pop\tbc");          /* BC = LHS low (B=byte1, C=byte0) */
            emit(out, "ld\ta,c");
            emit(out, "%s\t(hl)", mnem);   /* A = byte0 result */
            emit(out, "ld\te,a");           /* stash byte0 in E */
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");
            emit(out, "%s\t(hl)", mnem);   /* A = byte1 result */
            emit(out, "inc\thl");
            emit(out, "ld\td,a");           /* stash byte1 in D */
            emit(out, "pop\tbc");          /* BC = LHS high (B=byte3, C=byte2) */
            emit(out, "ld\ta,c");
            emit(out, "%s\t(hl)", mnem);   /* A = byte2 result */
            emit(out, "inc\thl");
            emit(out, "ld\tc,a");           /* stash byte2 in C */
            emit(out, "ld\ta,b");
            emit(out, "%s\t(hl)", mnem);   /* A = byte3 result */
            /* Normalise to canonical DEHL. gbz80 builds it directly to
               dodge the 56T ex de,hl emulation (A=b3, C=b2, D=b1, E=b0). */
            if (IS_GBZ80()) {
                emit(out, "ld\th,d");           /* H = b1 */
                emit(out, "ld\tl,e");           /* L = b0  -> HL = low */
                emit(out, "ld\td,a");           /* D = b3 */
                emit(out, "ld\te,c");           /* E = b2  -> DE = high */
            } else {
                emit(out, "ld\th,a");           /* H = byte3 */
                emit(out, "ld\tl,c");           /* L = byte2 */
                emit(out, "ex\tde,hl");        /* DEHL: D=b3 E=b2 H=b1 L=b0 */
            }
            if (src1_inline_pushed) {
                emit(out, "pop\tbc");
                emit(out, "pop\tbc");
                L.cur_sp_adjust -= 4;
                L.la.cur_dehl_inline_push = -1;
            }
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        load_to_dehl_adj(out, f, bsrc1, 4);
        emit(out, "pop\tbc");          /* BC = src[0] LOW (C=b0, B=b1) */
        emit(out, "ld\ta,c");
        emit(out, "%s\tl", mnem);
        emit(out, "ld\tl,a");
        emit(out, "ld\ta,b");
        emit(out, "%s\th", mnem);
        emit(out, "ld\th,a");
        emit(out, "pop\tbc");          /* BC = src[0] HIGH */
        emit(out, "ld\ta,c");
        emit(out, "%s\te", mnem);
        emit(out, "ld\te,a");
        emit(out, "ld\ta,b");
        emit(out, "%s\td", mnem);
        emit(out, "ld\td,a");
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }

    /* AND-mask + immediately-following BR_ZERO/COND fastpath (CRC inner
       loop archetype `crc & 0x8000U` then `if (cond)`). Byte-AND and
       branch on Z instead of computing the full AND result. cur_branch_test_kind
       being set implies dst is dead after the BR. */
    if (op->kind == IR_AND
        && op->src[1] == -1
        && L.la.cur_branch_test_kind != 0) {
        uint16_t k = (uint16_t)op->imm;
        uint8_t hi = (uint8_t)(k >> 8);
        uint8_t lo = (uint8_t)(k & 0xff);
        /* Shift-and-test fused fastpath (CRC inner loop archetype):
             if (v & 0x8000) v = (v << 1) ^ P; else v <<= 1;
           lowers to AND mask 0x8000 + BR_ZERO + (SHL by 1 in both succs).
           `add hl,hl` does the shift AND sets CF = old bit 15, so fold the
           test into it and elide the two SHL ops (saves 2-3 inst/fire in a
           hot unrolled loop). Fires only when the mask is exactly 0x8000,
           both BB succs' first op is `SHL src[0] by 1`, and the skip-arm
           SHL is in-place to op->src[0] (so HL-tracking lines up). */
        if (k == 0x8000 && cur_bb != NULL
            && cur_bb->succ[0] >= 0 && cur_bb->succ[1] >= 0
            && L.la.shl_skip_n + 2 <= SHL_SKIP_CAP) {
            /* skip_id = "skip" arm (in-place `v <<= 1`); poly_id = "poly"
               arm (`t = v << 1; v ^= P`). */
            int skip_id = L.la.cur_branch_test_label;
            int poly_id = (cur_bb->succ[0] == skip_id)
                          ? cur_bb->succ[1] : cur_bb->succ[0];
            const BB *bb_skip = NULL, *bb_poly = NULL;
            for (int bi = 0; bi < f->n_bbs; bi++) {
                if (f->bbs[bi].id == skip_id) bb_skip = &f->bbs[bi];
                if (f->bbs[bi].id == poly_id) bb_poly = &f->bbs[bi];
            }
            int ok = (bb_skip && bb_poly
                && bb_skip->n_ops > 0 && bb_poly->n_ops > 0
                && bb_skip->ops[0].kind == IR_SHL
                && bb_skip->ops[0].src[0] == op->src[0]
                && bb_skip->ops[0].src[1] == -1
                && bb_skip->ops[0].imm == 1
                && bb_skip->ops[0].dst == op->src[0]
                && bb_poly->ops[0].kind == IR_SHL
                && bb_poly->ops[0].src[0] == op->src[0]
                && bb_poly->ops[0].src[1] == -1
                && bb_poly->ops[0].imm == 1);
            if (ok) {
                if (!hl_has(op->src[0]))
                    load_to_hl(out, f, op->src[0]);
                else
                    ss_note_cache_read(f, op->src[0]);  /* served from HL */
                emit(out, "add\thl,hl");
                /* CF = old bit 15 of src[0]. BR_ZERO branches when
                   AND result was 0 → old bit 15 was 0 → CF clear. */
                const char *cc =
                    (L.la.cur_branch_test_kind == IR_BR_ZERO) ? "nc" : "c";
                emit(out, "jp\t%s,L_f%d_bb_%d",
                     cc, L.func_emit_idx, skip_id);
                /* HL now holds the shifted value. Record both succ SHLs to
                   skip; cache_vreg = op->src[0] so the SHL handler's
                   `hl_has(src[0])` hits and its shift loop is elided, and
                   its spill tail publishes the shifted HL to dst. */
                shl_skip[L.la.shl_skip_n].bb_id = bb_skip->id;
                shl_skip[L.la.shl_skip_n].op_idx = 0;
                shl_skip[L.la.shl_skip_n].cache_vreg = op->src[0];
                L.la.shl_skip_n++;
                shl_skip[L.la.shl_skip_n].bb_id = bb_poly->id;
                shl_skip[L.la.shl_skip_n].op_idx = 0;
                shl_skip[L.la.shl_skip_n].cache_vreg = op->src[0];
                L.la.shl_skip_n++;
                hl_about_to_change(op->src[0]);
                L.la.cur_skip_next_op = 1;
                return 0;
            }
        }
        if ((hi == 0) != (lo == 0)) {
            /* Single-byte mask. Load src[0] into HL if not cached. */
            if (!hl_has(op->src[0]))
                load_to_hl(out, f, op->src[0]);
            const char *reg = (hi != 0) ? "h" : "l";
            uint8_t mask  = (hi != 0) ? hi : lo;
            emit(out, "ld\ta,%s", reg);
            emit(out, "and\t%u", (unsigned)mask);
            const char *cc =
                (L.la.cur_branch_test_kind == IR_BR_ZERO) ? "z" : "nz";
            emit(out, "jp\t%s,L_f%d_bb_%d",
                 cc, L.func_emit_idx, L.la.cur_branch_test_label);
            /* HL still holds src[0] (`and` touched only A/F). Advertise it
               explicitly — load_to_hl doesn't update rs.hl, so a miss +
               non-cached load would otherwise leave the global stale. */
            cache_hl(op->src[0]);
            L.la.cur_skip_next_op = 1;   /* branch op now consumed */
            return 0;
        }
    }

    /* Literal-fold value context: immediate-form `and/or/xor K` per byte
       (no `ld de,K`). Skip identity bytes (0 for OR/XOR, 0xFF for AND);
       zero absorber bytes (0 for AND) without going through A. */
    if (op->src[1] == -1) {
        uint16_t k = (uint16_t)op->imm;
        uint8_t lo = (uint8_t)(k & 0xff);
        uint8_t hi = (uint8_t)(k >> 8);
        uint8_t identity = (op->kind == IR_AND) ? 0xff : 0x00;
        int lo_skip = (lo == identity);
        int hi_skip = (hi == identity);
        int lo_zero = (op->kind == IR_AND && lo == 0);
        int hi_zero = (op->kind == IR_AND && hi == 0);
        if (!hl_has(op->src[0]))
            load_to_hl(out, f, op->src[0]);
        /* PR_DE dst: route the byte writes into E/D instead of
           L/H. HL preserves src[0] (we never touch it during the
           op-with-A dance), so rs.hl = src[0] stays valid. */
        if (vreg_is_pr_de(f, op->dst)) {
            const char *low_dst  = "e";
            const char *high_dst = "d";
            if (lo_zero) {
                emit(out, "ld\t%s,0", low_dst);
            } else if (lo_skip) {
                emit(out, "ld\t%s,l", low_dst);
            } else {
                emit(out, "ld\ta,l");
                emit(out, "%s\t%u", mnem, (unsigned)lo);
                emit(out, "ld\t%s,a", low_dst);
            }
            if (hi_zero) {
                emit(out, "ld\t%s,0", high_dst);
            } else if (hi_skip) {
                emit(out, "ld\t%s,h", high_dst);
            } else {
                emit(out, "ld\ta,h");
                emit(out, "%s\t%u", mnem, (unsigned)hi);
                emit(out, "ld\t%s,a", high_dst);
            }
            cache_de(op->dst);
            /* HL still holds src[0] — cache_hl(src[0]) preserved. */
            return 0;
        }
        /* Single-bit shortcut (int variant): set/res for AND/OR when K or
           ~K is one bit (XOR excluded). CB-prefix, absent on 808x; the
           fallback below is all-CPU. */
        int cb = (!IS_808x()) != 0;
        uint8_t lo_bm = (op->kind == IR_AND)
                      ? (uint8_t)(~lo & 0xff) : lo;
        uint8_t hi_bm = (op->kind == IR_AND)
                      ? (uint8_t)(~hi & 0xff) : hi;
        int lo_single = (cb && op->kind != IR_XOR && lo_bm != 0 &&
                         (lo_bm & (lo_bm - 1)) == 0);
        int hi_single = (cb && op->kind != IR_XOR && hi_bm != 0 &&
                         (hi_bm & (hi_bm - 1)) == 0);
        const char *setres = (op->kind == IR_AND) ? "res" : "set";
        if (lo_zero) {
            emit(out, "ld\tl,0");
        } else if (lo_single) {
            int bit = 0; while ((lo_bm >> bit) != 1) bit++;
            emit(out, "%s\t%d,l", setres, bit);
        } else if (!lo_skip) {
            emit(out, "ld\ta,l");
            emit(out, "%s\t%u", mnem, (unsigned)lo);
            emit(out, "ld\tl,a");
        }
        if (hi_zero) {
            emit(out, "ld\th,0");
        } else if (hi_single) {
            int bit = 0; while ((hi_bm >> bit) != 1) bit++;
            emit(out, "%s\t%d,h", setres, bit);
        } else if (!hi_skip) {
            emit(out, "ld\ta,h");
            emit(out, "%s\t%u", mnem, (unsigned)hi);
            emit(out, "ld\th,a");
        }
        commit_hl_word(out, f, op->dst);
        return 0;
    }

    load_binop_operands(out, f, op);    /* HL=src[0], DE=src[1] */
    /* Rabbit native HL=HL<op>DE in 1 byte (and/or r2k+, xor r4k); DE
       preserved so the HL finalize below is unchanged. Off elsewhere:
       the assembler synthetic push-af-wraps. PR_DE dst falls through. */
    if ((op->kind == IR_AND || op->kind == IR_OR
         || (op->kind == IR_XOR && (IS_RABBIT4K())))
        && (IS_RABBIT())
        && !vreg_is_pr_de(f, op->dst)) {
        emit(out, "%s\thl,de", mnem);
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    /* PR_DE dst (variable RHS): write result bytes into E/D
       directly. HL = src[0] is preserved through the A-staged
       byte ops, so cache_hl(src[0]) survives. */
    if (vreg_is_pr_de(f, op->dst)) {
        emit(out, "ld\ta,l");
        emit(out, "%s\te", mnem);
        emit(out, "ld\te,a");
        emit(out, "ld\ta,h");
        emit(out, "%s\td", mnem);
        emit(out, "ld\td,a");
        cache_de(op->dst);
        /* rs.hl = src[0] unchanged. */
        return 0;
    }
    emit(out, "ld\ta,l");
    emit(out, "%s\te", mnem);
    emit(out, "ld\tl,a");
    emit(out, "ld\ta,h");
    emit(out, "%s\td", mnem);
    emit(out, "ld\th,a");
    commit_hl_word(out, f, op->dst);
    return 0;
}

/* ---- __sdcccall(1) register assignment (z80/z180/z80n, widths 1-2) ----
   Mirrors SDCC's aopArg / aopRet (src/sdcc-build/src/z80/gen.c) for the
   supported subset. 4-byte (HLDE) args/returns are handled/rejected
   elsewhere. */
typedef enum { SC1_STACK = 0, SC1_A, SC1_HL, SC1_L, SC1_DE, SC1_DEHL } Sc1Reg;

/* Register for argument `idx` (1-based, byte-width `w`), given the register
   the 1st argument got (`first`; SC1_STACK if it wasn't register-passed).
   SC1_STACK => the argument is pushed on the stack. */
static Sc1Reg sdcccall1_arg_reg(int idx, int w, Sc1Reg first)
{
    if (idx == 1) {
        if (w == 1) return SC1_A;
        if (w == 2) return SC1_HL;
        if (w == 4) return SC1_DEHL;   /* HLDE: DE=low, HL=high (a 4-byte 1st
                                          arg uses both pairs — no register 2nd) */
        return SC1_STACK;
    }
    if (idx == 2) {
        if (first == SC1_A && w == 1) return SC1_L;
        if (first == SC1_A && w == 2) return SC1_DE;
        if (first == SC1_HL && w == 2) return SC1_DE;
        return SC1_STACK;
    }
    return SC1_STACK;
}

/* Return register for a __sdcccall(1) function returning `w` bytes:
   1 byte -> A, 2 -> DE, 4 -> HLDE (DE=low, HL=high). SC1_STACK => out of subset. */
static Sc1Reg sdcccall1_ret_reg(int w)
{
    if (w == 1) return SC1_A;
    if (w == 2) return SC1_DE;
    if (w == 4) return SC1_DEHL;
    return SC1_STACK;
}

/* Read a stacked-arg byte into A during the push loop. fp mode: one
   `ld a,(ix+d)`, no sp adjustment or HL clobber. sp mode: the sp-relative
   dance (sp_adj = bytes pushed so far + the bc-save). */
static void push_arg_byte_to_a(FILE *out, const Func *f, int vreg, int sp_adj)
{
    if (fp_active(f)) {
        int ixoff = slot_ix_off(f, vreg);
        if (fp_offset_fits(ixoff)) {
            emit(out, "ld\ta,(%s%+d)", frame_reg(), ixoff);
            return;
        }
    }
    emit(out, "ld\thl,%d", slot_off(f, vreg) + sp_adj + L.cur_sp_adjust);
    emit(out, "add\thl,sp");
    emit(out, "ld\ta,(hl)");
}

