#
# Wahey, a messed up makefile for building libraries!
#

include ../../../../Make.config

default:
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making ts2068 hi-res version
	@echo
	$(LIBLINKER) -x../../../../$(OUTPUT_DIRECTORY)/sp1 @ts2068hr.lst
	cp ts2068hr-sp1.h ../../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo

clean:
	$(RM) sprites/*.o
	$(RM) sprites/draw/*.o
	$(RM) tiles/*.o
	$(RM) updater/*.o
	$(RM) *.o
