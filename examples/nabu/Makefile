#
# Examples for Spectravideo SVI 
#
# $Id: Makefile $
#

#include ../../libsrc/Make.config

CC = zcc

COMPILER ?= sccz80
CFLAGS = +nabu -llib3d  -lm -lndos -create-app -DAMALLOC


CFILES = \
	ex1.c \
	ex1b.c \
	ex2.c \
	ex4.c \
	ex5.c \
	ex7.c \
	ex9.c \
	ex10.c \
	ex10b.c \
	vpoke.c


EXECFILES = $(CFILES:.c=.NABU)

ifeq ($(COMPILER),sdcc)
   CFLAGS += -compiler=sdcc  -SO3 --max-allocs-per-node200000 --fsigned-char 
all: ex1.NABU ex1b.NABU ex2.NABU ex3.NABU ex6.NABU ex7.NABU ex10.NABU ex10b.NABU vpoke.NABU vtstone.NABU retronet.NABU inputtest.NABU
else
   CFLAGS += 
all: $(EXECFILES) dstar.NABU microman.NABU othello.NABU globe.NABU snakes.NABU vtstone.NABU psgtest.NABU retronet.NABU inputtest.NABU
endif

showlib3d.NABU: ../msx/showlib3d.c
	$(CC) $(CFLAGS) -oshowlib3d.bin ../msx/showlib3d.c

#ex8.com: ex8.c
#	$(CC) +cpm -create-app -lsvicpm -oex8 ex8.c

%.NABU: ../msx/%.c
	$(CC) $(CFLAGS) -o$*.bin ../msx/$*.c

dstar.NABU: ../dstar.c
	$(CC) $(CFLAGS) ../dstar.c -I.. -Dspritesize=16 -DSOUND -create-app -odstar.bin

othello.NABU: ../othello.c
	$(CC) $(CFLAGS) ../othello.c -I.. -clib=ansi -DGRAPHICS -create-app -oothello.bin

microman.NABU: ../microman.c
	$(CC) $(CFLAGS) ../microman.c -I.. -DSOUND -DJOYSTICK_DIALOG -create-app -omicroman.bin

wall.NABU: ../wall.c
	$(CC) $(CFLAGS) ../wall.c -I.. -DJOYSTICK -DBANNERS -Dspritesize=8 -DSOUND -DCLOCK -create-app -owall.bin 

globe.NABU: ../graphics/globe.c
	$(CC) $(CFLAGS) ../graphics/globe.c -I../graphics -create-app -pragma-redirect=fputc_cons=putc4x6 -oglobe.bin

snakes.NABU: ../graphics/snakes.c
	$(CC) $(CFLAGS) ../graphics/snakes.c -I../graphics -DJOYSTICK_DIALOG -DSPEED=1500 -DPSG -create-app -osnakes.bin
	
vtstone.NABU: ../console/vtstone.c
	$(CC) $(CFLAGS) ../console/vtstone.c -I../console -clib=ansi -pragma-define:ansicolumns=80 -create-app -ovtstone.bin

psgtest.NABU: ../sound/psgtest.c
	$(CC) $(CFLAGS) ../sound/psgtest.c -DNODELAY -create-app -opsgtest.bin

retronet.NABU: retronet.c
	$(CC) $(CFLAGS) retronet.c -DNODELAY -create-app -oretronet.bin

inputtest.NABU: inputtest.c
	$(CC) $(CFLAGS) inputtest.c -DNODELAY -create-app -oinputtest.bin

clean:
	$(RM) *.obj *.sym *.map *.o* *.bin zcc_opt.def *.reloc *.NABU
