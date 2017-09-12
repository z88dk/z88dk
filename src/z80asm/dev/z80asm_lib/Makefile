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
Z80ASM		?= ../../$(PROJ)
SRC			:= $(filter-out test.asm,$(wildcard *.asm))

#------------------------------------------------------------------------------
# Macro for each library build
#------------------------------------------------------------------------------
define MAKE_LIB
all: $(PROJ)-$(strip $(1)).lib

$(PROJ)-$(strip $(1)).lib: $(PROJ)_lib.lst $(SRC) Makefile
	$(Z80ASM) -x$(PROJ)-$(strip $(1)).lib $(2) @$(PROJ)_lib.lst

clean::
	$(RM) $(PROJ)-$(strip $(1)).lib

install::
	$(INSTALL) $(PROJ)-$(strip $(1)).lib $(PREFIX)/lib/$(PROJ)-$(strip $(1)).lib
endef

#------------------------------------------------------------------------------
# Call for all variants
#------------------------------------------------------------------------------
$(eval $(call MAKE_LIB,	z80-,			--cpu=z80				))
$(eval $(call MAKE_LIB,	z80-ixiy,		--cpu=z80 		--IXIY	))
$(eval $(call MAKE_LIB,	z80_zxn-,		--cpu=z80-zxn			))
$(eval $(call MAKE_LIB,	z80_zxn-ixiy,	--cpu=z80-zxn 	--IXIY	))
$(eval $(call MAKE_LIB,	z180-,			--cpu=z180				))
$(eval $(call MAKE_LIB,	z180-ixiy,		--cpu=z180 		--IXIY	))
$(eval $(call MAKE_LIB,	r2k-,			--cpu=r2k				))
$(eval $(call MAKE_LIB,	r2k-ixiy,		--cpu=r2k 		--IXIY	))
$(eval $(call MAKE_LIB,	r3k-,			--cpu=r3k				))
$(eval $(call MAKE_LIB,	r3k-ixiy,		--cpu=r3k 		--IXIY	))

$(PROJ)_lib.lst: $(SRC)
	$(RM) $(PROJ)_lib.lst
	$(foreach file, $(SRC), echo $(file) >> $(PROJ)_lib.lst; )

clean::
	$(RM) $(SRC:.asm=.o) $(SRC:.asm=.lis) test.asm test.o test.bin

test: all
	prove test.pl
