#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2001-04-18 11:17:38 dom Exp $



all:
	zcc +z88 -vn -D-make-lib clock.c
	zcc +z88 -vn -make-lib time.c

clean:
	rm -f *.o* *.i *.sym *.map zcc_opt.def
