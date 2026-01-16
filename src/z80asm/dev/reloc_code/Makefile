#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

PERL = perl

all: reloc_code.c

reloc_code.c: make_reloc_code.pl Makefile
	$(PERL) make_reloc_code.pl
