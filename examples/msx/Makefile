#
# Examples for MSX 
#
# $Id: Makefile $
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

all: $(EXECFILES) ex8.com dstar.cas microman.cas othello.cas wall.cas globe.cas

ex8.com: ex8.c
	$(CC) +msx -subtype=msxdos -create-app -oex8 ex8.c

%.cas: %.c
	$(CC) $(CFLAGS) -o$*.bin $*.c

dstar.cas: ../dstar.c
	$(CC) $(CFLAGS) ../dstar.c -I.. -Dspritesize=16 -DSOUND -create-app -odstar.bin

othello.cas: ../othello.c
	$(CC) $(CFLAGS) ../othello.c -I.. -clib=ansi -DGRAPHICS -create-app -oothello.bin

microman.cas: ../microman.c
	$(CC) $(CFLAGS) ../microman.c -I.. -DSOUND -DJOYSTICK_DIALOG -create-app -omicroman.bin

wall.cas: ../wall.c
	$(CC) $(CFLAGS) ../wall.c -I.. -DJOYSTICK -DBANNERS -Dspritesize=8 -DSOUND -DCLOCK -create-app -owall.bin

globe.cas: ../graphics/globe.c
	$(CC) $(CFLAGS) ../graphics/globe.c -I../graphics -create-app -pragma-redirect=fputc_cons=putc4x6 -oglobe.bin


clean:
	$(RM) *.obj *.sym *.map *.o* *.bin *.msx zcc_opt.def *.reloc *.cas *.COM
