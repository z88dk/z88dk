#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.23 2007-11-08 14:11:50 stefano Exp $
#

include ../Make.config

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

lcpm: std gen cpm

lz88: std gen z88_x

lz88net: std net z88_x


net:
	zcc $(CFLAGS) -DNET_STDIO fclose.c
	zcc $(CFLAGS) -DNET_STDIO fgetc.c
	zcc $(CFLAGS) -DNET_STDIO fputc.c
	zcc $(CFLAGS) -DNET_STDIO freopen_z88.c
	zcc $(CFLAGS) -DNET_STDIO fflush.c
	zcc $(CFLAGS) -DNET_STDIO fread.c
	cd zsock ; $(MAKE) ; cd ..

cpm:	$(GENCOBJECTS)
	zcc $(CFLAGS) -D__CPM__ fclose.c
	zcc $(CFLAGS) -D__CPM__ fgetc.c
	zcc $(CFLAGS) -D__CPM__ fputc.c
	zcc $(CFLAGS) -D__CPM__ freopen_z88.c
	zcc $(CFLAGS) -D__CPM__ fread.c


gen:
	zcc $(CFLAGS) fclose.c
	zcc $(CFLAGS) fgetc.c
	zcc $(CFLAGS) fputc.c
	zcc $(CFLAGS) freopen_z88.c
	zcc $(CFLAGS) fread.c
	cd 8080; $(MAKE) ; cd ..

std:    $(STDOBJECTS)

generic_iy:
#stdc
	zcc $(CFLAGS) -Ca-IXIY closeall.c
	zcc $(CFLAGS) -Ca-IXIY fabandon.c
	zcc $(CFLAGS) -Ca-IXIY fchkstd.c
	zcc $(CFLAGS) -Ca-IXIY fdopen.c
	zcc $(CFLAGS) -Ca-IXIY feof.c
	zcc $(CFLAGS) -Ca-IXIY fgetpos.c
	zcc $(CFLAGS) -Ca-IXIY fgets.c
	zcc $(CFLAGS) -Ca-IXIY fgets_cons.c
	zcc $(CFLAGS) -Ca-IXIY fopen.c
	zcc $(CFLAGS) -Ca-IXIY fopen_z88.c
	zcc $(CFLAGS) -Ca-IXIY fputs.c
	zcc $(CFLAGS) -Ca-IXIY freopen.c
	zcc $(CFLAGS) -Ca-IXIY fseek.c
	zcc $(CFLAGS) -Ca-IXIY ftell.c
	zcc $(CFLAGS) -Ca-IXIY gets.c
	zcc $(CFLAGS) -Ca-IXIY fwrite.c
	zcc $(CFLAGS) -Ca-IXIY printk.c
	zcc $(CFLAGS) -Ca-IXIY printn.c
	zcc $(CFLAGS) -Ca-IXIY puts.c
	zcc $(CFLAGS) -Ca-IXIY ungetc.c
	zcc $(CFLAGS) -Ca-IXIY vfprintf_mini.c
#gen
	zcc $(CFLAGS) -Ca-IXIY fclose.c
	zcc $(CFLAGS) -Ca-IXIY fgetc.c
	zcc $(CFLAGS) -Ca-IXIY fputc.c
	zcc $(CFLAGS) -Ca-IXIY freopen_z88.c
	zcc $(CFLAGS) -Ca-IXIY fread.c

z88_x:
	cd z88 ; $(MAKE) ; cd ..

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	$(RM) ansi/*.o
	$(RM) ansi/abc80/*.o
	$(RM) ansi/ace/*.o
	$(RM) ansi/aquarius/*.o
	$(RM) ansi/c128/*.o
	$(RM) ansi/cpc/*.o
	$(RM) ansi/generic/*.o
	$(RM) ansi/nascom/*.o
	$(RM) ansi/oz/*.o
	$(RM) ansi/sam/*.o
	$(RM) ansi/sharp-mz/*.o
	$(RM) ansi/spectrum/*.o
	$(RM) ansi/ts2068/*.o
	$(RM) ansi/sprinter/*.o
	$(RM) ansi/vz200/*.o
	$(RM) ansi/z88/*.o
	$(RM) ansi/zx81/*.o
	$(RM) abc80/*.o
	$(RM) abc800/*.o
	$(RM) ace/*.o
	$(RM) aquarius/*.o
	$(RM) c128/*.o
	$(RM) cpc/*.o
	$(RM) cpm/*.o
	$(RM) m5/*.o
	$(RM) msx/*.o
	$(RM) mz/*.o
	$(RM) nascom/*.o
	$(RM) nc100/*.o
	$(RM) newbrain/*.o
	$(RM) oz/*.o
	$(RM) sam/*.o
	$(RM) spectrum/*.o
	$(RM) ts2068/*.o
	$(RM) sprinter/*.o
	$(RM) svi/*.o
	$(RM) vz200/*.o
	$(RM) z88/*.o
	$(RM) zx81/*.o
	$(RM) rcmx000/*.o
	cd zsock ; $(MAKE) clean ; cd ..
	cd 8080 ; $(MAKE) clean ; cd ..
