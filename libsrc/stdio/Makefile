#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2001-04-30 16:49:55 dom Exp $
#

generic: std gen

lz88: std gen z88_x

lz88net: std net z88_x

net:
	zcc -vn -DNET_STDIO -make-lib fclose.c
	zcc -vn -DNET_STDIO -make-lib fgetc.c
	zcc -vn -DNET_STDIO -make-lib fputc.c
	zcc -vn -DNET_STDIO -make-lib freopen_z88.c
	zcc -vn -DNET_STDIO -make-lib fflush.c
	cd zsock ; make

gen:
	zcc -vn -make-lib fclose.c
	zcc -vn -make-lib fgetc.c
	zcc -vn -make-lib fputc.c
	zcc -vn -make-lib freopen_z88.c


std:    closeall.o fchkstd.o feof.o fgetpos.o fgets.o fopen.o fputs.o \
	fwrite.o fread.o freopen.o fopen_z88.o fseek.o ftell.o  \
	vfprintf_mini.o printn.o puts.o ungetc.o fdopen.o printk.o \
	fgets_cons.o fabandon.o


z88_x:
	cd z88 ; make

.c.o:
	zcc -vn -make-lib $*.c

clean:
	rm -f *.o* *.sym *.map zcc_opt.def
	cd z88 ; make clean
	cd zsock ; make clean
