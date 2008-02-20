#
# Wahey, a messed up makefile for building libraries!
#

include ../../../Make.config

default:
	@echo
	@echo Make the library from the {z88dk}/libsrc directory.
	@echo 'make sp1' will list instructions.
	@echo

sp1-spectrum:
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making sinclair spectrum version
	@echo
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/sp1 @spectrum.lst
	cp spectrum/spectrum-sp1.h ../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo

sp1-ts2068hr:
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making ts2068 hi-res version
	@echo
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/sp1 @ts2068hr.lst
	cp ts2068hr/ts2068hr-sp1.h ../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo

clean:
	$(RM) *.o
	$(RM) spectrum/sprites/*.o
	$(RM) spectrum/sprites/draw/*.o
	$(RM) spectrum/tiles/*.o
	$(RM) spectrum/updater/*.o
	$(RM) ts2068hr/sprites/*.o
	$(RM) ts2068hr/sprites/draw/*.o
	$(RM) ts2068hr/tiles/*.o
	$(RM) ts2068hr/updater/*.o
