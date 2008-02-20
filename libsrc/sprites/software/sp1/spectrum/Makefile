#
# Wahey, a messed up makefile for building libraries!
#

include ../../../../Make.config

default:
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making sinclair spectrum version
	@echo
	$(LIBLINKER) -x../../../../$(OUTPUT_DIRECTORY)/sp1 @spectrum.lst
	cp spectrum-sp1.h ../../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo

clean:
	$(RM) sprites/*.o
	$(RM) sprites/draw/*.o
	$(RM) tiles/*.o
	$(RM) updater/*.o
	$(RM) *.o
