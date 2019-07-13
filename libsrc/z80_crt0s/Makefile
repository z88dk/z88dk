#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

all: $(OUTPUT_DIRECTORY)/z80_crt0.lib $(OUTPUT_DIRECTORY)/rcmx000_crt0.lib $(OUTPUT_DIRECTORY)/z80iy_crt0.lib $(OUTPUT_DIRECTORY)/z80s183_crt0.lib $(OUTPUT_DIRECTORY)/z180_crt0.lib $(OUTPUT_DIRECTORY)/ez80_crt0.lib $(OUTPUT_DIRECTORY)/8080_crt0.lib


$(OUTPUT_DIRECTORY)/z80_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -x$@ @crt0.lst

$(OUTPUT_DIRECTORY)/8080_crt0.lib:
	@$(MAKE) clean
	$(LIBLINKER) -I.. -x$@ -DCPU_8080 @crt0_8080.lst

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
	@$(RM) crt0/*.o* crt0/*.sym crt0/*.map 
	@$(RM) crt0_fp/*.o* crt0_fp/*.sym crt0_fp/*.map 
	@$(RM) crt0_rcm/*.o* crt0_rcm/*.sym crt0_rcm/*.map 
	@$(RM) crt0_long/*.o* crt0_long/*.sym crt0_long/*.map 
	@$(RM) z80_emu/*.o* z80_emu/*.sym z80_emu/*.map 
	@$(RM) crt0_sdcc/*.o* crt0_sdcc/*.sym crt0_sdcc/*.map 
	@$(RM) crt0_z180/*.o* crt0_z180/*.sym crt0_z180/*.map 
	@$(RM) ../_DEVELOPMENT/z80/z80/*.o
	@$(RM) ../_DEVELOPMENT/l/z80/*.o
	@$(RM) ../_DEVELOPMENT/l/sdcc/*.o
	@$(RM) ../_DEVELOPMENT/math/integer/*.o
	@$(RM) ../_DEVELOPMENT/math/integer/fast/*.o
	@$(RM) ../_DEVELOPMENT/math/integer/small/*.o
