# long_ir is the 80cc regression suite — the tests encode 80cc's IR and
# lowering behaviour, and sccz80 is not expected to pass them. Claim the
# default before make.config's `COMPILER ?= sccz80`, so a bare `make` here
# tests the compiler these tests are about. An explicit COMPILER= on the
# command line still wins.
COMPILER ?= 80cc

include ../make.config

# $(SOURCES) is the framework (test.c) from make.config. Each suite .c
# has its own main(), so build one binary per suite rather than globbing
# every *.c into a single binary (two mains would collide; long_ir.c is
# also already at the MSX 64K ceiling).
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED -lmath48 -lmath16

# fnptr-dispatch thunks (l_jpix/l_jpiy), linked explicitly until they live in
# the lib — needed by fastcall AND __sdcccall(1) function-pointer calls.
JPTH = ../../../libsrc/l/sccz80/9-common/l_jpix.asm ../../../libsrc/l/sccz80/9-common/l_jpiy.asm

all:	test.bin test_gbz80.bin test_8080.bin test_8085.bin irgaps.bin irgaps_gbz80.bin irgaps_8080.bin irgaps_8085.bin structval.bin structval_gbz80.bin structval_8080.bin structval_8085.bin fixed.bin sdcccall.bin sdcccall_kc160.bin wr.bin wr_fp.bin fp_promote.bin fp_promote_reg.bin fp_promote_f48f16.bin fp_promote_accum.bin aggregate_init.bin fnptr_fastcall.bin fnptr_fastcall_noidx.bin fnptr_fastcall_gbz80.bin fnptr_fastcall_8080.bin fnptr_fastcall_8085.bin faslot.bin libcall_abi.bin const_mult.bin cmp_gt.bin cmp_sign.bin remat.bin idxcmp.bin idxcmp_fp.bin ixdcmp.bin ixdcmp_fp.bin dehome.bin dehome_fp.bin looppr.bin looppr_fp.bin redwb.bin redwb_fp.bin redwb_8080.bin addrcse.bin addrcse_fp.bin idxhome.bin idxhome_fp.bin longlong.bin bitfield.bin umaxd.bin ternwiden.bin ternwiden_fp.bin fp_to_int.bin fp_to_int_reg.bin linewrap.bin widen.bin hwmul.bin hwmul_z180.bin hwmul_ez80.bin hwmul_z80n.bin hwmul_kc160.bin narrowmul.bin narrowmul_fp.bin narrowmul_8080.bin derefcmp.bin derefcmp_fp.bin bytecmp.bin bytecmp_fp.bin bytecmp_8080.bin bytecmp_gbz80.bin bremat.bin bremat_fp.bin bremat_8080.bin bremat_gbz80.bin byteparam.bin byteparam_fp.bin byteparam_8080.bin byteparam_gbz80.bin fcparam.bin fcparam_fp.bin fcparam_8080.bin fcparam_gbz80.bin storecall.bin storecall_fp.bin storecall_8080.bin storecall_gbz80.bin compoundwiden.bin compoundwiden_fp.bin compoundwiden_8080.bin compoundwiden_gbz80.bin ivsr_lftr.bin ivsr_lftr_fp.bin binop_bc.bin binop_bc_fp.bin binop_bc_8080.bin binop_bc_gbz80.bin callsplit.bin callsplit_fp.bin callsplit_8080.bin callsplit_8085.bin callsplit_gbz80.bin jrelax.bin jrelax_fp.bin jrelax_8080.bin jrelax_gbz80.bin retthread.bin retthread_fp.bin retthread_8080.bin retthread_gbz80.bin dsword.bin dsword_fp.bin dsword_8080.bin dsword_gbz80.bin deaddef.bin deaddef_fp.bin deaddef_8080.bin dsub.bin dsub_fp.bin dsub_8085.bin dsub_8080.bin lhlx.bin lhlx_fp.bin lhlx_8085.bin lhlx_8080.bin csparam.bin csparam_fp.bin csparam_8080.bin csparam_gbz80.bin rotl32.bin rotl32_fp.bin rotl32_8080.bin rotl32_gbz80.bin mux.bin mux_fp.bin mux_8080.bin mux_gbz80.bin demorgan.bin demorgan_fp.bin demorgan_8080.bin pack16.bin pack16_fp.bin pack16_8080.bin pack16_gbz80.bin cmphi.bin cmphi_fp.bin cmphi_8080.bin cmphi_gbz80.bin sfr.bin sfr_fp.bin sfr_8080.bin boolbyte.bin boolbyte_fp.bin boolbyte_8080.bin boolbyte_gbz80.bin narrowld.bin narrowld_fp.bin narrowld_8080.bin narrowld_gbz80.bin dsshare.bin dsshare_fp.bin dsshare_8080.bin dsshare_gbz80.bin addridx.bin addridx_fp.bin addridx_8080.bin addridx_8085.bin unionmem.bin unionmem_fp.bin bfcse.bin bfcse_fp.bin widen2.bin widen2_fp.bin addridx_r6k.bin binop_bc_r6k.bin boolbyte_r6k.bin bremat_r6k.bin bytecmp_r6k.bin byteparam_r6k.bin callsplit_r6k.bin cmphi_r6k.bin compoundwiden_r6k.bin csparam_r6k.bin deaddef_r6k.bin demorgan_r6k.bin dsshare_r6k.bin dsword_r6k.bin fcparam_r6k.bin fnptr_fastcall_r6k.bin jrelax_r6k.bin retthread_r6k.bin mux_r6k.bin narrowld_r6k.bin narrowmul_r6k.bin pack16_r6k.bin rotl32_r6k.bin storecall_r6k.bin structval_r6k.bin remat_r6k.bin sfr_r6k.bin addridx_r2ka.bin binop_bc_r2ka.bin boolbyte_r2ka.bin bremat_r2ka.bin bytecmp_r2ka.bin byteparam_r2ka.bin callsplit_r2ka.bin cmphi_r2ka.bin compoundwiden_r2ka.bin csparam_r2ka.bin deaddef_r2ka.bin demorgan_r2ka.bin dsshare_r2ka.bin dsword_r2ka.bin fcparam_r2ka.bin fnptr_fastcall_r2ka.bin jrelax_r2ka.bin retthread_r2ka.bin mux_r2ka.bin narrowld_r2ka.bin narrowmul_r2ka.bin pack16_r2ka.bin rotl32_r2ka.bin storecall_r2ka.bin structval_r2ka.bin remat_r2ka.bin sfr_r2ka.bin addridx_r4k.bin binop_bc_r4k.bin boolbyte_r4k.bin bremat_r4k.bin bytecmp_r4k.bin byteparam_r4k.bin callsplit_r4k.bin cmphi_r4k.bin compoundwiden_r4k.bin csparam_r4k.bin deaddef_r4k.bin demorgan_r4k.bin dsshare_r4k.bin dsword_r4k.bin fcparam_r4k.bin fnptr_fastcall_r4k.bin jrelax_r4k.bin retthread_r4k.bin mux_r4k.bin narrowld_r4k.bin narrowmul_r4k.bin pack16_r4k.bin rotl32_r4k.bin storecall_r4k.bin structval_r4k.bin remat_r4k.bin sfr_r4k.bin

test.bin: $(SOURCES) long_ir.c
	$(compile)
	$(runtest)

# Non-z80 IR coverage. gbz80/8080/8085 have no 64-bit and no math16 maths
# (the suite gates those tests off via __GBZ80/__8080/__8085), and use the
# 32-bit MBF library for `double` (--math-mbf32). ticks runs them with the
# CPU flag and no -b (their crt0 sets the origin).
test_gbz80.bin: $(SOURCES) long_ir.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

test_8080.bin: $(SOURCES) long_ir.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

test_8085.bin: $(SOURCES) long_ir.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Statements wrapped after their first token — a lexer/line-buffer
# regression, CPU-independent, so plain z80 is enough.
linewrap.bin: $(SOURCES) linewrap.c
	$(compile)
	$(runtest)

# IR coverage-gap regressions — own binary (long_ir.c is at the MSX 64K
# ceiling). Same CPU matrix as long_ir: z80 (math48) + gbz80/8080/8085 (mbf32).
irgaps.bin: $(SOURCES) irgaps.c
	$(compile)
	$(runtest)

irgaps_gbz80.bin: $(SOURCES) irgaps.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

irgaps_8080.bin: $(SOURCES) irgaps.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

irgaps_8085.bin: $(SOURCES) irgaps.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# struct/union by-value params — z80 (math48) + gbz80/8080/8085 (mbf32). The
# non-z80 variants exercise the no-`ldir` struct block-copy (__z80asm__ldir).
structval.bin: $(SOURCES) structval.c
	$(compile)
	$(runtest)

structval_gbz80.bin: $(SOURCES) structval.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

structval_8080.bin: $(SOURCES) structval.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

structval_8085.bin: $(SOURCES) structval.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# _Accum fixed-point codegen — z80 only (math48 + the l_fix16_* helpers).
fixed.bin: $(SOURCES) fixed.c
	$(compile)
	$(runtest)

# __sdcccall(1) calling convention — z80 (z180/z80n share the ABI), and
# kc160 (no SDCC port; zsdcc builds kc160 in z80 mode, so same ABI).
sdcccall.bin: $(SOURCES) sdcccall.c $(JPTH)
	$(compile)
	$(runtest)

sdcccall_kc160.bin: $(SOURCES) sdcccall.c $(JPTH)
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=kc160 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mkc160 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

umaxd.bin: $(SOURCES) umaxd.c
	$(compile)
	$(runtest)

ternwiden.bin: $(SOURCES) ternwiden.c
	$(compile)
	$(runtest)

ternwiden_fp.bin: $(SOURCES) ternwiden.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

fp_to_int.bin: $(SOURCES) fp_to_int.c
	$(compile)
	$(runtest)

# Hardware multiply (IR_MUL) — built for every CPU with an inline multiply
# path plus the default z80 (l_mult fallback); values are CPU-agnostic.
hwmul.bin: $(SOURCES) hwmul.c
	$(compile)
	$(runtest)

hwmul_z180.bin: $(SOURCES) hwmul.c
	$(compile_z180)
	$(runtest_z180)

hwmul_ez80.bin: $(SOURCES) hwmul.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

hwmul_z80n.bin: $(SOURCES) hwmul.c
	$(compile_z80n)
	$(runtest_z80n)

hwmul_kc160.bin: $(SOURCES) hwmul.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=kc160 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mkc160 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

narrowmul.bin: $(SOURCES) narrowmul.c
	$(compile)
	$(runtest)

narrowmul_fp.bin: $(SOURCES) narrowmul.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

narrowmul_8080.bin: $(SOURCES) narrowmul.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

widen.bin: $(SOURCES) widen.c
	$(compile)
	$(runtest)

derefcmp.bin: $(SOURCES) derefcmp.c
	$(compile)
	$(runtest)

derefcmp_fp.bin: $(SOURCES) derefcmp.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

bytecmp.bin: $(SOURCES) bytecmp.c
	$(compile)
	$(runtest)

bytecmp_fp.bin: $(SOURCES) bytecmp.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

bytecmp_8080.bin: $(SOURCES) bytecmp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecmp_gbz80.bin: $(SOURCES) bytecmp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bremat.bin: $(SOURCES) bremat.c
	$(compile)
	$(runtest)

bremat_fp.bin: $(SOURCES) bremat.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

bremat_8080.bin: $(SOURCES) bremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bremat_gbz80.bin: $(SOURCES) bremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteparam.bin: $(SOURCES) byteparam.c
	$(compile)
	$(runtest)

byteparam_fp.bin: $(SOURCES) byteparam.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

byteparam_8080.bin: $(SOURCES) byteparam.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteparam_gbz80.bin: $(SOURCES) byteparam.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

fcparam.bin: $(SOURCES) fcparam.c
	$(compile)
	$(runtest)

fcparam_fp.bin: $(SOURCES) fcparam.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

fcparam_8080.bin: $(SOURCES) fcparam.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

fcparam_gbz80.bin: $(SOURCES) fcparam.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

storecall.bin: $(SOURCES) storecall.c
	$(compile)
	$(runtest)

storecall_fp.bin: $(SOURCES) storecall.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

storecall_8080.bin: $(SOURCES) storecall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

storecall_gbz80.bin: $(SOURCES) storecall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

compoundwiden.bin: $(SOURCES) compoundwiden.c
	$(compile)
	$(runtest)

compoundwiden_fp.bin: $(SOURCES) compoundwiden.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

compoundwiden_8080.bin: $(SOURCES) compoundwiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

compoundwiden_gbz80.bin: $(SOURCES) compoundwiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bitfield.bin: $(SOURCES) bitfield.c
	$(compile)
	$(runtest)

cmp_gt.bin: $(SOURCES) cmp_gt.c
	$(compile)
	$(runtest)

cmp_sign.bin: $(SOURCES) cmp_sign.c
	$(compile)
	$(runtest)

remat.bin: $(SOURCES) remat.c
	$(compile)
	$(runtest)

idxcmp.bin: $(SOURCES) idxcmp.c
	$(compile)
	$(runtest)

# Byte-wise (ix+d) int compare fold. sp build (fold fp-gated → inert) validates
# the ordinary compare path; ixdcmp_fp below exercises the fold itself.
ixdcmp.bin: $(SOURCES) ixdcmp.c
	$(compile)
	$(runtest)

# fp-mode: params are (ix+d) slots, so every relation folds byte-wise in place.
ixdcmp_fp.bin: $(SOURCES) ixdcmp.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

# General DE-home co-design. sp build: feature inert (fp-only) → validates the
# ordinary path. fp build (-Cc-fframe-pointer): the inlined binary searches home lo/hi
# in DE across the loop — exercises the compare fold, add hl,de, indexed deref,
# and ex-de-hl home-def.
dehome.bin: $(SOURCES) dehome.c
	$(compile)
	$(runtest)

dehome_fp.bin: $(SOURCES) dehome.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

# Loop register allocator Phase A: two walking pointers homed BC+DE across a
# loop (strcmp/strcpy), the `stpp` post-step-store fusion and gp (de) deref.
# Both sp (default) and fp builds exercise it; the assert is width-independent.
looppr.bin: $(SOURCES) looppr.c
	$(compile)
	$(runtest)

looppr_fp.bin: $(SOURCES) looppr.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

# Reduction write-back DE-home (in-place `a[i]=f(sum)`; fp-only feature,
# --opt-disable=declean opts out): plain / masked / OR / XOR / struct-field write-backs
# that keep the running sum in DE across the store. fp build exercises the
# feature; sp build validates the inert (ordinary) path. Host-verified checksum.
redwb.bin: $(SOURCES) redwb.c
	$(call compile,-DREDWB_CHK=34070u)
	$(runtest)

redwb_fp.bin: $(SOURCES) redwb.c
	$(call compile,-Cc-fframe-pointer -DREDWB_CHK=34070u)
	$(runtest)

redwb_8080.bin: $(SOURCES) redwb.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -DREDWB_CHK=34070u -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addrcse.bin: $(SOURCES) addrcse.c
	$(call compile,-DADDRCSE_CHK=32076u)
	$(runtest)

addrcse_fp.bin: $(SOURCES) addrcse.c
	$(call compile,-Cc-fframe-pointer -DADDRCSE_CHK=32076u)
	$(runtest)

ivsr_lftr.bin: $(SOURCES) ivsr_lftr.c
	$(compile)
	$(runtest)

ivsr_lftr_fp.bin: $(SOURCES) ivsr_lftr.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

# add hl,bc / sbc hl,bc with a BC-resident operand — z80 sp+fp plus 8080/gbz80
# (which emulate sbc hl,de, so exercise the byte-wise C/B subtract path).
binop_bc.bin: $(SOURCES) binop_bc.c
	$(compile)
	$(runtest)

binop_bc_fp.bin: $(SOURCES) binop_bc.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

binop_bc_8080.bin: $(SOURCES) binop_bc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

binop_bc_gbz80.bin: $(SOURCES) binop_bc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Call-bounded live-range splitting (IR_CALLSPLIT): a spilled reused word value
# BC-resident in a call-free >=3-read span, slotted across the calls it crosses.
# z80 sp+fp plus 8080/gbz80 (byte-wise `ld bc,hl` + slot store).
callsplit.bin: $(SOURCES) callsplit.c
	$(compile)
	$(runtest)

callsplit_fp.bin: $(SOURCES) callsplit.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

callsplit_8080.bin: $(SOURCES) callsplit.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

callsplit_8085.bin: $(SOURCES) callsplit.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

callsplit_gbz80.bin: $(SOURCES) callsplit.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Index-half BYTE HOME (second byte home in IYL/IXL). sp-mode (the default
# compile) has IY free, so this build exercises the index-half home on z80;
# the assert is width-independent so gbz80/8080/8085 validate the slot fallback.
idxhome.bin: $(SOURCES) idxhome.c
	$(compile)
	$(runtest)

# fp-mode: exercises INTERVAL REUSE of the index reg — mix2's `len` param owns IY
# only at entry (end = data+len), then `b` reuses IYL for the loop. The sp build
# above has IY free outright; this one proves the live-interval overlap path.
idxhome_fp.bin: $(SOURCES) idxhome.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

# Same test in FRAME-POINTER mode: the index-half signed compare
# (ld a,iyl; sub (ix+d); ...) is fp-only + index-half-CPU-only, so the sp build
# above exercises only the push iy;pop hl fallback. This binary hits the fp path.
idxcmp_fp.bin: $(SOURCES) idxcmp.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

longlong.bin: $(SOURCES) longlong.c
	$(compile)
	$(runtest)

const_mult.bin: $(SOURCES) const_mult.c
	$(compile)
	$(runtest)

faslot.bin: $(SOURCES) faslot.c
	$(compile)
	$(runtest)

libcall_abi.bin: $(SOURCES) libcall_abi.c
	$(compile)
	$(runtest)

wr.bin: $(SOURCES) word_resident.c
	$(compile)
	$(runtest)

# Same word-residency tests in FRAME-POINTER mode. The word DE-home — and its
# region-exit-flush hoist (the sum stored once at the loop exit, not per iter) —
# is fp-only, so the sp-built wr.bin above never exercises it. This binary does.
wr_fp.bin: $(SOURCES) word_resident.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

fp_promote.bin: $(SOURCES) fp_promote.c
	$(compile)
	$(runtest)

# Register-tier floats (f16 + IEEE-32) need their own math libs + mode, so it
# can't share the default -lmath48 CFLAGS — explicit recipe.
fp_promote_reg.bin: $(SOURCES) fp_promote_reg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fp-mode=ieee --math16 --math32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -b msx $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Implicit register-float->integer conversions — same mode/libs as
# fp_promote_reg (the acc-tier sibling fp_to_int.bin rides the default CFLAGS).
fp_to_int_reg.bin: $(SOURCES) fp_to_int_reg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fp-mode=ieee --math16 --math32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -b msx $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# f48 double + _Float16 (sp mode): links -lmath48 --math16 so cross-tier
# f16<->double conversions (l_f48_f16tof / l_f48_ftof16) resolve at runtime.
fp_promote_f48f16.bin: $(SOURCES) fp_promote_f48f16.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -lmath48 --math16 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -b msx $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# _Accum (fixed-point) needs the Q-format + fix16<->double conversion helpers.
fp_promote_accum.bin: $(SOURCES) fp_promote_accum.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -lmath48 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -b msx $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

clean::
	rm -f *.bin *.map *.asm *.o ../../framework/*.o

aggregate_init.bin: $(SOURCES) aggregate_init.c
	$(compile)
	$(runtest)

fnptr_fastcall.bin: $(SOURCES) fnptr_fastcall.c $(JPTH)
	$(compile)
	$(runtest)

# fc_ret dispatch path (no spare index reg: fnptr pushed, `ret`-dispatched).
# z80 with IR_NO_IDX2 forces it while keeping the i64 (__i64_acc) tests — the
# only place the fc_ret + long-long &__i64_acc early-push is exercised. The
# gbz80/8080/8085 variants (no i64) hit the same path natively and cover the
# long-arg value-return that a `pop af`/`pop de` fnptr shuttle corrupted.
fnptr_fastcall_noidx.bin: $(SOURCES) fnptr_fastcall.c $(JPTH)
	IR_NO_IDX2=1 $(compile)
	$(runtest)

fnptr_fastcall_gbz80.bin: $(SOURCES) fnptr_fastcall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

fnptr_fastcall_8080.bin: $(SOURCES) fnptr_fastcall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

fnptr_fastcall_8085.bin: $(SOURCES) fnptr_fastcall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Branch relaxation (jp -> jr, IR_JR): conditional forms that have a jr, a
# forward span too long to relax (must stay jp — also a build-time canary for
# the size bound), nested loops with an in-loop unconditional jump, and copt's
# #JI inversion window. z80 sp+fp plus 8080 (no jr at all — must be untouched)
# and gbz80 (jr present, different encodings).
jrelax.bin: $(SOURCES) jrelax.c
	$(compile)
	$(runtest)

retthread.bin: $(SOURCES) retthread.c
	$(compile)
	$(runtest)

jrelax_fp.bin: $(SOURCES) jrelax.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

retthread_fp.bin: $(SOURCES) retthread.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

jrelax_8080.bin: $(SOURCES) jrelax.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retthread_8080.bin: $(SOURCES) retthread.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

jrelax_gbz80.bin: $(SOURCES) jrelax.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retthread_gbz80.bin: $(SOURCES) retthread.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Dead WORD spill elision (IR_DEADSTORE width-2 / IR_DSWORD): a dead call-result
# slot store is elided and the value rides HL; the read-back, call-returned-
# pointer store base, and two-live-results cases must keep their slots. z80
# sp+fp, 8080 (has xchg, so in scope) and gbz80 (excluded from the width-2 half
# — pins that the exclusion holds).
dsword.bin: $(SOURCES) dsword.c
	$(compile)
	$(runtest)

dsword_fp.bin: $(SOURCES) dsword.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

dsword_8080.bin: $(SOURCES) dsword.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsword_gbz80.bin: $(SOURCES) dsword.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Per-BB dead-def elimination (--opt-disable=dead-def): the `int r = 0; r += f()`
# delegating shape whose init const-fold strands, plus the mid-block-branch
# hazard (a def, a conditional exit, then a redefinition) that must NOT be
# elided -- the first version of the pass got that wrong and umaxd caught it.
lhlx.bin: $(SOURCES) lhlx.c
	$(compile)
	$(runtest)

lhlx_fp.bin: $(SOURCES) lhlx.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

lhlx_8085.bin: $(SOURCES) lhlx.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lhlx_8080.bin: $(SOURCES) lhlx.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsub.bin: $(SOURCES) dsub.c
	$(compile)
	$(runtest)

dsub_fp.bin: $(SOURCES) dsub.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

dsub_8085.bin: $(SOURCES) dsub.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsub_8080.bin: $(SOURCES) dsub.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

deaddef.bin: $(SOURCES) deaddef.c
	$(compile)
	$(runtest)

deaddef_fp.bin: $(SOURCES) deaddef.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

deaddef_8080.bin: $(SOURCES) deaddef.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Ranged BC home for a reassigned PARAM: the const-multiply chain reads the
# multiplicand 7-8x in one write-free span, so the param earns BC over it. Pins
# the back-edge hazard -- the param is reassigned outside the span and the loop
# uses BC transiently as a deref base, so the belief must NOT survive the back
# edge. z80 sp+fp plus 8080/gbz80.
csparam.bin: $(SOURCES) csparam.c
	$(compile)
	$(runtest)

csparam_fp.bin: $(SOURCES) csparam.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

csparam_8080.bin: $(SOURCES) csparam.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

csparam_gbz80.bin: $(SOURCES) csparam.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# 32-bit ROTATE_LEFT lowering (gen_rotl): byte permute + single-bit rotates.
# The right-hand bit step seeds the carry with bit0 of L (ld a,l / rrca)
# instead of shifting it out and branching it back, so the wrap bit is the
# thing to pin -- every amount 1..31, both directions, three vectors.
# 8080/8085 are excluded from the fusion (no CB shifts) and lower via the
# shift helpers, so they cover the other path.
rotl32.bin: $(SOURCES) rotl32.c
	$(compile)
	$(runtest)

rotl32_fp.bin: $(SOURCES) rotl32.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

rotl32_8080.bin: $(SOURCES) rotl32.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

rotl32_gbz80.bin: $(SOURCES) rotl32.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Bitwise SELECT identity (ir_match "mux"): (x&y)|(~x&z) == z^(x&(y^z)).
# Turns a TREE (two live 32-bit intermediates, parked with push/pop and merged
# through an SP-derived pointer) into a CHAIN (one, carried in the register
# cache). Pins the algebra in both selector-slot orders, the masked-blit
# spelling, width 2, and the two non-firing guards (shared ~x, volatile).
mux.bin: $(SOURCES) mux.c
	$(compile)
	$(runtest)

mux_fp.bin: $(SOURCES) mux.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

mux_8080.bin: $(SOURCES) mux.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

mux_gbz80.bin: $(SOURCES) mux.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# De Morgan in the complement-REMOVING direction: (~x)&(~y) -> ~(x|y) and the
# dual. Two live complements become one chained value and a NOT disappears
# (12 instructions at width 4). Pins both directions (the apply must emit the
# DUAL operator), width 2, and the non-firing shared-temp guard.
demorgan.bin: $(SOURCES) demorgan.c
	$(compile)
	$(runtest)

demorgan_fp.bin: $(SOURCES) demorgan.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

demorgan_8080.bin: $(SOURCES) demorgan.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# 16-bit byte-pack fold (packbytes width-2 arm, both endiannesses). Endianness
# is one test: offset-shift/8 constant is little-endian, offset+shift/8 is big.
# Big-endian needs a byte reversal, which at width 2 IS a rotate by 8, so it
# reuses IR_ROTL -- no new IR op. Pins both spellings at even/odd offsets, that
# width-4 big-endian still computes right via the UNFOLDED path, and volatile.
pack16.bin: $(SOURCES) pack16.c
	$(compile)
	$(runtest)

pack16_fp.bin: $(SOURCES) pack16.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

pack16_8080.bin: $(SOURCES) pack16.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

pack16_gbz80.bin: $(SOURCES) pack16.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Unsigned width-2 bound compare against a constant with a ZERO LOW BYTE:
# `i < K` is exactly `hi(i) < hi(K)`, so the lowerer compares high bytes only
# (ld a,h; cp H) instead of ld hl / ld de / and a / sbc hl,de. Pins the branch
# POLARITY (< is carry, >= is no-carry) and the equality case at K-1/K/K+1, and
# that a non-zero low byte does NOT narrow. Both modes plus 8080 and gbz80.
cmphi.bin: $(SOURCES) cmphi.c
	$(compile)
	$(runtest)

cmphi_fp.bin: $(SOURCES) cmphi.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

cmphi_8080.bin: $(SOURCES) cmphi.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmphi_gbz80.bin: $(SOURCES) cmphi.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

sfr.bin: $(SOURCES) sfr.c
	$(compile)
	$(runtest)

sfr_fp.bin: $(SOURCES) sfr.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

sfr_8080.bin: $(SOURCES) sfr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Byte-width comparison results (narrow_def_kind + commit_flag_bool): a compare
# dst narrows to width 1 and the boolean is built in A, not HL. Pins the exact
# 0/1 per kind and polarity (a wrong skip condition inverts it silently) and
# that the one-byte commit does not overrun a neighbouring slot. z80 sp+fp,
# 8080 (jp-based skip, no jr) and gbz80 (sign-flipped signed compares).
boolbyte.bin: $(SOURCES) boolbyte.c
	$(compile)
	$(runtest)

boolbyte_fp.bin: $(SOURCES) boolbyte.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

boolbyte_8080.bin: $(SOURCES) boolbyte.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

boolbyte_gbz80.bin: $(SOURCES) boolbyte.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Byte-width narrowing of a LOAD (ldmem_narrowable): a load read only as a byte
# reads one byte. Every word here has a nonzero high byte, so reading the wrong
# end shows up as a wrong sum. `walk` pins the post-step exclusion -- `*p++` on
# a word pointer steps by two, and the byte lowering steps by one.
narrowld.bin: $(SOURCES) narrowld.c
	$(compile)
	$(runtest)

narrowld_fp.bin: $(SOURCES) narrowld.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

narrowld_8080.bin: $(SOURCES) narrowld.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

narrowld_gbz80.bin: $(SOURCES) narrowld.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Dead-store elision across a COALESCED slot (IR_DS_SHARE). emu.c's read_reg /
# write_reg reduced to their shape: a pointer local defined in TWO branches and
# read back through a switch. That is the one reader shape the coalesced-read
# veto must keep vetoing -- on the def that rides a register nothing writes the
# slot, so the read is served by the store the elision wanted to drop. Run with
# IR_DS_SHARE=1 to exercise the refinement.
dsshare.bin: $(SOURCES) dsshare.c
	$(compile)
	$(runtest)

dsshare_fp.bin: $(SOURCES) dsshare.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

dsshare_8080.bin: $(SOURCES) dsshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsshare_gbz80.bin: $(SOURCES) dsshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Symbol-address add whose INDEX is still live in DE afterwards (copt #ADDR).
# The rule folds `ex de,hl; ld hl,_sym; add hl,de` -> `ld de,_sym; add hl,de`;
# same address, but the index no longer survives in DE. 8085 is the target that
# builds that shape (LDSI+LHLX leaves the index in DE across the add and
# reclaims it with a later ex de,hl), hence %notcpu 8085 on the rule. Without
# it the 8085 build HANGS. 8080 is the control -- same clib family, unaffected.
widen2.bin: $(SOURCES) widen2.c
	$(compile)
	$(runtest)

widen2_fp.bin: $(SOURCES) widen2.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

bfcse.bin: $(SOURCES) bfcse.c
	$(compile)
	$(runtest)

bfcse_fp.bin: $(SOURCES) bfcse.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

unionmem.bin: $(SOURCES) unionmem.c
	$(compile)
	$(runtest)

unionmem_fp.bin: $(SOURCES) unionmem.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

addridx.bin: $(SOURCES) addridx.c
	$(compile)
	$(runtest)

addridx_fp.bin: $(SOURCES) addridx.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

addridx_8080.bin: $(SOURCES) addridx.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addridx_8085.bin: $(SOURCES) addridx.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }


# Rabbit coverage: the suites that already earn non-z80 variants. Every
# long_ir suite passes on r2ka/r4k/r6k in both modes, so the set is a CI-cost
# choice, not a capability one. The float suites are left out because the
# global CFLAGS here link -lmath48/-lmath16, which resolve to the z80 builds;
# a Rabbit float target needs the suffixed -lmath48_r2ka / -lmath16_r2ka.

addridx_r6k.bin: $(SOURCES) addridx.c
	$(compile_r6k)
	$(runtest_r6k)

binop_bc_r6k.bin: $(SOURCES) binop_bc.c
	$(compile_r6k)
	$(runtest_r6k)

boolbyte_r6k.bin: $(SOURCES) boolbyte.c
	$(compile_r6k)
	$(runtest_r6k)

bremat_r6k.bin: $(SOURCES) bremat.c
	$(compile_r6k)
	$(runtest_r6k)

bytecmp_r6k.bin: $(SOURCES) bytecmp.c
	$(compile_r6k)
	$(runtest_r6k)

byteparam_r6k.bin: $(SOURCES) byteparam.c
	$(compile_r6k)
	$(runtest_r6k)

callsplit_r6k.bin: $(SOURCES) callsplit.c
	$(compile_r6k)
	$(runtest_r6k)

cmphi_r6k.bin: $(SOURCES) cmphi.c
	$(compile_r6k)
	$(runtest_r6k)

compoundwiden_r6k.bin: $(SOURCES) compoundwiden.c
	$(compile_r6k)
	$(runtest_r6k)

csparam_r6k.bin: $(SOURCES) csparam.c
	$(compile_r6k)
	$(runtest_r6k)

deaddef_r6k.bin: $(SOURCES) deaddef.c
	$(compile_r6k)
	$(runtest_r6k)

demorgan_r6k.bin: $(SOURCES) demorgan.c
	$(compile_r6k)
	$(runtest_r6k)

dsshare_r6k.bin: $(SOURCES) dsshare.c
	$(compile_r6k)
	$(runtest_r6k)

dsword_r6k.bin: $(SOURCES) dsword.c
	$(compile_r6k)
	$(runtest_r6k)

fcparam_r6k.bin: $(SOURCES) fcparam.c
	$(compile_r6k)
	$(runtest_r6k)

fnptr_fastcall_r6k.bin: $(SOURCES) fnptr_fastcall.c
	$(compile_r6k)
	$(runtest_r6k)

jrelax_r6k.bin: $(SOURCES) jrelax.c
	$(compile_r6k)
	$(runtest_r6k)

retthread_r6k.bin: $(SOURCES) retthread.c
	$(compile_r6k)
	$(runtest_r6k)

mux_r6k.bin: $(SOURCES) mux.c
	$(compile_r6k)
	$(runtest_r6k)

narrowld_r6k.bin: $(SOURCES) narrowld.c
	$(compile_r6k)
	$(runtest_r6k)

narrowmul_r6k.bin: $(SOURCES) narrowmul.c
	$(compile_r6k)
	$(runtest_r6k)

pack16_r6k.bin: $(SOURCES) pack16.c
	$(compile_r6k)
	$(runtest_r6k)

rotl32_r6k.bin: $(SOURCES) rotl32.c
	$(compile_r6k)
	$(runtest_r6k)

storecall_r6k.bin: $(SOURCES) storecall.c
	$(compile_r6k)
	$(runtest_r6k)

structval_r6k.bin: $(SOURCES) structval.c
	$(compile_r6k)
	$(runtest_r6k)

remat_r6k.bin: $(SOURCES) remat.c
	$(compile_r6k)
	$(runtest_r6k)

sfr_r6k.bin: $(SOURCES) sfr.c
	$(compile_r6k)
	$(runtest_r6k)


# --- Rabbit 2000 ---

addridx_r2ka.bin: $(SOURCES) addridx.c
	$(compile_r2ka)
	$(runtest_r2ka)

binop_bc_r2ka.bin: $(SOURCES) binop_bc.c
	$(compile_r2ka)
	$(runtest_r2ka)

boolbyte_r2ka.bin: $(SOURCES) boolbyte.c
	$(compile_r2ka)
	$(runtest_r2ka)

bremat_r2ka.bin: $(SOURCES) bremat.c
	$(compile_r2ka)
	$(runtest_r2ka)

bytecmp_r2ka.bin: $(SOURCES) bytecmp.c
	$(compile_r2ka)
	$(runtest_r2ka)

byteparam_r2ka.bin: $(SOURCES) byteparam.c
	$(compile_r2ka)
	$(runtest_r2ka)

callsplit_r2ka.bin: $(SOURCES) callsplit.c
	$(compile_r2ka)
	$(runtest_r2ka)

cmphi_r2ka.bin: $(SOURCES) cmphi.c
	$(compile_r2ka)
	$(runtest_r2ka)

compoundwiden_r2ka.bin: $(SOURCES) compoundwiden.c
	$(compile_r2ka)
	$(runtest_r2ka)

csparam_r2ka.bin: $(SOURCES) csparam.c
	$(compile_r2ka)
	$(runtest_r2ka)

deaddef_r2ka.bin: $(SOURCES) deaddef.c
	$(compile_r2ka)
	$(runtest_r2ka)

demorgan_r2ka.bin: $(SOURCES) demorgan.c
	$(compile_r2ka)
	$(runtest_r2ka)

dsshare_r2ka.bin: $(SOURCES) dsshare.c
	$(compile_r2ka)
	$(runtest_r2ka)

dsword_r2ka.bin: $(SOURCES) dsword.c
	$(compile_r2ka)
	$(runtest_r2ka)

fcparam_r2ka.bin: $(SOURCES) fcparam.c
	$(compile_r2ka)
	$(runtest_r2ka)

fnptr_fastcall_r2ka.bin: $(SOURCES) fnptr_fastcall.c
	$(compile_r2ka)
	$(runtest_r2ka)

jrelax_r2ka.bin: $(SOURCES) jrelax.c
	$(compile_r2ka)
	$(runtest_r2ka)

retthread_r2ka.bin: $(SOURCES) retthread.c
	$(compile_r2ka)
	$(runtest_r2ka)

mux_r2ka.bin: $(SOURCES) mux.c
	$(compile_r2ka)
	$(runtest_r2ka)

narrowld_r2ka.bin: $(SOURCES) narrowld.c
	$(compile_r2ka)
	$(runtest_r2ka)

narrowmul_r2ka.bin: $(SOURCES) narrowmul.c
	$(compile_r2ka)
	$(runtest_r2ka)

pack16_r2ka.bin: $(SOURCES) pack16.c
	$(compile_r2ka)
	$(runtest_r2ka)

rotl32_r2ka.bin: $(SOURCES) rotl32.c
	$(compile_r2ka)
	$(runtest_r2ka)

storecall_r2ka.bin: $(SOURCES) storecall.c
	$(compile_r2ka)
	$(runtest_r2ka)

structval_r2ka.bin: $(SOURCES) structval.c
	$(compile_r2ka)
	$(runtest_r2ka)

remat_r2ka.bin: $(SOURCES) remat.c
	$(compile_r2ka)
	$(runtest_r2ka)

sfr_r2ka.bin: $(SOURCES) sfr.c
	$(compile_r2ka)
	$(runtest_r2ka)

# --- Rabbit 4000 ---

addridx_r4k.bin: $(SOURCES) addridx.c
	$(compile_r4k)
	$(runtest_r4k)

binop_bc_r4k.bin: $(SOURCES) binop_bc.c
	$(compile_r4k)
	$(runtest_r4k)

boolbyte_r4k.bin: $(SOURCES) boolbyte.c
	$(compile_r4k)
	$(runtest_r4k)

bremat_r4k.bin: $(SOURCES) bremat.c
	$(compile_r4k)
	$(runtest_r4k)

bytecmp_r4k.bin: $(SOURCES) bytecmp.c
	$(compile_r4k)
	$(runtest_r4k)

byteparam_r4k.bin: $(SOURCES) byteparam.c
	$(compile_r4k)
	$(runtest_r4k)

callsplit_r4k.bin: $(SOURCES) callsplit.c
	$(compile_r4k)
	$(runtest_r4k)

cmphi_r4k.bin: $(SOURCES) cmphi.c
	$(compile_r4k)
	$(runtest_r4k)

compoundwiden_r4k.bin: $(SOURCES) compoundwiden.c
	$(compile_r4k)
	$(runtest_r4k)

csparam_r4k.bin: $(SOURCES) csparam.c
	$(compile_r4k)
	$(runtest_r4k)

deaddef_r4k.bin: $(SOURCES) deaddef.c
	$(compile_r4k)
	$(runtest_r4k)

demorgan_r4k.bin: $(SOURCES) demorgan.c
	$(compile_r4k)
	$(runtest_r4k)

dsshare_r4k.bin: $(SOURCES) dsshare.c
	$(compile_r4k)
	$(runtest_r4k)

dsword_r4k.bin: $(SOURCES) dsword.c
	$(compile_r4k)
	$(runtest_r4k)

fcparam_r4k.bin: $(SOURCES) fcparam.c
	$(compile_r4k)
	$(runtest_r4k)

fnptr_fastcall_r4k.bin: $(SOURCES) fnptr_fastcall.c
	$(compile_r4k)
	$(runtest_r4k)

jrelax_r4k.bin: $(SOURCES) jrelax.c
	$(compile_r4k)
	$(runtest_r4k)

retthread_r4k.bin: $(SOURCES) retthread.c
	$(compile_r4k)
	$(runtest_r4k)

mux_r4k.bin: $(SOURCES) mux.c
	$(compile_r4k)
	$(runtest_r4k)

narrowld_r4k.bin: $(SOURCES) narrowld.c
	$(compile_r4k)
	$(runtest_r4k)

narrowmul_r4k.bin: $(SOURCES) narrowmul.c
	$(compile_r4k)
	$(runtest_r4k)

pack16_r4k.bin: $(SOURCES) pack16.c
	$(compile_r4k)
	$(runtest_r4k)

rotl32_r4k.bin: $(SOURCES) rotl32.c
	$(compile_r4k)
	$(runtest_r4k)

storecall_r4k.bin: $(SOURCES) storecall.c
	$(compile_r4k)
	$(runtest_r4k)

structval_r4k.bin: $(SOURCES) structval.c
	$(compile_r4k)
	$(runtest_r4k)

remat_r4k.bin: $(SOURCES) remat.c
	$(compile_r4k)
	$(runtest_r4k)

sfr_r4k.bin: $(SOURCES) sfr.c
	$(compile_r4k)
	$(runtest_r4k)
