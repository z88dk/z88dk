#
# Makefile for ESXDOS file support
#
# $Id: Makefile,v 1.9 2016-07-02 15:41:39 dom Exp $

include ../../../Make.config

CFILES = $(wildcard *.c)
AFILES = $(wildcard *.asm)

CLASSIC_OBJECTS = $(addprefix obj/,$(CFILES:.c=.o)) $(addprefix obj/,$(AFILES:.asm=.o))

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/arch/zxn/esxdos/z80/*.asm"  "$(NEWLIB_DIRECTORY)/arch/zxn/esxdos/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/esxdos/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/esxdos/z80/*.asm"

NEWLIB_TARGETS := obj/newlib-z80

all: dirs $(OUTPUT_DIRECTORY)/esxdos.lib

.PHONY: dirs $(NEWLIB_TARGETS)

$(OUTPUT_DIRECTORY)/esxdos.lib: $(CLASSIC_OBJECTS) $(NEWLIB_TARGETS) esxdos.lst
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/esxdos @esxdos.lst

obj/%.o: %.c
	$(ZCC) +zx $(CFLAGS) -DESXDOS -o $@ $^

obj/%.o: %.asm
	$(ZCC) +zx $(CFLAGS) -DESXDOS -o $@ $^

obj/newlib-z80:
	@$(ASSEMBLER) -d -O=obj/z80/x -I$(NEWLIB_DIRECTORY) -I../.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k

clean:
	$(RM) *.o* zcc_opt.def $(OUTPUT_DIRECTORY)/esxdos.lib
	$(RM) -fr obj
	

