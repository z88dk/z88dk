#------------------------------------------------------------------------------
# Z88DK Z80 Module Assembler
#
# Build and test z80asm-*.lib
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------
PROJ		:= z80asm

INSTALL 	?= install
Z80ASM_EXE	?= ../../$(PROJ)
SRC			:= $(filter-out test.asm,$(wildcard *.asm))

#------------------------------------------------------------------------------
# Macro for each library build
#------------------------------------------------------------------------------
define MAKE_LIB
all: $(PROJ)-$(strip $(1)).lib

$(PROJ)-$(strip $(1)).lib: $(PROJ)_lib.lst $(SRC) Makefile ../../zobjfile.h
	$(Z80ASM_EXE) -x$(PROJ)-$(strip $(1)).lib $(2) @$(PROJ)_lib.lst

clean::
	$(RM) $(PROJ)-$(strip $(1)).lib

install::
	$(INSTALL) $(PROJ)-$(strip $(1)).lib $(PREFIX)/lib/$(PROJ)-$(strip $(1)).lib
endef

#------------------------------------------------------------------------------
# Call for all variants
#------------------------------------------------------------------------------
$(eval $(call MAKE_LIB,	z80-,			-mz80				))
$(eval $(call MAKE_LIB,	z80-ixiy,		-mz80 		--IXIY	))
$(eval $(call MAKE_LIB,	z80n-,			-mz80n				))
$(eval $(call MAKE_LIB,	z80n-ixiy,		-mz80n 		--IXIY	))
$(eval $(call MAKE_LIB,	z180-,			-mz180				))
$(eval $(call MAKE_LIB,	z180-ixiy,		-mz180 		--IXIY	))
$(eval $(call MAKE_LIB,	r2k-,			-mr2k				))
$(eval $(call MAKE_LIB,	r2k-ixiy,		-mr2k 		--IXIY	))
$(eval $(call MAKE_LIB,	r3k-,			-mr3k				))
$(eval $(call MAKE_LIB,	r3k-ixiy,		-mr3k 		--IXIY	))

$(PROJ)_lib.lst: $(SRC)
	$(RM) $(PROJ)_lib.lst
	$(foreach file, $(SRC), echo $(file) >> $(PROJ)_lib.lst; )

clean::
	$(RM) $(SRC:.asm=.o) $(SRC:.asm=.lis) test.asm test.o test.bin

test: all
	prove t/*.t
