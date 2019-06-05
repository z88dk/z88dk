# $Id: Makefile $

include ../../Make.config

all: $(OUTPUT_DIRECTORY)/trsdos.lib

$(OUTPUT_DIRECTORY)/trsdos.lib: $(wildcard *.asm) trsdos.lst
	@echo ''
	@echo '---> Building TRSDOS library <---'
	@echo ''
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/trsdos @trsdos.lst

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* $(OUTPUT_DIRECTORY)/trsdos.lib
