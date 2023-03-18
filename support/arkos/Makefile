# We expect rasm and Diskarg to be in the path, if not fully qualify these lines
RASM	= rasm.exe
DISARK	= Disark

# tool where the magic happens :-)
ARKOS2Z88DK = ./arkos-to-z88dk.pl

# intermediate and target files
PASMO_ASM = pasmo_arkos2.asm
ARKOS_MSX_SMC_ASM = asm_arkos_msx_smc.asm
ARKOS_MSX_ROM_ASM = asm_arkos_msx_rom.asm
ARKOS_ZX_SMC_ASM = asm_arkos_zx_smc.asm
ARKOS_ZX_ROM_ASM = asm_arkos_zx_rom.asm
ARKOS_CPC_SMC_ASM = asm_arkos_cpc_smc.asm
ARKOS_CPC_ROM_ASM = asm_arkos_cpc_rom.asm

PLAYERS = $(ARKOS_MSX_SMC_ASM) $(ARKOS_MSX_ROM_ASM) $(ARKOS_ZX_SMC_ASM) $(ARKOS_ZX_ROM_ASM) $(ARKOS_CPC_SMC_ASM) $(ARKOS_CPC_ROM_ASM)

# targets
.SILENT:
.PHONY: clean all update-all-players update-all-players-classic update-all-players-newlib

all: $(PLAYERS) update-all-players

update-all-players: $(PLAYERS)
	cp -f $(ARKOS_MSX_SMC_ASM) ../../libsrc/target/msx/psg			# classic
	cp -f $(ARKOS_MSX_ROM_ASM) ../../libsrc/target/msx/psg
	cp -f $(ARKOS_ZX_SMC_ASM) ../../libsrc/target/zx/psg
	cp -f $(ARKOS_ZX_ROM_ASM) ../../libsrc/target/zx/psg
	cp -f $(ARKOS_CPC_SMC_ASM) ../../libsrc/target/cpc/psg
	cp -f $(ARKOS_CPC_ROM_ASM) ../../libsrc/target/cpc/psg
	cp -f $(ARKOS_ZX_SMC_ASM) ../../libsrc/_DEVELOPMENT/arch/zx/arkos	# newlib
	cp -f $(ARKOS_ZX_ROM_ASM) ../../libsrc/_DEVELOPMENT/arch/zx/arkos
	cp -f $(ARKOS_ZX_SMC_ASM) ../../libsrc/_DEVELOPMENT/arch/zxn/arkos
	cp -f $(ARKOS_ZX_ROM_ASM) ../../libsrc/_DEVELOPMENT/arch/zxn/arkos

# convert Arkos RASM player source to relocatable Z88DK asm player
# reference: "Source conversion with Disark" article:
# https://www.julien-nevo.com/arkostracker/index.php/source-conversion-with-disark/

# Player conversion to Z88DK asm
# Makefile targets for different hardware targets and player configurations

# MSX, running in RAM (self-modifying code), ~3300 bytes
$(ARKOS_MSX_SMC_ASM): PlayerAkg.asm arkos-to-z88dk.pl
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_MSX = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1" >> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) -t msx $(PASMO_ASM) > $@

# MSX, running in ROM (small buffer in SMC, slightly larger player code), ~3500 bytes ROM code, ~270 bytes RAM vars
$(ARKOS_MSX_ROM_ASM): PlayerAkg.asm arkos-to-z88dk.pl
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_MSX = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1" >> conf_PlayerAkg.asm
	echo "PLY_AKG_ROM = 1" 			>> conf_PlayerAkg.asm
	echo "PLY_AKG_ROM_Buffer = #c000" 	>> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) -t msx -r $(PASMO_ASM) > $@

# ZX, running in RAM (self-modifying code), ~3300 bytes
$(ARKOS_ZX_SMC_ASM):  PlayerAkg.asm arkos-to-z88dk.pl
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_SPECTRUM = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1"	>> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) -t zx $(PASMO_ASM) > $@

# ZX, running in ROM ~3500 bytes ROM code, ~270 bytes RAM vars
$(ARKOS_ZX_ROM_ASM):  PlayerAkg.asm arkos-to-z88dk.pl
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_SPECTRUM = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1"	>> conf_PlayerAkg.asm
	echo "PLY_AKG_ROM = 1" 			>> conf_PlayerAkg.asm
	echo "PLY_AKG_ROM_Buffer = #c000" 	>> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) -t zx -r $(PASMO_ASM) > $@

# CPC running in RAM (self-modifying code), ~3400 bytes
$(ARKOS_CPC_SMC_ASM):  PlayerAkg.asm arkos-to-z88dk.pl
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_CPC = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1"	>> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) -t zx $(PASMO_ASM) > $@

# CPC, running in ROM ~3600 bytes ROM code, ~270 bytes RAM vars
$(ARKOS_CPC_ROM_ASM):  PlayerAkg.asm arkos-to-z88dk.pl
	-rm -f conf_PlayerAkg.asm 2>/dev/null
	echo "PLY_AKG_HARDWARE_CPC = 1" 	>> conf_PlayerAkg.asm
	echo "PLY_AKG_MANAGE_SOUND_EFFECTS = 1"	>> conf_PlayerAkg.asm
	echo "PLY_AKG_ROM = 1" 			>> conf_PlayerAkg.asm
	echo "PLY_AKG_ROM_Buffer = #c000" 	>> conf_PlayerAkg.asm
	cat PlayerAkg.asm 			>> conf_PlayerAkg.asm
	$(RASM) conf_PlayerAkg.asm -o AT2Player -s -sl -sq
	$(DISARK) AT2Player.bin $(PASMO_ASM) --symbolFile AT2Player.sym --sourceProfile pasmo
	$(ARKOS2Z88DK) -t zx -r $(PASMO_ASM) > $@

clean:
	@-rm conf_PlayerAkg.asm *.lis *.bin *.tap *.o *.sym $(PASMO_ASM) $(PLAYERS) 2>/dev/null
