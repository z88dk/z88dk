#
# Makefile for OZ-7xx specific libraries
#
# $Id: Makefile,v 1.8 2006-06-18 17:59:38 dom Exp $

include ../Make.config

all:	
	$(RM) emu/ozgfx/*.o*
	cd oztime ; $(MAKE) ; cd ..
	cd ozinput ; $(MAKE) ; cd ..
	$(LIBLINKER) -xozextra -DFORoz -DOZDK @oz700.lst

	cd lib3d ; $(MAKE) ; cd ..
	$(LIBLINKER) -xlib3d -DFORoz -DOZDK @lib3d.lst

clean:
	$(RM) *.o* zcc_opt.def ozextra.lib
	$(RM) ozinput/*.o* ozinput/zcc_opt.def
	$(RM) ozinterrupt/*.o* ozinterrupt/zcc_opt.def
	$(RM) ozmisc/*.o* ozmisc/zcc_opt.def
	$(RM) ozscreen/*.o* ozscreen/zcc_opt.def
	$(RM) oztime/*.o* oztime/zcc_opt.def
	$(RM) ozgfx/*.o* ozgfx/zcc_opt.def
	$(RM) ozserial/*.o* ozserial/zcc_opt.def
