# $Id: Makefile,v 1.8 2002-12-08 15:24:44 dom Exp $

lz88:
	cd z88 ; $(MAKE) z88_fcntl

lzx:	
	cd spectrum ; $(MAKE)
	cd dummy    ; $(MAKE)

lcpm:
	cd cpm ; $(MAKE)

lpps:
	cd sprinter ; $(MAKE)


clean:
	cd cpm ; $(MAKE) clean
	cd dummy ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
	cd sprinter ; $(MAKE) clean
	cd z88 ; $(MAKE) clean
