#
# Wahey, a messed up makefile for building libraries!
#

generic: std gen

lz88: std gen z88_x

lz88net: std net z88_x

net:
	zcc -vn -DNET_STDIO -make-lib fabandon.c
	zcc -vn -DNET_STDIO -make-lib fclose.c
	zcc -vn -DNET_STDIO -make-lib fgetc.c
	zcc -vn -DNET_STDIO -make-lib fputc.c
	zcc -vn -DNET_STDIO -make-lib freopen_z88.c
	zcc -vn -DNET_STDIO -make-lib fflush.c
	cd zsock ; make

gen:
	zcc -vn -make-lib fabandon.c
	zcc -vn -make-lib fclose.c
	zcc -vn -make-lib fgetc.c
	zcc -vn -make-lib fputc.c
	zcc -vn -make-lib freopen_z88.c
	zcc -vn -make-lib fgets_cons.c


std:
	zcc -vn -make-lib closeall.c
	zcc -vn -make-lib fchkstd.c
	zcc -vn -make-lib feof.c
	zcc -vn -make-lib fgetpos.c
	zcc -vn -make-lib fgets.c
	zcc -vn -make-lib fopen.c
	zcc -vn -make-lib fputs.c
	zcc -vn -make-lib fread.c
	zcc -vn -make-lib freopen.c
	zcc -vn -make-lib fopen_z88.c
	zcc -vn -make-lib fseek.c
	zcc -vn -make-lib ftell.c
	zcc -vn -make-lib fwrite.c
	zcc -vn -make-lib vfprintf_mini.c
	zcc -vn -make-lib printn.c
	zcc -vn -make-lib puts.c
	zcc -vn -make-lib ungetc.c
	zcc -vn -make-lib fdopen.c
	zcc -vn -make-lib printk.c

z88_x:
	cd z88 ; make

clean:
	rm -f *.o* *.sym *.map zcc_opt.def
	cd z88 ; make clean
	cd zsock ; make clean
