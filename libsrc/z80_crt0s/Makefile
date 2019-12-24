#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

all: $(OUTPUT_DIRECTORY)/z80_crt0.lib $(OUTPUT_DIRECTORY)/rcmx000_crt0.lib $(OUTPUT_DIRECTORY)/z80iy_crt0.lib $(OUTPUT_DIRECTORY)/z80s183_crt0.lib $(OUTPUT_DIRECTORY)/z180_crt0.lib $(OUTPUT_DIRECTORY)/ez80_crt0.lib $(OUTPUT_DIRECTORY)/8080_crt0.lib $(OUTPUT_DIRECTORY)/gbz80_crt0.lib


$(OUTPUT_DIRECTORY)/z80_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -x$@ @crt0.lst

$(OUTPUT_DIRECTORY)/8080_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -x$@ -DCPU_8080 -m8080 @crt0_8080.lst

$(OUTPUT_DIRECTORY)/gbz80_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -x$@ -DCPU_GBZ80 -mgbz80 @crt0_gbz80.lst

$(OUTPUT_DIRECTORY)/z180_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -x$@ -mz180 @crt0_z180.lst

$(OUTPUT_DIRECTORY)/ez80_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -x$@ -mz180 -DEZ80 @crt0_ez80.lst

$(OUTPUT_DIRECTORY)/rcmx000_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -mr2k -x$@ @rcm.lst

# this one uses iy in place of ix
$(OUTPUT_DIRECTORY)/z80iy_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. --IXIY -D__SDCC_IX -DZ80S183 -x$@ @crt0.lst
	$(MAKE) clean

$(OUTPUT_DIRECTORY)/z80s183_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -DZ80S183 -x$(OUTPUT_DIRECTORY)/z80s183_crt0 @crt0.lst


clean:
	@$(RM) z80/sccz80/*.o z80/sdcc/*.o
	@$(RM) gbz80/sccz80/*.o gbz80/sdcc/*.o
	@$(RM) z180/sccz80/*.o r2k/sccz80/*.o
	@$(RM) 8080/sccz80/*.o 
	@$(RM) ../_DEVELOPMENT/l/z80/*.o
	@$(RM) ../_DEVELOPMENT/l/z80/*/*.o
	@$(RM) ../_DEVELOPMENT/l/z80/*/*/*.o
	@$(RM) ../_DEVELOPMENT/l/z80/*/*/*/*.o
	@$(RM) ../_DEVELOPMENT/l/sdcc/*.o
	@$(RM) ../_DEVELOPMENT/error/z80/*.o
	@$(RM) ../_DEVELOPMENT/math/integer/*.o
	@$(RM) ../_DEVELOPMENT/math/integer/fast/*.o
	@$(RM) ../_DEVELOPMENT/math/integer/small/*.o
