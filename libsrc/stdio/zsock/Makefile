# $Id: Makefile,v 1.3 2001-04-30 14:40:04 dom Exp $


all: opennet.o closenet.o fgetc_net.o fputc_net.o fflush_net.o


.c.o:
	zcc -vn -DNET_STDIO -make-lib $*.c

clean:
	rm -f *.o* zcc_opt.def *.sym *.map
