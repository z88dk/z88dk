include ../make.config

SRCZ = test_minifat.c ide_ram.asm bss_ram.asm bios_disk.asm redteam_wipe.asm \
	$(wildcard ../../../libsrc/classic/minifat/z80/*.asm)

SRC85 = test_minifat.c ide_ram_8085.asm bss_ram.asm bios_disk_85.asm redteam_wipe.asm \
	$(wildcard ../../../libsrc/classic/minifat/8085/*.asm)

SRC80 = test_minifat.c ide_ram_8080.asm bss_ram.asm bios_disk_80.asm redteam_wipe.asm \
	$(wildcard ../../../libsrc/classic/minifat/8080/*.asm)

SRCGB = test_minifat.c ide_ram_gb.asm bss_ram.asm bios_disk_gb.asm redteam_wipe.asm \
	$(wildcard ../../../libsrc/classic/minifat/gbz80/*.asm)

SRCVM = test_minifat.c ide_ram_vm1.asm bss_ram.asm bios_disk_vm1.asm redteam_wipe.asm \
	$(wildcard ../../../libsrc/classic/minifat/vm1/*.asm)

all: minifat.bin minifat85.bin minifat80.bin minifatgb.bin minifatvm.bin

# Not part of all. CI runs the suite without an IDE image.
# CPU flag comes before the binary. One image, so the five runs are serial.
IDEIMG = /tmp/minifat-ide.img

IDEZ = test_idehook.c ide_ticks.asm bss_ram.asm \
	$(wildcard ../../../libsrc/classic/minifat/z80/*.asm)

IDE85 = test_idehook.c ide_ticks.asm bss_ram.asm \
	$(wildcard ../../../libsrc/classic/minifat/8085/*.asm)

IDE80 = test_idehook.c ide_ticks.asm bss_ram.asm \
	$(wildcard ../../../libsrc/classic/minifat/8080/*.asm)

IDEGB = test_idehook.c ide_ticks.asm bss_ram.asm \
	$(wildcard ../../../libsrc/classic/minifat/gbz80/*.asm)

IDEVM = test_idehook.c ide_ticks.asm bss_ram.asm \
	$(wildcard ../../../libsrc/classic/minifat/vm1/*.asm)

idehook: idehook.bin idehook85.bin idehook80.bin idehookgb.bin idehookvm.bin

idehook.bin: $(IDEZ)
	$(call compile,-Ca-I../../../libsrc/classic/minifat/z80,)
	dd if=/dev/zero of=$(IDEIMG) bs=512 count=64 status=none
	$(MACHINE) -mz80 -ide0 $(IDEIMG) $@

idehook85.bin: $(IDE85)
	$(call compile_8085,-Ca-I../../../libsrc/classic/minifat/8085)
	dd if=/dev/zero of=$(IDEIMG) bs=512 count=64 status=none
	$(MACHINE) -m8085 -ide0 $(IDEIMG) $@

idehook80.bin: $(IDE80)
	$(call compile_8080,-Ca-I../../../libsrc/classic/minifat/8080)
	dd if=/dev/zero of=$(IDEIMG) bs=512 count=64 status=none
	$(MACHINE) -m8080 -ide0 $(IDEIMG) $@

idehookgb.bin: $(IDEGB)
	$(call compile_gbz80,-Ca-I../../../libsrc/classic/minifat/gbz80)
	dd if=/dev/zero of=$(IDEIMG) bs=512 count=64 status=none
	$(MACHINE) -mgbz80 -ide0 $(IDEIMG) $@

idehookvm.bin: $(IDEVM)
	$(call compile_vm1,-Ca-I../../../libsrc/classic/minifat/vm1)
	dd if=/dev/zero of=$(IDEIMG) bs=512 count=64 status=none
	$(MACHINE) -mvm1 -ide0 $(IDEIMG) $@

minifat.bin: $(SRCZ)
	$(call compile,-Ca-I../../../libsrc/classic/minifat/z80 -DMINIFAT_API=1,)
	$(runtest)

minifat85.bin: $(SRC85)
	$(call compile_8085,-Ca-I../../../libsrc/classic/minifat/8085 -DMINIFAT_API=1)
	$(runtest_8085)

minifat80.bin: $(SRC80)
	$(call compile_8080,-Ca-I../../../libsrc/classic/minifat/8080 -DMINIFAT_API=1)
	$(runtest_8080)

minifatgb.bin: $(SRCGB)
	$(call compile_gbz80,-Ca-I../../../libsrc/classic/minifat/gbz80 -DMINIFAT_API=1)
	$(runtest_gbz80)

minifatvm.bin: $(SRCVM)
	$(call compile_vm1,-Ca-I../../../libsrc/classic/minifat/vm1 -DMINIFAT_API=1)
	$(runtest_vm1)

clean:
	rm -f minifat.bin minifat85.bin minifat80.bin minifatgb.bin minifatvm.bin \
		idehook.bin idehook85.bin idehook80.bin idehookgb.bin idehookvm.bin \
		*.map zcc_opt.def *~
