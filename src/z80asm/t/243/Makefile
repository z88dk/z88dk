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
CPM_EXE = $(CURDIR)/cpm$(EXESUFFIX)

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

all: m80.com l80.com

m80.com: $(CPM_UTILS_DIR)/m80.com
	cp $< $@

l80.com: $(CPM_UTILS_DIR)/l80.com
	cp $< $@

clean::
	$(RM) m80.com l80.com

#------------------------------------------------------------------------------
# build and run example CPM program with M80 and L80
#------------------------------------------------------------------------------
M80 = $(CPM_EXE) m80
L80 = $(CPM_EXE) l80

all: m80.com l80.com relmain.out

relmain.com: relmain.rel reltesta.rel reltestb.rel relputch.rel
	$(L80) relmain,reltesta,reltestb,relputch,relmain/N/E

relmain.rel: relmain.mac
	$(M80) relmain=relmain

reltesta.rel: reltesta.mac
	$(M80) reltesta=reltesta

reltestb.rel: reltestb.mac
	$(M80) reltestb=reltestb

relputch.rel: relputch.mac
	$(M80) relputch=relputch

relmain.out: relmain.com filter_cpm.pl test_file.pl
	$(CPM_EXE) relmain > relmain.out1
	$(PERL) filter_cpm.pl relmain.out1 relmain.out
	$(RM) relmain.out1
	$(PERL) test_file.pl relmain.out "HELLO !"

clean::
	$(RM) relmain.out relmain.com relmain.rel 
	$(RM) reltesta.rel reltestb.rel relputch.rel
