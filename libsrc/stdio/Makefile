#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.11 2002-10-02 09:38:57 dom Exp $
#

STDCFILES = \
	closeall.c \
	fabandon.c \
	fchkstd.c \
	fdopen.c \
	feof.c \
	fgetpos.c \
	fgets.c \
	fgets_cons.c \
	fopen.c \
	fopen_z88.c \
	fputs.c \
	freopen.c \
	fseek.c \
	ftell.c \
	fwrite.c \
	printk.c \
	printn.c \
	puts.c \
	ungetc.c \
	vfprintf_mini.c

GENCFILES = \
	fclose.c \
	fgetc.c \
	fputc.c \
	freopen_z88.c \
	fread.c 

NETCFILES = $(GENCFILES) \
	fflush.c

#	stdio_fp.c

AFILES  = $(STDCFILES:.c=.asm) $(NETCFILES:.c=.asm)
STDOBJECTS = $(STDCFILES:.c=.o)
GENCOBJECTS = $(GENCFILES:.c=.o)

generic: std gen

lcpm: std cpm

lz88: std gen z88_x

lz88net: std net z88_x

net:
	zcc -vn -DNET_STDIO -make-lib fclose.c
	zcc -vn -DNET_STDIO -make-lib fgetc.c
	zcc -vn -DNET_STDIO -make-lib fputc.c
	zcc -vn -DNET_STDIO -make-lib freopen_z88.c
	zcc -vn -DNET_STDIO -make-lib fflush.c
	zcc -vn -DNET_STDIO -make-lib fread.c
	cd zsock ; $(MAKE)

cpm:	$(GENCOBJECTS)
	zcc -vn -D__CPM__ -make-lib fclose.c
	zcc -vn -D__CPM__ -make-lib fgetc.c
	zcc -vn -D__CPM__ -make-lib fputc.c
	zcc -vn -D__CPM__ -make-lib freopen_z88.c
	zcc -vn -D__CPM__ -make-lib fread.c


gen:
	zcc -vn -make-lib fclose.c
	zcc -vn -make-lib fgetc.c
	zcc -vn -make-lib fputc.c
	zcc -vn -make-lib freopen_z88.c
	zcc -vn -make-lib fread.c
	cd 8080; $(MAKE)

std:    $(STDOBJECTS)

z88_x:
	cd z88 ; $(MAKE)

.c.o:
	zcc -vn -make-lib $*.c

clean:
	rm -f *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	rm -f ansi/*.o
	rm -f ansi/abc80/*.o
	rm -f ansi/ace/*.o
	rm -f ansi/aquarius/*.o
	rm -f ansi/c128/*.o
	rm -f ansi/generic/*.o
	rm -f ansi/sharp-mz/*.o
	rm -f ansi/spectrum/*.o
	rm -f ansi/vz200/*.o
	rm -f ansi/z88/*.o
	rm -f ansi/zx81/*.o
	rm -f abc80/*.o
	rm -f ace/*.o
	rm -f aquarius/*.o
	rm -f c128/*.o
	rm -f cpc/*.o
	rm -f cpm/*.o
	rm -f m5/*.o
	rm -f msx/*.o
	rm -f mz/*.o
	rm -f nc100/*.o
	rm -f sam/*.o
	rm -f spectrum/*.o
	rm -f svi/*.o
	rm -f vz200/*.o
	rm -f z88/*.o
	rm -f zx81/*.o

	cd zsock ; $(MAKE) clean
	cd 8080 ; $(MAKE) clean
