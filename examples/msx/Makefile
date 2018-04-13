#
# Examples for MSX 
#
# $Id: Makefile,v 1.3 2016-07-02 10:38:28 dom Exp $
#

#include ../../libsrc/Make.config

CC = zcc
CFLAGS = +msx -vn -llib3d  -lm -lndos -create-app


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
	showlib3d.c \
	vpoke.c


EXECFILES = $(CFILES:.c=.cas)

all: $(EXECFILES) ex8.com

ex8.com: ex8.c
	zcc +msx -subtype=msxdos -create-app -oex8 ex8.c
 
%.cas: %.c
	$(CC) $(CFLAGS) -o$*.bin $*.c

clean:
	$(RM) *.obj *.sym *.map *.o* *.bin *.msx zcc_opt.def *.reloc *.cas *.COM
