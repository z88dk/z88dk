#
# Wahey, a messed up makefile for building libraries!
#



all: assert.o

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f *.o* *.sym *.map *~ *.err  zcc_opt.def
