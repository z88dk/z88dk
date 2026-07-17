/* ir_lower_call.inc.c — part of ir_lower.c, #included (single TU). Do not compile standalone. */

/* After store_hl() of a used word CALL result (store_hl leaves the value in DE,
   HL=junk): in fp mode restore HL and cache it, so consumers read HL directly
   rather than reloading the slot / oscillating DE<->HL. store_hl's offset-fits
   path is `ld (ix+d),hl; ex de,hl`, so the recover ex de,hl forms an adjacent
   pair that copt (#284) cancels — the store keeps HL and the recover is free.
   In sp mode store_hl's paths don't reliably end in ex de,hl (TOS push, byte
   walk), so leave the value in DE (cache_de) as before. */
static void store_call_result_recover(FILE *out, const Func *f, int vreg)
{
    if (fp_active(f)) {
        emit(out, "ex\tde,hl");
        cache_hl(vreg);
    } else {
        cache_de(vreg);
    }
}

static int gen_call(FILE *out, Func *f, const Op *op)
{
    CallInfo *ci = op->call;
    if (!ci) {
        fputs("ir_lower: IR_CALL with NULL CallInfo\n", stderr);
        return -1;
    }
    int is_indirect = (ci->target == NULL);
    if (is_indirect && ci->fnptr_vreg < 0) {
        fputs("ir_lower: indirect IR_CALL missing fnptr_vreg\n",
              stderr);
        return -1;
    }
    if (ci->is_critical)
        emit(out, (IS_RABBIT()) ? "ipset\t3" : "di");

    int pre = (ci->pre_pushed > 0);

    /* __sdcccall(1) register convention (z80/z180/z80n): 1st arg A/HL/HLDE,
       2nd DE (when eligible), the rest stacked (STDC R→L, pushed below).
       `sc1_n_reg` = count of register-passed args. Reject the deferred
       shapes (indirect, A,L two-char 2nd, 1-byte/wide stacked args, long
       long, odd-width return). */
    int sc1 = (ci->flags & SDCCCALL1) != 0;
    Sc1Reg sc1_r1 = SC1_STACK, sc1_r2 = SC1_STACK;
    int sc1_n_reg = 0;
    if (sc1) {
        int w0 = ci->n_args >= 1 ? f->vregs[ci->args[0]].width : 0;
        int w1 = ci->n_args >= 2 ? f->vregs[ci->args[1]].width : 0;
        if (ci->n_args >= 1) sc1_r1 = sdcccall1_arg_reg(1, w0, SC1_STACK);
        if (ci->n_args >= 2) sc1_r2 = sdcccall1_arg_reg(2, w1, sc1_r1);
        sc1_n_reg = (sc1_r1 == SC1_STACK) ? 0
                  : (sc1_r1 == SC1_DEHL)  ? 1
                  : (sc1_r2 == SC1_DE || sc1_r2 == SC1_L) ? 2 : 1;
        int ret_w = ci->ret_vreg >= 0 ? f->vregs[ci->ret_vreg].width : 0;
        /* Indirect sc1 calls dispatch via the fc_idx/fc_ret machinery below. */
        int supported =
               (ci->n_args < 1 || sc1_r1 == SC1_A || sc1_r1 == SC1_HL
                               || sc1_r1 == SC1_DEHL)
            && !ci->ret_longlong
            && (ret_w <= 2 || ret_w == 4);
        for (int k = sc1_n_reg; k < ci->n_args && supported; k++) {
            int w = f->vregs[ci->args[k]].width;
            if (w != 1 && w != 2 && w != 4) supported = 0;  /* stacked: char/int/long */
        }
        if (!supported) {
            ir_lower_loc();
            fprintf(stderr, "ir_lower: __sdcccall(1) call shape not yet supported "
                    "(1st char/int/long, 2nd int->DE, extra args stacked as "
                    "int/long; 1-2-4 byte return)\n");
            ir_lower_src();
            return -1;
        }
    }

    /* PR_BC across calls: callees clobber BC, so save it if the function has
       any PR_BC vreg (conservative — not checked per-op). Pre-pushed calls
       never coexist with PR_BC (a `push bc` here would land ABOVE the
       already-pushed args); ir_alloc disables the PR_BC pool in functions
       containing IR_PUSH_ARG. */
    int bc_saved = 0;
    int bc_vreg_at_call_entry = L.rs.bc;
    if (!pre) {
        /* IR_VREG_BC_PACK tenants are call-free by construction (never live
           across this call), so they add no BC-save — Part 1. */
        for (int i = 0; i < f->n_vregs; i++) {
            if (f->vreg_to_phys[i] == IR_PR_BC
                && !(f->vregs[i].flags & IR_VREG_BC_PACK)) { bc_saved = 1; break; }
        }
    }
    if (bc_saved) {
        emit(out, "push\tbc");
    }
    int sp_adj_extra = bc_saved ? 2 : 0;

    /* Push args. SMALLC/CALLEE: left-to-right. STDC: right-to-left.
       CALLEE cleans the stack after ret instead of us.
       Each push shifts sp, but slot loads use `add hl,sp`, so bump the slot
       offset by bytes already pushed (+ saved BC) to keep landing on the
       original slot.
       Fastcall: push n-1 args (SMALLC order), then load the LAST arg into HL
       (or DEHL for width 4) just before the call; that load is emitted below. */
    int pushed_bytes = 0;
    int is_fastcall = (ci->abi == IR_ABI_FASTCALL);
    int n_to_push   = is_fastcall ? (ci->n_args - 1)
                    : sc1          ? (ci->n_args - sc1_n_reg)  /* stacked remainder */
                    : ci->n_args;
    /* sc1 stacked args use STDC order (R→L) regardless of the cleanup-driven
       ci->abi; push from the rightmost down to the first stacked index. */
    int push_step = (ci->abi == IR_ABI_STDC || sc1) ? -1 : 1;
    int start    = sc1 ? (ci->n_args - 1)
                 : (ci->abi == IR_ABI_STDC) ? (n_to_push - 1) : 0;
    if (pre) {
        /* Args already on the stack via IR_PUSH_ARG/IR_PUSH_STRUCT ops (which
           bumped cur_sp_adjust). Just tally the bytes for the variadic count
           and the cleanup pops. A struct arg occupies its full size (its vreg
           is the 2-byte address) — use arg_pushed_bytes when present. */
        for (int k = 0; k < n_to_push; k++)
            pushed_bytes += ci->arg_pushed_bytes
                          ? ci->arg_pushed_bytes[k]
                          : ((f->vregs[ci->args[k]].width == 4) ? 4 : 2);
        n_to_push = 0;
    }
    for (int k = 0; k < n_to_push; k++) {
        int i = start + k * push_step;
        int slot = slot_off(f, ci->args[i]);
        int adj  = slot + pushed_bytes + sp_adj_extra + L.cur_sp_adjust;
        int width = f->vregs[ci->args[i]].width;
        if (width > 4) {
            /* Wide double arg: load slot into acc and push — combined (dldpsh)
               when the format provides it, else load + push. */
            emit_acc_slot_addr(out, f, ci->args[i], pushed_bytes + sp_adj_extra);
            if (acc_prim(f, ci->args[i], "loadpush")) {
                emit(out, "call\t%s", acc_prim(f, ci->args[i], "loadpush"));
            } else {
                emit(out, "call\t%s", acc_prim(f, ci->args[i], "load"));
                emit(out, "call\t%s", acc_prim(f, ci->args[i], "push"));
            }
            pushed_bytes += width;
            invalidate_hl_cache();
        } else if (width == 4) {
            /* Long arg: load via load_to_dehl_adj (DEHL = value),
               then `push de; push hl` so sp[0]=low, sp[2]=high
               matching the z88dk lpush() convention. */
            load_to_dehl_adj(out, f, ci->args[i],
                             pushed_bytes + sp_adj_extra);
            emit(out, "push\tde");
            emit(out, "push\thl");
            pushed_bytes += 4;
        } else if (width == 1 && push_step == -1
                   && (ci->flags & (SDCCDECL | SDCCCALL1))
                   && k + 1 < n_to_push
                   && f->vregs[ci->args[start + (k + 1) * push_step]].width == 1) {
            /* Two adjacent stacked chars → one `push de` (matches SDCC
               sc1/sdccdecl R→L char push): higher-index char → D, lower → E,
               matching two 1-byte pushes at half the cost. push_step==-1
               keeps that D/E mapping valid. */
            int j   = start + (k + 1) * push_step;
            int sda = pushed_bytes + sp_adj_extra;
            push_arg_byte_to_a(out, f, ci->args[i], sda); /* current i (higher) */
            emit(out, "ld\td,a");
            push_arg_byte_to_a(out, f, ci->args[j], sda); /* next (lower) */
            emit(out, "ld\te,a");
            emit(out, "push\tde");
            pushed_bytes += 2;
            invalidate_hl_cache();   /* sp path clobbered HL; both clobber DE */
            k++;   /* the paired char is consumed here */
        } else if (width == 1 && (ci->flags & (SDCCDECL | SDCCCALL1))) {
            /* sc1/sdccdecl char arg: push ONE byte. `push af; inc sp` leaves
               the char (A) at sp+0 and reclaims F — no BC clobber. */
            push_arg_byte_to_a(out, f, ci->args[i], pushed_bytes + sp_adj_extra);
            emit(out, "push\taf");
            emit(out, "inc\tsp");
            pushed_bytes += 1;
        } else if (width == 1) {
            emit(out, "ld\thl,%d", adj);
            emit(out, "add\thl,sp");
            emit(out, "ld\ta,(hl)");
            emit(out, "ld\tl,a");
            emit(out, "ld\th,0");
            emit(out, "push\thl");
            pushed_bytes += 2;
        } else {
            /* Width-2 arg via load_to_hl_adj so PR_BC cache hits
               (`ld l,c; ld h,b`) and FP-relative loads fire. The sp adjustment
               covers the bc-save and prior arg pushes. */
            load_to_hl_adj(out, f, ci->args[i],
                           pushed_bytes + sp_adj_extra);
            emit(out, "push\thl");
            pushed_bytes += 2;
        }
    }

    /* Fastcall and __sdcccall(1) indirect calls need the fnptr OFF HL (the
       args ride HL/DEHL resp. A/HL/DE): load it into a spare index reg (ix/iy,
       not the frame pointer) when free, else push it and dispatch via the
       pushed-retaddr `ret` fallback below. */
    int idx_dispatch = is_indirect && (is_fastcall || sc1) && !ci->far_fnptr;
    int fc_pr = idx_dispatch ? ir_idx2_reg() : IR_PR_NONE;
    const char *fc_idx = (fc_pr == IR_PR_IX) ? "ix"
                       : (fc_pr == IR_PR_IY) ? "iy" : NULL;
    /* No free index reg (idx2 off, target reserves one, or 808x/gbz80): the
       fnptr can't sit in ix/iy, so push it and dispatch via pushed-retaddr +
       `ret` (the arg still rides HL/DEHL/acc). */
    int fc_ret = (idx_dispatch && !fc_idx);
    int fnptr_pushed = 0;
    int sc1_fcret_lbl = -1;
    if (fc_idx) {
        load_to_hl_adj(out, f, ci->fnptr_vreg,
                       pre ? 0 : pushed_bytes + sp_adj_extra);
        emit(out, "push\thl");
        emit(out, "pop\t%s", fc_idx);   /* fnptr → ix/iy (HL freed for the arg) */
        invalidate_hl_cache();
    } else if (fc_ret && sc1) {
        /* The fastcall `pop af` fnptr shuttle would clobber A (an sc1 char
           arg), so sc1 diverges: HL is still free here (before the args
           load), so push [retlabel][fnptr] now and `ret` at dispatch — the
           callee's ret lands on retlabel. fnptr_pushed shifts sc1_adj below. */
        sc1_fcret_lbl = L.fc_ret_label_counter++;
        load_to_hl_adj(out, f, ci->fnptr_vreg,
                       pre ? 0 : pushed_bytes + sp_adj_extra);
        emit(out, "ld\tbc,L_f%d_fcret_%d", L.func_emit_idx, sc1_fcret_lbl);
        emit(out, "push\tbc");          /* return address (below the fnptr) */
        emit(out, "push\thl");          /* fnptr on TOS — `ret` jumps to it */
        fnptr_pushed = 4;
        invalidate_hl_cache();
    } else if (fc_ret) {
        load_to_hl_adj(out, f, ci->fnptr_vreg,
                       pre ? 0 : pushed_bytes + sp_adj_extra);
        emit(out, "push\thl");          /* fnptr on TOS; `pop af` reclaims it */
        fnptr_pushed = 2;
        if (pre) L.cur_sp_adjust += 2;
        invalidate_hl_cache();
    }

    /* Fastcall: load the last arg into HL (width 1/2) or DEHL (width 4) just
       before the call. Must come AFTER all pushes — earlier pushes shift sp,
       compensated via the load helpers' sp_adj parameter. */
    if (is_fastcall && ci->n_args > 0) {
        /* Pre-pushed args live in cur_sp_adjust (load helpers add it
           themselves). A ret-dispatch fnptr pushed above shifts slots +2. */
        int adj = pre ? 0 : pushed_bytes + sp_adj_extra + fnptr_pushed;
        int last = ci->n_args - 1;
        int width = f->vregs[ci->args[last]].width;
        if (width > 4) {
            /* Wide fastcall arg (long long / 5-8B double) rides the
               accumulator (__i64_acc or FA), not HL — callee binds it there. */
            emit_acc_slot_addr(out, f, ci->args[last], adj);
            emit_c(out, CLOB_HL, "call\t%s", acc_prim(f, ci->args[last], "load"));
        } else if (width == 4) {
            load_to_dehl_adj(out, f, ci->args[last], adj);
        } else {
            load_to_hl_adj(out, f, ci->args[last], adj);
        }
    }

    /* __sdcccall(1): place the register args. Load the 2nd arg (DE) first,
       then the 1st (A/HL) — loading HL/A doesn't disturb DE. The slot loads
       must clear the stacked-arg pushes (pushed_bytes), the bc-save, AND any
       fnptr+retlabel pushed for the indirect `ret` dispatch (fnptr_pushed). */
    if (sc1) {
        int sc1_adj = pushed_bytes + sp_adj_extra + fnptr_pushed;
        if (sc1_r1 == SC1_DEHL) {         /* 4-byte sole arg -> HLDE */
            load_to_dehl_adj(out, f, ci->args[0], sc1_adj);  /* native HL=lo,DE=hi */
            emit(out, "ex\tde,hl");       /* -> sc1: DE=low, HL=high */
            invalidate_hl_cache();
            invalidate_de_cache();
        } else if (sc1_r2 == SC1_L) {     /* two chars: 1st -> A, 2nd -> L */
            /* Both byte loads use A as scratch, so stage the 2nd in C: load
               2nd -> C, 1st -> A, then L = C. (C is free — the call clobbers
               BC and a PR_BC tenant is saved by bc_saved.) */
            load_to_hl_adj(out, f, ci->args[1], sc1_adj);  /* L = 2nd char */
            emit(out, "ld\tc,l");                          /* C = 2nd char */
            load_to_hl_adj(out, f, ci->args[0], sc1_adj);  /* L = 1st char */
            emit(out, "ld\ta,l");                          /* A = 1st char */
            emit(out, "ld\tl,c");                          /* L = 2nd char */
            invalidate_hl_cache();
        } else {
            if (sc1_r2 == SC1_DE) {       /* 2nd arg -> DE (via HL + ex) */
                load_to_hl_adj(out, f, ci->args[1], sc1_adj);
                emit(out, "ex\tde,hl");
                invalidate_hl_cache();    /* HL now holds junk (was arg1) */
            }
            if (ci->n_args >= 1) {
                load_to_hl_adj(out, f, ci->args[0], sc1_adj);
                if (sc1_r1 == SC1_A)
                    emit(out, "ld\ta,l"); /* 1st char arg -> A */
            }
        }
    }

    /* SMALLC variadic ABI: emit `ld a,bytes/2` (or `xor a` if 0)
       immediately before the call. Stdc and fastcall don't need it. The
       stuffed pointer (pushed below) is not part of the arg count. */
    if (ci->is_variadic && ci->abi == IR_ABI_SMALLC) {
        int n = pushed_bytes / 2;
        if (n == 0) emit(out, "xor\ta");
        else        emit(out, "ld\ta,%d", n);
    }

    /* long long return: push the hidden result-buffer pointer (&__i64_acc)
       last, so it lands just above the return address (callee param offsets
       already account for the +2). The result comes back in __i64_acc; the
       caller-cleanup below pops this with the args. */
    if (ci->ret_longlong && !fc_ret) {
        emit(out, "ld\tbc,__i64_acc");
        emit(out, "push\tbc");
        pushed_bytes += 2;
        if (pre) L.cur_sp_adjust += 2;
    }

    if (is_indirect && ci->far_fnptr) {
        /* __far fnptr: materialize the far address into DEHL (EHL = E:bank,
           HL:offset), A = arg-word count, dispatch through l_farcall (pages
           bank E, calls offset HL). l_farcall reads EHL, so — unlike sccz80 —
           the fnptr need not also sit on the stack. Args popped by the
           caller-cleanup below. */
        load_to_dehl_adj(out, f, ci->fnptr_vreg,
                         pre ? 0 : pushed_bytes + sp_adj_extra);
        int argwords = pushed_bytes / 2;
        if (argwords == 0) emit(out, "xor\ta");
        else               emit(out, "ld\ta,%d", argwords);
        emit(out, "call\tl_farcall");
    } else if (is_indirect && fc_idx) {
        /* Fastcall / sc1 fnptr: the fnptr is already in ix/iy (loaded above,
           before the args took A/HL/DE); dispatch via the jp(ix)/jp(iy) thunk
           (l_jpix/l_jpiy are pure `jp (ix)`, no A/HL/DE clobber). */
        emit(out, "call\tl_jp%s", fc_idx);
    } else if (is_indirect && fc_ret && sc1) {
        /* [retlabel][fnptr] already pushed above (before the args); just
           `ret` into the fnptr — its own `ret` returns to our label. */
        emit(out, "ret");
        fprintf(out, "L_f%d_fcret_%d:\n", L.func_emit_idx, sc1_fcret_lbl);
    } else if (is_indirect && fc_ret) {
        /* No spare index reg (idx2 off / target reserves one / 808x / gbz80):
           the fnptr is on TOS and the arg rides HL/DEHL/acc. Reclaim the fnptr
           into AF, push a return label then the fnptr, and `ret` into it — the
           callee's own `ret` lands back at the label. */
        int lbl = L.fc_ret_label_counter++;
        emit(out, "pop\taf");           /* fnptr → AF */
        if (pre) L.cur_sp_adjust -= 2;
        if (ci->ret_longlong) {
            /* hidden &__i64_acc must sit just above the return address */
            emit(out, "ld\tbc,__i64_acc");
            emit(out, "push\tbc");
            pushed_bytes += 2;
        }
        emit(out, "ld\tbc,L_f%d_fcret_%d", L.func_emit_idx, lbl);
        emit(out, "push\tbc");          /* return address */
        emit(out, "push\taf");          /* fnptr */
        emit(out, "ret");               /* jump to fnptr; its ret → our label */
        fprintf(out, "L_f%d_fcret_%d:\n", L.func_emit_idx, lbl);
    } else if (is_indirect) {
        /* Load funcptr into HL, `call l_jphl` (the `jp (hl)` thunk): the call
           pushes the return address, l_jphl jumps to HL, the target's `ret`
           returns to our call-site. fnptr slot offset picks up pushed arg
           bytes + saved BC (sp_adj_extra); pre-pushed args are in
           cur_sp_adjust. */
        load_to_hl_adj(out, f, ci->fnptr_vreg,
                       pre ? 0 : pushed_bytes + sp_adj_extra);
        emit(out, "call\tl_jphl");
    } else if ((ci->flags & SHORTCALL) && !(ci->flags & SHORTCALL_HL)) {
        /* __z88dk_shortcall: dispatch via the rst vector, with the value
           as an inline operand (defb if it fits a byte, else defw) that
           the rst handler reads. (long-long return's __i64_acc push was
           already emitted above.) */
        emit(out, "rst\t%d", ci->shortcall_rst);
        emit(out, "%s\t%d",
             ci->shortcall_value < 0x100 ? "defb" : "defw",
             ci->shortcall_value);
    } else if (ci->flags & SHORTCALL_HL) {
        /* __z88dk_shortcall_hl: value passed in HL, no inline operand.
           A fastcall arg already in HL is preserved into BC first. */
        if (ci->abi == IR_ABI_FASTCALL)
            emit(out, "ld\tbc,hl");
        emit(out, "ld\thl,%d", ci->shortcall_value);
        emit(out, "rst\t%d", ci->shortcall_rst);
    } else if (ci->flags & HL_CALL) {
        /* __z88dk_hl_call: module in HL, then a direct call to the fixed
           numeric address. A fastcall arg in HL is preserved into BC. */
        if (ci->abi == IR_ABI_FASTCALL)
            emit(out, "ld\tbc,hl");
        emit(out, "ld\thl,%d", ci->hlcall_module);
        emit(out, "call\t%d", ci->hlcall_addr);
    } else if ((ci->flags & BANKED) && c_banked_style == BANKED_STYLE_TICALC) {
        /* TICALC banked call: BCALL via rst $28, a unique import label
           (patched by appmake) and a defw 0 placeholder. */
        static int banked_label = 0;
        emit(out, "rst\t$28");
        fprintf(out, ".__banked_import_%x%s%s\n", banked_label++,
             ir_sym_prefix(ci->target),
             ci->target_name ? ci->target_name : ir_sym_name(ci->target));
        emit(out, "defw 0");
    } else if (ci->flags & BANKED) {
        /* REGULAR banked call: the banked_call trampoline reads the inline
           4-byte target (defq) after the call, pages it in and jumps. */
        emit(out, "call\tbanked_call");
        emit(out, "defq\t%s%s",
             ir_sym_prefix(ci->target),
             ci->target_name ? ci->target_name : ir_sym_name(ci->target));
    } else {
        emit(out, "call\t%s%s",
             ir_sym_prefix(ci->target),
             ci->target_name ? ci->target_name : ir_sym_name(ci->target));
    }

    /* Caller-cleanup for SMALLC and STDC (CALLEE cleans its own).
       Rabbit/gbz80 reclaim the whole arg block in one `add sp,N` — preserves
       all regs incl. the HL/DEHL return value, and from 2 args up it's
       size-equal-or-smaller AND faster than the pop chain (gbz80 `add sp,e`
       16T vs 2×`pop bc` 24T; Rabbit cheaper). Below that, and on plain z80,
       `pop bc` (10T/1 byte each, DEHL/HL-preserving) wins; the ex/add/ld dance
       only pays off at N≥10 args. */
    if (ci->abi != IR_ABI_CALLEE && pushed_bytes > 0) {
        if ((IS_RABBIT() || IS_GBZ80()) && pushed_bytes >= 4) {
            emit_add_sp_chain(out, pushed_bytes);
        } else {
            int n = pushed_bytes;
            for (; n >= 2; n -= 2)
                emit(out, "pop\tbc");
            if (n == 1)         /* odd byte (a __z88dk_sdccdecl char arg) */
                emit(out, "inc\tsp");
        }
    }
    /* Pre-pushed args bumped cur_sp_adjust at each IR_PUSH_ARG; the
       stack is rebalanced now (our pops, or the callee's cleanup). */
    if (pre)
        L.cur_sp_adjust -= pushed_bytes;

    if (ci->is_critical)
        emit(out, (IS_RABBIT()) ? "ipres" : "ei");

    /* Restore the BC pushed before the call. arg setup may have reloaded BC to
       a different tenant (emit_bc_reload), so re-sync the cache to the tenant
       held at call entry. */
    if (bc_saved) {
        emit(out, "pop\tbc");
        L.rs.bc = bc_vreg_at_call_entry;
    }

    /* Callee clobbers caller-saved regs (HL/DE/BC/A), so invalidate their
       caches. BC: if pushed via bc_saved, the pop above restored it and the
       cache is already accurate; if not pushed (no PR_BC vregs), the cache may
       advertise HL-mirror contents the call destroyed — invalidate then. */
    invalidate_hl_cache();
    if (!bc_saved)
        invalidate_bc_cache();
    /* The callee may have paged a different __addressmod bank — re-page on
       the next namespaced access. (The page-in call is emitted inline, not
       via gen_call, so it doesn't reach here.) */
    cur_bank_fn = NULL;
    /* Return value in HL (width ≤ 2) or DEHL (width 4) per z88dk smallc/stdc.
       Pick the store routine from the ret vreg's width — store_hl on a width-4
       vreg would drop the high half. */
    if (ci->ret_vreg >= 0) {
        int ret_w = f->vregs[ci->ret_vreg].width;
        if (sc1) {
            /* __sdcccall(1) return: 1B in A, 2B in DE, 4B in HLDE (DE=low,
               HL=high — `ex de,hl` converts to native DEHL). */
            if (ret_w == 1) {
                if (L.la.cur_dst_dead || vreg_in_register_pool(f, ci->ret_vreg))
                    cache_a(ci->ret_vreg);
                else
                    store_a_byte(out, f, ci->ret_vreg);
            } else if (ret_w == 4) {
                emit(out, "ex\tde,hl");    /* sc1 HLDE -> native DEHL */
                store_dehl_cached(out, f, ci->ret_vreg);
            } else {                       /* width 2 -> HL */
                emit(out, "ex\tde,hl");    /* HL = result */
                if (L.la.cur_dst_dead || vreg_in_register_pool(f, ci->ret_vreg))
                    cache_hl(ci->ret_vreg);   /* dead/reg-pool: keep in HL, no spill */
                else {
                    store_hl(out, f, ci->ret_vreg);
                    store_call_result_recover(out, f, ci->ret_vreg);
                }
            }
        } else if (ret_w > 4) {
            /* Wide return: the callee left it in the accumulator (FA for
               double, __i64_acc for long long); store it to the ret slot. */
            emit_acc_slot_addr(out, f, ci->ret_vreg, 0);
            emit_acc_store_hl(out, f, ci->ret_vreg);
            invalidate_hl_cache();
            *wide_acc_cell(f, ci->ret_vreg) = ci->ret_vreg;
        } else if (ret_w == 4) {
            /* Lever A: a width-4 result feeding a later HCALL's stacked
               arg is pushed straight to the data stack (the lookahead set
               cur_dehl_push_to_stack) rather than spilled to its slot. */
            if (L.la.cur_dehl_push_to_stack && L.la.cur_dehl_inline_push < 0
                && L.la.cur_stack_long_top < 0 && !L.la.cur_dehl_dst_dead_safe
                && !vreg_is_pr_dehl(f, ci->ret_vreg))
                emit_dehl_stack_push(out, ci->ret_vreg);
            else
                store_dehl_cached(out, f, ci->ret_vreg);
            L.la.cur_dehl_push_to_stack = 0;
        } else if (ret_w == 1) {
            /* Byte return: value in HL (low byte in L, char-widened by the
               callee). store_hl writes 2 bytes and would overrun a 1-byte
               slot, so store the low byte via A. */
            emit(out, "ld\ta,l");
            if (L.la.cur_dst_dead || vreg_in_register_pool(f, ci->ret_vreg))
                cache_a(ci->ret_vreg);
            else
                store_a_byte(out, f, ci->ret_vreg);
        } else {                           /* width 2, result in HL */
            if (L.la.cur_dst_dead || vreg_in_register_pool(f, ci->ret_vreg))
                cache_hl(ci->ret_vreg);    /* dead/reg-pool: keep in HL, no spill */
            else {
                store_hl(out, f, ci->ret_vreg);
                store_call_result_recover(out, f, ci->ret_vreg);
            }
        }
    }

    /* Pre-pushed calls: the BC save (if the function keeps a PR_BC tenant) was
       emitted by this call's FIRST IR_PUSH_ARG, below the arg block. Pop it
       here, after the cleanup, and restore the cache to the tenant recorded at
       save time. */
    if (pre && func_has_pr_bc(f) && bc_args_save_depth > 0) {
        emit(out, "pop\tbc");
        L.rs.bc = bc_args_save_stack[--bc_args_save_depth];
        L.cur_sp_adjust -= 2;
    }
    return 0;
}

/* Address of ACC operand `pos` into HL: a pool constant's `i_<litlab>`, else
   the vreg's frame slot. Ready for an acc load / loadpush. */
static void emit_acc_operand_addr(FILE *out, Func *f, const HelperInfo *hi, int pos)
{
    if (hi->acc_src_is_pool[pos])
        emit(out, "ld\thl,i_%d", hi->acc_src_litlab[pos]);
    else
        emit_acc_slot_addr(out, f, hi->args[pos], 0);
}

/* Is ACC operand `pos` a vreg already resident in the accumulator? */
static int acc_operand_resident(const Func *f, const HelperInfo *hi, int pos)
{
    return !hi->acc_src_is_pool[pos] && hi->args[pos] >= 0
        && *wide_acc_cell(f, hi->args[pos]) == hi->args[pos];
}

/* Push one operand of a wide binop/cmp and return the POSITION (0/1) to load
   into the accumulator. Honours acc_holds_lhs (non-commutative order); for a
   commutative op pushes whichever operand is accumulator-resident (straight
   from the accumulator — no reload). Pool-constant operands are loaded by
   address; never resident, so they end up loaded-last. */
static int acc_push_one_operand(FILE *out, Func *f, const HelperInfo *hi)
{
    int push_pos = hi->acc_holds_lhs ? 1 : 0;
    int acc_pos  = hi->acc_holds_lhs ? 0 : 1;
    if (hi->acc_commutative) {
        if      (acc_operand_resident(f, hi, 1)) { push_pos = 1; acc_pos = 0; }
        else if (acc_operand_resident(f, hi, 0)) { push_pos = 0; acc_pos = 1; }
    }
    if (acc_operand_resident(f, hi, push_pos)) {
        emit(out, "call\t%s", hi->acc_push);          /* already resident */
    } else {
        emit_acc_operand_addr(out, f, hi, push_pos);
        if (hi->acc_loadpush) {
            emit(out, "call\t%s", hi->acc_loadpush);
        } else {
            emit(out, "call\t%s", hi->acc_load);
            emit(out, "call\t%s", hi->acc_push);
        }
    }
    return acc_pos;
}

/* Would ACC op `h` push vreg `v` straight from the accumulator (rather than
   load it from its slot), given v is accumulator-resident? Mirrors exactly
   acc_push_one_operand's choice — they must never disagree. */
static int acc_op_pushes_from_acc(const HelperInfo *h, int v)
{
    if (!h || h->n_args != 2 || h->acc_count_in_a) return 0;
    int a0 = h->args[0], a1 = h->args[1];
    if (a0 == a1) return 0;            /* used as both operands → the load reads the slot */
    if (h->acc_commutative) return (v == a0 || v == a1);
    return v == (h->acc_holds_lhs ? a1 : a0);   /* the fixed pushed operand */
}

/* A wide-accumulator result `v` just produced (and left resident) needs no
   slot store: the next real op consumes it straight from the accumulator
   (push-from-acc) and v is dead afterwards, so its slot is never read.
   Conservative — any uncertainty (no liveness, BB-end, non-acc next op)
   keeps the store. */
static int wide_acc_result_dead_in_acc(const Func *f, int v)
{
    if (opt_disabled("acc-drop") || !cur_bb || v < 0) return 0;
    int j = cur_op_idx + 1;
    while (j < cur_bb->n_ops && cur_bb->ops[j].kind == IR_NOP) j++;
    if (j >= cur_bb->n_ops) return 0;
    const Op *nx = &cur_bb->ops[j];
    if (nx->kind != IR_ACC_BINOP && nx->kind != IR_ACC_CMP) return 0;
    if (!acc_op_pushes_from_acc(nx->hcall, v)) return 0;
    /* v must be dead after nx (its slot then never read). */
    const BitSet *after = (j + 1 < cur_bb->n_ops)
        ? ir_op_live_in(cur_bb, j + 1) : cur_bb->live_out;
    (void)f;
    return after && !ir_bitset_get(after, v);
}

/* Wide memory-accumulator binop (IR_ACC_BINOP). Operands and result are
   slot-resident wide vregs (width 6/8); the accumulator (FA / __i64_acc) is
   the working store. Sequence (sp-relative; ir_build gates to !fp_active):
     dload(push_operand); push          ; one operand to acc, push it
     dload(acc_operand)                 ; other operand into acc (last)
     call <binop>                       ; helper consumes the pushed operand
     store(dst)                         ; acc -> result slot
   `acc_holds_lhs` selects which operand is loaded-last vs pushed so
   non-commutative ops (sub/div) get the right order. */
static int gen_acc_binop(FILE *out, Func *f, const Op *op)
{
    HelperInfo *hi = op->hcall;
    if (!hi || !hi->name || hi->n_args != 2 || hi->ret_vreg < 0) {
        fputs("ir_lower: IR_ACC_BINOP malformed\n", stderr);
        return -1;
    }
    int lhs = hi->args[0], rhs = hi->args[1];
    int w = hi->acc_width;

    /* i64 shift: push the value (lhs), count's low byte in A, call the
       count-in-A helper (it pops the value). Literal count (rhs < 0) is an
       immediate in op->imm; a variable count is loaded after the push. No i64
       count is ever materialised. */
    if (hi->acc_count_in_a) {
        emit_acc_slot_addr(out, f, lhs, 0);
        emit(out, "call\t%s", hi->acc_load);
        emit(out, "call\t%s", hi->acc_push);
        L.cur_sp_adjust += w;
        /* The value load + push clobbered HL/DE/BC via plain calls (no cache
           invalidation), so drop the stale caches before reading the count —
           else load_byte_to_a takes a phantom HL/DE hit (e.g. Rabbit sp-rel
           `ld (sp+N),hl` leaves the ++counter cached in HL) and shifts by
           garbage. */
        invalidate_hl_bc();
        if (rhs < 0)
            emit(out, "ld\ta,%d", (int)(op->imm & 0xff));
        else
            load_byte_to_a(out, f, rhs);      /* count -> A (offsets incl. push) */
        emit(out, "call\t%s", hi->name);
        L.cur_sp_adjust -= w;
        if (!wide_acc_result_dead_in_acc(f, hi->ret_vreg)) {
            emit_acc_slot_addr(out, f, hi->ret_vreg, 0);
            if (hi->acc_store_bc) { emit(out, "ld\tb,h"); emit(out, "ld\tc,l"); }
            emit_c(out, CLOB_HL, "call\t%s", hi->acc_store);
        }
        invalidate_de_cache();
        invalidate_bc_cache();
        invalidate_a_cache();
        *wide_acc_cell(f, hi->ret_vreg) = hi->ret_vreg;
        return 0;
    }

    (void)lhs; (void)rhs;
    /* 1. push one operand (from the accumulator if already resident). */
    int acc_pos = acc_push_one_operand(out, f, hi);
    L.cur_sp_adjust += w;
    /* 2. acc operand -> acc (offsets now include the push) */
    emit_acc_operand_addr(out, f, hi, acc_pos);
    emit(out, "call\t%s", hi->acc_load);
    /* 3. binop — the helper pops the pushed operand */
    emit(out, "call\t%s", hi->name);
    L.cur_sp_adjust -= w;
    /* 4. acc -> dst slot — unless the result is consumed straight from the
       accumulator by the next op and dies there (slot never read). */
    if (!wide_acc_result_dead_in_acc(f, hi->ret_vreg)) {
        emit_acc_slot_addr(out, f, hi->ret_vreg, 0);
        if (hi->acc_store_bc) {        /* l_i64_store wants the address in BC */
            emit(out, "ld\tb,h");
            emit(out, "ld\tc,l");
        }
        emit_c(out, CLOB_HL, "call\t%s", hi->acc_store);
    }
    invalidate_de_cache();
    invalidate_bc_cache();
    invalidate_a_cache();
    /* Advertise the result as accumulator-resident so the next op (or return)
       consumes it from there instead of reloading the slot. */
    *wide_acc_cell(f, hi->ret_vreg) = hi->ret_vreg;
    return 0;
}

/* Wide memory-accumulator compare (IR_ACC_CMP): same push/load dance as
   the binop, but the helper (dlt/dleq/…) returns an int 0/1 bool in HL,
   stored to the width-2 int dst (no accumulator store). */
static int gen_acc_cmp(FILE *out, Func *f, const Op *op)
{
    HelperInfo *hi = op->hcall;
    if (!hi || !hi->name || hi->n_args != 2 || hi->ret_vreg < 0) {
        fputs("ir_lower: IR_ACC_CMP malformed\n", stderr);
        return -1;
    }
    int w = hi->acc_width;
    int acc_pos = acc_push_one_operand(out, f, hi);
    L.cur_sp_adjust += w;
    emit_acc_operand_addr(out, f, hi, acc_pos);
    emit(out, "call\t%s", hi->acc_load);
    emit(out, "call\t%s", hi->name);
    L.cur_sp_adjust -= w;
    /* The bool (0/1) is in HL. Commit word-result way: spill to the slot only
       if live-read (dead → skipped), advertise HL = result so a following
       consumer takes it from HL not a slot reload. */
    invalidate_hl_bc();
    commit_hl_word(out, f, hi->ret_vreg);
    return 0;
}

/* Store the working accumulator to dst's slot and record it resident.
   The i64 store wants the slot address in BC (acc_store_bc); the float
   store wants it in HL — emit_acc_slot_addr leaves it in HL either way. */
static void store_acc_to_slot(FILE *out, const Func *f, int dst, const HelperInfo *hi)
{
    emit_acc_slot_addr(out, f, dst, 0);
    if (hi->acc_store_bc) { emit(out, "ld\tb,h"); emit(out, "ld\tc,l"); }
    emit(out, "call\t%s", hi->acc_store);
    invalidate_hl_bc();
    *wide_acc_cell(f, dst) = dst;
}

/* Wide memory-accumulator unary op (IR_ACC_UNOP): int→acc conversion,
   acc→int conversion, or acc→acc move. Reuses the FA-residency cache so
   a value already in the accumulator isn't reloaded. */
static int gen_acc_unop(FILE *out, Func *f, const Op *op)
{
    HelperInfo *hi = op->hcall;
    if (!hi || !hi->name || hi->ret_vreg < 0 || hi->n_args != 1) {
        fputs("ir_lower: IR_ACC_UNOP malformed\n", stderr);
        return -1;
    }
    int src = hi->args[0], dst = hi->ret_vreg;
    if (hi->acc_subkind == ACC_SUB_INT2ACC) {
        /* int → acc: load the int into HL/DEHL, convert (result in the
           accumulator), store the accumulator to the dst slot. */
        if (f->vregs[src].width == 4) load_to_dehl(out, f, src);
        else                          load_to_hl(out, f, src);
        emit(out, "call\t%s", hi->name);
        store_acc_to_slot(out, f, dst, hi);
        return 0;
    }
    if (hi->acc_subkind == ACC_SUB_ACC2INT) {
        /* acc → int: load the accumulator (unless already resident),
           convert (result in HL/DEHL), store to the int dst. */
        if (*wide_acc_cell(f, src) != src) {
            emit_acc_slot_addr(out, f, src, 0);
            emit(out, "call\t%s", hi->acc_load);
        }
        emit(out, "call\t%s", hi->name);
        invalidate_hl_bc();
        if (f->vregs[dst].width == 4) store_dehl_finalize(out, f, dst);
        else                         store_hl(out, f, dst);
        return 0;
    }
    if (hi->acc_subkind == ACC_SUB_CROSS) {
        /* Cross-family conversion (long long <-> 5/6/8-byte double): load src
           via the SRC family's load, call the conversion (reads one
           accumulator, writes the other — __i64_acc / FA), store from the DST
           accumulator via the DST family's store. The two accumulators are
           distinct memory areas, so no FA-residency shortcut on the source. */
        emit_acc_slot_addr(out, f, src, 0);
        emit(out, "call\t%s", hi->acc_load);
        emit(out, "call\t%s", hi->name);
        store_acc_to_slot(out, f, dst, hi);
        return 0;
    }
    if (hi->acc_subkind == ACC_SUB_ACC_UNARY) {
        /* acc → acc in-place unary (float negate / l_i64_neg): load the acc
           (unless already resident), call the in-place helper, store back. */
        if (*wide_acc_cell(f, src) != src) {
            emit_acc_slot_addr(out, f, src, 0);
            emit(out, "call\t%s", hi->acc_load);
        }
        emit(out, "call\t%s", hi->name);
        store_acc_to_slot(out, f, dst, hi);
        return 0;
    }
    /* acc → acc move */
    if (*wide_acc_cell(f, src) != src) {
        emit_acc_slot_addr(out, f, src, 0);
        emit(out, "call\t%s", hi->acc_load);
    }
    store_acc_to_slot(out, f, dst, hi);
    return 0;
}

/* True if args[idx]'s vreg is loaded again by a later operand — then its
   DEHL cache (BC=low) may be recovered via a cache-hit `ld hl,bc`, so the
   BC-stash must be kept. Otherwise the stash is dead (the call clobbers BC
   before any re-read). */
static int hcall_vreg_used_after(const HelperInfo *hi, int idx)
{
    int v = hi->args[idx];
    if (v < 0) return 0;
    for (int k = idx + 1; k < hi->n_args; k++)
        if (hi->args[k] == v) return 1;
    return 0;
}

static int gen_hcall(FILE *out, Func *f, const Op *op)
{
    HelperInfo *hi = op->hcall;
    if (!hi || !hi->name) {
        fputs("ir_lower: IR_HCALL missing HelperInfo\n", stderr);
        return -1;
    }
    int n_stacked = hi->n_stacked;
    int n_regs    = hi->n_args - n_stacked;
    if (n_regs > 2 || n_regs < 0) {
        fprintf(stderr,
            "ir_lower: IR_HCALL %s with %d register args (max 2)\n",
            hi->name, n_regs);
        return -1;
    }
    /* z80 helper convention: stacked args[0..n_stacked-1] pushed before the
       call (4 bytes via DEHL for long, else 2 via HL); the helper pops them.
       Register args go in HL (width ≤ 2) or DEHL (width 4); two int args →
       args[n_stacked] in HL, args[n_stacked+1] in DE. Return in HL (default),
       DE (ret_in_de), or DEHL (width 4). Helpers clobber BC, so PR_BC vregs
       must be saved. */
    int hc_bc_saved = 0;
    for (int i = 0; i < f->n_vregs; i++) {
        if (f->vreg_to_phys[i] == IR_PR_BC
            && !(f->vregs[i].flags & IR_VREG_BC_PACK)) { hc_bc_saved = 1; break; }
    }
    if (hc_bc_saved) {
        emit(out, "push\tbc");
        L.cur_sp_adjust += 2;
    }
    int popped_bytes = 0;
    for (int i = 0; i < n_stacked; i++) {
        int v = hi->args[i];
        int w = (v >= 0) ? f->vregs[v].width : 2;
        /* Lever A: this stacked arg was already pushed to the data stack at its
           production (cur_dehl_inline_push). Its image [low][high] is exactly a
           normal stacked arg and sits topmost (lookahead barred any
           intervening push, and !hc_bc_saved). Skip the reload+push; the
           helper still pops it (popped_bytes). */
        if (w == 4 && v >= 0 && v == L.la.cur_dehl_inline_push && !hc_bc_saved
            && L.cur_sp_adjust == L.la.cur_dehl_inline_push_base_sp) {
            L.la.cur_dehl_inline_push = -1;
            popped_bytes += 4;
            continue;
        }
        if (w == 4) {
            /* The helper clobbers BC, so this operand's DEHL BC=low stash is
               dead unless the same vreg is re-loaded as a later operand.
               (frameix: drops the trailing `ld bc,hl`; sp-mode byte-walk is
               unaffected — its BC=low is inherent.) */
            L.la.cur_load_to_dehl_no_bc = !hcall_vreg_used_after(hi, i);
            load_to_dehl(out, f, v);
            emit(out, "push\tde");
            emit(out, "push\thl");
            L.cur_sp_adjust += 4;
            popped_bytes += 4;
        } else {
            load_to_hl(out, f, v);
            emit(out, "push\thl");
            L.cur_sp_adjust += 2;
            popped_bytes += 2;
        }
    }
    /* Register args. load_to_de may clobber HL, load_to_hl preserves
       DE, so DE first. A single width-4 register arg goes in DEHL. */
    if (n_regs == 2) load_to_de(out, f, hi->args[n_stacked + 1]);
    if (n_regs >= 1) {
        int v = hi->args[n_stacked];
        int w = (v >= 0) ? f->vregs[v].width : 2;
        if (w == 4) {
            /* Last operand loaded before the call → its BC=low stash is
               always dead (nothing re-reads it; the call clobbers BC). */
            L.la.cur_load_to_dehl_no_bc = 1;
            load_to_dehl(out, f, v);
        } else {
            load_to_hl(out, f, v);
        }
    }
    emit(out, "call\t%s", hi->name);
    L.cur_sp_adjust -= popped_bytes;
    if (hc_bc_saved) {
        emit(out, "pop\tbc");
        L.cur_sp_adjust -= 2;
    }
    invalidate_hl_cache();
    if (!hc_bc_saved)
        invalidate_bc_cache();
    if (hi->ret_in_de) {
        emit(out, "ex\tde,hl");
        invalidate_de_cache();
    }
    if (hi->ret_vreg >= 0) {
        if (f->vregs[hi->ret_vreg].width == 4)
            store_dehl_finalize(out, f, hi->ret_vreg);
        else
            store_hl(out, f, hi->ret_vreg);
    }
    return 0;
}

/* The lp_* far-access helper for an element kind + width + sign.
   load=1 → lp_g*, load=0 → lp_p*. Dispatch by width with the
   char/cptr/wide-double/longlong special-cases — mirrors
   ir_build.c:far_helper. */
static const char *far_helper_name(Kind elem, int width, int is_unsigned, int load)
{
    if (elem == KIND_CHAR)
        return load ? (is_unsigned ? "lp_guchar" : "lp_gchar") : "lp_pchar";
    if (elem == KIND_CPTR)
        return load ? "lp_gptr" : "lp_pptr";
    if (elem == KIND_LONGLONG)
        return load ? "lp_glonglong" : "lp_i64_load";
    if ((elem == KIND_DOUBLE || elem == KIND_FLOAT) && width >= 5)
        return load ? "lp_gdoub" : "lp_pdoub";
    if (width == 1)
        return load ? (is_unsigned ? "lp_guchar" : "lp_gchar") : "lp_pchar";
    if (width == 2)
        return load ? "lp_gint" : "lp_pint";
    if (width == 4)
        return load ? "lp_glong" : "lp_plong";
    return NULL;
}

/* IR_LD_FAR: dst ← *src[0], src[0] a __far pointer (KIND_CPTR) in DEHL (D=0,
   E=bank, HL=offset). Routes through an lp_g* helper that pages the bank
   in/out. A far helper is a CALL: clobbers AF/BC/DE + the alt register set, so
   a PR_BC tenant is saved and HL/BC/A/bank caches invalidated afterwards.
   Result in HL (char/int → width-2 promoted) or DEHL (long/cptr). */
static int gen_ld_far(FILE *out, Func *f, const Op *op)
{
    int dst_w = (op->dst >= 0) ? f->vregs[op->dst].width : 2;
    const char *h = far_helper_name((int)op->mem.elem, dst_w, (int)op->imm, 1);
    if (!h) {
        fprintf(stderr, "ir_lower: IR_LD_FAR element kind %d width %d "
                "unsupported\n", (int)op->mem.elem, dst_w);
        return -1;
    }
    int bc_saved = func_has_pr_bc(f);
    if (bc_saved) { emit(out, "push\tbc"); L.cur_sp_adjust += 2; }
    /* Materialize the far pointer into DEHL = EHL far address (D=0). */
    load_to_dehl(out, f, op->src[0]);
    emit(out, "call\t%s", h);
    if (bc_saved) { emit(out, "pop\tbc"); L.cur_sp_adjust -= 2; }
    invalidate_hl_cache();
    if (!bc_saved) invalidate_bc_cache();
    invalidate_de_cache();
    invalidate_a_cache();
    cur_bank_fn = NULL;   /* the helper paged a bank; re-page on next access */
    if (op->dst >= 0) {
        if (dst_w > 4) {
            /* Wide: lp_gdoub left the value in FA, lp_glonglong in
               __i64_acc — store the accumulator to the dst slot, exactly
               like gen_ld_mem's wide path. */
            emit_acc_slot_addr(out, f, op->dst, 0);
            emit_acc_store_hl(out, f, op->dst);
            invalidate_hl_bc();
            *wide_acc_cell(f, op->dst) = op->dst;
        } else if (dst_w == 4)
            store_dehl_finalize(out, f, op->dst);   /* lp_glong/lp_gptr → DEHL */
        else
            store_hl(out, f, op->dst);              /* lp_g{char,uchar,int} → HL */
    }
    return 0;
}

/* IR_ST_FAR: *src[0] ← src[1], src[0] a __far pointer (KIND_CPTR / DEHL),
   src[1] the value. Store helpers (lp_p*) take the address in the ALT set
   (E'H'L') and the value in the PRIMARY set (HL, or DEHL for wide). The IR has
   no model of the alt register file, so the address is moved into it via an
   opaque `exx; pop hl; pop de; exx` over a stack push.

   The ADDRESS is materialized and pushed FIRST: it's typically a
   freshly-computed DEHL value (an IR_ADD result, possibly DEHL-resident with
   no frame slot), so pushing it before the value's load_to_* clobbers DEHL
   keeps it recoverable. The value is then materialized into the primary set,
   and the exx-pop loads the address into the alt set without disturbing it.
   A far helper is a CALL — full clobber. */
static int gen_st_far(FILE *out, Func *f, const Op *op)
{
    int val   = op->src[1];
    int val_w = (val >= 0) ? f->vregs[val].width : 2;
    const char *h = far_helper_name((int)op->mem.elem, val_w, 0, 0);
    if (!h) {
        fprintf(stderr, "ir_lower: IR_ST_FAR element kind %d width %d "
                "unsupported\n", (int)op->mem.elem, val_w);
        return -1;
    }
    int bc_saved = func_has_pr_bc(f);
    if (bc_saved) { emit(out, "push\tbc"); L.cur_sp_adjust += 2; }
    /* 1. Address → primary DEHL, then onto the stack. */
    load_to_dehl(out, f, op->src[0]);
    emit(out, "push\tde");
    emit(out, "push\thl");
    L.cur_sp_adjust += 4;
    /* 2. Value into its delivery register(s): a wide (5/6/8B double / long
          long) value into the accumulator (lp_pdoub takes FA, lp_i64_load
          takes __i64_acc) via the maths load primitive; a narrow value into
          the primary set (DEHL for 4B, HL/L otherwise). The address is safe on
          the stack; this may clobber DEHL/BC. */
    if (val_w > 4) {
        if (*wide_acc_cell(f, val) != val) {
            emit_acc_slot_addr(out, f, val, 0);
            emit(out, "call\t%s", acc_prim(f, val, "load"));
        }
    } else if (val_w == 4) {
        load_to_dehl(out, f, val);
    } else {
        load_to_hl(out, f, val);
    }
    /* 3. Move the address into the alt set (E'H'L') via the exx-pop, leaving
          the value untouched in the primary set (the accumulator survives —
          the pops only touch alt HL/DE). */
    emit(out, "exx");
    emit(out, "pop\thl");          /* alt HL = offset */
    emit(out, "pop\tde");          /* alt DE = (D=0,E=bank) → E'H'L' = addr */
    L.cur_sp_adjust -= 4;
    emit(out, "exx");
    emit(out, "call\t%s", h);
    if (bc_saved) { emit(out, "pop\tbc"); L.cur_sp_adjust -= 2; }
    invalidate_hl_cache();
    if (!bc_saved) invalidate_bc_cache();
    invalidate_de_cache();
    invalidate_a_cache();
    if (val_w > 4) *wide_acc_cell(f, val) = -1;   /* helper clobbered the accumulator */
    cur_bank_fn = NULL;
    return 0;
}

/* IR_LD_FARSYM: dst (KIND_CPTR) ← the far address of a banked (FARACC)
   symbol. The symbol's link-time address encodes the bank in its high
   half; l_far_mapaddr turns the (bank, offset) pair into a logical far
   pointer (EHL, D=0). A CALL — full clobber. (A near symbol cast to far
   reaches the far world via IR_LD_SYM + the near→far widen cast, not
   here.) */
static int gen_ld_farsym(FILE *out, Func *f, const Op *op)
{
    const char *nm = ir_sym_name(op->mem.sym);
    int bc_saved = func_has_pr_bc(f);
    if (bc_saved) { emit(out, "push\tbc"); L.cur_sp_adjust += 2; }
    emit(out, "ld\thl,+(_%s %% 65536)", nm);
    emit(out, "ld\tde,+(_%s / 65536)", nm);
    emit(out, "call\tl_far_mapaddr");
    if (bc_saved) { emit(out, "pop\tbc"); L.cur_sp_adjust -= 2; }
    invalidate_hl_cache();
    if (!bc_saved) invalidate_bc_cache();
    invalidate_de_cache();
    invalidate_a_cache();
    cur_bank_fn = NULL;
    if (op->dst >= 0)
        store_dehl_finalize(out, f, op->dst);   /* EHL far ptr → DEHL */
    return 0;
}

/* gbz80/808x signed long (32-bit) compare: they lack P/V, so the inline
   `jp po; xor 0x80` S^V correction is illegal. Instead flip bit 31 of BOTH
   operands (the unsigned borrow of minu^0x80000000 vs subtr^0x80000000 then
   equals signed minu<subtr). The `xor 0x80` flips run on D BEFORE any subtract
   — an xor mid-chain would clear the borrow CF. After: CF = (minu < subtr
   signed). Clobbers A/BC/DE/HL. Mirrors load_binop_operands staging, sp_adj=4. */
static void emit_long_signflip_sub(FILE *out, Func *f, int minu, int subtr)
{
    load_to_dehl(out, f, subtr);
    emit(out, "ld\ta,d"); emit(out, "xor\t0x80"); emit(out, "ld\td,a");
    emit(out, "push\tde"); emit(out, "push\thl");
    load_to_dehl_adj(out, f, minu, 4);
    emit(out, "ld\ta,d"); emit(out, "xor\t0x80"); emit(out, "ld\td,a");
    emit(out, "pop\tbc");                 /* BC = subtr low */
    emit(out, "ld\ta,l"); emit(out, "sub\tc");
    emit(out, "ld\ta,h"); emit(out, "sbc\ta,b");
    emit(out, "pop\tbc");                 /* BC = subtr high */
    emit(out, "ld\ta,e"); emit(out, "sbc\ta,c");
    emit(out, "ld\ta,d"); emit(out, "sbc\ta,b");
}

