#
# $Id: Makefile,v 1.5 2006-07-18 21:02:54 stefano Exp $

all:
	@echo ''
	@echo '---> Building +3 File library <---'
	@echo ''
	cd plus3 ; $(MAKE) ; cd ..
	@echo ''
	@echo '---> Building ZX Microdrive File library <---'
	@echo ''
	cd microdrive ; $(MAKE)
	@echo ''
	@echo '---> Building ZX BASIC driver library <---'
	@echo ''
	cd zxbasdrv ; $(MAKE)


clean:
	cd plus3 ; $(MAKE) clean ; cd ..
	cd microdrive ; $(MAKE) clean ; cd ..
