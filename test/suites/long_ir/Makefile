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
all:	countborrow.bin countborrow_gbz80.bin
all:	localrmw_gbz80.bin localrmw_gbz80_keep.bin
all:	localrmw_z80.bin localrmw_z80n.bin localrmw_z180.bin localrmw_ez80_z80.bin localrmw_8080.bin localrmw_vm1.bin localrmw_r2ka.bin localrmw_r4k.bin localrmw_r6k.bin localrmw_kc160.bin localrmw_z80_keep.bin
all:	homeexitdead_gbz80.bin homeexitdead_gbz80_keep.bin
JPTH = ../../../libsrc/l/sccz80/9-common/l_jpix.asm ../../../libsrc/l/sccz80/9-common/l_jpiy.asm

all:	test.bin test_gbz80.bin test_8080.bin test_8085.bin irgaps.bin irgaps_gbz80.bin irgaps_8080.bin irgaps_8085.bin structval.bin structval_gbz80.bin structval_8080.bin structval_8085.bin fixed.bin sdcccall.bin sdcccall_kc160.bin wr.bin wr_fp.bin fp_promote.bin fp_promote_reg.bin fp_promote_f48f16.bin fp_promote_accum.bin aggregate_init.bin fnptr_fastcall.bin fnptr_fastcall_noidx.bin fnptr_fastcall_gbz80.bin fnptr_fastcall_8080.bin fnptr_fastcall_8085.bin faslot.bin libcall_abi.bin const_mult.bin cmp_gt.bin cmp_sign.bin remat.bin idxcmp.bin idxcmp_fp.bin ixdcmp.bin ixdcmp_fp.bin dehome.bin dehome_fp.bin looppr.bin looppr_fp.bin redwb.bin redwb_fp.bin redwb_8080.bin addrcse.bin addrcse_fp.bin idxhome.bin idxhome_fp.bin longlong.bin bitfield.bin umaxd.bin ternwiden.bin ternwiden_fp.bin fp_to_int.bin fp_to_int_reg.bin linewrap.bin widen.bin hwmul.bin hwmul_z180.bin hwmul_ez80.bin hwmul_z80n.bin hwmul_kc160.bin narrowmul.bin narrowmul_fp.bin narrowmul_8080.bin derefcmp.bin derefcmp_fp.bin bytecmp.bin bytecmp_fp.bin bytecmp_8080.bin bytecmp_gbz80.bin bremat.bin bremat_fp.bin bremat_8080.bin bremat_gbz80.bin fclong.bin fclong_fp.bin fclong_8080.bin fclong_gbz80.bin memberarr.bin memberarr_fp.bin memberarr_8080.bin memberarr_gbz80.bin statscope.bin statscope_fp.bin statscope_8080.bin statscope_gbz80.bin byteparam.bin byteparam_fp.bin byteparam_8080.bin byteparam_gbz80.bin fcparam.bin fcparam_fp.bin fcparam_8080.bin fcparam_gbz80.bin storecall.bin storecall_fp.bin storecall_8080.bin storecall_gbz80.bin compoundwiden.bin compoundwiden_fp.bin compoundwiden_8080.bin compoundwiden_gbz80.bin ivsr_lftr.bin ivsr_lftr_fp.bin binop_bc.bin binop_bc_fp.bin binop_bc_8080.bin binop_bc_gbz80.bin callsplit.bin callsplit_fp.bin callsplit_8080.bin callsplit_8085.bin callsplit_gbz80.bin jrelax.bin jrelax_fp.bin jrelax_8080.bin jrelax_gbz80.bin slotaddr.bin slotaddr_fp.bin slotaddr_8080.bin slotaddr_8085.bin slotaddr_gbz80.bin slotaddr_vm1.bin shrmask.bin shrmask_fp.bin shrmask_8080.bin shrmask_8085.bin shrmask_gbz80.bin idxbase.bin idxbase_fp.bin idxbase_8080.bin idxbase_gbz80.bin idxderef.bin idxderef_fp.bin idxderef_8080.bin idxderef_gbz80.bin idxderef_ez80.bin idxderef_ez80_fp.bin idxderef_z180.bin idxderef_z180_fp.bin idxderef_kc160.bin idxderef_kc160_fp.bin idxderef_r2ka.bin idxderef_r4k.bin tailmerge.bin tailmerge_fp.bin tailmerge_8080.bin tailmerge_gbz80.bin byteshr.bin byteshr_fp.bin byteshr_8080.bin byteshr_8085.bin byteshr_gbz80.bin blayout.bin blayout_fp.bin blayout_8080.bin blayout_gbz80.bin retthread.bin retthread_fp.bin retthread_8080.bin retthread_gbz80.bin dsword.bin dsword_fp.bin dsword_8080.bin dsword_gbz80.bin prepush.bin prepush_fp.bin prepush_8080.bin prepush_gbz80.bin constern.bin constern_fp.bin constern_8080.bin naked.bin naked_fp.bin naked_8080.bin voidhoist.bin voidhoist_fp.bin szstatic.bin szstatic_fp.bin deaddef.bin deaddef_fp.bin deaddef_8080.bin dsub.bin dsub_fp.bin dsub_8085.bin dsub_8080.bin longshl.bin longshl_fp.bin longshl_8085.bin longshl_8080.bin longshl_vm1.bin longshl_gbz80.bin lhlx.bin lhlx_fp.bin lhlx_8085.bin lhlx_8080.bin derefw.bin derefw_fp.bin derefw_8085.bin derefw_8080.bin depark.bin depark_fp.bin depark_8085.bin depark_8085_keep.bin depark_8080.bin ldsiaddr.bin ldsiaddr_fp.bin ldsiaddr_8085.bin ldsiaddr_8085_fp.bin ldsiaddr_8085_keep.bin ldsiaddr_8080.bin ldhiaddr.bin ldhiaddr_fp.bin ldhiaddr_8085.bin ldhiaddr_8085_fp.bin ldhiaddr_8085_keep.bin ldhiaddr_8080.bin znadda.bin znadda_fp.bin znadda_z80n.bin znadda_z80n_fp.bin znadda_z80n_keep.bin znadda_8080.bin incmem.bin incmem_fp.bin incmem_keep.bin incmem_fp_keep.bin incmem_8080.bin incmem_gbz80.bin incmem_8085.bin incmem_r4k.bin leafa.bin leafa_fp.bin leafa_ez80.bin leafa_ez80_fp.bin leafa_ez80_fp_keep.bin leafa_8080.bin cfescape.bin cfescape_fp.bin cfescape_8080.bin cfescape_gbz80.bin cfescape_8085.bin cfescape_r4k.bin cfescape_ez80.bin aliaswr.bin aliaswr_fp.bin aliaswr_8080.bin aliaswr_gbz80.bin aliaswr_8085.bin aliaswr_r4k.bin aliaswr_ez80.bin leaimm.bin leaimm_fp.bin leaimm_8085.bin leaimm_8080.bin csparam.bin csparam_fp.bin csparam_8080.bin csparam_gbz80.bin rotl32.bin rotl32_fp.bin rotl32_8080.bin rotl32_gbz80.bin mux.bin mux_fp.bin mux_8080.bin mux_gbz80.bin demorgan.bin demorgan_fp.bin demorgan_8080.bin pack16.bin pack16_fp.bin pack16_8080.bin pack16_gbz80.bin cmphi.bin cmphi_fp.bin cmphi_8080.bin cmphi_gbz80.bin sfr.bin sfr_fp.bin sfr_8080.bin boolbyte.bin boolbyte_fp.bin boolbyte_8080.bin boolbyte_gbz80.bin narrowld.bin narrowld_fp.bin narrowld_8080.bin narrowld_gbz80.bin dsshare.bin dsshare_fp.bin dsshare_8080.bin dsshare_gbz80.bin addridx.bin addridx_fp.bin addridx_8080.bin addridx_8085.bin unionmem.bin unionmem_fp.bin bfcse.bin bfcse_fp.bin castcse.bin castcse_fp.bin shrnarrow.bin shrnarrow_fp.bin shrnarrow_8080.bin shrnarrow_gbz80.bin copta.bin copta_fp.bin copta_8080.bin copta_gbz80.bin ivacc.bin ivacc_fp.bin ivacc_8080.bin ivacc_gbz80.bin cmpsign.bin cmpsign_fp.bin cmpsign_8080.bin cmpsign_gbz80.bin parremat.bin parremat_fp.bin parremat_8080.bin parremat_gbz80.bin widen2.bin widen2_fp.bin addridx_r6k.bin binop_bc_r6k.bin boolbyte_r6k.bin bremat_r6k.bin fclong_r6k.bin memberarr_r6k.bin statscope_r6k.bin bytecmp_r6k.bin byteparam_r6k.bin callsplit_r6k.bin cmphi_r6k.bin compoundwiden_r6k.bin csparam_r6k.bin deaddef_r6k.bin demorgan_r6k.bin dsshare_r6k.bin dsword_r6k.bin fcparam_r6k.bin fnptr_fastcall_r6k.bin jrelax_r6k.bin retthread_r6k.bin mux_r6k.bin narrowld_r6k.bin narrowmul_r6k.bin pack16_r6k.bin rotl32_r6k.bin storecall_r6k.bin structval_r6k.bin remat_r6k.bin sfr_r6k.bin addridx_r2ka.bin binop_bc_r2ka.bin boolbyte_r2ka.bin bremat_r2ka.bin fclong_r2ka.bin memberarr_r2ka.bin statscope_r2ka.bin bytecmp_r2ka.bin byteparam_r2ka.bin callsplit_r2ka.bin cmphi_r2ka.bin compoundwiden_r2ka.bin csparam_r2ka.bin deaddef_r2ka.bin demorgan_r2ka.bin dsshare_r2ka.bin dsword_r2ka.bin fcparam_r2ka.bin fnptr_fastcall_r2ka.bin jrelax_r2ka.bin retthread_r2ka.bin mux_r2ka.bin narrowld_r2ka.bin narrowmul_r2ka.bin pack16_r2ka.bin rotl32_r2ka.bin storecall_r2ka.bin structval_r2ka.bin remat_r2ka.bin sfr_r2ka.bin addridx_r4k.bin binop_bc_r4k.bin boolbyte_r4k.bin bremat_r4k.bin fclong_r4k.bin memberarr_r4k.bin statscope_r4k.bin bytecmp_r4k.bin byteparam_r4k.bin callsplit_r4k.bin cmphi_r4k.bin compoundwiden_r4k.bin csparam_r4k.bin deaddef_r4k.bin demorgan_r4k.bin dsshare_r4k.bin dsword_r4k.bin fcparam_r4k.bin fnptr_fastcall_r4k.bin jrelax_r4k.bin retthread_r4k.bin mux_r4k.bin narrowld_r4k.bin narrowmul_r4k.bin pack16_r4k.bin rotl32_r4k.bin storecall_r4k.bin structval_r4k.bin remat_r4k.bin sfr_r4k.bin rabmul.bin rabmul_fp.bin rabmul_r2ka.bin rabmul_r4k.bin rabmul_r6k.bin rabmul_8080.bin delive.bin delive_fp.bin delive_8085.bin delive_8085_fp.bin delive_8085_keep.bin delive_z80n.bin delive_8080.bin dewiden.bin dewiden_fp.bin dewiden_keep.bin dewiden_fp_keep.bin dewiden_8080.bin dewiden_gbz80.bin dewiden_r4k.bin regcopyflow.bin regcopyflow_fp.bin regcopyflow_gbz80.bin regcopyflow_gbz80_keep.bin shrdeadl.bin shrdeadl_fp.bin shrdeadl_keep.bin shrdeadl_fp_keep.bin shrdeadl_8080.bin shrtbac.bin shrtbac_fp.bin shrtbac_keep.bin shrtbac_gbz80.bin shrtbac_8080.bin leapro.bin leapro_fp.bin leapro_ez80_fp.bin leapro_ez80_fp_keep.bin leapro_8080.bin

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

countborrow.bin: $(SOURCES) countborrow.c
	$(compile)
	$(runtest)

countborrow_gbz80.bin: $(SOURCES) countborrow.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) $(FPFLAG) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
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
sdcccall.bin: | sdcccall_fp.bin

sdcccall_fp.bin: $(SOURCES) sdcccall.c $(JPTH)
	$(call compile,-Cc-fframe-pointer)
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

homeexitdead_gbz80.bin: $(SOURCES) homeexitdead.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) $(FPFLAG) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

homeexitdead_gbz80_keep.bin: $(SOURCES) homeexitdead.c
	IR_OFF=home-exit-dead zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) $(FPFLAG) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

fclong.bin: $(SOURCES) fclong.c
	$(compile)
	$(runtest)

fclong_fp.bin: $(SOURCES) fclong.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

fclong_8080.bin: $(SOURCES) fclong.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

fclong_gbz80.bin: $(SOURCES) fclong.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

memberarr.bin: $(SOURCES) memberarr.c
	$(compile)
	$(runtest)

memberarr_fp.bin: $(SOURCES) memberarr.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

memberarr_8080.bin: $(SOURCES) memberarr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

memberarr_gbz80.bin: $(SOURCES) memberarr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

statscope.bin: $(SOURCES) statscope.c
	$(compile)
	$(runtest)

statscope_fp.bin: $(SOURCES) statscope.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

statscope_8080.bin: $(SOURCES) statscope.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

statscope_gbz80.bin: $(SOURCES) statscope.c
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

slotaddr.bin: $(SOURCES) slotaddr.c
	$(compile)
	$(runtest)

idxbase.bin: $(SOURCES) idxbase.c
	$(compile)
	$(runtest)

idxbase_fp.bin: $(SOURCES) idxbase.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

idxderef.bin: $(SOURCES) idxderef.c
	$(compile)
	$(runtest)

idxderef_fp.bin: $(SOURCES) idxderef.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

idxderef_ez80.bin: $(SOURCES) idxderef.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

idxderef_ez80_fp.bin: $(SOURCES) idxderef.c
	$(call compile_ez80_z80,-Cc-fframe-pointer)
	$(runtest_ez80_z80)

idxderef_z180.bin: $(SOURCES) idxderef.c
	$(compile_z180)
	$(runtest_z180)

idxderef_z180_fp.bin: $(SOURCES) idxderef.c
	$(call compile_z180,-Cc-fframe-pointer)
	$(runtest_z180)

idxderef_kc160.bin: $(SOURCES) idxderef.c
	$(compile_kc160)
	$(runtest_kc160)

idxderef_kc160_fp.bin: $(SOURCES) idxderef.c
	$(call compile_kc160,-Cc-fframe-pointer)
	$(runtest_kc160)

idxderef_r2ka.bin: $(SOURCES) idxderef.c
	$(compile_r2ka)
	$(runtest_r2ka)

idxderef_r4k.bin: $(SOURCES) idxderef.c
	$(compile_r4k)
	$(runtest_r4k)

shrmask.bin: $(SOURCES) shrmask.c
	$(compile)
	$(runtest)

blayout.bin: $(SOURCES) blayout.c
	$(compile)
	$(runtest)

blayout_fp.bin: $(SOURCES) blayout.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

blayout_8080.bin: $(SOURCES) blayout.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

blayout_gbz80.bin: $(SOURCES) blayout.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteshr.bin: $(SOURCES) byteshr.c
	$(compile)
	$(runtest)

byteshr_fp.bin: $(SOURCES) byteshr.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

byteshr_8080.bin: $(SOURCES) byteshr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteshr_8085.bin: $(SOURCES) byteshr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteshr_gbz80.bin: $(SOURCES) byteshr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

tailmerge.bin: $(SOURCES) tailmerge.c
	$(compile)
	$(runtest)

tailmerge_fp.bin: $(SOURCES) tailmerge.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

tailmerge_8080.bin: $(SOURCES) tailmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

tailmerge_gbz80.bin: $(SOURCES) tailmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retthread.bin: $(SOURCES) retthread.c
	$(compile)
	$(runtest)

jrelax_fp.bin: $(SOURCES) jrelax.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

slotaddr_fp.bin: $(SOURCES) slotaddr.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

shrmask_fp.bin: $(SOURCES) shrmask.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

retthread_fp.bin: $(SOURCES) retthread.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

jrelax_8080.bin: $(SOURCES) jrelax.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotaddr_gbz80.bin: $(SOURCES) slotaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# vm1 deliberately WITHOUT --math-mbf32: that library has never been built for
# vm1 (see longshl_vm1), and this test does not need it. vm1 is the variant that
# catches the slot-address carry bug — the z80 build allocates differently and
# does not form the shape.
slotaddr_vm1.bin: $(SOURCES) slotaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=vm1 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mvm1 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

shrmask_gbz80.bin: $(SOURCES) shrmask.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxbase_gbz80.bin: $(SOURCES) idxbase.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxderef_gbz80.bin: $(SOURCES) idxderef.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotaddr_8085.bin: $(SOURCES) slotaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

shrmask_8085.bin: $(SOURCES) shrmask.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotaddr_8080.bin: $(SOURCES) slotaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

shrmask_8080.bin: $(SOURCES) shrmask.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxbase_8080.bin: $(SOURCES) idxbase.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxderef_8080.bin: $(SOURCES) idxderef.c
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

prepush.bin: $(SOURCES) prepush.c
	$(compile)
	$(runtest)

prepush_fp.bin: $(SOURCES) prepush.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

prepush_8080.bin: $(SOURCES) prepush.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

prepush_gbz80.bin: $(SOURCES) prepush.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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
derefw.bin: $(SOURCES) derefw.c
	$(compile)
	$(runtest)

derefw_fp.bin: $(SOURCES) derefw.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

derefw_8085.bin: $(SOURCES) derefw.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

derefw_8080.bin: $(SOURCES) derefw.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

depark.bin: $(SOURCES) depark.c
	$(compile)
	$(runtest)

depark_fp.bin: $(SOURCES) depark.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

depark_8085.bin: $(SOURCES) depark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

depark_8085_keep.bin: $(SOURCES) depark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -Cc--opt-disable=de-park -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

depark_8080.bin: $(SOURCES) depark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldsiaddr.bin: $(SOURCES) ldsiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldsiaddr_fp.bin: $(SOURCES) ldsiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldsiaddr_8085.bin: $(SOURCES) ldsiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldsiaddr_8085_fp.bin: $(SOURCES) ldsiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldsiaddr_8085_keep.bin: $(SOURCES) ldsiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=ldsi-addr --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldsiaddr_8080.bin: $(SOURCES) ldsiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldhiaddr.bin: $(SOURCES) ldhiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldhiaddr_fp.bin: $(SOURCES) ldhiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldhiaddr_8085.bin: $(SOURCES) ldhiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldhiaddr_8085_fp.bin: $(SOURCES) ldhiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldhiaddr_8085_keep.bin: $(SOURCES) ldhiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=ldhi-addr --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ldhiaddr_8080.bin: $(SOURCES) ldhiaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

znadda.bin: $(SOURCES) znadda.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

znadda_fp.bin: $(SOURCES) znadda.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

znadda_z80n.bin: $(SOURCES) znadda.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

znadda_z80n_fp.bin: $(SOURCES) znadda.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

znadda_z80n_keep.bin: $(SOURCES) znadda.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n -Cc--opt-disable=z80n-add-a --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

znadda_8080.bin: $(SOURCES) znadda.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dewiden.bin: $(SOURCES) dewiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dewiden_fp.bin: $(SOURCES) dewiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dewiden_keep.bin: $(SOURCES) dewiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=de-widen --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dewiden_fp_keep.bin: $(SOURCES) dewiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=de-widen --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dewiden_8080.bin: $(SOURCES) dewiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dewiden_gbz80.bin: $(SOURCES) dewiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dewiden_r4k.bin: $(SOURCES) dewiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

shrtbac.bin: $(SOURCES) shrtbac.c
	$(compile)
	$(runtest)

shrtbac_fp.bin: $(SOURCES) shrtbac.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

shrtbac_keep.bin: $(SOURCES) shrtbac.c
	$(call compile,-Cc--opt-disable=shr-tbac)
	$(runtest)

shrtbac_gbz80.bin: $(SOURCES) shrtbac.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

shrtbac_8080.bin: $(SOURCES) shrtbac.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

shrdeadl.bin: $(SOURCES) shrdeadl.c
	$(compile)
	$(runtest)

shrdeadl_fp.bin: $(SOURCES) shrdeadl.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

shrdeadl_keep.bin: $(SOURCES) shrdeadl.c
	$(call compile,-Cc--opt-disable=shr-dead-l)
	$(runtest)

shrdeadl_fp_keep.bin: $(SOURCES) shrdeadl.c
	$(call compile,-Cc-fframe-pointer -Cc--opt-disable=shr-dead-l)
	$(runtest)

shrdeadl_8080.bin: $(SOURCES) shrdeadl.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

regcopyflow.bin: $(SOURCES) regcopyflow.c
	$(compile)
	$(runtest)

regcopyflow_fp.bin: $(SOURCES) regcopyflow.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

regcopyflow_gbz80.bin: $(SOURCES) regcopyflow.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

regcopyflow_gbz80_keep.bin: $(SOURCES) regcopyflow.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -Cc--opt-disable=regcopy-flow --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

incmem.bin: $(SOURCES) incmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

incmem_fp.bin: $(SOURCES) incmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

incmem_keep.bin: $(SOURCES) incmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=inc-mem --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

incmem_fp_keep.bin: $(SOURCES) incmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=inc-mem --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

incmem_8080.bin: $(SOURCES) incmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

localrmw_z80.bin: $(SOURCES) localrmw.c
	$(compile)
	$(runtest)

localrmw_z80_keep.bin: $(SOURCES) localrmw.c
	zcc +test -vn $(CFLAGS) -Cc--opt-disable=local-rmw $^ -o $@ -m
	@$(MACHINE) -b msx $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

localrmw_z80n.bin: $(SOURCES) localrmw.c
	$(compile_z80n)
	$(runtest_z80n)

localrmw_z180.bin: $(SOURCES) localrmw.c
	$(compile_z180)
	$(runtest_z180)

localrmw_ez80_z80.bin: $(SOURCES) localrmw.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

localrmw_8080.bin: $(SOURCES) localrmw.c
	$(compile_8080)
	$(runtest_8080)

localrmw_vm1.bin: $(SOURCES) localrmw.c
	$(compile_vm1)
	$(runtest_vm1)

localrmw_r2ka.bin: $(SOURCES) localrmw.c
	$(compile_r2ka)
	$(runtest_r2ka)

localrmw_r4k.bin: $(SOURCES) localrmw.c
	$(compile_r4k)
	$(runtest_r4k)

localrmw_r6k.bin: $(SOURCES) localrmw.c
	$(compile_r6k)
	$(runtest_r6k)

localrmw_kc160.bin: $(SOURCES) localrmw.c
	$(compile_kc160)
	$(runtest_kc160)

localrmw_gbz80.bin: $(SOURCES) localrmw.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@

localrmw_gbz80_keep.bin: $(SOURCES) localrmw.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=gbz80-rmw -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@

incmem_gbz80.bin: $(SOURCES) incmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

incmem_8085.bin: $(SOURCES) incmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

incmem_r4k.bin: $(SOURCES) incmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leapro.bin: $(SOURCES) leapro.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leapro_fp.bin: $(SOURCES) leapro.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leapro_ez80_fp.bin: $(SOURCES) leapro.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leapro_ez80_fp_keep.bin: $(SOURCES) leapro.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer -Cc--opt-disable=lea-frame-prologue --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leapro_8080.bin: $(SOURCES) leapro.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leafa.bin: $(SOURCES) leafa.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leafa_fp.bin: $(SOURCES) leafa.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leafa_ez80.bin: $(SOURCES) leafa.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leafa_ez80_fp.bin: $(SOURCES) leafa.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leafa_ez80_fp_keep.bin: $(SOURCES) leafa.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer -Cc--opt-disable=lea-frame-addr --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leafa_8080.bin: $(SOURCES) leafa.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cfescape.bin: $(SOURCES) cfescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cfescape_fp.bin: $(SOURCES) cfescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cfescape_8080.bin: $(SOURCES) cfescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cfescape_gbz80.bin: $(SOURCES) cfescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cfescape_8085.bin: $(SOURCES) cfescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cfescape_r4k.bin: $(SOURCES) cfescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cfescape_ez80.bin: $(SOURCES) cfescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

aliaswr.bin: $(SOURCES) aliaswr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

aliaswr_fp.bin: $(SOURCES) aliaswr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

aliaswr_8080.bin: $(SOURCES) aliaswr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

aliaswr_gbz80.bin: $(SOURCES) aliaswr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

aliaswr_8085.bin: $(SOURCES) aliaswr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

aliaswr_r4k.bin: $(SOURCES) aliaswr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

aliaswr_ez80.bin: $(SOURCES) aliaswr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leaimm.bin: $(SOURCES) leaimm.c
	$(compile)
	$(runtest)

leaimm_fp.bin: $(SOURCES) leaimm.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

leaimm_8085.bin: $(SOURCES) leaimm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

leaimm_8080.bin: $(SOURCES) leaimm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

longshl.bin: $(SOURCES) longshl.c
	$(compile)
	$(runtest)

longshl_fp.bin: $(SOURCES) longshl.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

longshl_8085.bin: $(SOURCES) longshl.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longshl_8080.bin: $(SOURCES) longshl.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longshl_vm1.bin: $(SOURCES) longshl.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=vm1 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mvm1 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longshl_gbz80.bin: $(SOURCES) longshl.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

naked.bin: $(SOURCES) naked.c
	$(compile)
	$(runtest)

naked_fp.bin: $(SOURCES) naked.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

naked_8080.bin: $(SOURCES) naked.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

szstatic.bin: $(SOURCES) szstatic.c
	$(compile)
	$(runtest)

szstatic_fp.bin: $(SOURCES) szstatic.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

voidhoist.bin: $(SOURCES) voidhoist.c
	$(compile)
	$(runtest)

voidhoist_fp.bin: $(SOURCES) voidhoist.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

constern.bin: $(SOURCES) constern.c
	$(compile)
	$(runtest)

constern_fp.bin: $(SOURCES) constern.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

constern_8080.bin: $(SOURCES) constern.c
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

# A cast's value is its TARGET TYPE, not just its operand — two casts of one
# subexpression to different widths are different expressions. Sibling of
# bfcse.bin: same nodes_equivalent() defect, one node type along.
castcse.bin: $(SOURCES) castcse.c
	$(compile)
	$(runtest)

castcse_fp.bin: $(SOURCES) castcse.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

# A PARAMETER's incoming value is an INVISIBLE def, so a parameter assigned once
# under a condition is NOT the single-def constant remat took it for:
# `int floor0(int v) { if (v<0) v=0; return v+1; }` loaded `ld hl,0` for the
# parameter and returned 1 for every input. See the file header.
parremat.bin: $(SOURCES) parremat.c
	$(compile)
	$(runtest)

parremat_fp.bin: $(SOURCES) parremat.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

parremat_8080.bin: $(SOURCES) parremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

parremat_gbz80.bin: $(SOURCES) parremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# A signed compare may drop its 7-byte sign correction only when BOTH operands
# are provably non-negative. Pins the two ways the proof goes wrong: a PARAMETER
# has an invisible def (caught in the wild by depark's satband(-5)), and a value
# that only rises can wrap past 32767. See the file header.
cmpsign.bin: $(SOURCES) cmpsign.c
	$(compile)
	$(runtest)

cmpsign_fp.bin: $(SOURCES) cmpsign.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

cmpsign_8080.bin: $(SOURCES) cmpsign.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpsign_gbz80.bin: $(SOURCES) cmpsign.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# A value REASSIGNED many times and read once per write fell between the two BC
# gates (write-once vs hot) and landed in a slot. It may now take BC when its
# range is call-free and uncontended, which puts a MULTIPLY-DEFINED value in a
# register — so every def must stamp BC coherently. See the file header.
ivacc.bin: $(SOURCES) ivacc.c
	$(compile)
	$(runtest)

ivacc_fp.bin: $(SOURCES) ivacc.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

ivacc_8080.bin: $(SOURCES) ivacc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivacc_gbz80.bin: $(SOURCES) ivacc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# A copt fold must not delete a LIVE definition of A: folding the byte-global
# widen `ld a,(_g); ld l,a; ld h,0` to `ld hl,(_g); ld h,0` kills the A the NEXT
# widen of the same byte reads. Costs no bytes to fix, so only a value check
# finds it — see the file header.
copta.bin: $(SOURCES) copta.c
	$(compile)
	$(runtest)

copta_fp.bin: $(SOURCES) copta.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

copta_8080.bin: $(SOURCES) copta.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

copta_gbz80.bin: $(SOURCES) copta.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# A truncated long shift computes only the bytes that survive, trimming both
# ends and flipping direction past K%8 == 4. The must-NOT-fire half (a result
# also read at full width) is the valuable one — see the file header.
shrnarrow.bin: $(SOURCES) shrnarrow.c
	$(compile)
	$(runtest)

shrnarrow_fp.bin: $(SOURCES) shrnarrow.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

shrnarrow_8080.bin: $(SOURCES) shrnarrow.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

shrnarrow_gbz80.bin: $(SOURCES) shrnarrow.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

fclong_r6k.bin: $(SOURCES) fclong.c
	$(compile_r6k)
	$(runtest_r6k)

memberarr_r6k.bin: $(SOURCES) memberarr.c
	$(compile_r6k)
	$(runtest_r6k)

statscope_r6k.bin: $(SOURCES) statscope.c
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

fclong_r2ka.bin: $(SOURCES) fclong.c
	$(compile_r2ka)
	$(runtest_r2ka)

memberarr_r2ka.bin: $(SOURCES) memberarr.c
	$(compile_r2ka)
	$(runtest_r2ka)

statscope_r2ka.bin: $(SOURCES) statscope.c
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

rabmul.bin: $(SOURCES) rabmul.c
	$(compile)
	$(runtest)

rabmul_fp.bin: $(SOURCES) rabmul.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

rabmul_r2ka.bin: $(SOURCES) rabmul.c
	$(compile_r2ka)
	$(runtest_r2ka)

rabmul_r4k.bin: $(SOURCES) rabmul.c
	$(compile_r4k)
	$(runtest_r4k)

rabmul_r6k.bin: $(SOURCES) rabmul.c
	$(compile_r6k)
	$(runtest_r6k)

rabmul_8080.bin: $(SOURCES) rabmul.c
	$(compile_8080)
	$(runtest_8080)

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

fclong_r4k.bin: $(SOURCES) fclong.c
	$(compile_r4k)
	$(runtest_r4k)

memberarr_r4k.bin: $(SOURCES) memberarr.c
	$(compile_r4k)
	$(runtest_r4k)

statscope_r4k.bin: $(SOURCES) statscope.c
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

delive.bin: $(SOURCES) delive.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

delive_fp.bin: $(SOURCES) delive.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

delive_8085.bin: $(SOURCES) delive.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

delive_8085_fp.bin: $(SOURCES) delive.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

delive_8085_keep.bin: $(SOURCES) delive.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=de-ret,de-call --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

delive_z80n.bin: $(SOURCES) delive.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

delive_8080.bin: $(SOURCES) delive.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Local aggregate field promotion: positive scalar replacement plus escaping
# and overlapping views that must retain their memory representation.
all: aggpromote.bin aggpromote_fp.bin aggpromote_8080.bin aggpromote_gbz80.bin

aggpromote.bin: $(SOURCES) aggpromote.c
	$(compile)
	$(runtest)

aggpromote_fp.bin: $(SOURCES) aggpromote.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

aggpromote_8080.bin: $(SOURCES) aggpromote.c
	$(compile_8080)
	$(runtest_8080)

aggpromote_gbz80.bin: $(SOURCES) aggpromote.c
	$(compile_gbz80)
	$(runtest_gbz80)
