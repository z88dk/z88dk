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
all:	rabsub.bin rabsub_r2ka.bin rabsub_r4k.bin rabsub_asm.bin jrtight.bin jrtight_r2ka.bin jrtight_ez80.bin jrtight_kc160.bin jrtight_asm.bin
all:	smod.bin smod_8080.bin smod_gbz80.bin smod_r2ka.bin smod_ez80.bin smod_kc160.bin smod_8085.bin smod_fp.bin
all:	blockfn.bin blockfn_8080.bin blockfn_gbz80.bin blockfn_r2ka.bin blockfn_ez80.bin blockfn_8085.bin blockfn_fp.bin
all:	accintcomp.bin accintcomp_fp.bin
all:	bigframe.bin bigframe_fp.bin bigframe_8080.bin bigframe_r2ka.bin bigframe_ez80.bin bigframe_gbz80.bin
all:	longasr.bin longasr_8080.bin longasr_gbz80.bin longasr_r2ka.bin longasr_ez80.bin longasr_8085.bin longasr_kc160.bin longasr_z180.bin longasr_r4k.bin longasr_fp.bin
all:	crcloop.bin crcloop_8080.bin crcloop_gbz80.bin crcloop_r2ka.bin crcloop_ez80.bin crcloop_8085.bin crcloop_kc160.bin crcloop_z180.bin crcloop_r4k.bin crcloop_fp.bin
all:	zxfold.bin zxfold_8080.bin zxfold_gbz80.bin zxfold_r2ka.bin zxfold_ez80.bin zxfold_8085.bin zxfold_kc160.bin zxfold_z180.bin zxfold_r4k.bin zxfold_fp.bin
all:	bytestore.bin bytestore_8080.bin bytestore_gbz80.bin bytestore_r2ka.bin bytestore_ez80.bin bytestore_8085.bin bytestore_kc160.bin bytestore_z180.bin bytestore_r4k.bin bytestore_fp.bin
all:	foldshift.bin foldshift_8080.bin foldshift_gbz80.bin foldshift_r2ka.bin foldshift_ez80.bin foldshift_8085.bin foldshift_kc160.bin foldshift_z180.bin foldshift_r4k.bin foldshift_fp.bin
all:	countborrow.bin countborrow_gbz80.bin
all:	strremat.bin strremat_fp.bin strremat_8080.bin strremat_gbz80.bin
all:	fnptrdead.bin fnptrdead_fp.bin fnptrdead_8080.bin fnptrdead_gbz80.bin
all:	argcf.bin argcf_fp.bin argcf_8080.bin argcf_gbz80.bin
all:	jpnext.bin jpnext_fp.bin jpnext_8080.bin jpnext_gbz80.bin
all:	ixind.bin
all:	bchand.bin bchand_fp.bin bchand_8080.bin bchand_gbz80.bin
all:	localrmw_gbz80.bin localrmw_gbz80_keep.bin
all:	localrmw_z80.bin localrmw_z80n.bin localrmw_z180.bin localrmw_ez80_z80.bin localrmw_8080.bin localrmw_vm1.bin localrmw_r2ka.bin localrmw_r4k.bin localrmw_r6k.bin localrmw_kc160.bin localrmw_r800.bin localrmw_z80_keep.bin
all:	homeexitdead_gbz80.bin homeexitdead_gbz80_keep.bin
all:	derefcmp_bcstep.bin derefcmp_bcstep_8080.bin
all:	directwiden.bin directwiden_z80n.bin directwiden_ez80_z80.bin directwiden_r800.bin
all:	widestep.bin widestep_fp.bin widestep_8080.bin widestep_8085.bin widestep_gbz80.bin widestep_r2ka.bin widestep_calls.bin
all:	poolremat.bin poolremat_fp.bin poolremat_gbz80.bin poolremat_8080.bin poolremat_8085.bin
all:	deaddereload.bin deaddereload_fp.bin deaddereload_gbz80.bin
all:	xorflipconst.bin xorflipconst_fp.bin xorflipconst_gbz80.bin xorflipconst_8080.bin xorflipconst_vm1.bin
all:	xorflipchain.bin xorflipchain_fp.bin xorflipchain_gbz80.bin xorflipchain_8080.bin
all:	gbwordmem.bin gbwordmem_fp.bin gbwordmem_8080.bin gbwordmem_gbz80.bin gbwordmem_gbz80_keep.bin
all:	ivsrsup.bin ivsrsup_fp.bin ivsrsup_gbz80.bin ivsrsup_gbz80_keep.bin ivsrsup_8080.bin ivsrsup_8085.bin ivsrsup_8085_keep.bin ivsrsup_vm1.bin ivsrsup_8080_rckeep.bin
all:	hlmemcarry.bin hlmemcarry_fp.bin hlmemcarry_gbz80.bin hlmemcarry_gbz80_keep.bin hlmemcarry_8080.bin hlmemcarry_8085.bin
all:	decallasm.bin decallasm_fp.bin decallasm_keep.bin decallasm_gbz80.bin decallasm_8080.bin decallasm_8085.bin decallasm_8085_keep.bin
all:	switchchain.bin switchchain_fp.bin switchchain_keep.bin switchchain_gbz80.bin switchchain_8080.bin switchchain_8085.bin switchchain_r4k.bin gbstorea.bin gbstorea_gbz80.bin gbstorea_gbz80_keep.bin gbstorea_8080.bin
all:	hlconst.bin hlconst_fp.bin hlconst_keep.bin hlconst_gbz80.bin hlconst_8080.bin hlconst_8085.bin hlconst_r4k.bin
all:	hcallstash.bin hcallstash_8085.bin hcallstash_8080.bin mathstash_8085.bin
all:	dsubbc.bin dsubbc_fp.bin dsubbc_8085.bin dsubbc_8085_keep.bin dsubbc_8080.bin
all:	gbsmallframe.bin gbsmallframe_fp.bin gbsmallframe_gbz80.bin gbsmallframe_gbz80_keep.bin
all:	lcallflags.bin lcallflags_fp.bin lcallflags_8080.bin lcallflags_8085.bin lcallflags_8085_keep.bin lcallflags_gbz80.bin
JPTH = ../../../libsrc/l/sccz80/9-common/l_jpix.asm ../../../libsrc/l/sccz80/9-common/l_jpiy.asm

all:	test.bin test_gbz80.bin test_8080.bin test_8085.bin irgaps.bin irgaps_gbz80.bin irgaps_8080.bin irgaps_8085.bin structval.bin structval_gbz80.bin structval_8080.bin structval_8085.bin fixed.bin sdcccall.bin sdcccall_kc160.bin wr.bin wr_fp.bin fp_promote.bin fp_promote_reg.bin fp_promote_f48f16.bin fp_promote_accum.bin aggregate_init.bin fnptr_fastcall.bin fnptr_fastcall_noidx.bin fnptr_fastcall_gbz80.bin fnptr_fastcall_8080.bin fnptr_fastcall_8085.bin faslot.bin libcall_abi.bin const_mult.bin cmp_gt.bin cmp_sign.bin remat.bin idxcmp.bin idxcmp_fp.bin ixdcmp.bin ixdcmp_fp.bin dehome.bin dehome_fp.bin looppr.bin looppr_fp.bin redwb.bin redwb_fp.bin redwb_8080.bin addrcse.bin addrcse_fp.bin idxhome.bin idxhome_fp.bin longlong.bin bitfield.bin umaxd.bin ternwiden.bin ternwiden_fp.bin fp_to_int.bin fp_to_int_reg.bin linewrap.bin widen.bin hwmul.bin hwmul_z180.bin hwmul_ez80.bin hwmul_z80n.bin hwmul_kc160.bin narrowmul.bin narrowmul_fp.bin narrowmul_8080.bin derefcmp.bin derefcmp_fp.bin bytecmp.bin bytecmp_fp.bin bytecmp_8080.bin bytecmp_gbz80.bin bremat.bin bremat_fp.bin bremat_8080.bin bremat_gbz80.bin fclong.bin fclong_fp.bin fclong_8080.bin fclong_gbz80.bin memberarr.bin memberarr_fp.bin memberarr_8080.bin memberarr_gbz80.bin statscope.bin statscope_fp.bin statscope_8080.bin statscope_gbz80.bin byteparam.bin byteparam_fp.bin byteparam_8080.bin byteparam_gbz80.bin fcparam.bin fcparam_fp.bin fcparam_8080.bin fcparam_gbz80.bin storecall.bin storecall_fp.bin storecall_8080.bin storecall_gbz80.bin compoundwiden.bin compoundwiden_fp.bin compoundwiden_8080.bin compoundwiden_gbz80.bin ivsr_lftr.bin ivsr_lftr_fp.bin binop_bc.bin binop_bc_fp.bin binop_bc_8080.bin binop_bc_gbz80.bin callsplit.bin callsplit_fp.bin callsplit_8080.bin callsplit_8085.bin callsplit_gbz80.bin jrelax.bin jrelax_fp.bin jrelax_8080.bin jrelax_gbz80.bin slotaddr.bin slotaddr_fp.bin slotaddr_8080.bin slotaddr_8085.bin slotaddr_gbz80.bin slotaddr_vm1.bin shrmask.bin shrmask_fp.bin shrmask_8080.bin shrmask_8085.bin shrmask_gbz80.bin idxbase.bin idxbase_fp.bin idxbase_8080.bin idxbase_gbz80.bin idxderef.bin idxderef_fp.bin idxderef_8080.bin idxderef_gbz80.bin idxderef_ez80.bin idxderef_ez80_fp.bin idxderef_z180.bin idxderef_z180_fp.bin idxderef_kc160.bin idxderef_kc160_fp.bin idxderef_r800.bin idxderef_r800_fp.bin idxderef_r2ka.bin idxderef_r4k.bin tailmerge.bin tailmerge_fp.bin tailmerge_8080.bin tailmerge_gbz80.bin byteshr.bin byteshr_fp.bin byteshr_8080.bin byteshr_8085.bin byteshr_gbz80.bin blayout.bin blayout_fp.bin blayout_8080.bin blayout_gbz80.bin retthread.bin retthread_fp.bin retthread_8080.bin retthread_gbz80.bin dsword.bin dsword_fp.bin dsword_8080.bin dsword_gbz80.bin prepush.bin prepush_fp.bin prepush_8080.bin prepush_gbz80.bin constern.bin constern_fp.bin constern_8080.bin naked.bin naked_fp.bin naked_8080.bin voidhoist.bin voidhoist_fp.bin szstatic.bin szstatic_fp.bin deaddef.bin deaddef_fp.bin deaddef_8080.bin dsub.bin dsub_fp.bin dsub_8085.bin dsub_8080.bin longshl.bin longshl_fp.bin longshl_8085.bin longshl_8080.bin longshl_vm1.bin longshl_gbz80.bin lhlx.bin lhlx_fp.bin lhlx_8085.bin lhlx_8080.bin derefw.bin derefw_fp.bin derefw_8085.bin derefw_8080.bin depark.bin depark_fp.bin depark_8085.bin depark_8085_keep.bin depark_8080.bin ldsiaddr.bin ldsiaddr_fp.bin ldsiaddr_8085.bin ldsiaddr_8085_fp.bin ldsiaddr_8085_keep.bin ldsiaddr_8080.bin ldhiaddr.bin ldhiaddr_fp.bin ldhiaddr_8085.bin ldhiaddr_8085_fp.bin ldhiaddr_8085_keep.bin ldhiaddr_8080.bin znadda.bin znadda_fp.bin znadda_z80n.bin znadda_z80n_fp.bin znadda_z80n_keep.bin znadda_8080.bin incmem.bin incmem_fp.bin incmem_keep.bin incmem_fp_keep.bin incmem_8080.bin incmem_gbz80.bin incmem_8085.bin incmem_r4k.bin leafa.bin leafa_fp.bin leafa_ez80.bin leafa_ez80_fp.bin leafa_ez80_fp_keep.bin leafa_8080.bin cfescape.bin cfescape_fp.bin cfescape_8080.bin cfescape_gbz80.bin cfescape_8085.bin cfescape_r4k.bin cfescape_ez80.bin aliaswr.bin aliaswr_fp.bin aliaswr_8080.bin aliaswr_gbz80.bin aliaswr_8085.bin aliaswr_r4k.bin aliaswr_ez80.bin csealias.bin csealias_fp.bin csealias_8080.bin csealias_gbz80.bin csealias_8085.bin csealias_r4k.bin csealias_ez80.bin longmultgate.bin ivpair.bin idxstep.bin cmpkload.bin addkreg.bin bcsavegrp.bin downloop.bin downloop_fp.bin downloop_8080.bin downloop_gbz80.bin downloop_r4k.bin downloop_ez80.bin downloop_z80n.bin downloop_z180.bin bcsavegrp_fp.bin bcsavegrp_8080.bin bcsavegrp_gbz80.bin bcsavegrp_r4k.bin bcsavegrp_ez80.bin bcsavegrp_z80n.bin bcsavegrp_z180.bin addkreg_fp.bin addkreg_8080.bin addkreg_gbz80.bin addkreg_r4k.bin addkreg_ez80.bin addkreg_z80n.bin addkreg_z180.bin cmpkload_fp.bin cmpkload_8080.bin cmpkload_gbz80.bin cmpkload_r4k.bin cmpkload_ez80.bin cmpkload_z80n.bin cmpkload_z180.bin idxstep_fp.bin idxstep_r4k.bin idxstep_ez80.bin idxstep_z80n.bin ivpair_fp.bin ivpair_r4k.bin ivpair_ez80.bin ivpair_z80n.bin longmultgate_fp.bin longmultgate_8080.bin longmultgate_gbz80.bin longmultgate_8085.bin longmultgate_r4k.bin longmultgate_ez80.bin ptrescape.bin ptrescape_fp.bin ptrescape_8080.bin ptrescape_gbz80.bin ptrescape_8085.bin ptrescape_r4k.bin ptrescape_ez80.bin ptrfuzz.bin ptrfuzz_fp.bin ptrfuzz_8080.bin ptrfuzz_gbz80.bin ptrfuzz_8085.bin ptrfuzz_r4k.bin ptrfuzz_ez80.bin fuzz_1037.bin fuzz_1037_fp.bin fuzz_1039.bin fuzz_1039_fp.bin fuzz_161.bin fuzz_161_fp.bin fuzz_214.bin fuzz_214_fp.bin fuzz_232.bin fuzz_232_fp.bin fuzz_2496.bin fuzz_2496_fp.bin fuzz_2734.bin fuzz_2734_fp.bin fuzzp_1232.bin fuzzp_1232_fp.bin fuzzp_1428.bin fuzzp_1428_fp.bin fuzzp_1478b.bin fuzzp_1478b_fp.bin fuzzp_325.bin fuzzp_325_fp.bin fuzzp_4735.bin fuzzp_4735_fp.bin fuzzp_6486.bin fuzzp_6486_fp.bin fuzzp_7421.bin fuzzp_7421_fp.bin fuzzp_k2_8085.bin fuzzp_k2_8085_fp.bin fuzzp_480_kc160.bin fuzzp_480_kc160_fp.bin fuzzp_929_r6k.bin fuzzp_929_r6k_fp.bin fuzzp_5075_r2ka.bin fuzzp_5075_r2ka_fp.bin fuzzp_5629_z80n.bin fuzzp_5629_z80n_fp.bin fuzzp_327_kc160.bin fuzzp_327_kc160_fp.bin fuzzp_351_r2ka.bin fuzzp_351_r2ka_fp.bin fuzzp_326_r2ka.bin fuzzp_326_r2ka_fp.bin fuzzp_7255.bin fuzzp_7255_fp.bin fuzzp_6302.bin fuzzp_6302_fp.bin leaimm.bin leaimm_fp.bin leaimm_8085.bin leaimm_8080.bin csparam.bin csparam_fp.bin csparam_8080.bin csparam_gbz80.bin rotl32.bin rotl32_fp.bin rotl32_8080.bin rotl32_gbz80.bin mux.bin mux_fp.bin mux_8080.bin mux_gbz80.bin demorgan.bin demorgan_fp.bin demorgan_8080.bin pack16.bin pack16_fp.bin pack16_8080.bin pack16_gbz80.bin homeexit.bin homeexit_fp.bin homeexit_8080.bin homeexit_gbz80.bin cmphi.bin cmphi_fp.bin cmphi_8080.bin cmphi_gbz80.bin sfr.bin sfr_fp.bin sfr_8080.bin boolbyte.bin boolbyte_fp.bin boolbyte_8080.bin boolbyte_gbz80.bin narrowld.bin narrowld_fp.bin narrowld_8080.bin narrowld_gbz80.bin dsshare.bin dsshare_fp.bin dsshare_8080.bin dsshare_gbz80.bin addridx.bin addridx_fp.bin addridx_8080.bin addridx_8085.bin unionmem.bin unionmem_fp.bin bfcse.bin bfcse_fp.bin castcse.bin castcse_fp.bin shrnarrow.bin shrnarrow_fp.bin shrnarrow_8080.bin shrnarrow_gbz80.bin copta.bin copta_fp.bin copta_8080.bin copta_gbz80.bin ivacc.bin ivacc_fp.bin ivacc_8080.bin ivacc_gbz80.bin cmpsign.bin cmpsign_fp.bin cmpsign_8080.bin cmpsign_gbz80.bin parremat.bin parremat_fp.bin parremat_8080.bin parremat_gbz80.bin widen2.bin widen2_fp.bin addridx_r6k.bin binop_bc_r6k.bin boolbyte_r6k.bin bremat_r6k.bin fclong_r6k.bin memberarr_r6k.bin statscope_r6k.bin bytecmp_r6k.bin byteparam_r6k.bin callsplit_r6k.bin cmphi_r6k.bin compoundwiden_r6k.bin csparam_r6k.bin deaddef_r6k.bin demorgan_r6k.bin dsshare_r6k.bin dsword_r6k.bin fcparam_r6k.bin fnptr_fastcall_r6k.bin jrelax_r6k.bin retthread_r6k.bin mux_r6k.bin narrowld_r6k.bin narrowmul_r6k.bin pack16_r6k.bin rotl32_r6k.bin storecall_r6k.bin structval_r6k.bin remat_r6k.bin sfr_r6k.bin addridx_r2ka.bin binop_bc_r2ka.bin boolbyte_r2ka.bin bremat_r2ka.bin fclong_r2ka.bin memberarr_r2ka.bin statscope_r2ka.bin bytecmp_r2ka.bin byteparam_r2ka.bin callsplit_r2ka.bin cmphi_r2ka.bin compoundwiden_r2ka.bin csparam_r2ka.bin deaddef_r2ka.bin demorgan_r2ka.bin dsshare_r2ka.bin dsword_r2ka.bin fcparam_r2ka.bin fnptr_fastcall_r2ka.bin jrelax_r2ka.bin retthread_r2ka.bin mux_r2ka.bin narrowld_r2ka.bin narrowmul_r2ka.bin pack16_r2ka.bin rotl32_r2ka.bin storecall_r2ka.bin structval_r2ka.bin remat_r2ka.bin sfr_r2ka.bin addridx_r4k.bin binop_bc_r4k.bin boolbyte_r4k.bin bremat_r4k.bin fclong_r4k.bin memberarr_r4k.bin statscope_r4k.bin bytecmp_r4k.bin byteparam_r4k.bin callsplit_r4k.bin cmphi_r4k.bin compoundwiden_r4k.bin csparam_r4k.bin deaddef_r4k.bin demorgan_r4k.bin dsshare_r4k.bin dsword_r4k.bin fcparam_r4k.bin fnptr_fastcall_r4k.bin jrelax_r4k.bin retthread_r4k.bin mux_r4k.bin narrowld_r4k.bin narrowmul_r4k.bin pack16_r4k.bin rotl32_r4k.bin storecall_r4k.bin structval_r4k.bin remat_r4k.bin sfr_r4k.bin rabmul.bin rabmul_fp.bin rabmul_r2ka.bin rabmul_r4k.bin rabmul_r6k.bin rabmul_8080.bin delive.bin delive_fp.bin delive_8085.bin delive_8085_fp.bin delive_8085_keep.bin delive_z80n.bin delive_8080.bin dewiden.bin dewiden_fp.bin dewiden_keep.bin dewiden_fp_keep.bin dewiden_8080.bin dewiden_gbz80.bin dewiden_r4k.bin regcopyflow.bin regcopyflow_fp.bin regcopyflow_gbz80.bin regcopyflow_gbz80_keep.bin shrdeadl.bin shrdeadl_fp.bin shrdeadl_keep.bin shrdeadl_fp_keep.bin shrdeadl_8080.bin shrtbac.bin shrtbac_fp.bin shrtbac_keep.bin shrtbac_gbz80.bin shrtbac_8080.bin leapro.bin leapro_fp.bin leapro_ez80_fp.bin leapro_ez80_fp_keep.bin leapro_8080.bin longmemrhs.bin longmemrhs_fp.bin longmemrhs_8080.bin longmemrhs_8085.bin longmemrhs_gbz80.bin longmemrhs_r4k.bin longmemrhs_ez80.bin longmemrhs_z80n.bin longmemrhs_z180.bin longmemrhs_kc160.bin longmemrhs_r2ka.bin longmempark.bin longmempark_fp.bin longmempark_8080.bin longmempark_8085.bin longmempark_gbz80.bin longmempark_r4k.bin longmempark_ez80.bin longmempark_z80n.bin longmempark_z180.bin longmempark_kc160.bin longmempark_r2ka.bin retmerge.bin retmerge_fp.bin retmerge_8080.bin retmerge_8085.bin retmerge_gbz80.bin retmerge_r4k.bin retmerge_ez80.bin bytecleanup.bin bytecleanup_fp.bin bytecleanup_8080.bin bytecleanup_8085.bin bytecleanup_gbz80.bin bytecleanup_r4k.bin bytecleanup_ez80.bin bytecleanup_z80n.bin bytecleanup_z180.bin bytecleanup_kc160.bin bytecleanup_r2ka.bin

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

widestep.bin: $(SOURCES) widestep.c
	$(compile)
	$(runtest)

widestep_fp.bin: $(SOURCES) widestep.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

widestep_8080.bin: $(SOURCES) widestep.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) $(FPFLAG) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

widestep_8085.bin: $(SOURCES) widestep.c
	$(compile_8085)
	$(runtest_8085)

widestep_gbz80.bin: $(SOURCES) widestep.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) $(FPFLAG) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

widestep_r2ka.bin: $(SOURCES) widestep.c
	$(compile_r2ka)
	$(runtest_r2ka)

# Check that all four ll_*dec* sites call l_i64_dec and that the
# discarded-result steps use the in-memory helpers.
widestep_calls.bin: widestep.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) $(FPFLAG) -I$(FRAMEWORK_DIR) -S $< -o widestep_calls.asm
	@test `grep -c 'call[[:space:]]*l_i64_dec' widestep_calls.asm` -ge 4 || { echo "$(RED)" `date +%H:%M:%S` " Test failure: l_i64_dec not called $(RESET)" ; exit 1; }
	@test `grep -c 'call[[:space:]]*l_long_inc_mhl' widestep_calls.asm` -ge 3 || { echo "$(RED)" `date +%H:%M:%S` " Test failure: l_long_inc_mhl not called $(RESET)" ; exit 1; }
	@test `grep -c 'call[[:space:]]*l_long_dec_mhl' widestep_calls.asm` -ge 3 || { echo "$(RED)" `date +%H:%M:%S` " Test failure: l_long_dec_mhl not called $(RESET)" ; exit 1; }
	@touch $@

# IR_BC_STEP_CALL re-arbitrates dc_streq after a home demotion; the rerun's
# rejected DE pick restores a BC tenant over a B byte pack made meanwhile.
derefcmp_bcstep.bin: $(SOURCES) derefcmp.c
	IR_BC_STEP_CALL=1 $(compile)
	$(runtest)

derefcmp_bcstep_8080.bin: $(SOURCES) derefcmp.c
	IR_BC_STEP_CALL=1 zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) $(FPFLAG) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

poolremat.bin: $(SOURCES) poolremat.c
	$(compile)
	$(runtest)

poolremat_fp.bin: $(SOURCES) poolremat.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

poolremat_gbz80.bin: $(SOURCES) poolremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

poolremat_8080.bin: $(SOURCES) poolremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

poolremat_8085.bin: $(SOURCES) poolremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

deaddereload.bin: $(SOURCES) deaddereload.c
	$(compile)
	$(runtest)

deaddereload_fp.bin: $(SOURCES) deaddereload.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

deaddereload_gbz80.bin: $(SOURCES) deaddereload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

xorflipconst.bin: $(SOURCES) xorflipconst.c
	$(compile)
	$(runtest)

xorflipconst_fp.bin: $(SOURCES) xorflipconst.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

xorflipconst_gbz80.bin: $(SOURCES) xorflipconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

xorflipconst_8080.bin: $(SOURCES) xorflipconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

xorflipconst_vm1.bin: $(SOURCES) xorflipconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=vm1 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mvm1 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

xorflipchain.bin: $(SOURCES) xorflipchain.c
	$(compile)
	$(runtest)

xorflipchain_fp.bin: $(SOURCES) xorflipchain.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

xorflipchain_gbz80.bin: $(SOURCES) xorflipchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

xorflipchain_8080.bin: $(SOURCES) xorflipchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

ivsr_lftr_ez80.bin: $(SOURCES) ivsr_lftr.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

ivsr_lftr_ez80_fp.bin: $(SOURCES) ivsr_lftr.c
	$(call compile_ez80_z80,-Cc-fframe-pointer)
	$(runtest_ez80_z80)

ivsr_lftr_kc160.bin: $(SOURCES) ivsr_lftr.c
	$(compile_kc160)
	$(runtest_kc160)

ivsr_lftr_kc160_fp.bin: $(SOURCES) ivsr_lftr.c
	$(call compile_kc160,-Cc-fframe-pointer)
	$(runtest_kc160)

ivsr_lftr_r4k.bin: $(SOURCES) ivsr_lftr.c
	$(compile_r4k)
	$(runtest_r4k)

# smax0: the signed-bound clamp. 8080 has no `bit`, so it takes the
# `ld a,h; add a,a` form; _keep is the three-op opt-out.
ivsr_lftr_8080.bin: $(SOURCES) ivsr_lftr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsr_lftr_gbz80.bin: $(SOURCES) ivsr_lftr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsr_lftr_keep.bin: $(SOURCES) ivsr_lftr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=smax0 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

# Direct byte-to-DE widening. Keep this on the index-half-capable CPUs as
# well as plain Z80 so the shared lowering is exercised in each enabled path.
directwiden.bin: $(SOURCES) directwiden.c
	$(compile)
	$(runtest)

directwiden_z80n.bin: $(SOURCES) directwiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

directwiden_ez80_z80.bin: $(SOURCES) directwiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

directwiden_r800.bin: $(SOURCES) directwiden.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=r800 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr800 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

idxderef_r800.bin: $(SOURCES) idxderef.c
	$(compile_r800)
	$(runtest_r800)

idxderef_r800_fp.bin: $(SOURCES) idxderef.c
	$(call compile_r800,-Cc-fframe-pointer)
	$(runtest_r800)

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

lcallflags.bin: $(SOURCES) lcallflags.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lcallflags_fp.bin: $(SOURCES) lcallflags.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lcallflags_8080.bin: $(SOURCES) lcallflags.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lcallflags_8085.bin: $(SOURCES) lcallflags.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lcallflags_8085_keep.bin: $(SOURCES) lcallflags.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=l-call-flags --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lcallflags_gbz80.bin: $(SOURCES) lcallflags.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbwordmem.bin: $(SOURCES) gbwordmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbwordmem_fp.bin: $(SOURCES) gbwordmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbwordmem_8080.bin: $(SOURCES) gbwordmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbwordmem_gbz80.bin: $(SOURCES) gbwordmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbwordmem_gbz80_keep.bin: $(SOURCES) gbwordmem.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -Cc--opt-disable=gb-word-mem --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbsmallframe.bin: $(SOURCES) gbsmallframe.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbsmallframe_fp.bin: $(SOURCES) gbsmallframe.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbsmallframe_gbz80.bin: $(SOURCES) gbsmallframe.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbsmallframe_gbz80_keep.bin: $(SOURCES) gbsmallframe.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -Cc--opt-disable=gb-small-frame --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_fp.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_gbz80.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_gbz80_keep.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -Cc--opt-disable=ivsr-suppress --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_8080.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_8085.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_8085_keep.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=ivsr-suppress --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_vm1.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=vm1 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mvm1 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_8080_rckeep.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -Cc--opt-disable=ivsr-recompute --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsubbc.bin: $(SOURCES) dsubbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsubbc_fp.bin: $(SOURCES) dsubbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsubbc_8085.bin: $(SOURCES) dsubbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsubbc_8085_keep.bin: $(SOURCES) dsubbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=dsub-bc --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsubbc_8080.bin: $(SOURCES) dsubbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlmemcarry.bin: $(SOURCES) hlmemcarry.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlmemcarry_fp.bin: $(SOURCES) hlmemcarry.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlmemcarry_gbz80.bin: $(SOURCES) hlmemcarry.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlmemcarry_gbz80_keep.bin: $(SOURCES) hlmemcarry.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -Cc--opt-disable=hl-mem-carry,block-layout-rounds --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlmemcarry_8080.bin: $(SOURCES) hlmemcarry.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlmemcarry_8085.bin: $(SOURCES) hlmemcarry.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

decallasm.bin: $(SOURCES) decallasm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

decallasm_fp.bin: $(SOURCES) decallasm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

decallasm_keep.bin: $(SOURCES) decallasm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=de-call-asm --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

decallasm_gbz80.bin: $(SOURCES) decallasm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

decallasm_8080.bin: $(SOURCES) decallasm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

decallasm_8085.bin: $(SOURCES) decallasm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

decallasm_8085_keep.bin: $(SOURCES) decallasm.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=de-call-asm --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hcallstash.bin: $(SOURCES) hcallstash.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m 
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hcallstash_8085.bin: $(SOURCES) hcallstash.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -DMATH16 -D__MATH_MATH16 -fp-mode=ieee -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m --math16 -lmath32_8085
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hcallstash_8080.bin: $(SOURCES) hcallstash.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DMATH16 -D__MATH_MATH16 -fp-mode=ieee -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m --math16 -lmath32_8080
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

mathstash_8085.bin: $(SOURCES) ../math/math.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -DMATH16 -D__MATH_MATH16 -DMATH_SPECIALS -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math16-8085\\\"\"" -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m --math16 -lmath32_8085
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

switchchain.bin: $(SOURCES) switchchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

switchchain_fp.bin: $(SOURCES) switchchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

switchchain_keep.bin: $(SOURCES) switchchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=switch-chain --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

switchchain_gbz80.bin: $(SOURCES) switchchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

switchchain_8080.bin: $(SOURCES) switchchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

switchchain_8085.bin: $(SOURCES) switchchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

switchchain_r4k.bin: $(SOURCES) switchchain.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbstorea.bin: $(SOURCES) gbstorea.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbstorea_gbz80.bin: $(SOURCES) gbstorea.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbstorea_gbz80_keep.bin: $(SOURCES) gbstorea.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -Cc--opt-disable=gb-store-a --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

gbstorea_8080.bin: $(SOURCES) gbstorea.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlconst.bin: $(SOURCES) hlconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlconst_fp.bin: $(SOURCES) hlconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlconst_keep.bin: $(SOURCES) hlconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=hl-const-reuse --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlconst_gbz80.bin: $(SOURCES) hlconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlconst_8080.bin: $(SOURCES) hlconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlconst_8085.bin: $(SOURCES) hlconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

hlconst_r4k.bin: $(SOURCES) hlconst.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

localrmw_r800.bin: $(SOURCES) localrmw.c
	$(compile_r800)
	$(runtest_r800)

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

csealias.bin: $(SOURCES) csealias.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

csealias_fp.bin: $(SOURCES) csealias.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

csealias_8080.bin: $(SOURCES) csealias.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

csealias_gbz80.bin: $(SOURCES) csealias.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

csealias_8085.bin: $(SOURCES) csealias.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

csealias_r4k.bin: $(SOURCES) csealias.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

csealias_ez80.bin: $(SOURCES) csealias.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmultgate.bin: $(SOURCES) longmultgate.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmultgate_fp.bin: $(SOURCES) longmultgate.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmultgate_8080.bin: $(SOURCES) longmultgate.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmultgate_gbz80.bin: $(SOURCES) longmultgate.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmultgate_8085.bin: $(SOURCES) longmultgate.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmultgate_r4k.bin: $(SOURCES) longmultgate.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmultgate_ez80.bin: $(SOURCES) longmultgate.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivpair.bin: $(SOURCES) ivpair.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivpair_fp.bin: $(SOURCES) ivpair.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivpair_r4k.bin: $(SOURCES) ivpair.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivpair_ez80.bin: $(SOURCES) ivpair.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivpair_z80n.bin: $(SOURCES) ivpair.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxstep.bin: $(SOURCES) idxstep.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxstep_fp.bin: $(SOURCES) idxstep.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxstep_r4k.bin: $(SOURCES) idxstep.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxstep_ez80.bin: $(SOURCES) idxstep.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxstep_z80n.bin: $(SOURCES) idxstep.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpkload.bin: $(SOURCES) cmpkload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpkload_fp.bin: $(SOURCES) cmpkload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpkload_8080.bin: $(SOURCES) cmpkload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpkload_gbz80.bin: $(SOURCES) cmpkload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpkload_r4k.bin: $(SOURCES) cmpkload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpkload_ez80.bin: $(SOURCES) cmpkload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpkload_z80n.bin: $(SOURCES) cmpkload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpkload_z180.bin: $(SOURCES) cmpkload.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addkreg.bin: $(SOURCES) addkreg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addkreg_fp.bin: $(SOURCES) addkreg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addkreg_8080.bin: $(SOURCES) addkreg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addkreg_gbz80.bin: $(SOURCES) addkreg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addkreg_r4k.bin: $(SOURCES) addkreg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addkreg_ez80.bin: $(SOURCES) addkreg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addkreg_z80n.bin: $(SOURCES) addkreg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

addkreg_z180.bin: $(SOURCES) addkreg.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_fp.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_8080.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_8085.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_gbz80.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_r4k.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_ez80.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_z80n.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_z180.bin: $(SOURCES) longmemrhs.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmemrhs_kc160.bin: $(SOURCES) longmemrhs.c
	$(compile_kc160)
	$(runtest_kc160)

longmemrhs_r2ka.bin: $(SOURCES) longmemrhs.c
	$(compile_r2ka)
	$(runtest_r2ka)

longmempark.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_fp.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_8080.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_8085.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_gbz80.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_r4k.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_ez80.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_z80n.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_z180.bin: $(SOURCES) longmempark.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longmempark_kc160.bin: $(SOURCES) longmempark.c
	$(compile_kc160)
	$(runtest_kc160)

longmempark_r2ka.bin: $(SOURCES) longmempark.c
	$(compile_r2ka)
	$(runtest_r2ka)

retmerge.bin: $(SOURCES) retmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retmerge_fp.bin: $(SOURCES) retmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retmerge_8080.bin: $(SOURCES) retmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retmerge_8085.bin: $(SOURCES) retmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retmerge_gbz80.bin: $(SOURCES) retmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retmerge_r4k.bin: $(SOURCES) retmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

retmerge_ez80.bin: $(SOURCES) retmerge.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_fp.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_8080.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_8085.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_gbz80.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_r4k.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_ez80.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_z80n.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_z180.bin: $(SOURCES) bytecleanup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecleanup_kc160.bin: $(SOURCES) bytecleanup.c
	$(compile_kc160)
	$(runtest_kc160)

bytecleanup_r2ka.bin: $(SOURCES) bytecleanup.c
	$(compile_r2ka)
	$(runtest_r2ka)

bcsavegrp.bin: $(SOURCES) bcsavegrp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bcsavegrp_fp.bin: $(SOURCES) bcsavegrp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bcsavegrp_8080.bin: $(SOURCES) bcsavegrp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bcsavegrp_gbz80.bin: $(SOURCES) bcsavegrp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bcsavegrp_r4k.bin: $(SOURCES) bcsavegrp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bcsavegrp_ez80.bin: $(SOURCES) bcsavegrp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bcsavegrp_z80n.bin: $(SOURCES) bcsavegrp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bcsavegrp_z180.bin: $(SOURCES) bcsavegrp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

downloop.bin: $(SOURCES) downloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

downloop_fp.bin: $(SOURCES) downloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

downloop_8080.bin: $(SOURCES) downloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

downloop_gbz80.bin: $(SOURCES) downloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

downloop_r4k.bin: $(SOURCES) downloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

downloop_ez80.bin: $(SOURCES) downloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

downloop_z80n.bin: $(SOURCES) downloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

downloop_z180.bin: $(SOURCES) downloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrescape.bin: $(SOURCES) ptrescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrescape_fp.bin: $(SOURCES) ptrescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrescape_8080.bin: $(SOURCES) ptrescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrescape_gbz80.bin: $(SOURCES) ptrescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrescape_8085.bin: $(SOURCES) ptrescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrescape_r4k.bin: $(SOURCES) ptrescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrescape_ez80.bin: $(SOURCES) ptrescape.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrfuzz.bin: $(SOURCES) ptrfuzz.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrfuzz_fp.bin: $(SOURCES) ptrfuzz.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrfuzz_8080.bin: $(SOURCES) ptrfuzz.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrfuzz_gbz80.bin: $(SOURCES) ptrfuzz.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrfuzz_8085.bin: $(SOURCES) ptrfuzz.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrfuzz_r4k.bin: $(SOURCES) ptrfuzz.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ptrfuzz_ez80.bin: $(SOURCES) ptrfuzz.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }


# Reduced programs from the differential fuzzer (see the comment in each file).
fuzz_1037.bin: $(SOURCES) fuzz_1037.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_1037_fp.bin: $(SOURCES) fuzz_1037.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_1039.bin: $(SOURCES) fuzz_1039.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_1039_fp.bin: $(SOURCES) fuzz_1039.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_161.bin: $(SOURCES) fuzz_161.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_161_fp.bin: $(SOURCES) fuzz_161.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_214.bin: $(SOURCES) fuzz_214.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_214_fp.bin: $(SOURCES) fuzz_214.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_2496.bin: $(SOURCES) fuzz_2496.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_2496_fp.bin: $(SOURCES) fuzz_2496.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_2734.bin: $(SOURCES) fuzz_2734.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_2734_fp.bin: $(SOURCES) fuzz_2734.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_232.bin: $(SOURCES) fuzz_232.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzz_232_fp.bin: $(SOURCES) fuzz_232.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

fuzzp_1232.bin: fuzzp_1232.c fuzzp_1232.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_1232.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_1232.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_1232_fp.bin: fuzzp_1232.c fuzzp_1232.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_1232.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_1232.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_1428.bin: fuzzp_1428.c fuzzp_1428.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_1428.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_1428.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_1428_fp.bin: fuzzp_1428.c fuzzp_1428.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_1428.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_1428.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_1478b.bin: fuzzp_1478b.c fuzzp_1478b.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_1478b.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_1478b.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_1478b_fp.bin: fuzzp_1478b.c fuzzp_1478b.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_1478b.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_1478b.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_325.bin: fuzzp_325.c fuzzp_325.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_325.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_325.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_325_fp.bin: fuzzp_325.c fuzzp_325.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_325.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_325.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_4735.bin: fuzzp_4735.c fuzzp_4735.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_4735.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_4735.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_4735_fp.bin: fuzzp_4735.c fuzzp_4735.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_4735.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_4735.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_6486.bin: fuzzp_6486.c fuzzp_6486.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_6486.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_6486.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_6486_fp.bin: fuzzp_6486.c fuzzp_6486.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_6486.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_6486.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_7421.bin: fuzzp_7421.c fuzzp_7421.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_7421.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_7421.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_7421_fp.bin: fuzzp_7421.c fuzzp_7421.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_7421.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_7421.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_k2_8085.bin: fuzzp_k2.c fuzzp_k2.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_k2.c -o $@ -m
	@$(MACHINE) -m8085 $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_k2.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_k2_8085_fp.bin: fuzzp_k2.c fuzzp_k2.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_k2.c -o $@ -m
	@$(MACHINE) -m8085 $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_k2.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_480_kc160.bin: fuzzp_480.c fuzzp_480.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=kc160  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_480.c -o $@ -m
	@$(MACHINE) -mkc160 $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_480.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_480_kc160_fp.bin: fuzzp_480.c fuzzp_480.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=kc160 -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_480.c -o $@ -m
	@$(MACHINE) -mkc160 $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_480.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_929_r6k.bin: fuzzp_929.c fuzzp_929.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit6k  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_929.c -o $@ -m
	@$(MACHINE) -mr6k $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_929.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_929_r6k_fp.bin: fuzzp_929.c fuzzp_929.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit6k -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_929.c -o $@ -m
	@$(MACHINE) -mr6k $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_929.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_5075_r2ka.bin: fuzzp_5075.c fuzzp_5075.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_5075.c -o $@ -m
	@$(MACHINE) -mr2ka $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_5075.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_5075_r2ka_fp.bin: fuzzp_5075.c fuzzp_5075.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_5075.c -o $@ -m
	@$(MACHINE) -mr2ka $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_5075.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_5629_z80n.bin: fuzzp_5629.c fuzzp_5629.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_5629.c -o $@ -m
	@$(MACHINE) -mz80n $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_5629.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_5629_z80n_fp.bin: fuzzp_5629.c fuzzp_5629.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_5629.c -o $@ -m
	@$(MACHINE) -mz80n $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_5629.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_327_kc160.bin: fuzzp_327.c fuzzp_327.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=kc160  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_327.c -o $@ -m
	@$(MACHINE) -mkc160 $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_327.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_327_kc160_fp.bin: fuzzp_327.c fuzzp_327.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=kc160 -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_327.c -o $@ -m
	@$(MACHINE) -mkc160 $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_327.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_351_r2ka.bin: fuzzp_351.c fuzzp_351.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_351.c -o $@ -m
	@$(MACHINE) -mr2ka $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_351.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_351_r2ka_fp.bin: fuzzp_351.c fuzzp_351.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_351.c -o $@ -m
	@$(MACHINE) -mr2ka $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_351.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_326_r2ka.bin: fuzzp_326.c fuzzp_326.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_326.c -o $@ -m
	@$(MACHINE) -mr2ka $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_326.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_326_r2ka_fp.bin: fuzzp_326.c fuzzp_326.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_326.c -o $@ -m
	@$(MACHINE) -mr2ka $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_326.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_7255.bin: fuzzp_7255.c fuzzp_7255.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_7255.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_7255.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_7255_fp.bin: fuzzp_7255.c fuzzp_7255.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_7255.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_7255.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_6302.bin: fuzzp_6302.c fuzzp_6302.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_6302.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_6302.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

fuzzp_6302_fp.bin: fuzzp_6302.c fuzzp_6302.want
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer  -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) fuzzp_6302.c -o $@ -m
	@$(MACHINE) -b msx $@ | tr -d '\r' | grep -v '^Ticks' | grep -v '^$$' | head -2 | diff - fuzzp_6302.want || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"

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

homeexit.bin: $(SOURCES) homeexit.c
	$(compile)
	$(runtest)

homeexit_fp.bin: $(SOURCES) homeexit.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

homeexit_8080.bin: $(SOURCES) homeexit.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

homeexit_gbz80.bin: $(SOURCES) homeexit.c
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

# A string-literal address (IR_LD_STR) is a rematerialisable constant: LICM no
# longer hoists it into a loop-long frame slot and a call argument no longer
# stores it to a slot only to reload it. See the file header.
strremat.bin: $(SOURCES) strremat.c
	$(compile)
	$(runtest)

strremat_fp.bin: $(SOURCES) strremat.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

strremat_8080.bin: $(SOURCES) strremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

strremat_gbz80.bin: $(SOURCES) strremat.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# A zero-argument near indirect call reads its target from HL, so the target's
# frame copy is not stored; every other position keeps its slot. See the file
# header.
fnptrdead.bin: $(SOURCES) fnptrdead.c
	$(compile)
	$(runtest)

fnptrdead_fp.bin: $(SOURCES) fnptrdead.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

fnptrdead_8080.bin: $(SOURCES) fnptrdead.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

fnptrdead_gbz80.bin: $(SOURCES) fnptrdead.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# A call argument with control flow (?:, &&, ||) no longer forces the earlier
# arguments through frame slots: pure argument lists are reordered so the pushes
# stay in one block. Impure lists keep left-to-right. See the file header.
argcf.bin: $(SOURCES) argcf.c
	$(compile)
	$(runtest)

argcf_fp.bin: $(SOURCES) argcf.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

argcf_8080.bin: $(SOURCES) argcf.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

argcf_gbz80.bin: $(SOURCES) argcf.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# An unconditional jump to the label directly below it is deleted in the final
# text (the shared return block is emitted last, so the block above it ends in
# one). Non-adjacent jumps stay. See the file header.
jpnext.bin: $(SOURCES) jpnext.c
	$(compile)
	$(runtest)

jpnext_fp.bin: $(SOURCES) jpnext.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

jpnext_8080.bin: $(SOURCES) jpnext.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

jpnext_gbz80.bin: $(SOURCES) jpnext.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# A BC temp may be defined by the very op that is the last read of an existing
# BC tenant (an index dying at its own shift), so the doubled value stays in BC
# instead of a frame slot. See the file header.
bchand.bin: $(SOURCES) bchand.c
	$(compile)
	$(runtest)

bchand_fp.bin: $(SOURCES) bchand.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

bchand_8080.bin: $(SOURCES) bchand.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bchand_gbz80.bin: $(SOURCES) bchand.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# An sp-mode function with a plain near indirect call no longer saves IX (the
# call never touches it); the fastcall dispatch still does. Z80 family only, and
# always built without the frame pointer: the test overwrites IX. See the file
# header.
ixind.bin: $(SOURCES) ixind.c $(JPTH)
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	$(runtest)

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

# idx2 live-range reuse: a non-overlapping param/counter pair sharing the
# slot, and an overlapping pair that must NOT share it.
all: idx2reuse.bin idx2reuse_fp.bin idx2reuse_keep.bin idx2reuse_fp_keep.bin idx2reuse_ez80.bin idx2reuse_ez80_fp.bin idx2reuse_ez80_fp_keep.bin idx2reuse_8080.bin idx2reuse_gbz80.bin

# IVSR induction pointer in idx2 (IX/IY): ez80/kc160/rabbit only, where
# ivsr_lftr's walking pointer now also homes in the index register.
all: ivsr_lftr_ez80.bin ivsr_lftr_ez80_fp.bin ivsr_lftr_kc160.bin ivsr_lftr_kc160_fp.bin ivsr_lftr_r4k.bin
all: ivsr_lftr_8080.bin ivsr_lftr_gbz80.bin ivsr_lftr_keep.bin
all: derearb.bin derearb_fp.bin derearb_8080.bin derearb_gbz80.bin derearb_keep.bin

# ez80 gates lifted once ticks priced ld rr,(ix+d) at 5: an sp index home
# across calls (cmp_sign, bytecmp), IVSR redundant-pointer suppression
# (ivsrsup), fp remat-lea (slotaddr). _keep restores all three exclusions.
all: ivsrsup_ez80.bin ivsrsup_ez80_fp.bin ivsrsup_ez80_keep.bin slotaddr_ez80_fp.bin slotaddr_ez80_fp_keep.bin cmp_sign_ez80.bin bytecmp_ez80.bin

ivsrsup_ez80.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_ez80_fp.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrsup_ez80_keep.bin: $(SOURCES) ivsrsup.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -Cc--opt-disable=idx2-call-ez80,ivsr-suppress-ez80,remat-lea-ez80fp --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotaddr_ez80_fp.bin: $(SOURCES) slotaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotaddr_ez80_fp_keep.bin: $(SOURCES) slotaddr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer -Cc--opt-disable=idx2-call-ez80,ivsr-suppress-ez80,remat-lea-ez80fp --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmp_sign_ez80.bin: $(SOURCES) cmp_sign.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytecmp_ez80.bin: $(SOURCES) bytecmp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# ez80 `ld hl,(hl)` word reads and the tos-rmw fold (push hl ... pop de
# cancelled around a stack-top read-modify-write); _keep variants opt out.
all: blayout_ez80.bin blayout_ez80_fp.bin blayout_ez80_ihl_keep.bin blayout_tosrmw_keep.bin blayout_tosrmw_8080_keep.bin

blayout_ez80.bin: $(SOURCES) blayout.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

blayout_ez80_fp.bin: $(SOURCES) blayout.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

blayout_ez80_ihl_keep.bin: $(SOURCES) blayout.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -Cc--opt-disable=ez80-hl-ihl --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

blayout_tosrmw_keep.bin: $(SOURCES) blayout.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=tos-rmw --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

blayout_tosrmw_8080_keep.bin: $(SOURCES) blayout.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -Cc--opt-disable=tos-rmw --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# remat-lea-call: &local rematerialised as a call argument counts the words
# [slot-bitop-de / mask-shl-a] post-render folds that replaced copt #285r / #285q.
all: postfold.bin postfold_fp.bin postfold_z180_fp.bin postfold_z80n_fp.bin postfold_ez80_fp.bin postfold_r4k_fp.bin postfold_keep.bin

postfold.bin: $(SOURCES) postfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

postfold_fp.bin: $(SOURCES) postfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

postfold_z180_fp.bin: $(SOURCES) postfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

postfold_z80n_fp.bin: $(SOURCES) postfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z80n -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz80n $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

postfold_ez80_fp.bin: $(SOURCES) postfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

postfold_r4k_fp.bin: $(SOURCES) postfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit4k -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr4k $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

postfold_keep.bin: $(SOURCES) postfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=slot-bitop-de -Cc--opt-disable=mask-shl-a -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# [#DE7 / reg-int-literal / hcall-commit / remat-imm32 / f32-prepush] register-tier floats.
# f32wide_de7: with hcall-commit off the f32->int result takes the TOS store,
# which copt #DE7 rewrites; c_twice reads DE after it.
all: f32wide.bin f32wide_fp.bin f32wide_mbf.bin f32wide_mbf_fp.bin f32wide_8085.bin f32wide_gbz80.bin f32wide_r2ka.bin f32wide_keep.bin f32wide_de7.bin

f32wide.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fp-mode=ieee --math16 --math32 -DHAVE_F16 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

f32wide_fp.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -fp-mode=ieee --math16 --math32 -DHAVE_F16 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

f32wide_mbf.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

f32wide_mbf_fp.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

f32wide_8085.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

f32wide_gbz80.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

f32wide_r2ka.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit -fframe-pointer --math32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

f32wide_keep.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=reg-int-literal -Cc--opt-disable=remat-imm32 -Cc--opt-disable=f32-prepush -fp-mode=ieee --math16 --math32 -DHAVE_F16 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

f32wide_de7.bin: $(SOURCES) f32wide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=hcall-commit -fp-mode=ieee --math16 --math32 -DHAVE_F16 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# [acc-drop-wide / acc-int-literal / acc-pool-operand] wide results read from the accumulator.
all: accwide.bin accwide_fp.bin accwide_keep.bin accwide_z180.bin accwide_r2ka.bin accwide_r2ka_fp.bin accwide_ez80.bin accwide_kc160.bin

accwide.bin: $(SOURCES) accwide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -lmath48 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accwide_fp.bin: $(SOURCES) accwide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -lmath48 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accwide_keep.bin: $(SOURCES) accwide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=acc-drop-wide -Cc--opt-disable=acc-int-literal -Cc--opt-disable=acc-pool-operand -lmath48 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accwide_z180.bin: $(SOURCES) accwide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-bbc -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accwide_r2ka.bin: $(SOURCES) accwide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-bbc -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accwide_r2ka_fp.bin: $(SOURCES) accwide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit -fframe-pointer --math-bbc -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accwide_ez80.bin: $(SOURCES) accwide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --genmath -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accwide_kc160.bin: $(SOURCES) accwide.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=kc160 -fframe-pointer --math-bbc -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mkc160 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# [prepush-straddle] a value defined inside a pre-pushed group and read after its call.
all: prestrad.bin prestrad_fp.bin prestrad_8080.bin prestrad_gbz80.bin prestrad_r2ka.bin prestrad_ez80.bin

prestrad.bin: $(SOURCES) prestrad.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

prestrad_fp.bin: $(SOURCES) prestrad.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

prestrad_8080.bin: $(SOURCES) prestrad.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

prestrad_gbz80.bin: $(SOURCES) prestrad.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

prestrad_r2ka.bin: $(SOURCES) prestrad.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

prestrad_ez80.bin: $(SOURCES) prestrad.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# [ivsr-ez80-byte] ez80 keeps walking pointers against a byte-bounded counter.
all: ivsrbyte.bin ivsrbyte_ez80.bin ivsrbyte_ez80_fp.bin ivsrbyte_ez80_keep.bin

ivsrbyte.bin: $(SOURCES) ivsrbyte.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrbyte_ez80.bin: $(SOURCES) ivsrbyte.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrbyte_ez80_fp.bin: $(SOURCES) ivsrbyte.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrbyte_ez80_keep.bin: $(SOURCES) ivsrbyte.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -Cc--opt-disable=ivsr-ez80-byte --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# already pushed; _keep restores the no-call gate.
all: remacall.bin remacall_fp.bin remacall_8080.bin remacall_gbz80.bin remacall_r2ka.bin remacall_ez80_fp.bin remacall_keep.bin

remacall.bin: $(SOURCES) remacall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

remacall_fp.bin: $(SOURCES) remacall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

remacall_8080.bin: $(SOURCES) remacall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

remacall_gbz80.bin: $(SOURCES) remacall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

remacall_r2ka.bin: $(SOURCES) remacall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

remacall_ez80_fp.bin: $(SOURCES) remacall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

remacall_keep.bin: $(SOURCES) remacall.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=remat-lea-call --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# ds-fp-store (dead word stores to (ix+d) dropped, never below the frame) and
# dead-sp-addr (unused `ld hl,N; add hl,sp`); _keep opts out of both.
all: dsfp.bin dsfp_fp.bin dsfp_8080.bin dsfp_gbz80.bin dsfp_ez80_fp.bin dsfp_z180_fp.bin dsfp_fp_keep.bin

dsfp.bin: $(SOURCES) dsfp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsfp_fp.bin: $(SOURCES) dsfp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsfp_8080.bin: $(SOURCES) dsfp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsfp_gbz80.bin: $(SOURCES) dsfp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsfp_ez80_fp.bin: $(SOURCES) dsfp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsfp_z180_fp.bin: $(SOURCES) dsfp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

dsfp_fp_keep.bin: $(SOURCES) dsfp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=ds-fp-store,dead-sp-addr --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# yield-total (byteshr on ez80), deref-width (derefw), de-keep-hl (idxderef
# on ez80 fp); _keep variants opt out.
all: byteshr_ez80.bin byteshr_ez80_yt_keep.bin derefw_z180_fp.bin derefw_dw_keep.bin idxderef_ez80_fp_dkh_keep.bin

byteshr_ez80.bin: $(SOURCES) byteshr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteshr_ez80_yt_keep.bin: $(SOURCES) byteshr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -Cc--opt-disable=yield-total --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

derefw_z180_fp.bin: $(SOURCES) derefw.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

derefw_dw_keep.bin: $(SOURCES) derefw.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=deref-width --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

idxderef_ez80_fp_dkh_keep.bin: $(SOURCES) idxderef.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer -Cc--opt-disable=de-keep-hl --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# A word home placed after a rejected DE pick is demoted when the restored
# tenant shares its pair (hist_pass hung on z80 fp).
all: latepair.bin latepair_fp.bin latepair_8080.bin

latepair.bin: $(SOURCES) latepair.c
	$(compile)
	$(runtest)

latepair_fp.bin: $(SOURCES) latepair.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

latepair_8080.bin: $(SOURCES) latepair.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# de-rearb: a rejected word DE-home pick, lowered again without a DE-class home.
derearb.bin: $(SOURCES) derearb.c
	$(compile)
	$(runtest)

derearb_fp.bin: $(SOURCES) derearb.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

derearb_8080.bin: $(SOURCES) derearb.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

derearb_gbz80.bin: $(SOURCES) derearb.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

derearb_keep.bin: $(SOURCES) derearb.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=de-rearb --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# 8085 BC word reload via LDSI+LHLX. 8080 is the no-LHLX control.
all: lhlxbc.bin lhlxbc_fp.bin lhlxbc_8085.bin lhlxbc_8085_fp.bin lhlxbc_8085_keep.bin lhlxbc_8080.bin
all: byteret.bin byteret_fp.bin byteret_8085.bin byteret_8085_fp.bin byteret_keep.bin byteret_8085_keep.bin byteret_fp_keep.bin

lhlxbc.bin: $(SOURCES) lhlxbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lhlxbc_fp.bin: $(SOURCES) lhlxbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lhlxbc_8085.bin: $(SOURCES) lhlxbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lhlxbc_8085_fp.bin: $(SOURCES) lhlxbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lhlxbc_8085_keep.bin: $(SOURCES) lhlxbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=lhlx-bc --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

lhlxbc_8080.bin: $(SOURCES) lhlxbc.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteret.bin: $(SOURCES) byteret.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteret_fp.bin: $(SOURCES) byteret.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteret_8085.bin: $(SOURCES) byteret.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteret_8085_fp.bin: $(SOURCES) byteret.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteret_keep.bin: $(SOURCES) byteret.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=byte-ret --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteret_fp_keep.bin: $(SOURCES) byteret.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=byte-ret --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

byteret_8085_keep.bin: $(SOURCES) byteret.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 -Cc--opt-disable=byte-ret --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

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

idx2reuse.bin: $(SOURCES) idx2reuse.c
	$(compile)
	$(runtest)

idx2reuse_fp.bin: $(SOURCES) idx2reuse.c
	$(call compile,-Cc-fframe-pointer)
	$(runtest)

idx2reuse_keep.bin: $(SOURCES) idx2reuse.c
	$(call compile,-Cc--opt-disable=idx2-reuse)
	$(runtest)

idx2reuse_fp_keep.bin: $(SOURCES) idx2reuse.c
	$(call compile,-Cc-fframe-pointer -Cc--opt-disable=idx2-reuse)
	$(runtest)

idx2reuse_ez80.bin: $(SOURCES) idx2reuse.c
	$(call compile_ez80_z80,)
	$(runtest_ez80_z80)

idx2reuse_ez80_fp.bin: $(SOURCES) idx2reuse.c
	$(call compile_ez80_z80,-Cc-fframe-pointer)
	$(runtest_ez80_z80)

idx2reuse_ez80_fp_keep.bin: $(SOURCES) idx2reuse.c
	$(call compile_ez80_z80,-Cc-fframe-pointer -Cc--opt-disable=idx2-reuse)
	$(runtest_ez80_z80)

idx2reuse_8080.bin: $(SOURCES) idx2reuse.c
	$(compile_8080)
	$(runtest_8080)

idx2reuse_gbz80.bin: $(SOURCES) idx2reuse.c
	$(compile_gbz80)
	$(runtest_gbz80)

# [dead-slot-drop] untouched frame slots dropped by a verified re-render;
# slotdrop_r2ka also takes the restore-the-slots fallback.
all: slotdrop.bin slotdrop_fp.bin slotdrop_gbz80.bin slotdrop_8080.bin slotdrop_z180_fp.bin slotdrop_r2ka.bin slotdrop_keep.bin

slotdrop.bin: $(SOURCES) slotdrop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotdrop_fp.bin: $(SOURCES) slotdrop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotdrop_gbz80.bin: $(SOURCES) slotdrop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotdrop_8080.bin: $(SOURCES) slotdrop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotdrop_z180_fp.bin: $(SOURCES) slotdrop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotdrop_r2ka.bin: $(SOURCES) slotdrop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

slotdrop_keep.bin: $(SOURCES) slotdrop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=dead-slot-drop -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# [small-frame-fast] 4-byte frames: ld hl,-4 form on z180, four dec sp on ez80/kc160.
all: smallframe.bin smallframe_z180.bin smallframe_z180_fp.bin smallframe_ez80_z80.bin smallframe_ez80_z80_fp.bin smallframe_kc160.bin smallframe_kc160_fp.bin smallframe_kc160_keep.bin smallframe_8080.bin smallframe_8085.bin smallframe_r800.bin

smallframe.bin: $(SOURCES) smallframe.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

smallframe_z180.bin: $(SOURCES) smallframe.c
	$(compile_z180)
	$(runtest_z180)

smallframe_z180_fp.bin: $(SOURCES) smallframe.c
	$(call compile_z180,-Cc-fframe-pointer)
	$(runtest_z180)

smallframe_ez80_z80.bin: $(SOURCES) smallframe.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

smallframe_ez80_z80_fp.bin: $(SOURCES) smallframe.c
	$(call compile_ez80_z80,-Cc-fframe-pointer)
	$(runtest_ez80_z80)

smallframe_kc160.bin: $(SOURCES) smallframe.c
	$(compile_kc160)
	$(runtest_kc160)

smallframe_kc160_fp.bin: $(SOURCES) smallframe.c
	$(call compile_kc160,-Cc-fframe-pointer)
	$(runtest_kc160)

smallframe_kc160_keep.bin: $(SOURCES) smallframe.c
	$(call compile_kc160,-Cc--opt-disable=small-frame-fast)
	$(runtest_kc160)

smallframe_8080.bin: $(SOURCES) smallframe.c
	$(compile_8080)
	$(runtest_8080)

smallframe_8085.bin: $(SOURCES) smallframe.c
	$(compile_8085)
	$(runtest_8085)

smallframe_r800.bin: $(SOURCES) smallframe.c
	$(compile_r800)
	$(runtest_r800)

# [ss-evidence] lazy-spill stores dropped when no slot read was emitted.
all: ssevid.bin ssevid_fp.bin ssevid_8080.bin ssevid_gbz80.bin ssevid_z180_fp.bin ssevid_r2ka.bin ssevid_keep.bin ssevid_ez80_fp.bin ssevid_kc160.bin ssevid_gbz80_keep.bin ssevid_byte_keep.bin

ssevid.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ssevid_fp.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ssevid_8080.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ssevid_gbz80.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ssevid_z180_fp.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ssevid_r2ka.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ssevid_keep.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -Cc--opt-disable=ss-evidence -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ssevid_ez80_fp.bin: $(SOURCES) ssevid.c
	$(call compile_ez80_z80,-Cc-fframe-pointer)
	$(runtest_ez80_z80)

ssevid_kc160.bin: $(SOURCES) ssevid.c
	$(compile_kc160)
	$(runtest_kc160)

ssevid_gbz80_keep.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 -Cc--opt-disable=ss-keep-hl -Cc--opt-disable=gb-hl-to-de -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ssevid_byte_keep.bin: $(SOURCES) ssevid.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -Cc--opt-disable=ss-byte -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# [trunc-store-bc] byte store of a truncated word counter, and the shapes that must not fuse.
all: trstore.bin trstore_fp.bin trstore_8080.bin trstore_gbz80.bin trstore_r2ka.bin trstore_ez80.bin trstore_ez80_fp.bin trstore_z180.bin

trstore.bin: $(SOURCES) trstore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

trstore_fp.bin: $(SOURCES) trstore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

trstore_8080.bin: $(SOURCES) trstore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

trstore_gbz80.bin: $(SOURCES) trstore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

trstore_r2ka.bin: $(SOURCES) trstore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

trstore_ez80.bin: $(SOURCES) trstore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

trstore_ez80_fp.bin: $(SOURCES) trstore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

trstore_z180.bin: $(SOURCES) trstore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }


# [self-ops] block-local value equivalence folds, and the shapes that must not fold.
all: selfops.bin selfops_fp.bin selfops_8080.bin selfops_gbz80.bin selfops_r2ka.bin selfops_ez80.bin selfops_z180.bin

selfops.bin: $(SOURCES) selfops.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

selfops_fp.bin: $(SOURCES) selfops.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

selfops_8080.bin: $(SOURCES) selfops.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

selfops_gbz80.bin: $(SOURCES) selfops.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

selfops_r2ka.bin: $(SOURCES) selfops.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

selfops_ez80.bin: $(SOURCES) selfops.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

selfops_z180.bin: $(SOURCES) selfops.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }


# [pair-bitop] word bit ops between register words, a DE-stepped counter, and dead/live loop exits.
all: pairbitop.bin pairbitop_fp.bin pairbitop_8080.bin pairbitop_gbz80.bin pairbitop_r2ka.bin pairbitop_ez80.bin pairbitop_z180.bin pairbitop_8085.bin

pairbitop.bin: $(SOURCES) pairbitop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

pairbitop_fp.bin: $(SOURCES) pairbitop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

pairbitop_8080.bin: $(SOURCES) pairbitop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

pairbitop_gbz80.bin: $(SOURCES) pairbitop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

pairbitop_r2ka.bin: $(SOURCES) pairbitop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

pairbitop_ez80.bin: $(SOURCES) pairbitop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

pairbitop_z180.bin: $(SOURCES) pairbitop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

pairbitop_8085.bin: $(SOURCES) pairbitop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }


# [ivsr-share] derived induction addresses that share a pointer, and ones that must not.
all: ivsrshare.bin ivsrshare_fp.bin ivsrshare_8080.bin ivsrshare_gbz80.bin ivsrshare_r2ka.bin ivsrshare_ez80.bin ivsrshare_z180.bin ivsrshare_8085.bin

ivsrshare.bin: $(SOURCES) ivsrshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrshare_fp.bin: $(SOURCES) ivsrshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrshare_8080.bin: $(SOURCES) ivsrshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrshare_gbz80.bin: $(SOURCES) ivsrshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrshare_r2ka.bin: $(SOURCES) ivsrshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrshare_ez80.bin: $(SOURCES) ivsrshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrshare_z180.bin: $(SOURCES) ivsrshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivsrshare_8085.bin: $(SOURCES) ivsrshare.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }


# [cmp-k-signed] signed word compare against a constant, byte-wise through A.
all: cmpks.bin cmpks_fp.bin cmpks_8080.bin cmpks_gbz80.bin cmpks_r2ka.bin cmpks_ez80.bin cmpks_z180.bin cmpks_8085.bin cmpks_vm1.bin

cmpks.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpks_fp.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpks_8080.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpks_gbz80.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpks_r2ka.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpks_ez80.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpks_z180.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpks_8085.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8085 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8085 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

cmpks_vm1.bin: $(SOURCES) cmpks.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=vm1 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mvm1 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }


# [iv-narrow-unsigned] byte-narrowed loop counters compared unsigned, around the 127/128 and 254/255 edges.
all: ivnu.bin ivnu_fp.bin ivnu_8080.bin ivnu_gbz80.bin ivnu_r2ka.bin ivnu_ez80.bin ivnu_z180.bin

ivnu.bin: $(SOURCES) ivnu.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivnu_fp.bin: $(SOURCES) ivnu.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivnu_8080.bin: $(SOURCES) ivnu.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=8080 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -m8080 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivnu_gbz80.bin: $(SOURCES) ivnu.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=gbz80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mgbz80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivnu_r2ka.bin: $(SOURCES) ivnu.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=rabbit --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mr2ka $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivnu_ez80.bin: $(SOURCES) ivnu.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=ez80_z80 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mez80_z80 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

ivnu_z180.bin: $(SOURCES) ivnu.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -clib=z180 --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) -mz180 $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

# Rabbit 2000/3000 have no `sub hl,de` (z80asm makes it a helper call).
rabsub.bin: $(SOURCES) rabsub.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

rabsub_r2ka.bin: $(SOURCES) rabsub.c
	$(compile_r2ka)
	$(runtest_r2ka)

rabsub_r4k.bin: $(SOURCES) rabsub.c
	$(compile_r4k)
	$(runtest_r4k)

rabsub_asm.bin: rabsub.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -mr2ka -I$(FRAMEWORK_DIR) -S $< -o rabsub_r2ka.asm
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -mr4k -I$(FRAMEWORK_DIR) -S $< -o rabsub_r4k.asm
	@test `grep -c 'sub[[:space:]]*hl,de' rabsub_r2ka.asm` -eq 0 || { echo "$(RED)" `date +%H:%M:%S` " Test failure: sub hl,de on r2ka $(RESET)" ; exit 1; }
	@test `grep -c 'sub[[:space:]]*hl,de' rabsub_r4k.asm` -ge 1 || { echo "$(RED)" `date +%H:%M:%S` " Test failure: no native sub hl,de on r4k $(RESET)" ; exit 1; }
	@rm -f rabsub_r2ka.asm rabsub_r4k.asm

# Relaxation size model: exact on z80/r2ka, loose on ez80/kc160/r4k in a
# function with an __asm block.
jrtight.bin: $(SOURCES) jrtight.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

jrtight_r2ka.bin: $(SOURCES) jrtight.c
	$(compile_r2ka)
	$(runtest_r2ka)

jrtight_ez80.bin: $(SOURCES) jrtight.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

jrtight_kc160.bin: $(SOURCES) jrtight.c
	$(compile_kc160)
	$(runtest_kc160)

jrtight_asm.bin: jrtight.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -mz80 -I$(FRAMEWORK_DIR) -S $< -o jrtight_z80.asm
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -mr2ka -I$(FRAMEWORK_DIR) -S $< -o jrtight_r2ka.asm
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -mez80_z80 -I$(FRAMEWORK_DIR) -S $< -o jrtight_ez80.asm
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -mkc160 -I$(FRAMEWORK_DIR) -S $< -o jrtight_kc160.asm
	@for c in z80 r2ka; do test `grep -c '^[[:space:]]*jr[[:space:]]*z,' jrtight_$$c.asm` -ge 1 || { echo "$(RED)" `date +%H:%M:%S` " Test failure: branch not relaxed on $$c $(RESET)" ; exit 1; }; done
	@for c in ez80 kc160; do test `grep -c '^[[:space:]]*jp[[:space:]]*z,' jrtight_$$c.asm` -ge 1 || { echo "$(RED)" `date +%H:%M:%S` " Test failure: asm function relaxed on $$c $(RESET)" ; exit 1; }; done
	@rm -f jrtight_z80.asm jrtight_r2ka.asm jrtight_ez80.asm jrtight_kc160.asm

smod.bin: $(SOURCES) smod.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

smod_8080.bin: $(SOURCES) smod.c
	$(compile_8080)
	$(runtest_8080)

smod_gbz80.bin: $(SOURCES) smod.c
	$(compile_gbz80)
	$(runtest_gbz80)

smod_r2ka.bin: $(SOURCES) smod.c
	$(compile_r2ka)
	$(runtest_r2ka)

smod_ez80.bin: $(SOURCES) smod.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

smod_kc160.bin: $(SOURCES) smod.c
	$(compile_kc160)
	$(runtest_kc160)

smod_8085.bin: $(SOURCES) smod.c
	$(compile_8085)
	$(runtest_8085)

smod_fp.bin: $(SOURCES) smod.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

blockfn.bin: $(SOURCES) blockfn.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

blockfn_8080.bin: $(SOURCES) blockfn.c
	$(compile_8080)
	$(runtest_8080)

blockfn_gbz80.bin: $(SOURCES) blockfn.c
	$(compile_gbz80)
	$(runtest_gbz80)

blockfn_r2ka.bin: $(SOURCES) blockfn.c
	$(compile_r2ka)
	$(runtest_r2ka)

blockfn_ez80.bin: $(SOURCES) blockfn.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

blockfn_8085.bin: $(SOURCES) blockfn.c
	$(compile_8085)
	$(runtest_8085)

blockfn_fp.bin: $(SOURCES) blockfn.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accintcomp.bin: $(SOURCES) accintcomp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

accintcomp_fp.bin: $(SOURCES) accintcomp.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bigframe.bin: $(SOURCES) bigframe.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bigframe_fp.bin: $(SOURCES) bigframe.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bigframe_8080.bin: $(SOURCES) bigframe.c
	$(compile_8080)
	$(runtest_8080)

bigframe_r2ka.bin: $(SOURCES) bigframe.c
	$(compile_r2ka)
	$(runtest_r2ka)

bigframe_ez80.bin: $(SOURCES) bigframe.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

bigframe_gbz80.bin: $(SOURCES) bigframe.c
	$(compile_gbz80)
	$(runtest_gbz80)

longasr.bin: $(SOURCES) longasr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

longasr_8080.bin: $(SOURCES) longasr.c
	$(compile_8080)
	$(runtest_8080)

longasr_gbz80.bin: $(SOURCES) longasr.c
	$(compile_gbz80)
	$(runtest_gbz80)

longasr_r2ka.bin: $(SOURCES) longasr.c
	$(compile_r2ka)
	$(runtest_r2ka)

longasr_ez80.bin: $(SOURCES) longasr.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

longasr_8085.bin: $(SOURCES) longasr.c
	$(compile_8085)
	$(runtest_8085)

longasr_kc160.bin: $(SOURCES) longasr.c
	$(compile_kc160)
	$(runtest_kc160)

longasr_z180.bin: $(SOURCES) longasr.c
	$(compile_z180)
	$(runtest_z180)

longasr_r4k.bin: $(SOURCES) longasr.c
	$(compile_r4k)
	$(runtest_r4k)

longasr_fp.bin: $(SOURCES) longasr.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

crcloop.bin: $(SOURCES) crcloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

crcloop_8080.bin: $(SOURCES) crcloop.c
	$(compile_8080)
	$(runtest_8080)

crcloop_gbz80.bin: $(SOURCES) crcloop.c
	$(compile_gbz80)
	$(runtest_gbz80)

crcloop_r2ka.bin: $(SOURCES) crcloop.c
	$(compile_r2ka)
	$(runtest_r2ka)

crcloop_ez80.bin: $(SOURCES) crcloop.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

crcloop_8085.bin: $(SOURCES) crcloop.c
	$(compile_8085)
	$(runtest_8085)

crcloop_kc160.bin: $(SOURCES) crcloop.c
	$(compile_kc160)
	$(runtest_kc160)

crcloop_z180.bin: $(SOURCES) crcloop.c
	$(compile_z180)
	$(runtest_z180)

crcloop_r4k.bin: $(SOURCES) crcloop.c
	$(compile_r4k)
	$(runtest_r4k)

crcloop_fp.bin: $(SOURCES) crcloop.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

zxfold.bin: $(SOURCES) zxfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

zxfold_8080.bin: $(SOURCES) zxfold.c
	$(compile_8080)
	$(runtest_8080)

zxfold_gbz80.bin: $(SOURCES) zxfold.c
	$(compile_gbz80)
	$(runtest_gbz80)

zxfold_r2ka.bin: $(SOURCES) zxfold.c
	$(compile_r2ka)
	$(runtest_r2ka)

zxfold_ez80.bin: $(SOURCES) zxfold.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

zxfold_8085.bin: $(SOURCES) zxfold.c
	$(compile_8085)
	$(runtest_8085)

zxfold_kc160.bin: $(SOURCES) zxfold.c
	$(compile_kc160)
	$(runtest_kc160)

zxfold_z180.bin: $(SOURCES) zxfold.c
	$(compile_z180)
	$(runtest_z180)

zxfold_r4k.bin: $(SOURCES) zxfold.c
	$(compile_r4k)
	$(runtest_r4k)

zxfold_fp.bin: $(SOURCES) zxfold.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytestore.bin: $(SOURCES) bytestore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

bytestore_8080.bin: $(SOURCES) bytestore.c
	$(compile_8080)
	$(runtest_8080)

bytestore_gbz80.bin: $(SOURCES) bytestore.c
	$(compile_gbz80)
	$(runtest_gbz80)

bytestore_r2ka.bin: $(SOURCES) bytestore.c
	$(compile_r2ka)
	$(runtest_r2ka)

bytestore_ez80.bin: $(SOURCES) bytestore.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

bytestore_8085.bin: $(SOURCES) bytestore.c
	$(compile_8085)
	$(runtest_8085)

bytestore_kc160.bin: $(SOURCES) bytestore.c
	$(compile_kc160)
	$(runtest_kc160)

bytestore_z180.bin: $(SOURCES) bytestore.c
	$(compile_z180)
	$(runtest_z180)

bytestore_r4k.bin: $(SOURCES) bytestore.c
	$(compile_r4k)
	$(runtest_r4k)

bytestore_fp.bin: $(SOURCES) bytestore.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

foldshift.bin: $(SOURCES) foldshift.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER))  --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

foldshift_8080.bin: $(SOURCES) foldshift.c
	$(compile_8080)
	$(runtest_8080)

foldshift_gbz80.bin: $(SOURCES) foldshift.c
	$(compile_gbz80)
	$(runtest_gbz80)

foldshift_r2ka.bin: $(SOURCES) foldshift.c
	$(compile_r2ka)
	$(runtest_r2ka)

foldshift_ez80.bin: $(SOURCES) foldshift.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

foldshift_8085.bin: $(SOURCES) foldshift.c
	$(compile_8085)
	$(runtest_8085)

foldshift_kc160.bin: $(SOURCES) foldshift.c
	$(compile_kc160)
	$(runtest_kc160)

foldshift_z180.bin: $(SOURCES) foldshift.c
	$(compile_z180)
	$(runtest_z180)

foldshift_r4k.bin: $(SOURCES) foldshift.c
	$(compile_r4k)
	$(runtest_r4k)

foldshift_fp.bin: $(SOURCES) foldshift.c
	zcc +test -vn $(if $(COMPILER),-compiler=$(COMPILER)) -fframe-pointer --math-mbf32 -DNO_LOG_RUNNING -DNO_LOG_PASSED -I$(FRAMEWORK_DIR) $^ -o $@ -m
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }

