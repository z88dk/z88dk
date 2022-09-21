#
# Makefile for S-OS
#
# $Id: Makefile $
#

include ../../../Make.config

CIAFILES = \
	rnd_saveblock.c \
	rnd_loadblock.c \
	tape_save.c \
	tape_save_block.c \
	tape_load.c \
	tape_load_block.c

CIAOBJECTS = $(CIAFILES:.c=.o)

AFILES  = $(CIAFILES:.c=.asm)

all:    $(CIAOBJECTS)

.c.o:
	$(ZCC) +test -DBUILDING_SOSLIB $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
