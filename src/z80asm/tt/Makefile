# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Makefile to build Toolkit::Template generated files

TPAGE = perl -S tpage --include_path=. 

all : $(patsubst %.tt, ../%, $(wildcard *.tt))

../%.c : %.c.tt %.yaml
	@echo $$PATH; perl -I ~/perl5/lib/perl5/ -Mlocal::lib; echo $$PATH
	which tpage
	$(TPAGE) --help
	$(TPAGE) $< > $@~
	mv $@~ $@
	dos2unix $@

../%.h : %.h.tt %.yaml
	@echo $$PATH; perl -I ~/perl5/lib/perl5/ -Mlocal::lib; echo $$PATH
	which tpage
	$(TPAGE) --help
	$(TPAGE) $< > $@~
	mv $@~ $@
	dos2unix $@
