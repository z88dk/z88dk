#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

CFILES = \
	fscanf.c \
	itou.c \
	ltoa_any.c \
	scanf.c \
	sscanf.c \
	utoi.c \
	vfscanf.c \
	vsscanf.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

generic_iy:
	zcc +test $(CFLAGS) -Ca-IXIY fscanf.c
	zcc +test $(CFLAGS) -Ca-IXIY itou.c
	zcc +test $(CFLAGS) -Ca-IXIY ltoa_any.c
	zcc +test $(CFLAGS) -Ca-IXIY scanf.c
	zcc +test $(CFLAGS) -Ca-IXIY sscanf.c
	zcc +test $(CFLAGS) -Ca-IXIY utoi.c
	zcc +test $(CFLAGS) -Ca-IXIY vfscanf.c
	zcc +test $(CFLAGS) -Ca-IXIY vsscanf.c

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.err *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
