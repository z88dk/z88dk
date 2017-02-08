# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Makefile to build Toolkit::Template generated files

TPAGE = perl -S tpage --include_path=. 

all : $(patsubst %.tt, ../%, $(wildcard *.tt))

../%.c : %.c.tt %.yaml
	$(TPAGE) $< > $@~
	mv $@~ $@
	dos2unix $@

../%.h : %.h.tt %.yaml
	$(TPAGE) $< > $@~
	mv $@~ $@
	dos2unix $@
