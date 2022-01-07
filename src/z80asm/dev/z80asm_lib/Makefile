#------------------------------------------------------------------------------
# Z88DK Z80 Module Assembler
#
# Build and test z88dk-z80asm-*.lib
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------
PROJ		:= z88dk-z80asm

INSTALL 	?= install
Z80ASM_EXE	?= ../../$(PROJ)
SRC		:= $(filter-out test.asm,$(wildcard *.asm))

#------------------------------------------------------------------------------
# Macro for each library build
#------------------------------------------------------------------------------
define MAKE_LIB
all: $(PROJ)-$(strip $(1)).lib

$(PROJ)-$(strip $(1)).lib: $(PROJ)_lib.lst $(SRC) Makefile ../../src/c/zobjfile.h
	$(Z80ASM_EXE) -l -x$(PROJ)-$(strip $(1)).lib $(2) @$(PROJ)_lib.lst

clean::
	$(RM) $(PROJ)-$(strip $(1)).lib

install::
	$(INSTALL) $(PROJ)-$(strip $(1)).lib $(PREFIX)/lib/$(PROJ)-$(strip $(1)).lib
endef

#------------------------------------------------------------------------------
# Call for all variants
#------------------------------------------------------------------------------
$(foreach cpu,8080 8085 gbz80 r2ka r3k z180 z80 z80n,$(eval $(call MAKE_LIB,$(cpu)-,-m$(cpu))))
$(foreach cpu,8080 8085 gbz80 r2ka r3k z180 z80 z80n,$(eval $(call MAKE_LIB,$(cpu)-ixiy,-m$(cpu) -IXIY)))

$(PROJ)_lib.lst: $(SRC)
	$(RM) $(PROJ)_lib.lst
	$(foreach file, $(sort $(SRC)), echo $(file) >> $(PROJ)_lib.lst; )

clean::
	$(RM) $(SRC:.asm=.o) $(SRC:.asm=.lis) test.asm test.o test.bin $(PROJ)

test: all
	cp $(Z80ASM_EXE) $(PROJ)
	perl -S prove t/*.t
