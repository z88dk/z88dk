# $Id: Makefile,v 1.9 2016-07-02 15:41:38 dom Exp $

include ../../Make.config

all: $(OUTPUT_DIRECTORY)/ndos.lib

$(OUTPUT_DIRECTORY)/ndos.lib: $(wildcard *.asm) ndoslist
	@echo ''
	@echo '---> Building NDOS library <---'
	@echo ''
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/ndos @ndoslist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* $(OUTPUT_DIRECTORY)/ndos.lib
