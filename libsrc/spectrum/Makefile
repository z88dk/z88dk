#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.1 2001-10-16 19:45:43 dom Exp $



all:	tape_save.o tape_save_block.o tape_load_block.o

.c.o:
	zcc +zx -vn -make-lib $*.c

clean:
	rm -f *.o* zcc_opt.def
