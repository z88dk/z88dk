#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.16 2003-01-26 17:39:48 dom Exp $
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
	gets.c  \
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
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	$(RM) ansi/*.o
	$(RM) ansi/abc80/*.o
	$(RM) ansi/ace/*.o
	$(RM) ansi/aquarius/*.o
	$(RM) ansi/c128/*.o
	$(RM) ansi/generic/*.o
	$(RM) ansi/oz/*.o
	$(RM) ansi/sharp-mz/*.o
	$(RM) ansi/spectrum/*.o
	$(RM) ansi/sprinter/*.o
	$(RM) ansi/vz200/*.o
	$(RM) ansi/z88/*.o
	$(RM) ansi/zx81/*.o
	$(RM) abc80/*.o
	$(RM) ace/*.o
	$(RM) aquarius/*.o
	$(RM) c128/*.o
	$(RM) cpc/*.o
	$(RM) cpm/*.o
	$(RM) m5/*.o
	$(RM) msx/*.o
	$(RM) mz/*.o
	$(RM) nc100/*.o
	$(RM) oz/*.o
	$(RM) sam/*.o
	$(RM) spectrum/*.o
	$(RM) sprinter/*.o
	$(RM) svi/*.o
	$(RM) vz200/*.o
	$(RM) z88/*.o
	$(RM) zx81/*.o

	cd zsock ; $(MAKE) clean
	cd 8080 ; $(MAKE) clean
