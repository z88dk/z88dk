#
# Wahey, a messed up makefile for building libraries!
#

include ../../../Make.config

default:
	@echo
	@echo Make the library from the {z88dk}/libsrc directory.
	@echo 'make sp1' will list instructions.
	@echo

sp1-all:
	@echo
	@echo --- SP1 Software Sprite Engine ---
	@echo
	@echo Making default build for all targets
	@echo Results in z88dk/libsrc/sprites/software/sp1/{target}
	@echo
	@echo Making sp1-spectrum
	@echo
	$(LIBLINKER) -xspectrum/sp1 @spectrum.lst
	@echo
	@echo Making sp1-ts2068hr
	@echo
	$(LIBLINKER) -xts2068hr/sp1 @ts2068hr.lst
	@echo
	@echo Making sp1-zx81hr
	@echo
	$(LIBLINKER) -xzx81hr/sp1 --IXIY @zx81hr.lst
	@echo

sp1-spectrum:
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making sinclair spectrum version
	@echo
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/sp1 @spectrum.lst
	cp spectrum/spectrum-sp1.h ../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo

sp1-ts2068hr:
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making ts2068 hi-res version
	@echo
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/sp1 @ts2068hr.lst
	cp ts2068hr/ts2068hr-sp1.h ../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo
	
sp1-zx81hr:
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making zx81 hrg version
	@echo
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/sp1 --IXIY @zx81hr.lst
	cp zx81hr/zx81hr-sp1.h ../../../../include/sprites/sp1.h
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
	$(RM) zx81hr/sprites/*.o
	$(RM) zx81hr/sprites/draw/*.o
	$(RM) zx81hr/tiles/*.o
	$(RM) zx81hr/updater/*.o
