# configure these if needed
RASM	= ~/src/spectrum/rasm/rasm.exe
DISARK	= '/home/jorgegv/src/spectrum/arkos/Arkos Tracker 2/tools/Disark'

ARKOS2Z88DK = ./arkos-to-z88dk.pl

# intermediate files
PASMO_ASM = pasmo_arkos2.asm
ARKOS_MSX_RAM_ASM = asm_arkos2_msx_ram.asm
ARKOS_MSX_ROM_ASM = asm_arkos2_msx_rom.asm
ARKOS_ZX_RAM_ASM = asm_arkos2_zx_ram.asm

# targets
.SILENT:
.PHONY: clean all-players

generate-all-players: clean
	make $(ARKOS_MSX_RAM_ASM)
	make $(ARKOS_MSX_ROM_ASM)
	make $(ARKOS_ZX_RAM_ASM)
	mv -f $(ARKOS_MSX_RAM_ASM) $(ARKOS_MSX_ROM_ASM) $(ARKOS_ZX_RAM_ASM) ../libsrc

# convert Arkos RASM player source to relocatable Z88DK asm player
# reference: "Source conversion with Disark" article:
# https://www.julien-nevo.com/arkostracker/index.php/source-conversion-with-disark/

# Player conversion to Z88DK asm
# Makefile targets for different hardware targets and player configurations

# MSX, running in RAM (self-modifying code), ~3300 bytes
$(ARKOS_MSX_RAM_ASM):
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_MSX = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1" >> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) $(PASMO_ASM) > $(ARKOS_MSX_RAM_ASM)

# MSX, running in ROM (small buffer in RAM, slightly larger player code), ~3800 bytes
$(ARKOS_MSX_ROM_ASM):
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_MSX = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1" >> conf_PlayerAkg.asm
	echo "PLY_AKG_ROM = 1" 			>> conf_PlayerAkg.asm
	echo "PLY_AKG_ROM_Buffer = #c000" 	>> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) $(PASMO_ASM) > $(ARKOS_MSX_ROM_ASM)

# ZX, running in RAM (self-modifying code), ~3300 bytes
$(ARKOS_ZX_RAM_ASM):
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_SPECTRUM = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1"	>> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) $(PASMO_ASM) > $(ARKOS_ZX_RAM_ASM)

clean:
	@-rm conf_PlayerAkg.asm *.lis *.bin *.tap *.o *.sym $(PASMO_ASM) 2>/dev/null
