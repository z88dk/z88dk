#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.2 2002-10-22 19:15:16 dom Exp $



all:	tape_save.o tape_save_block.o tape_load_block.o

.c.o:
	zcc +zx -vn -make-lib $*.c

clean:
	$(RM) *.o* zcc_opt.def
