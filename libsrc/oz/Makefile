#
# Makefile for OZ-7xx specific libraries
#
# $Id: Makefile,v 1.5 2003-10-29 11:37:11 stefano Exp $



all:	
	$(RM) emu/ozgfx/*.o*
	cd oztime ; $(MAKE)
	cd ozinput ; $(MAKE)
	zcc +z88 -vn -make-lib
	z80asm -d -ns -nm -Mo -xozextra -DFORoz -DOZDK @oz700.lst

	cd lib3d ; $(MAKE)
	z80asm -d -ns -nm -Mo -xlib3d -DFORoz -DOZDK @lib3d.lst

clean:
	$(RM) *.o* zcc_opt.def ozextra.lib
	$(RM) ozinput/*.o* ozinput/zcc_opt.def
	$(RM) ozinterrupt/*.o* ozinterrupt/zcc_opt.def
	$(RM) ozmisc/*.o* ozmisc/zcc_opt.def
	$(RM) ozscreen/*.o* ozscreen/zcc_opt.def
	$(RM) oztime/*.o* oztime/zcc_opt.def
	$(RM) ozgfx/*.o* ozgfx/zcc_opt.def
	$(RM) ozserial/*.o* ozserial/zcc_opt.def
