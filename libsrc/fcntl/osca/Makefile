#
# $Id: Makefile,v 1.3 2016-06-22 22:13:09 dom Exp $

all:
	@echo ''
	@echo '---> Building basic FLOS file library <---'
	@echo ''
	$(MAKE) -C flos
	@echo ''
	@echo '---> Building FLOS multi file library <---'
	@echo ''
	$(MAKE) -C flos

clean:
	$(MAKE) -C flos clean
	$(MAKE) -C flosmulti clean
