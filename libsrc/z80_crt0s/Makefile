#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

all: crt0s crtz80s183 crt0iy


crt0s:
	@$(RM) crt0_long/l_long_case.o
	$(LIBLINKER) -I. -x$(OUTPUT_DIRECTORY)/z80_crt0 @crt0list
	$(LIBLINKER) -I. -x$(OUTPUT_DIRECTORY)/rcmx000_crt0 @rcm.lst

# this one uses iy in place of ix
crt0iy:
	$(MAKE) clean
	@$(RM) crt0_long/l_long_case.o
	$(LIBLINKER) -I. --IXIY -DZ80S183 -x$(OUTPUT_DIRECTORY)/z80iy_crt0 @crt0list
	$(MAKE) clean

crtz80s183:
	@$(RM) crt0_long/l_long_case.o
	$(LIBLINKER) -I. -DZ80S183 -x$(OUTPUT_DIRECTORY)/z80s183_crt0 @crt0list


clean:
	$(RM) crt0/*.o* crt0/*.sym crt0/*.map 
	$(RM) crt0_long/*.o* crt0_long/*.sym crt0_long/*.map 
	$(RM) z80_emu/*.o* z80_emu/*.sym z80_emu/*.map 
	$(RM) crt0_sdcc/*.o* crt0_sdcc/*.sym crt0_sdcc/*.map 
