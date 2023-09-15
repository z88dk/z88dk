#------------------------------------------------------------------------------
# Z88DK Z80 Module Assembler
#
# Build and test z88dk-z80asm-*.lib
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------
PROJ		:= z88dk-z80asm

INSTALL 	?= install
Z80ASM_EXE	?= ../../$(PROJ)
SRC			:= $(wildcard *.asm)

all:		$(PROJ).lib

$(PROJ).lib: $(SRC) $(PROJ)_lib.lst Makefile
	$(Z80ASM_EXE) -l -m* -x$(PROJ).lib @$(PROJ)_lib.lst

$(PROJ)_lib.lst: $(SRC) Makefile
	perl -E 'say $$_ for grep {!/^test/} sort @ARGV' $(SRC) > $(PROJ)_lib.lst

clean::
	$(RM) $(PROJ).lib $(SRC:.asm=.o) $(SRC:.asm=.lis) test.asm test.o test.bin $(PROJ) *.bak

install::
	$(INSTALL) $(PROJ).lib $(PREFIX)/lib/$(PROJ).lib

test: all
	cp $(Z80ASM_EXE) $(PROJ)
	perl -S prove --state=slow,save -j9 t/*.t
