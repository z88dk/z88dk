/* ir_lower_cmp.inc.c — part of ir_lower.c, #included (single TU). Do not compile standalone. */
static int gen_cmp_lt_ge(FILE *out, Func *f, const Op *op)
{
    int is_signed = (op->kind == IR_CMP_LT || op->kind == IR_CMP_GE);
    int cf_true_long = (op->kind == IR_CMP_ULT || op->kind == IR_CMP_LT);
    /* gbz80 has no jp po/pe at all, so the inline S^V correction can't run —
       sign-flip the operands instead. (808x also lacks the overflow flag but
       DOES have jp po (parity), which works for these compares, so they stay
       on the jp-po path.) */
    int long_signflip = is_signed && IS_GBZ80();
    /* Byte compare against a small constant: a width-1 operand is loaded
       zero-extended (`ld l,(hl); ld h,0`), so the existing widen+16-bit
       compare is really an UNSIGNED compare of a [0,255] value against a
       [0,255] constant — identical to a single `cp K`. Emit that directly
       for the branch-fused `c REL K` (K in a byte): CF = (c < K) unsigned,
       matching cf_true_long. Removes the widen + the 16-bit sbc machinery.
       Chiefly the range-narrowed loop counter (`i < 16`). */
    if (op->src[0] >= 0 && op->src[1] == -1
        && f->vregs[op->src[0]].width == 1
        && op->imm >= 0 && op->imm <= 255
        && cur_branch_test_kind != 0) {
        load_byte_to_a(out, f, op->src[0]);
        emit(out, "cp\t%u", (unsigned)(op->imm & 0xff));
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want_carry = (cf_true_long == br_true);
        emit(out, "jp\t%s,L_f%d_bb_%d",
             want_carry ? "c" : "nc", func_emit_idx, cur_branch_test_label);
        rs.a = -1;                     /* A clobbered; HL/DE/BC untouched */
        cur_skip_next_op = 1;
        return 0;
    }
    /* Long ordered compare: byte-wise sub/sbc chain. Final sbc
       leaves CF = unsigned borrow (a<b) and A = high byte of result.
       Signed gets the S^V correction inline (`jp po ok; xor 0x80;
       ok: rla`) — same shape as signed_result_to_carry but A
       already has the high byte. */
    int src0w_lt = (op->src[0] >= 0) ? f->vregs[op->src[0]].width : 0;
    if (src0w_lt == 4) {
        if (long_signflip && op->src[1] == -1) {
            /* gbz80 signed vs const: flip bit31 of src0 and of K, then the
               unsigned borrow = signed LT (no S^V correction below). */
            uint32_t k = (uint32_t)op->imm;
            load_to_dehl(out, f, op->src[0]);
            emit(out, "ld\ta,d"); emit(out, "xor\t0x80"); emit(out, "ld\td,a");
            emit(out, "ld\ta,l");
            emit(out, "sub\t%u", (unsigned)(k & 0xff));
            emit(out, "ld\ta,h");
            emit(out, "sbc\ta,%u", (unsigned)((k >> 8) & 0xff));
            emit(out, "ld\ta,e");
            emit(out, "sbc\ta,%u", (unsigned)((k >> 16) & 0xff));
            emit(out, "ld\ta,d");
            emit(out, "sbc\ta,%u", (unsigned)(((k >> 24) & 0xff) ^ 0x80));
        } else if (long_signflip) {
            emit_long_signflip_sub(out, f, op->src[0], op->src[1]);
        } else if (op->src[1] == -1) {
            uint32_t k = (uint32_t)op->imm;
            load_to_dehl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
            emit(out, "sub\t%u", (unsigned)(k & 0xff));
            emit(out, "ld\ta,h");
            emit(out, "sbc\ta,%u", (unsigned)((k >> 8) & 0xff));
            emit(out, "ld\ta,e");
            emit(out, "sbc\ta,%u", (unsigned)((k >> 16) & 0xff));
            emit(out, "ld\ta,d");
            emit(out, "sbc\ta,%u", (unsigned)((k >> 24) & 0xff));
        } else if (!fp_active(f) && !dehl_has(op->src[1])) {
            load_to_dehl(out, f, op->src[0]);
            int off = slot_off(f, op->src[1]) + cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,c");        /* LHS b0 via BC mirror */
            emit(out, "sub\t(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");
            emit(out, "sbc\ta,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\ta,e");
            emit(out, "sbc\ta,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\ta,d");
            emit(out, "sbc\ta,(hl)");
        } else {
            /* Fallback: stage both via push/pop. */
            load_to_dehl(out, f, op->src[1]);
            emit(out, "push\tde");
            emit(out, "push\thl");
            load_to_dehl_adj(out, f, op->src[0], 4);
            emit(out, "pop\tbc");        /* BC = RHS low */
            emit(out, "ld\ta,l");
            emit(out, "sub\tc");
            emit(out, "ld\ta,h");
            emit(out, "sbc\ta,b");
            emit(out, "pop\tbc");        /* BC = RHS high */
            emit(out, "ld\ta,e");
            emit(out, "sbc\ta,c");
            emit(out, "ld\ta,d");
            emit(out, "sbc\ta,b");
        }
        if (is_signed && !long_signflip) {
            /* A holds high byte of result; CF set iff borrow. Apply
               the S^V correction so CF ends up = signed-LT. (gbz80 took
               the sign-flip path above — CF is already signed-LT.) */
            int n = cmp_label_counter++;
            emit(out, "jp\tpo,L_f%d_cmp_ok_%d", func_emit_idx, n);
            emit(out, "xor\t0x80");
            fprintf(out, "L_f%d_cmp_ok_%d:\n", func_emit_idx, n);
            emit(out, "rla");
        }
        invalidate_hl_bc();
        if (cur_branch_test_kind != 0) {
            int br_true = (cur_branch_test_kind == IR_BR_COND);
            int want_carry = (cf_true_long == br_true);
            const char *cc = want_carry ? "c" : "nc";
            emit(out, "jp\t%s,L_f%d_bb_%d",
                 cc, func_emit_idx, cur_branch_test_label);
            cur_skip_next_op = 1;
            return 0;
        }
        carry_to_bool(out, f, cf_true_long);
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    /* Byte-wise unsigned loop test: LHS in BC, RHS in a slot, branch-fused.
       `ld a,c; sub mem_lo; ld a,b; sbc a,mem_hi` lands CF = unsigned borrow
       (src0<src1) using ONLY A — DE and HL (and a slot-backed byte home in E)
       survive, vs `ld de,(slot); ld hl,bc; sbc hl,de` which clobbers both.
       Eligibility mirrors op_de_clean's cmp_bytewise_ok exactly. */
    if (cmp_bytewise_ok(f, op)) {
        int s1 = op->src[1];
        if (fp_active(f)) {
            int ix = slot_ix_off(f, s1);
            emit(out, "ld\ta,c");
            emit(out, "sub\t(%s%+d)", frame_reg(), ix);
            emit(out, "ld\ta,b");
            emit(out, "sbc\ta,(%s%+d)", frame_reg(), ix + 1);
        } else {
            int off = slot_off(f, s1) + cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,c");
            emit(out, "sub\t(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");
            emit(out, "sbc\ta,(hl)");
            invalidate_hl_cache();     /* HL now holds the slot address */
        }
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want_carry = (cf_true_long == br_true);
        emit(out, "jp\t%s,L_f%d_bb_%d",
             want_carry ? "c" : "nc", func_emit_idx, cur_branch_test_label);
        cur_skip_next_op = 1;
        return 0;
    }
    /* Slot-vs-slot unsigned loop test, byte-wise through A (fp). Both operands
       read from their ix-slots; CF = unsigned borrow (src0 < src1). A-only, so
       DE (a word home), BC and HL all survive — vs two synthetic ix pair-loads
       + `sbc hl,de` that clobber DE and HL. Mirrors cmp_bytewise_mem_ok. */
    if (cmp_bytewise_mem_ok(f, op)) {
        int s0 = op->src[0], s1 = op->src[1];
        int ix0 = slot_ix_off(f, s0), ix1 = slot_ix_off(f, s1);
        emit(out, "ld\ta,(%s%+d)", frame_reg(), ix0);
        emit(out, "sub\t(%s%+d)", frame_reg(), ix1);
        emit(out, "ld\ta,(%s%+d)", frame_reg(), ix0 + 1);
        emit(out, "sbc\ta,(%s%+d)", frame_reg(), ix1 + 1);
        rs.a = -1;                        /* A clobbered; DE/BC/HL untouched */
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want_carry = (cf_true_long == br_true);
        emit(out, "jp\t%s,L_f%d_bb_%d",
             want_carry ? "c" : "nc", func_emit_idx, cur_branch_test_label);
        cur_skip_next_op = 1;
        return 0;
    }
    /* Word DE-home DE-clean signed loop test (fp): RHS (n) → HL, then subtract
       LHS (i) from it byte-wise reading i from its ix-slot. Uses only A/HL,
       so DE (the resident sum) survives — letting compute_home_region admit
       the loop. HL keeps n, DE keeps the home; only A is clobbered. */
    if (word_dehome_signed_test_shape_ok(f, op) && cur_branch_test_kind != 0) {
        int s0 = op->src[0];
        int ix = slot_ix_off(f, s0);
        load_to_hl(out, f, op->src[1]);          /* HL = n (DE-clean in fp) */
        emit(out, "ld\ta,(%s%+d)", frame_reg(), ix);
        emit(out, "sub\tl");                     /* i_lo - n_lo */
        emit(out, "ld\ta,(%s%+d)", frame_reg(), ix + 1);
        emit(out, "sbc\ta,h");                   /* A=hi(i-n), P/V=ovf, CF=borrow */
        int lbl = cmp_label_counter++;
        emit(out, "jp\tpo,L_f%d_cmp_ok_%d", func_emit_idx, lbl);
        emit(out, "xor\t0x80");
        fprintf(out, "L_f%d_cmp_ok_%d:\n", func_emit_idx, lbl);
        emit(out, "rla");                        /* CF = signed (i < n) */
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want_carry = (cf_true_long == br_true);
        emit(out, "jp\t%s,L_f%d_bb_%d",
             want_carry ? "c" : "nc", func_emit_idx, cur_branch_test_label);
        rs.a = -1;                         /* A clobbered; HL=n, DE=home kept */
        cur_skip_next_op = 1;
        return 0;
    }
    load_binop_operands(out, f, op);   /* HL=src0, DE=src1 */
    /* 8085 DSUB + jp k/nk: fuse the compare into the branch. `sub hl,bc`
       (BC=src1) sets K=signed(src0<src1) and CF=unsigned borrow in one
       byte — replacing the sign-flip + byte-wise sub entirely. Only in
       the branch-fused path: K has no register form, and it's only
       valid right after DSUB. DSUB needs the RHS in BC, clobbering it;
       when BC holds a live value, push/pop around the subtract — `pop bc`
       restores BC and leaves the flags (incl. K) untouched, so the jump
       still sees the DSUB result (only `pop af` reloads flags). 6 bytes
       (BC free) / 8 bytes (BC live), both beating the 15-byte sign-flip
       + byte-sub. Signed only: for unsigned the byte-wise sub/sbc is
       already cheap (no sign-flip to beat), so DSUB+push/pop would only
       add stack traffic. */
    if ((IS_8085()) && is_signed
        && cur_branch_test_kind != 0) {
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want = (cf_true_long == br_true);
        const char *cc = want ? "k" : "nk";
        int bc_live = (rs.bc >= 0);
        if (bc_live) emit(out, "push\tbc");
        emit(out, "ld\tc,e");
        emit(out, "ld\tb,d");          /* BC = src1 */
        emit(out, "sub\thl,bc");       /* HL-BC: K=signed LT, CF=uns borrow */
        if (bc_live) emit(out, "pop\tbc"); /* restores BC; flags survive */
        emit(out, "jp\t%s,L_f%d_bb_%d", cc, func_emit_idx,
             cur_branch_test_label);
        invalidate_hl_keep_de();       /* DSUB clobbers HL, preserves DE/BC */
        if (!bc_live) invalidate_bc_cache();
        cur_skip_next_op = 1;
        return 0;
    }
    int sflip_lt = signed_cmp_signflip(out, f, is_signed);
    if (!(IS_808x() || IS_GBZ80())) {
        emit(out, "and\ta");
        emit(out, "sbc\thl,de");
    } else {
        /* No usable native 16-bit sbc: 8080 expands `sbc hl,de` to a slow
           __z80asm__sbc_hl_de call, gbz80 lacks it. Byte-wise sub/sbc a
           lands the same CF (unsigned borrow = src0<src1); A = high byte
           of the result, which signed_result_to_carry would read — but
           !OVERFLOW already sign-flipped above (sflip_lt=1), so CF is the
           signed answer directly and no correction runs. */
        emit(out, "ld\ta,l");
        emit(out, "sub\te");
        emit(out, "ld\ta,h");
        emit(out, "sbc\ta,d");
    }
    if (is_signed && !sflip_lt) signed_result_to_carry(out);
    int cf_true = cf_true_long;
    if (cur_branch_test_kind != 0) {
        const char *cc;
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want_carry = (cf_true == br_true);
        cc = want_carry ? "c" : "nc";
        emit(out, "jp\t%s,L_f%d_bb_%d",
             cc, func_emit_idx, cur_branch_test_label);
        /* `sbc hl,de` clobbered HL but preserved DE — keep cache. */
        invalidate_hl_keep_de();
        cur_skip_next_op = 1;
        return 0;
    }
    carry_to_bool(out, f, cf_true);
    commit_hl_word(out, f, op->dst);
    return 0;
}

/* Operand load for the GT/LE swap-subtraction: DE = src[0], HL = src[1]
   (the mirror of load_binop_operands, which yields HL=src0/DE=src1). The
   swap lets `HL-DE` compute src1-src0 so CF=borrow means src0>src1. Modeled
   branch-for-branch on load_binop_operands with the src roles exchanged, so
   it handles every cache/spill case safely — crucially, when src[1] is the
   DE-resident operand a naive `load_to_de(src0); load_to_hl(src1)` would
   evict src1 from DE and then reload it from a slot it never had (slot_off
   returns the -1 "no slot" sentinel → `ld hl,-1; add hl,sp` reads below the
   frame). Const RHS never reaches here (canonicalized to LT/GE), so src[1]
   is always a real vreg. */
static void load_cmp_swap_operands(FILE *out, const Func *f, const Op *op)
{
    if (hl_has(op->src[1])) {
        /* src1 already in HL (its target). Load src0 into DE, keeping HL. */
        load_to_de_preserve_hl(out, f, op->src[0]);
        cache_de(op->src[0]);
        return;
    }
    if (hl_has(op->src[0])) {
        /* src0 in HL but wanted in DE. If it's the pending spill, flush it
           (store_hl leaves it in DE — the swap's intent). Else ex de,hl. */
        if (lazy_spill_on && pending_spill_v == op->src[0]) {
            pending_spill_flush();
            cache_de(op->src[0]);
            load_to_hl(out, f, op->src[1]);
            return;
        }
        emit(out, "ex\tde,hl");
        swap_hl_de_caches();
        load_to_hl(out, f, op->src[1]);
        return;
    }
    if (de_has(op->src[0])) {
        /* src0 already in DE: just bring src1 into HL (preserves DE). */
        load_to_hl(out, f, op->src[1]);
        return;
    }
    if (de_has(op->src[1])) {
        /* src1 in DE but wanted in HL. An unrelated pending spill in HL
           would be clobbered by store_hl's ex de,hl, so resolve and rebuild;
           otherwise swap src1 into HL and load src0 into DE preserving HL. */
        if (lazy_spill_on && pending_spill_v >= 0) {
            pending_spill_resolve();
            invalidate_de_cache();
            load_to_de(out, f, op->src[0]);
            cache_de(op->src[0]);
            load_to_hl(out, f, op->src[1]);
            return;
        }
        emit(out, "ex\tde,hl");
        swap_hl_de_caches();
        load_to_de_preserve_hl(out, f, op->src[0]);
        cache_de(op->src[0]);
        return;
    }
    load_to_de(out, f, op->src[0]);    /* DE = src0; trashes HL */
    cache_de(op->src[0]);
    load_to_hl(out, f, op->src[1]);    /* HL = src1; preserves DE */
}

static int gen_cmp_gt_le(FILE *out, Func *f, const Op *op)
{
    int is_signed = (op->kind == IR_CMP_GT || op->kind == IR_CMP_LE);
    /* After swap-load, CF=true means swapped operand src1 < src0
       = original src0 > src1 → GT/UGT. */
    int cf_true_gt = (op->kind == IR_CMP_UGT || op->kind == IR_CMP_GT);
    int long_signflip = is_signed && IS_GBZ80();   /* see gen_cmp_lt_ge */
    /* Long ordered compare, GT/LE variant: subtract src[0] from
       src[1] byte-wise — the swap means CF=borrow iff src1<src0 iff
       src0>src1. Const-RHS not folded (ast_opt rewrites it to
       LT/GE before reaching IR). */
    int src0w_gt = (op->src[0] >= 0) ? f->vregs[op->src[0]].width : 0;
    if (src0w_gt == 4) {
        if (long_signflip) {
            /* gbz80: minu=src1, subtr=src0 (the swap) — CF = src1<src0
               signed = src0>src1, no S^V correction below. */
            emit_long_signflip_sub(out, f, op->src[1], op->src[0]);
        } else if (op->src[1] == -1) {
            /* `a > K` / `a <= K` (width 4, const RHS): ir_build now
               canonicalizes these to `a >= K+1` / `a < K+1` (the LT/GE
               const path above). If one still reaches here it's the
               degenerate type-max edge — name the bail (failure is
               fatal). */
            fprintf(stderr, "ir_lower: long %s with const RHS unsupported "
                    "(width-4 GT/LE const should be canonicalized to GE/LT)\n",
                    op->kind == IR_CMP_GT ? "a>K" : "a<=K");
            return -1;
        } else if (!fp_active(f) && !dehl_has(op->src[0])) {
            /* Load src[1] (the "left" of the swapped subtraction) into
               DEHL, point HL at &src[0], subtract through (hl). */
            load_to_dehl(out, f, op->src[1]);
            int off = slot_off(f, op->src[0]) + cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,c");
            emit(out, "sub\t(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");
            emit(out, "sbc\ta,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\ta,e");
            emit(out, "sbc\ta,(hl)");
            emit(out, "inc\thl");
            emit(out, "ld\ta,d");
            emit(out, "sbc\ta,(hl)");
        } else {
            load_to_dehl(out, f, op->src[0]);
            emit(out, "push\tde");
            emit(out, "push\thl");
            load_to_dehl_adj(out, f, op->src[1], 4);
            emit(out, "pop\tbc");
            emit(out, "ld\ta,l");
            emit(out, "sub\tc");
            emit(out, "ld\ta,h");
            emit(out, "sbc\ta,b");
            emit(out, "pop\tbc");
            emit(out, "ld\ta,e");
            emit(out, "sbc\ta,c");
            emit(out, "ld\ta,d");
            emit(out, "sbc\ta,b");
        }
        if (is_signed && !long_signflip) {
            int n = cmp_label_counter++;
            emit(out, "jp\tpo,L_f%d_cmp_ok_%d", func_emit_idx, n);
            emit(out, "xor\t0x80");
            fprintf(out, "L_f%d_cmp_ok_%d:\n", func_emit_idx, n);
            emit(out, "rla");
        }
        invalidate_hl_bc();
        if (cur_branch_test_kind != 0) {
            int br_true = (cur_branch_test_kind == IR_BR_COND);
            int want_carry = (cf_true_gt == br_true);
            const char *cc = want_carry ? "c" : "nc";
            emit(out, "jp\t%s,L_f%d_bb_%d",
                 cc, func_emit_idx, cur_branch_test_label);
            cur_skip_next_op = 1;
            return 0;
        }
        carry_to_bool(out, f, cf_true_gt);
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    /* Swap operand load to reuse the same ordering arithmetic
       (DE=src0, HL=src1 — the mirror of load_binop_operands). */
    load_cmp_swap_operands(out, f, op);
    /* 8085 DSUB + jp k/nk (see gen_cmp_lt_ge). `sub hl,bc` (BC=src0)
       computes src1-src0, so K=signed(src1<src0)=signed(src0>src1)=GT,
       CF=unsigned borrow. Fused-branch path, signed only; push/pop a
       live BC around the subtract (see gen_cmp_lt_ge — pop leaves flags
       and unsigned wouldn't beat the byte-wise sub). */
    if ((IS_8085()) && is_signed
        && cur_branch_test_kind != 0) {
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want = (cf_true_gt == br_true);
        const char *cc = want ? "k" : "nk";
        int bc_live = (rs.bc >= 0);
        if (bc_live) emit(out, "push\tbc");
        emit(out, "ld\tc,e");
        emit(out, "ld\tb,d");          /* BC = src0 */
        emit(out, "sub\thl,bc");       /* HL-BC = src1-src0 */
        if (bc_live) emit(out, "pop\tbc"); /* restores BC; flags survive */
        emit(out, "jp\t%s,L_f%d_bb_%d", cc, func_emit_idx,
             cur_branch_test_label);
        invalidate_hl_keep_de();       /* DSUB clobbers HL, preserves DE/BC */
        if (!bc_live) invalidate_bc_cache();
        cur_skip_next_op = 1;
        return 0;
    }
    int sflip_gt = signed_cmp_signflip(out, f, is_signed);
    if (!(IS_808x() || IS_GBZ80())) {
        emit(out, "and\ta");
        emit(out, "sbc\thl,de");
    } else {
        /* Byte-wise HL-DE (= src1-src0 after the swap-load); CF=borrow iff
           src0>src1. See gen_cmp_lt_ge for the sbc-emulation rationale. */
        emit(out, "ld\ta,l");
        emit(out, "sub\te");
        emit(out, "ld\ta,h");
        emit(out, "sbc\ta,d");
    }
    if (is_signed && !sflip_gt) signed_result_to_carry(out);
    int cf_true = cf_true_gt;
    if (cur_branch_test_kind != 0) {
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want_carry = (cf_true == br_true);
        const char *cc = want_carry ? "c" : "nc";
        emit(out, "jp\t%s,L_f%d_bb_%d",
             cc, func_emit_idx, cur_branch_test_label);
        invalidate_hl_keep_de();
        cur_skip_next_op = 1;
        return 0;
    }
    carry_to_bool(out, f, cf_true);
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_cmp_eq_ne(FILE *out, Func *f, const Op *op)
{
    /* Long compare: byte-wise XOR-then-OR chain that sets Z iff all
       4 bytes match. dst is width 2 (the bool result). */
    int src0w = (op->src[0] >= 0) ? f->vregs[op->src[0]].width : 0;
    if (src0w == 4) {
        int z_true_long = (op->kind == IR_CMP_EQ);
        if (op->src[1] == -1) {
            /* Const-RHS: XOR each of DEHL's bytes against the const
               bytes; OR the 4 results together. Z set iff equal. */
            uint32_t k = (uint32_t)op->imm;
            uint8_t b0 = (uint8_t)(k & 0xff);
            uint8_t b1 = (uint8_t)((k >> 8) & 0xff);
            uint8_t b2 = (uint8_t)((k >> 16) & 0xff);
            uint8_t b3 = (uint8_t)((k >> 24) & 0xff);
            load_to_dehl(out, f, op->src[0]);
            emit(out, "ld\ta,l");
            if (b0) emit(out, "xor\t%u", (unsigned)b0);
            emit(out, "ld\tc,a");
            emit(out, "ld\ta,h");
            if (b1) emit(out, "xor\t%u", (unsigned)b1);
            emit(out, "or\tc");
            emit(out, "ld\tc,a");
            emit(out, "ld\ta,e");
            if (b2) emit(out, "xor\t%u", (unsigned)b2);
            emit(out, "or\tc");
            emit(out, "ld\tc,a");
            emit(out, "ld\ta,d");
            if (b3) emit(out, "xor\t%u", (unsigned)b3);
            emit(out, "or\tc");
        } else if (!fp_active(f) && !dehl_has(op->src[1])) {
            /* Var-RHS sp-rel: point HL at &RHS, XOR through (hl).
               BC mirrors LHS low half via DEHL cache invariant. */
            load_to_dehl(out, f, op->src[0]);
            int off = slot_off(f, op->src[1]) + cur_sp_adjust;
            emit(out, "ld\thl,%d", off);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,c");
            emit(out, "xor\t(hl)");
            emit(out, "ld\tc,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,b");
            emit(out, "xor\t(hl)");
            emit(out, "or\tc");
            emit(out, "ld\tc,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,e");
            emit(out, "xor\t(hl)");
            emit(out, "or\tc");
            emit(out, "ld\tc,a");
            emit(out, "inc\thl");
            emit(out, "ld\ta,d");
            emit(out, "xor\t(hl)");
            emit(out, "or\tc");
        } else {
            /* Both operands in registers / FP-mode: stage one, load the
               other, XOR through registers. Push whichever is currently
               DEHL-cached FIRST — a register-only operand has no coherent
               slot, so loading the other would clobber it beyond recovery
               (frameix long-compare of a just-loaded temp vs a slot value).
               The XOR/OR chain is symmetric, so operand order is irrelevant. */
            int pushed = dehl_has(op->src[0]) ? op->src[0] : op->src[1];
            int loaded = (pushed == op->src[0]) ? op->src[1] : op->src[0];
            load_to_dehl(out, f, pushed);
            emit(out, "push\tde");
            emit(out, "push\thl");
            load_to_dehl_adj(out, f, loaded, 4);
            emit(out, "pop\tbc");          /* BC = pushed operand low */
            emit(out, "ld\ta,l");
            emit(out, "xor\tc");
            emit(out, "ld\tc,a");
            emit(out, "ld\ta,h");
            emit(out, "xor\tb");
            emit(out, "or\tc");
            emit(out, "ld\tc,a");
            emit(out, "pop\thl");          /* HL = RHS high */
            emit(out, "ld\ta,e");
            emit(out, "xor\tl");
            emit(out, "or\tc");
            emit(out, "ld\tc,a");
            emit(out, "ld\ta,d");
            emit(out, "xor\th");
            emit(out, "or\tc");
        }
        invalidate_hl_bc();
        if (cur_branch_test_kind != 0) {
            int br_true = (cur_branch_test_kind == IR_BR_COND);
            int want_z = (z_true_long == br_true);
            const char *cc = want_z ? "z" : "nz";
            emit(out, "jp\t%s,L_f%d_bb_%d",
                 cc, func_emit_idx, cur_branch_test_label);
            cur_skip_next_op = 1;
            return 0;
        }
        emit(out, "ld\thl,0");
        emit_skip(out, f, z_true_long ? "nz" : "z", 1);
        emit(out, "inc\tl");
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    /* Equality is sign-independent. On real-ALU CPUs `or a; sbc hl,de`
       sets Z = equal. On gbz80/808x `sbc hl,de` is an emulated helper
       call — for equality, XOR the halves instead (Z = equal, no helper,
       no DE load for a constant RHS). */
    int z_true = (op->kind == IR_CMP_EQ);
    if (!(IS_808x() || IS_GBZ80())) {
        load_binop_operands(out, f, op);
        emit(out, "or\ta");
        emit(out, "sbc\thl,de");
    } else if (op->src[1] == -1) {
        uint16_t k = (uint16_t)op->imm;
        load_to_hl(out, f, op->src[0]);
        if (k == 0) {
            emit(out, "ld\ta,h");
            emit(out, "or\tl");                 /* Z iff HL==0 */
        } else {
            /* H holds the high byte to OR in; only rewrite it when the
               constant's high byte is nonzero (else `ld a,h;ld h,a` is a
               no-op and we OR the original H directly). */
            if ((k >> 8) & 0xff) {
                emit(out, "ld\ta,h");
                emit(out, "xor\t%u", (unsigned)((k >> 8) & 0xff));
                emit(out, "ld\th,a");
            }
            emit(out, "ld\ta,l");
            if (k & 0xff) emit(out, "xor\t%u", (unsigned)(k & 0xff));
            emit(out, "or\th");                 /* Z iff HL==K */
        }
    } else {
        load_binop_operands(out, f, op);
        emit(out, "ld\ta,h");
        emit(out, "xor\td");
        emit(out, "ld\th,a");
        emit(out, "ld\ta,l");
        emit(out, "xor\te");
        emit(out, "or\th");                     /* Z iff HL==DE */
    }
    if (cur_branch_test_kind != 0) {
        int br_true = (cur_branch_test_kind == IR_BR_COND);
        int want_z = (z_true == br_true);
        const char *cc = want_z ? "z" : "nz";
        emit(out, "jp\t%s,L_f%d_bb_%d",
             cc, func_emit_idx, cur_branch_test_label);
        invalidate_hl_keep_de();
        cur_skip_next_op = 1;
        return 0;
    }
    if (IS_RABBIT()) {
        /* Rabbit: HL = src0-src1 (from sbc above). bool hl → 0/1 = NE;
           for EQ, bool hl;dec hl;bool hl inverts it (logical NOT). */
        emit(out, "bool\thl");
        if (z_true) {
            emit(out, "dec\thl");
            emit(out, "bool\thl");
        }
    } else {
        emit(out, "ld\thl,0");
        emit_skip(out, f, z_true ? "nz" : "z", 1);
        emit(out, "inc\tl");
    }
    commit_hl_word(out, f, op->dst);
    return 0;
}

static int gen_shr(FILE *out, Func *f, const Op *op)
{
    if (op->dst >= 0 && f->vregs[op->dst].width == 4) {
        if (op->src[1] >= 0) {
            /* Variable-count long shift → l_lsr_dehl helper
               (logical/unsigned — IR_SHR is always logical here).
               Same staging convention as IR_SHL. */
            if (!hl_has(op->src[1]))
                load_to_hl(out, f, op->src[1]);
            emit(out, "ld\ta,l");
            /* The count now lives in A. Mark A live so load_to_dehl's gbz80
               byte-walk uses the A-preserving `ld r,(hl); inc hl` form, not
               `ld a,(hl+)` (which would clobber the count the helper needs).
               The cache is a transient (A holds the count, not src[1]'s full
               value) and the helper clobbers A, so drop it right after. */
            cache_a(op->src[1]);
            load_to_dehl(out, f, op->src[0]);
            emit(out, "call\tl_lsr_dehl");
            invalidate_a_cache();
            invalidate_hl_bc();
            store_dehl_finalize(out, f, op->dst);
            return 0;
        }
        int count = (int)op->imm & 0x1f;
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
           inline, only count%8 bits via l_lsr_dehl). */
        if (IS_808x()) {
            gen_808x_long_const_shift(out, f, op, count, 1);
            return 0;
        }
        /* In-place long >> 1 on a stack slot: walk via `srl (hl);
           rr (hl); rr (hl); rr (hl)` from MSB down. Logical shift
           — IR_SHR is always unsigned at this level. */
        if (count == 1
            && op->dst == op->src[0]
            && !cur_dst_dead
            && !vreg_in_pr_bc(f, op->dst)
            && f->vreg_to_phys
            && f->vreg_to_phys[op->dst] == IR_PR_SPILL) {
            int off = slot_off(f, op->dst) + cur_sp_adjust;
            emit(out, "ld\thl,%d", off + 3);
            emit(out, "add\thl,sp");        /* HL = &slot[3] (MSB) */
            emit(out, "srl\t(hl)");          /* byte3: high=0, low→C */
            emit(out, "dec\thl");
            emit(out, "rr\t(hl)");           /* byte2: C→high, low→C */
            emit(out, "dec\thl");
            emit(out, "rr\t(hl)");           /* byte1 */
            emit(out, "dec\thl");
            emit(out, "rr\t(hl)");           /* byte0 */
            invalidate_hl_bc();
            return 0;
        }
        int byte_shift = count / 8;
        int bit_shift  = count % 8;
        /* Partial-load fastpath: for byte_shift ≥ 1 the low bytes
           of the source are discarded. Skip them at load time. */
        if (byte_shift >= 1 && !dehl_has(op->src[0])) {
            partial_load_long_shr(out, f, op->src[0], byte_shift);
            invalidate_hl_cache();
            goto shr_long_bit_shift;
        }
        load_to_dehl(out, f, op->src[0]);
        /* Byte shift right, strength-reduced. Source layout
           D=byte3 E=byte2 H=byte1 L=byte0; after shifting right by
           `byte_shift` bytes each source byte moves down by that
           many, and the top `byte_shift` bytes become zero. The
           loop form did this iteratively; the direct form is one
           4-instruction sequence regardless of byte_shift. */
        switch (byte_shift) {
        case 0: break;
        case 1: /* L=H H=E E=D D=0 */
            emit(out, "ld\tl,h");
            emit(out, "ld\th,e");
            emit(out, "ld\te,d");
            emit(out, "ld\td,0");
            break;
        case 2: /* L=E H=D E=0 D=0; chain the zero through r,r */
            emit(out, "ld\tl,e");
            emit(out, "ld\th,d");
            emit(out, "ld\te,0");
            emit(out, "ld\td,e");
            break;
        case 3: /* L=D H=0 E=0 D=0; chain the zeros */
            emit(out, "ld\tl,d");
            emit(out, "ld\th,0");
            emit(out, "ld\te,h");
            emit(out, "ld\td,e");
            break;
        default: break;
        }
    shr_long_bit_shift:
        /* After a partial load, the high `byte_shift` bytes are
           zero — shifting them just rotates 0 through the chain.
           Trim to the bytes that actually hold data. Wrap in a
           djnz loop when it strictly saves bytes (mirror of the
           SHL fastpath above). */
        {
        static const int body_sz_shr[4] = { 8, 6, 4, 2 };
        int body_sz = body_sz_shr[byte_shift];
        int use_djnz = (bit_shift * body_sz > body_sz + 4);
        int iters = use_djnz ? 1 : bit_shift;
        int loop_label = 0;
        if (use_djnz) {
            loop_label = cmp_label_counter++;
            emit(out, "ld\tb,%d", bit_shift);
            fprintf(out, "L_f%d_shr_loop_%d:\n",
                    func_emit_idx, loop_label);
        }
        for (int i = 0; i < iters; i++) {
            switch (byte_shift) {
            case 0: /* all 4 bytes have data */
                emit(out, "srl\td");
                emit(out, "rr\te");
                emit(out, "rr\th");
                emit(out, "rr\tl");
                break;
            case 1: /* D=0; E,H,L have data */
                emit(out, "srl\te");
                emit(out, "rr\th");
                emit(out, "rr\tl");
                break;
            case 2: /* D=E=0; only H,L have data */
                emit(out, "srl\th");
                emit(out, "rr\tl");
                break;
            case 3: /* D=E=H=0; only L has data */
                emit(out, "srl\tl");
                break;
            }
        }
        if (use_djnz) {
            emit(out, "djnz\tL_f%d_shr_loop_%d",
                 func_emit_idx, loop_label);
            invalidate_bc_cache();
        }
        }
        store_dehl_finalize(out, f, op->dst);
        return 0;
    }
    /* 8080/8085: no CB shifts — route 16-bit `>>` (logical) to l_asr_u
       (DE=value, HL=count, result HL). Covers const and variable counts.
       `<<` stays the add-hl-hl path below (dad h, 8080-safe). */
    if (IS_808x()) {
        load_binop_operands(out, f, op);   /* HL=value, DE=count */
        emit(out, "ex\tde,hl");            /* DE=value, HL=count */
        emit_c(out, CLOB_HL, "call\tl_asr_u");
        invalidate_de_cache();
        /* l_asr_u is BC-clean on every non-CB target (8080/8085/gbz80/
           r2ka byte-rotate loops) — do NOT drop a live slotless PR_BC
           resident's belief (it would force a bogus reload). */
        if (vreg_is_pr_de(f, op->dst)) {
            emit(out, "ex\tde,hl");
            cache_de(op->dst);
            return 0;
        }
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    if (op->src[1] < 0) {
        int count = (int)op->imm & 0x1f;
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
        if (try_const_barrel(out, f, op, 1)) return 0;
        /* Partial-load fastpath for int SHR ≥ 8: only the high
           byte of the source survives, and goes into L of the
           result. Read it directly; skip the low byte. Only fires
           on a genuine SLOT read — a register-only vreg (PR_BC/HL/DE,
           vreg_spill_slot == -1) would read a bogus below-frame offset;
           for those fall through to load_to_hl + the `ld l,h` strength
           reduction (mirror of the SHL ≥8 guard above). */
        if (count >= 8 && !hl_has(op->src[0])
            && f->vreg_spill_slot && f->vreg_spill_slot[op->src[0]] >= 0) {
            ss_note_reload(f, op->src[0]);
            if (fp_active(f)) {
                int ix = slot_ix_off(f, op->src[0]);
                if (fp_offset_fits(ix + 1)) {
                    emit(out, "ld\tl,(%s%+d)", frame_reg(), ix + 1);
                    emit(out, "ld\th,0");
                    goto shr_int_bit_remainder;
                }
            }
            int off = slot_off(f, op->src[0]) + cur_sp_adjust;
            emit(out, "ld\thl,%d", off + 1);
            emit(out, "add\thl,sp");
            emit(out, "ld\tl,(hl)");        /* L = byte 1 */
            emit(out, "ld\th,0");
            goto shr_int_bit_remainder;
        }
        load_to_hl(out, f, op->src[0]);  /* no-op on HL hit; records cacheread */
        /* Mirror of the SHL ≥8 strength reduction: shift right by
           8 just moves H→L and zeros H. Extra `srl l` cycles cover
           the remainder above 8. */
        if (count >= 8) {
            emit(out, "ld\tl,h");
            emit(out, "ld\th,0");
        shr_int_bit_remainder:
            for (int k = 8; k < count; k++)
                emit(out, "srl\tl");
        } else {
            for (int k = 0; k < count; k++) {
                if (IS_RABBIT()) {
                    emit(out, "or\ta");      /* clear carry → logical >>1 */
                    emit(out, "rr\thl");
                } else {
                    emit(out, "srl\th");
                    emit(out, "rr\tl");
                }
            }
        }
        commit_hl_result(out, f, op->dst);
        return 0;
    }
    /* z80n: variable 16-bit logical shift-right as flat `bsrl de,b`
       (IR_SHR is always logical here). Sets no flags; result is a
       value, not a branch condition. */
    if (IS_Z80N()) {
        load_binop_operands(out, f, op);   /* HL=value(src0), DE=count(src1) */
        int bc_live = (rs.bc >= 0);  /* `ld b,e` clobbers B — preserve */
        if (bc_live) emit(out, "push\tbc");
        emit(out, "ld\tb,e");              /* B = count low byte */
        emit(out, "ex\tde,hl");            /* DE = value */
        emit(out, "bsrl\tde,b");           /* DE = value >> B (logical) */
        if (bc_live) emit(out, "pop\tbc");
        invalidate_hl_cache();
        invalidate_de_cache();
        if (!bc_live) invalidate_bc_cache();
        if (vreg_is_pr_de(f, op->dst)) {
            cache_de(op->dst);
            return 0;
        }
        emit(out, "ex\tde,hl");            /* HL = result */
        commit_hl_word(out, f, op->dst);
        return 0;
    }
    int n = cmp_label_counter++;
    load_binop_operands(out, f, op);
    emit(out, "ld\ta,e");
    emit(out, "or\ta");
    emit(out, "jr\tz,L_f%d_shift_end_%d", func_emit_idx, n);
    fprintf(out, "L_f%d_shift_loop_%d:\n", func_emit_idx, n);
    if (IS_RABBIT()) {
        emit(out, "or\ta");          /* clear carry → logical >>1 */
        emit(out, "rr\thl");
    } else {
        emit(out, "srl\th");
        emit(out, "rr\tl");
    }
    emit(out, "dec\ta");
    emit(out, "jr\tnz,L_f%d_shift_loop_%d", func_emit_idx, n);
    fprintf(out, "L_f%d_shift_end_%d:\n", func_emit_idx, n);
    commit_hl_result(out, f, op->dst);
    return 0;
}

