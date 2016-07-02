#
# Amstrad CPC rs232 drivers for Z80 STI based controller
#
# $Id: Makefile,v 1.3 2016-07-02 15:42:55 dom Exp $

include ../../../Make.config

all: $(OUTPUT_DIRECTORY)/rs232cpc_booster.lib


$(OUTPUT_DIRECTORY)/rs232cpc_booster.lib: $(wildcard *.asm)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/rs232cpc_booster @boosterlist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(OUTPUT_DIRECTORY)/rs232cpc_booster.lib
