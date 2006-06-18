# $Id: Makefile,v 1.6 2006-06-18 14:55:43 dom Exp $

include ../../Make.config

all:
	@echo ''
	@echo '---> Building NDOS library <---'
	@echo ''
	$(LIBLINKER) -x../../ndos @ndoslist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
