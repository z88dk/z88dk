# $Id: Makefile,v 1.9 2003-03-22 14:17:34 dom Exp $

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
	cd zxvgs ; $(MAKE) clean
