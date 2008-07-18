#
# Amstrad CPC rs232 drivers for Z80 STI based controller
#
# $Id: Makefile,v 1.1 2008-07-18 07:51:12 stefano Exp $

include ../../../Make.config

all:
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/rs232cpc_booster @boosterlist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i
