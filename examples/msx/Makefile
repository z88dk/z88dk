#
# Examples for MSX 
#
# $Id: Makefile,v 1.2 2016-07-02 10:35:16 dom Exp $
#

#include ../../libsrc/Make.config

CC = zcc
CFLAGS = +msx -llib3d -lmalloc -lm -lndos -create-app


CFILES = \
	ex1.c \
	ex1b.c \
	ex2.c \
	ex3.c \
	ex4.c \
	ex5.c \
	ex6.c \
	ex7.c \
	ex9.c \
	ex10.c \
	ex10b.c \
	ex11.c \
	showlib3d.c

OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

$(OBJECTS):
	$(CC) $(CFLAGS) -o$*.bin $*.c

clean:
	$(RM) *.obj *.sym *.map *.o* *.bin *.msx zcc_opt.def
