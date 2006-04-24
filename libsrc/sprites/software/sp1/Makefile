#
# Wahey, a messed up makefile for building libraries!
#


default:
	@echo
	@echo SP1 Software Sprite Engine
	@echo
	@echo You must specify a target machine
	@echo Valid targets listed below
	@echo 
	@echo make spectrum
	@echo

spectrum: customize.asm
	@echo
	@echo SP1 Software Sprite Engine 
	@echo making sinclair spectrum version
	@echo
	z80asm -d -ns -nm -Mo -x../../../../lib/clibs/sp1 @spectrum.lst
	cp spectrum-sp1.h ../../../../include/sprites/sp1.h
	@echo
	@echo all done
	@echo



