# $Id: Makefile,v 1.11 2003-09-14 11:46:39 dom Exp $

lz88:
	cd z88 ; $(MAKE) z88_fcntl

lzx:	
	cd spectrum ; $(MAKE)
	cd dummy    ; $(MAKE)

lcpm:
	cd cpm ; $(MAKE)

lpps:
	cd sprinter ; $(MAKE)

lzxvgs:
	cd zxvgs; $(MAKE)

lcpc:
	cd cpc ; $(MAKE)
	cd dummy    ; $(MAKE)

clean:
	cd cpm ; $(MAKE) clean
	cd dummy ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
	cd sprinter ; $(MAKE) clean
	cd z88 ; $(MAKE) clean
	cd zxvgs ; $(MAKE) clean
	cd cpc ; $(MAKE) clean
