#
# Wahey, a messed up makefile for building libraries!
#


all: crt0s crtz80s183


crt0s:
	@rm -f crt0_long/l_long_case.o
	z80asm -d -ns -nm -Mo -x../z80_crt0 @crt0list

crtz80s183:
	@rm -f crt0_long/l_long_case.o
	z80asm -d -DZ80S183 -ns -nm -Mo -x../z80s183_crt0 @crt0list


clean:
	rm -f crt0/*.o* crt0/*.sym crt0/*.map 
	rm -f crt0_long/*.o* crt0_long/*.sym crt0_long/*.map 
