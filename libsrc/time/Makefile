#
# Wahey, a messed up makefile for building libraries!
#


lz88: time z88_time

lzx: spectrum_time

time:
	zcc -vn -D__Z88__ -make-lib gmtime.c
	zcc -vn -D__Z88__ -make-lib localtime.c

z88_time:
	cd z88 ; make

spectrum_time:
	cd spectrum ; make

clean:
	rm -f *.o* *.i *.sym *.map zcc_opt.def
	cd z88 ; make clean
	cd spectrum ; make clean
