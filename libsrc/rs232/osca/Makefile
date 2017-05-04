#
# OSCA RS232 drivers
#
# $Id: Makefile,v 1.2 2016-07-02 15:42:55 dom Exp $

include ../../Make.config

all:
	@echo ''
	@echo '---> Building OSCA RS232 library <---'
	@echo ''
	$(LIBLINKER) -I$(DEFFILE_DIR)/osca/def -x$(OUTPUT_DIRECTORY)/rs232osca @oscalist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i
