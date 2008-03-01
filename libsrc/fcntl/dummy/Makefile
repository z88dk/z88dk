# $Id: Makefile,v 1.8 2008-03-01 10:20:28 aralbrec Exp $

include ../../Make.config

all:
	@echo ''
	@echo '---> Building NDOS library <---'
	@echo ''
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/ndos @ndoslist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
