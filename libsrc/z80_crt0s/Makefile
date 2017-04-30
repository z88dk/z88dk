#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

all: $(OUTPUT_DIRECTORY)/z80_crt0.lib $(OUTPUT_DIRECTORY)/rcmx000_crt0.lib $(OUTPUT_DIRECTORY)/z80iy_crt0.lib $(OUTPUT_DIRECTORY)/z80s183_crt0.lib


$(OUTPUT_DIRECTORY)/z80_crt0.lib:
	$(MAKE) clean
	$(LIBLINKER) -I. -x$@ @crt0.lst

$(OUTPUT_DIRECTORY)/rcmx000_crt0.lib:
	$(MAKE) clean
	$(LIBLINKER) -I. --RCMX000 -x$@ @rcm.lst

# this one uses iy in place of ix
$(OUTPUT_DIRECTORY)/z80iy_crt0.lib:
	$(MAKE) clean
	$(LIBLINKER) -I. --IXIY -DZ80S183 -x$@ @crt0.lst
	$(MAKE) clean

$(OUTPUT_DIRECTORY)/z80s183_crt0.lib:
	$(MAKE) clean
	$(LIBLINKER) -I. -DZ80S183 -x$(OUTPUT_DIRECTORY)/z80s183_crt0 @crt0.lst


clean:
	$(RM) crt0/*.o* crt0/*.sym crt0/*.map 
	$(RM) crt0_fp/*.o* crt0_fp/*.sym crt0_fp/*.map 
	$(RM) crt0_rcm/*.o* crt0_rcm/*.sym crt0_rcm/*.map 
	$(RM) crt0_long/*.o* crt0_long/*.sym crt0_long/*.map 
	$(RM) z80_emu/*.o* z80_emu/*.sym z80_emu/*.map 
	$(RM) crt0_sdcc/*.o* crt0_sdcc/*.sym crt0_sdcc/*.map 
