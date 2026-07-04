include ../make.config

# $(SOURCES) is the framework (test.c) from make.config. Each suite .c
# has its own main(), so build one binary per suite rather than globbing
# every *.c into a single binary (two mains would collide; long_ir.c is
# also already at the MSX 64K ceiling).
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED -lmath48 -lmath16

# fnptr-dispatch thunks (l_jpix/l_jpiy), linked explicitly until they live in
# the lib — needed by fastcall AND __sdcccall(1) function-pointer calls.
JPTH = ../../../libsrc/l/sccz80/9-common/l_jpix.asm ../../../libsrc/l/sccz80/9-common/l_jpiy.asm

all:	test.bin test_gbz80.bin test_8080.bin test_8085.bin irgaps.bin irgaps_gbz80.bin irgaps_8080.bin irgaps_8085.bin structval.bin structval_gbz80.bin structval_8080.bin structval_8085.bin fixed.bin sdcccall.bin sdcccall_kc160.bin wr.bin wr_fp.bin fp_promote.bin fp_promote_reg.bin fp_promote_f48f16.bin fp_promote_accum.bin aggregate_init.bin fnptr_fastcall.bin faslot.bin libcall_abi.bin const_mult.bin cmp_gt.bin cmp_sign.bin remat.bin longlong.bin bitfield.bin umaxd.bin fp_to_int.bin

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

fp_to_int.bin: $(SOURCES) fp_to_int.c
	$(compile)
	$(runtest)

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
	$(call compile,-Cc-frameix)
	$(runtest)

fp_promote.bin: $(SOURCES) fp_promote.c
	$(compile)
	$(runtest)

# Register-tier floats (f16 + IEEE-32) need their own math libs + mode, so it
# can't share the default -lmath48 CFLAGS — explicit recipe.
fp_promote_reg.bin: $(SOURCES) fp_promote_reg.c
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
