#
# Makefile for far malloc
#



all:
	cd strings; make
	z80asm -d -ns -nm -Mo -x../farz88 @farz88.lst

clean:
	rm -f *.o *~
	cd strings; make clean
