#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# windows portability layer
PERL   = perl
CP     = $(PERL) ../../tools/cp.pl
RM     = $(PERL) ../../tools/rm.pl
MV     = $(PERL) ../../tools/mv.pl
MKDIR  = $(PERL) ../../tools/mkdir.pl
TOUCH  = $(PERL) ../../tools/touch.pl
INSTALL= $(PERL) ../../tools/install.pl

ifeq ($(OS),Windows_NT)
  EXESUFFIX := .exe
else
  EXESUFFIX ?=
endif

PROJ		:= z88dk-z80asm$(EXESUFFIX)
TICKS		:= z88dk-ticks$(EXESUFFIX)
TICKS_DIR	:= ../../../ticks

INSTALL 	?= install
Z80ASM_EXE	?= ../../$(PROJ)
SRC			:= $(wildcard *.asm)

TASKS ?= 9

all:		$(PROJ).lib

$(PROJ).lib: $(SRC) $(PROJ)_lib.lst Makefile
	$(Z80ASM_EXE) -l -m* -x$(PROJ).lib @$(PROJ)_lib.lst

$(PROJ)_lib.lst: $(SRC) Makefile
	$(PERL) make_lib_list.pl $(SRC) > $(PROJ)_lib.lst

clean::
	$(RM) -f $(PROJ).lib $(SRC:.asm=.o) $(SRC:.asm=.lis) test.asm test.o test.bin $(PROJ) *.bak

install::
	$(INSTALL) $(PROJ).lib $(PREFIX)/lib/$(PROJ).lib

test: all $(PROJ) $(TICKS)
	$(PERL) -S prove --state=slow,save -j$(TASKS) t/*.t

$(PROJ): $(Z80ASM_EXE)
	$(CP) $(Z80ASM_EXE) $(PROJ)

$(TICKS): $(TICKS_DIR)/$(TICKS)
	$(CP) $(TICKS_DIR)/$(TICKS) $(TICKS)

$(TICKS_DIR)/$(TICKS): $(wildcard $(TICKS_DIR)/*.c $(TICKS_DIR)/*.h)
	$(MAKE) -C $(TICKS_DIR)
