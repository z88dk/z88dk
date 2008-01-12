#
# Wahey, a messed up makefile for building libraries!
#

include ../../../Make.config

default:
	@echo
	@echo SP1 Software Sprite Engine
	@echo
	@echo You must specify a target machine
	@echo Valid targets listed below
	@echo 
	@echo make spectrum
	@echo make cpc-mode1  -- not yet!
	@echo

spectrum: customize.asm
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making sinclair spectrum version
	@echo
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/sp1 @spectrum.lst
	cp spectrum-sp1.h ../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo

cpc-mode1: customize.asm
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making amstrad cpc mode 1 version
	@echo
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/sp1 @cpc-mode1.lst
	cp cpc-mode1-sp1.h ../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo

clean:
	$(RM) spectrum/collision/*.o
	$(RM) spectrum/sprites/*.o
	$(RM) spectrum/sprites/draw/*.o
	$(RM) spectrum/tiles/*.o
	$(RM) spectrum/updater/*.o
	$(RM) *.o
