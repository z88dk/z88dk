#
# Wahey, a messed up makefile for building libraries!
#


include ../Make.config


all: assert.o

generic_iy:
	zcc +test $(CFLAGS) -Ca--IXIY assert.c

.c.o:
	zcc +test $(CFLAGS) $*.c


clean:
	$(RM) *.o* *.sym *.map *~ *.err  zcc_opt.def
	$(RM) assert.asm *.i
