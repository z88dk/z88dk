#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2001-04-30 14:40:04 dom Exp $


all: string

string: memcpy.o memset.o memcpy.o memcmp.o strspn.o strupr.o strlwr.o \
	strrstrip.o strstr.o strpbrk.o strpos.o strcspn.o strchr.o strrchr.o

.c.o:  
	zcc -vn -Wn43 -make-lib $*.c


clean:
	rm -f *.sym *.map zcc_opt.def *.o*
