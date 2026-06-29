include ../make.config

# $(SOURCES) is the framework (test.c) from make.config. Each suite .c
# has its own main(), so build one binary per suite rather than globbing
# every *.c into a single binary (two mains would collide; long_ir.c is
# also already at the MSX 64K ceiling).
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED -lmath48 -lmath16

all:	test.bin wr.bin fp_promote.bin fp_promote_reg.bin fp_promote_f48f16.bin fp_promote_accum.bin aggregate_init.bin fnptr_fastcall.bin faslot.bin libcall_abi.bin const_mult.bin cmp_gt.bin longlong.bin bitfield.bin umaxd.bin fp_to_int.bin

test.bin: $(SOURCES) long_ir.c
	$(compile)
	$(runtest)

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

# fnptr-fastcall dispatch thunks (l_jpix/l_jpiy) linked explicitly until the lib
# carries them; drop the .asm prereqs once they are in the standard lib.
JPTH = ../../../libsrc/l/sccz80/9-common/l_jpix.asm ../../../libsrc/l/sccz80/9-common/l_jpiy.asm
fnptr_fastcall.bin: $(SOURCES) fnptr_fastcall.c $(JPTH)
	$(compile)
	$(runtest)
