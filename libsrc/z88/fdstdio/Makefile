#
# Wahey, a messed up makefile for building libraries!
#


all: fdstdio


fdstdio:
	zcc -make-lib -vn fdfread.c
	zcc -make-lib -vn fdfwrite.c
	zcc -make-lib -vn fchkhdl.c
	zcc -make-lib -vn fdprintn.c
	zcc -make-lib -vn zfdopen.c
	zcc -make-lib -vn zfdopen_z88.c


clean:
	rm -f *.o*  *.sym *.map zcc_opt.def
