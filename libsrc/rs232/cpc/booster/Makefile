#
# Amstrad CPC rs232 drivers for Z80 STI based controller
#
# $Id: Makefile,v 1.2 2015-08-05 07:24:24 pauloscustodio Exp $

include ../../../Make.config

all:
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/rs232cpc_booster @boosterlist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i
