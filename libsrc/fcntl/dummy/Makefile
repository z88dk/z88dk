# $Id: Makefile,v 1.7 2007-06-03 15:13:05 stefano Exp $

include ../../Make.config

all:
	@echo ''
	@echo '---> Building NDOS library <---'
	@echo ''
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/ndos @ndoslist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
