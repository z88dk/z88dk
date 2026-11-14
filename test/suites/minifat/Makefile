include ../make.config

# One host image. The five CPU runs are serial and each recreates it.
IDEIMG = /tmp/minifat-ide.img

SRC = test_minifat.c ide_ticks.asm bss_ram.asm redteam_wipe.asm

SRCZ = $(SRC) $(wildcard ../../../libsrc/classic/minifat/z80/*.asm)
SRC85 = $(SRC) $(wildcard ../../../libsrc/classic/minifat/8085/*.asm)
SRC80 = $(SRC) $(wildcard ../../../libsrc/classic/minifat/8080/*.asm)
SRCGB = $(SRC) $(wildcard ../../../libsrc/classic/minifat/gbz80/*.asm)
SRCVM = $(SRC) $(wildcard ../../../libsrc/classic/minifat/vm1/*.asm)

all: minifat.bin minifat85.bin minifat80.bin minifatgb.bin minifatvm.bin

define run_ide
	dd if=/dev/zero of=$(IDEIMG) bs=512 count=48 status=none
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting test $(RESET)"
	@$(MACHINE) -b msx $(1) -ide0 $(IDEIMG) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"
endef

minifat.bin: $(SRCZ)
	$(call compile,-Ca-I../../../libsrc/classic/minifat/z80 -DMINIFAT_API=1,)
	$(call run_ide,-mz80)

minifat85.bin: $(SRC85)
	$(call compile_8085,-Ca-I../../../libsrc/classic/minifat/8085 -DMINIFAT_API=1)
	$(call run_ide,-m8085)

minifat80.bin: $(SRC80)
	$(call compile_8080,-Ca-I../../../libsrc/classic/minifat/8080 -DMINIFAT_API=1)
	$(call run_ide,-m8080)

minifatgb.bin: $(SRCGB)
	$(call compile_gbz80,-Ca-I../../../libsrc/classic/minifat/gbz80 -DMINIFAT_API=1)
	$(call run_ide,-mgbz80)

minifatvm.bin: $(SRCVM)
	$(call compile_vm1,-Ca-I../../../libsrc/classic/minifat/vm1 -DMINIFAT_API=1)
	$(call run_ide,-mvm1)

clean:
	rm -f minifat.bin minifat85.bin minifat80.bin minifatgb.bin minifatvm.bin \
		*.map zcc_opt.def *~
