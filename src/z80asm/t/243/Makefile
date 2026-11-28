#------------------------------------------------------------------------------
# z80asm
# test linking of Microsoft .rel files
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

ifeq ($(OS),Windows_NT)
  EXESUFFIX := .exe
else
  EXESUFFIX ?=
endif

PERL 	= perl
Z80ASM 	= z88dk-z80asm
ZCC 	= zcc
DOS2UNIX = dos2unix

#------------------------------------------------------------------------------
# build CPM emulator
# NOTE: cpm is hasdcoded little endian
#------------------------------------------------------------------------------
CPM_DIR = ../../../../ext/cpm
CPM_EXE = ./cpm$(EXESUFFIX)

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

#------------------------------------------------------------------------------
# build the same example CPM program with z80asm/zcc
#------------------------------------------------------------------------------
all: z88dkm.out

z88dka.o: z88dka.asm
	$(Z80ASM) $<

z88dkb.o: z88dkb.asm
	$(Z80ASM) $<

z88dkm.com: z88dkm.c z88dka.o z88dkb.o
	$(ZCC) +cpm -lndos -create-app -oz88dkm.com z88dkm.c z88dka.o z88dkb.o

z88dkm.out: z88dkm.com filter_cpm.pl test_file.pl
	$(CPM_EXE) z88dkm > z88dkm.out1
	$(PERL) filter_cpm.pl z88dkm.out1 z88dkm.out
	$(RM) z88dkm.out1
	$(PERL) test_file.pl z88dkm.out "HELLO !"

clean::
	$(RM) z88dkm.out z88dkm.com z88dka.o

#------------------------------------------------------------------------------
# dump the .rel files
#------------------------------------------------------------------------------
all: relmain.dump reltesta.dump reltestb.dump relputch.dump

relmain.dump: relmain.rel dump_rel.pl
	$(PERL) dump_rel.pl $< > $@
	$(DOS2UNIX) $@

reltesta.dump: reltesta.rel dump_rel.pl
	$(PERL) dump_rel.pl $< > $@
	$(DOS2UNIX) $@

reltestb.dump: reltestb.rel dump_rel.pl
	$(PERL) dump_rel.pl $< > $@
	$(DOS2UNIX) $@

relputch.dump: relputch.rel dump_rel.pl
	$(PERL) dump_rel.pl $< > $@
	$(DOS2UNIX) $@

