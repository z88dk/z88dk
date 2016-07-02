#
# Wahey, a messed up makefile for building libraries!
#
include ../Make.config

all: $(wildcard *.asm) balloc.lst
	$(LIBLINKER)  -x$(OUTPUT_DIRECTORY)/balloc @balloc.lst

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def

