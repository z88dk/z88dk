#
# OSCA RS232 drivers
#
# $Id: Makefile,v 1.1 2012-06-26 06:09:53 stefano Exp $

include ../../Make.config

all:
	@echo ''
	@echo '---> Building OSCA RS232 library <---'
	@echo ''
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/rs232osca @oscalist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i
