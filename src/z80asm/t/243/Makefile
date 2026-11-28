#------------------------------------------------------------------------------
# z80asm
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

ifeq ($(OS),Windows_NT)
  EXESUFFIX := .exe
else
  EXESUFFIX ?=
endif

PERL = perl

#------------------------------------------------------------------------------
# build CPM emulator
# NOTE: cpm is hasdcoded little endian
#------------------------------------------------------------------------------
CPM_DIR = ../../../../ext/cpm
CPM_EXE = cpm$(EXESUFFIX)

all: $(CPM_EXE)

$(CPM_EXE): $(CPM_DIR)/cpm$(EXESUFFIX)
	cp $< $@

$(CPM_DIR)/cpm$(EXESUFFIX): \
		$(wildcard $(CPM_DIR)/*.c) \
		$(wildcard $(CPM_DIR)/*.h)
	$(MAKE) -C $(CPM_DIR)

clean::
	$(MAKE) -C $(CPM_DIR) clean
	$(RM) $(CPM_EXE)

#------------------------------------------------------------------------------
# copy CPM tools to current directory
#------------------------------------------------------------------------------
CPM_UTILS_DIR = ../../../../ext/cpm_utils

all: M80.COM L80.COM

M80.COM: $(CPM_UTILS_DIR)/M80.COM
	cp $< $@

L80.COM: $(CPM_UTILS_DIR)/L80.COM
	cp $< $@

clean::
	$(RM) M80.COM L80.COM

#------------------------------------------------------------------------------
# build and run example CPM program with M80 and L80
#------------------------------------------------------------------------------
M80 = $(CPM_EXE) M80
L80 = $(CPM_EXE) L80

all: M80.COM L80.COM RELMAIN.OUT

RELMAIN.COM: RELMAIN.REL RELTESTA.REL RELTESTB.REL RELPUTCH.REL
	$(L80) RELMAIN,RELTESTA,RELTESTB,RELPUTCH,RELMAIN/N/E

RELMAIN.REL: RELMAIN.MAC
	$(M80) RELMAIN=RELMAIN

RELTESTA.REL: RELTESTA.MAC
	$(M80) RELTESTA=RELTESTA

RELTESTB.REL: RELTESTB.MAC
	$(M80) RELTESTB=RELTESTB

RELPUTCH.REL: RELPUTCH.MAC
	$(M80) RELPUTCH=RELPUTCH

RELMAIN.OUT: RELMAIN.COM filter_cpm.pl test_file.pl
	$(CPM_EXE) RELMAIN > RELMAIN.OUT1
	$(PERL) filter_cpm.pl RELMAIN.OUT1 RELMAIN.OUT
	$(RM) RELMAIN.OUT1
	$(PERL) test_file.pl RELMAIN.OUT "HELLO !"

clean::
	$(RM) RELMAIN.OUT RELMAIN.COM RELMAIN.REL 
	$(RM) RELTESTA.REL RELTESTB.REL RELPUTCH.REL
