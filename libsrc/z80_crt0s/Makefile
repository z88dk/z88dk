#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

all: crt0s crtz80s183


crt0s:
	@$(RM) crt0_long/l_long_case.o
	$(LIBLINKER) -x../z80_crt0 @crt0list

crtz80s183:
	@$(RM) crt0_long/l_long_case.o
	$(LIBLINKER) -DZ80S183 -x../z80s183_crt0 @crt0list


clean:
	$(RM) crt0/*.o* crt0/*.sym crt0/*.map 
	$(RM) crt0_long/*.o* crt0_long/*.sym crt0_long/*.map 
