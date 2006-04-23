#
# Wahey, a messed up makefile for building libraries!
#


default:
	echo You must specify a target...
	echo Valid targets are: spectrum

spectrum: 
	z80asm -d -ns -nm -Mo -x../../../../lib/clibs/sp1 @spectrum.lst
	cp spectrum-sp1.h ../../../../include/sprites/sp1.h

clean:


