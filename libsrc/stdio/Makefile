#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.46 2014-07-21 12:39:53 stefano Exp $
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
	fputs_callee.c \
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
	fputc_callee.c \
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
	zcc +z88 $(CFLAGS) -DNET_STDIO fclose.c
	zcc +z88 $(CFLAGS) -DNET_STDIO fgetc.c
	zcc +z88 $(CFLAGS) -DNET_STDIO fputc_callee.c
	zcc +z88 $(CFLAGS) -DNET_STDIO freopen_z88.c
	zcc +z88 $(CFLAGS) -DNET_STDIO fflush.c
	zcc +z88 $(CFLAGS) -DNET_STDIO fread.c
	cd zsock ; $(MAKE) ; cd ..


# It can't be +cpm, otherwise the bin output filename
# could be forced to 'a.com' !!
cpm:	$(GENCOBJECTS)
	zcc +test $(CFLAGS) -D__CPM__ fclose.c
	zcc +test $(CFLAGS) -D__CPM__ fgetc.c
	zcc +test $(CFLAGS) -D__CPM__ fputc_callee.c
	zcc +test $(CFLAGS) -D__CPM__ freopen_z88.c
	zcc +test $(CFLAGS) -D__CPM__ fread.c


gen:
	zcc +test $(CFLAGS) fclose.c
	zcc +test $(CFLAGS) fgetc.c
	zcc +test $(CFLAGS) fputc_callee.c
	zcc +test $(CFLAGS) freopen_z88.c
	zcc +test $(CFLAGS) fread.c
	cd 8080; $(MAKE) ; cd ..

std:    $(STDOBJECTS)

generic_iy:
#stdc
	zcc +test $(CFLAGS) -Ca-IXIY closeall.c
	zcc +test $(CFLAGS) -Ca-IXIY fabandon.c
	zcc +test $(CFLAGS) -Ca-IXIY fchkstd.c
	zcc +test $(CFLAGS) -Ca-IXIY fdopen.c
	zcc +test $(CFLAGS) -Ca-IXIY feof.c
	zcc +test $(CFLAGS) -Ca-IXIY fgetpos.c
	zcc +test $(CFLAGS) -Ca-IXIY fgets.c
	zcc +test $(CFLAGS) -Ca-IXIY fgets_cons.c
	zcc +test $(CFLAGS) -Ca-IXIY fopen.c
	zcc +test $(CFLAGS) -Ca-IXIY fopen_z88.c
	zcc +test $(CFLAGS) -Ca-IXIY fputs_callee.c
	zcc +test $(CFLAGS) -Ca-IXIY freopen.c
	zcc +test $(CFLAGS) -Ca-IXIY fseek.c
	zcc +test $(CFLAGS) -Ca-IXIY ftell.c
	zcc +test $(CFLAGS) -Ca-IXIY fwrite.c
	zcc +test $(CFLAGS) -Ca-IXIY printk.c
	zcc +test $(CFLAGS) -Ca-IXIY printn.c
	zcc +test $(CFLAGS) -Ca-IXIY puts.c
	zcc +test $(CFLAGS) -Ca-IXIY ungetc.c
	zcc +test $(CFLAGS) -Ca-IXIY vfprintf_mini.c
#gen
	zcc +test $(CFLAGS) -Ca-IXIY fclose.c
	zcc +test $(CFLAGS) -Ca-IXIY fgetc.c
	zcc +test $(CFLAGS) -Ca-IXIY fputc_callee.c
	zcc +test $(CFLAGS) -Ca-IXIY freopen_z88.c
	zcc +test $(CFLAGS) -Ca-IXIY fread.c

z88_x:
	cd z88 ; $(MAKE) ; cd ..

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	$(RM) ansi/*.o
	$(RM) ansi/abc80/*.o
	$(RM) ansi/ace/*.o
	$(RM) ansi/aquarius/*.o
	$(RM) ansi/c128/*.o
	$(RM) ansi/cpc/*.o
	$(RM) ansi/generic/*.o
	$(RM) ansi/mc1000/*.o
	$(RM) ansi/nascom/*.o
	$(RM) ansi/oz/*.o
	$(RM) ansi/osca/*.o
	$(RM) ansi/p2000/*.o
	$(RM) ansi/pc6001/*.o
	$(RM) ansi/sam/*.o
	$(RM) ansi/sharp-mz/*.o
	$(RM) ansi/spectrum/*.o
	$(RM) ansi/ts2068/*.o
	$(RM) ansi/sprinter/*.o
	$(RM) ansi/vg5k/*.o
	$(RM) ansi/vz200/*.o
	$(RM) ansi/x1/*.o
	$(RM) ansi/z88/*.o
	$(RM) ansi/zx81/*.o
	$(RM) abc80/*.o
	$(RM) abc800/*.o
	$(RM) ace/*.o
	$(RM) aquarius/*.o
	$(RM) c128/*.o
	$(RM) cpc/*.o
	$(RM) cpm/*.o
	$(RM) enterprise/*.o
	$(RM) gal/*.o
	$(RM) lynx/*.o
	$(RM) m5/*.o
	$(RM) mc1000/*.o
	$(RM) msx/*.o
	$(RM) mtx/*.o
	$(RM) mz/*.o
	$(RM) nascom/*.o
	$(RM) nc100/*.o
	$(RM) newbrain/*.o
	$(RM) osca/*.o
	$(RM) oz/*.o
	$(RM) p2000/*.o
	$(RM) pc6001/*.o
	$(RM) sam/*.o
	$(RM) sms/*.o
	$(RM) sos/*.o
	$(RM) sorcerer/*.o
	$(RM) spectrum/*.o
	$(RM) test/*.o
	$(RM) ticalc/*.o
	$(RM) trs80/*.o
	$(RM) ts2068/*.o
	$(RM) sprinter/*.o
	$(RM) svi/*.o
	$(RM) sc3000/*.o
	$(RM) vz200/*.o
	$(RM) vg5k/*.o
	$(RM) x07/*.o
	$(RM) x1/*.o
	$(RM) z88/*.o
	$(RM) zx80/*.o
	$(RM) zx81/*.o
	$(RM) rcmx000/*.o
	cd zsock ; $(MAKE) clean ; cd ..
	cd 8080 ; $(MAKE) clean ; cd ..
