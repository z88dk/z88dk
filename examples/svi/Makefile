#
# Examples for Spectravideo SVI 
#
# $Id: Makefile $
#

#include ../../libsrc/Make.config

CC = zcc

COMPILER ?= sccz80
CFLAGS = +svi -vn -llib3d  -lm -lndos -create-app -DAMALLOC


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

ifeq ($(COMPILER),sdcc)
   CFLAGS += -compiler=sdcc  -SO3 --max-allocs-per-node200000 --fsigned-char 
all: ex1.cas ex1b.cas ex2.cas ex3.cas ex6.cas ex7.cas ex10.cas ex10b.cas vpoke.cas vtstone.cas
else
all: $(EXECFILES) dstar.cas microman.cas othello.cas wall.cas globe.cas snakes.cas vtstone.cas
endif

ex6.cas: ../msx/ex6.c
	$(CC) $(CFLAGS) -oex6.bin ../msx/ex6.c -lsvibios

ex7.cas: ../msx/ex7.c
	$(CC) $(CFLAGS) -oex7.bin ../msx/ex7.c -lsvibios

ex11.cas: ../msx/ex11.c
	$(CC) $(CFLAGS) -oex11.bin ../msx/ex11.c -lsvibios

showlib3d.cas: ../msx/showlib3d.c
	$(CC) $(CFLAGS) -oshowlib3d.bin ../msx/showlib3d.c -lsvibios

#ex8.com: ex8.c
#	$(CC) +cpm -create-app -lsvicpm -oex8 ex8.c

%.cas: ../msx/%.c
	$(CC) $(CFLAGS) -o$*.bin ../msx/$*.c

dstar.cas: ../dstar.c
	$(CC) $(CFLAGS) ../dstar.c -I.. -Dspritesize=16 -DSOUND -create-app -odstar.bin

othello.cas: ../othello.c
	$(CC) $(CFLAGS) ../othello.c -I.. -clib=ansi -DGRAPHICS -create-app -oothello.bin

microman.cas: ../microman.c
	$(CC) $(CFLAGS) ../microman.c -I.. -DSOUND -DJOYSTICK_DIALOG -create-app -omicroman.bin

wall.cas: ../wall.c
	$(CC) $(CFLAGS) ../wall.c -I.. -DJOYSTICK -DBANNERS -Dspritesize=8 -DSOUND -DCLOCK -create-app -owall.bin -lsvibios

globe.cas: ../graphics/globe.c
	$(CC) $(CFLAGS) ../graphics/globe.c -I../graphics -create-app -pragma-redirect=fputc_cons=putc4x6 -oglobe.bin

snakes.cas: ../graphics/snakes.c
	$(CC) $(CFLAGS) ../graphics/snakes.c -I../graphics -DJOYSTICK_DIALOG -DSPEED=1500 -DPSG -create-app -osnakes.bin
	
vtstone.cas: ../console/vtstone.c
	$(CC) $(CFLAGS) ../console/vtstone.c -I../console -clib=ansi -pragma-define:ansicolumns=80 -create-app -ovtstone.bin

clean:
	$(RM) *.obj *.sym *.map *.o* *.bin zcc_opt.def *.reloc *.cas
