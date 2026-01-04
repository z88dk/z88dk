#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# windows portability layer
PERL   = perl
CP     = $(PERL) ../../tools/posix.pl cp
RM     = $(PERL) ../../tools/posix.pl rm
MV     = $(PERL) ../../tools/posix.pl mv
MKDIR  = $(PERL) ../../tools/posix.pl mkdir
TOUCH  = $(PERL) ../../tools/posix.pl touch
INSTALL= $(PERL) ../../tools/posix.pl install

ifeq ($(OS),Windows_NT)
  EXESUFFIX := .exe
else
  EXESUFFIX ?=
endif

PROJ		:= z88dk-z80asm
PROJ_EXE	:= $(PROJ)$(EXESUFFIX)
TICKS_EXE	:= z88dk-ticks$(EXESUFFIX)
TICKS_DIR	:= ../../../ticks

INSTALL 	?= install
Z80ASM_EXE	?= ../../$(PROJ)$(EXESUFFIX)
SRC			:= $(wildcard *.asm)

TASKS ?= 9

all:		$(PROJ).lib

$(PROJ).lib: $(SRC) $(PROJ)_lib.lst Makefile
	$(Z80ASM_EXE) -l -m* -x$(PROJ).lib @$(PROJ)_lib.lst

$(PROJ)_lib.lst: $(SRC) Makefile
	$(PERL) make_lib_list.pl $(SRC) > $(PROJ)_lib.lst

clean::
	$(RM) -f $(PROJ).lib $(SRC:.asm=.o) $(SRC:.asm=.lis) test.asm test.o test.bin $(PROJ_EXE) *.bak

install::
	$(INSTALL) $(PROJ).lib $(PREFIX)/lib/$(PROJ).lib

test: all $(PROJ_EXE) $(TICKS_EXE)
	$(PERL) -S prove --state=slow,save -j$(TASKS) t/*.t

$(PROJ)$(EXESUFFIX): $(Z80ASM_EXE)
	$(CP) $(Z80ASM_EXE) $(PROJ_EXE)

$(TICKS_EXE): $(TICKS_DIR)/$(TICKS_EXE)
	$(CP) $(TICKS_DIR)/$(TICKS_EXE) $(TICKS_EXE)

$(TICKS_DIR)/$(TICKS_EXE): $(wildcard $(TICKS_DIR)/*.c $(TICKS_DIR)/*.h)
	$(MAKE) -C $(TICKS_DIR)
