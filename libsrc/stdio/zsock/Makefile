# $Id: Makefile,v 1.2 2001-04-13 14:14:00 stefano Exp $

all:
	zcc -vn -DNET_STDIO -make-lib opennet.c
	zcc -vn -DNET_STDIO -make-lib closenet.c
	zcc -vn -DNET_STDIO -make-lib fgetc_net.c
	zcc -vn -DNET_STDIO -make-lib fputc_net.c
	zcc -vn -DNET_STDIO -make-lib fflush_net.c

clean:
	rm -f *.o* zcc_opt.def *.sym *.map
