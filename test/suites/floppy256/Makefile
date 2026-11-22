include ../make.config

SRC = test_floppy.c f256_hook.asm ../minifat/bss_ram.asm \
	../../../libsrc/classic/floppy/floppy256_xfer.asm \
	../../../libsrc/classic/floppy/floppy256_minifat.asm

SRCZ = $(SRC) $(wildcard ../../../libsrc/classic/minifat/z80/*.asm)
SRC85 = $(SRC) $(wildcard ../../../libsrc/classic/minifat/8085/*.asm)
SRC80 = $(SRC) $(wildcard ../../../libsrc/classic/minifat/8080/*.asm)
SRCGB = $(SRC) $(wildcard ../../../libsrc/classic/minifat/gbz80/*.asm)
SRCVM = $(SRC) $(wildcard ../../../libsrc/classic/minifat/vm1/*.asm)

all: floppy.bin floppy85.bin floppy80.bin floppygb.bin floppyvm.bin

define run_cpu
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting test $(RESET)"
	@$(MACHINE) -b msx $(1) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"
endef

floppy.bin: $(SRCZ)
	$(call compile,-Ca-I../../../libsrc/classic/minifat/z80,)
	$(call run_cpu,-mz80)

floppy85.bin: $(SRC85)
	$(call compile_8085,-Ca-I../../../libsrc/classic/minifat/8085)
	$(call run_cpu,-m8085)

floppy80.bin: $(SRC80)
	$(call compile_8080,-Ca-I../../../libsrc/classic/minifat/8080)
	$(call run_cpu,-m8080)

floppygb.bin: $(SRCGB)
	$(call compile_gbz80,-Ca-I../../../libsrc/classic/minifat/gbz80)
	$(call run_cpu,-mgbz80)

floppyvm.bin: $(SRCVM)
	$(call compile_vm1,-Ca-I../../../libsrc/classic/minifat/vm1)
	$(call run_cpu,-mvm1)

clean:
	rm -f floppy.bin floppy85.bin floppy80.bin floppygb.bin floppyvm.bin \
		*.map zcc_opt.def *~
