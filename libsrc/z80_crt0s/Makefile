#
# Wahey, a messed up makefile for building libraries!
#


all: crt0s


crt0s:
	z80asm -d -ns -nm -Mo -x../z80_crt0 @crt0list


clean:
	rm -f */*.obj */*.sym */*.map */*.o
