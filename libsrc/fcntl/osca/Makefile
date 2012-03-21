#
# $Id: Makefile,v 1.2 2012-03-21 10:20:23 stefano Exp $

all:
	@echo ''
	@echo '---> Building basic FLOS file library <---'
	@echo ''
	cd flos ; $(MAKE) ; cd ..
	@echo ''
	@echo '---> Building FLOS multi file library <---'
	@echo ''
	cd flosmulti ; $(MAKE) ; cd ..

clean:
	cd flos ; $(MAKE) clean ; cd ..
	cd flosmulti ; $(MAKE) clean ; cd ..
