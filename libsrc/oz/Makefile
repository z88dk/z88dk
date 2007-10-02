#
# Makefile for OZ-7xx specific libraries
#
# $Id: Makefile,v 1.11 2007-10-02 14:13:48 stefano Exp $

include ../Make.config

all:	
	$(RM) emu/ozgfx/*.o*
	cd oztime ; $(MAKE) ; cd ..
	cd ozinput ; $(MAKE) ; cd ..
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/ozextra -DFORoz -DOZDK @oz700.lst

	cd lib3d ; $(MAKE) ; cd ..
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/lib3d -DFORoz -DOZDK @lib3d.lst

clean:
	cd lib3d ; $(MAKE) clean ; cd ..
	$(RM) *.o* zcc_opt.def ozextra.lib
	$(RM) emu/ozgfx/*.o*
	$(RM) ozinput/*.o* ozinput/zcc_opt.def
	$(RM) ozinterrupt/*.o* ozinterrupt/zcc_opt.def
	$(RM) ozmisc/*.o* ozmisc/zcc_opt.def
	$(RM) ozscreen/*.o* ozscreen/zcc_opt.def
	$(RM) oztime/*.o* oztime/zcc_opt.def
	$(RM) ozgfx/*.o* ozgfx/zcc_opt.def
	$(RM) ozserial/*.o* ozserial/zcc_opt.def
