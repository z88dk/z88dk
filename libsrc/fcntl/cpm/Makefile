#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.15 2016-07-02 15:41:38 dom Exp $

include ../../Make.config

CFILES = \
	_putoffset.c \
	bios.c \
	bdos.c \
	close.c \
	creat.c \
	change_volume.c \
	dir_move_first.c \
	dir_move_next.c \
	dir_get_entry_type.c \
	dir_get_entry_name.c \
	dir_get_entry_size.c \
	get_current_volume.c \
	get_dir_name.c \
	fdtell.c \
	getfcb.c \
	lseek.c \
	open.c \
	parsefcb.c \
	read.c \
	readbyte.c \
	remove.c \
	rename.c \
	setfcb.c \
	write.c \
	writebyte.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

# It can't be +cpm, otherwise the bin output filename
# will be forced to 'a.com' !!
.c.o:
	zcc +cpm $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.i $(AFILES)
