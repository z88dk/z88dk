include ../make.config

SRCZ = test_minifat.c ide_ram.asm bss_ram.asm bios_disk.asm redteam_wipe.asm \
	../../../libsrc/classic/minifat/z80/fatfs.asm

SRC85 = test_minifat.c ide_ram_8085.asm bss_ram.asm bios_disk_85.asm redteam_wipe.asm \
	../../../libsrc/classic/minifat/8085/fatfs.asm

all: minifat.bin minifat85.bin

minifat.bin: $(SRCZ)
	$(call compile,)
	$(runtest)

minifat85.bin: $(SRC85)
	$(call compile_8085,)
	$(runtest_8085)

clean:
	rm -f minifat.bin minifat85.bin *.map zcc_opt.def *~
