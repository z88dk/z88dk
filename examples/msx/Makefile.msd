#
# Examples for MSX 
#
# $Id: Makefile.msd,v 1.1 2009-04-29 07:43:06 stefano Exp $
#

#include ../../libsrc/Make.config

CC = zcc
CFLAGS = +msx -llib3d -lmalloc -lm -startup=2


CFILES = \
	ex1.c \
	ex1b.c \
	ex2.c \
	ex3.c \
	ex4.c \
	ex5.c \
	ex6.c \
	ex7.c \
	ex8.c \
	ex9.c \
	ex10.c \
	ex10b.c \
	ex11.c \
	ex12.c \
	showlib3d.c

OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

$(OBJECTS):
	$(CC) $(CFLAGS) -o$*.bin $*.c
	cp $*.bin $*.com

clean:
	$(RM) *.obj *.sym *.map *.o* *.bin *.com zcc_opt.def
