#
# Makefile for OZ-7xx specific libraries
#
# $Id: Makefile,v 1.1 2003-10-21 17:15:19 stefano Exp $



all:	
	zcc +z88 -vn -make-lib oztime/ozt.c
	z80asm -d -ns -nm -Mo -xozextra @oz700.lst

clean:
	$(RM) *.o* zcc_opt.def ozextra.lib
	$(RM) ozinput/*.o* ozinput/zcc_opt.def
	$(RM) ozinterrupt/*.o* ozinterrupt/zcc_opt.def
	$(RM) ozmisc/*.o* ozmisc/zcc_opt.def
	$(RM) ozscreen/*.o* ozscreen/zcc_opt.def
	$(RM) oztime/*.o* oztime/zcc_opt.def
	$(RM) ozgfx/*.o* ozgfx/zcc_opt.def
	$(RM) ozserial/*.o* ozserial/zcc_opt.def
