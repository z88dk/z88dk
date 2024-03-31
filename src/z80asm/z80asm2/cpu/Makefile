#------------------------------------------------------------------------------
# z80asm - build parsing tables
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

all: opcodes.yaml
opcodes.yaml: make_opcodes.pl Makefile
	perl make_opcodes.pl $@ && dos2unix $@ 2> /dev/null

all: opcodes.txt
opcodes.txt: opcodes.yaml dump_opcodes.pl Makefile
	perl dump_opcodes.pl opcodes.yaml $@ && dos2unix $@ 2> /dev/null

all: cpu_test/z80_ok.asm
cpu_test/z80_ok.asm: opcodes.yaml make_cpu_test.pl Makefile
	perl make_cpu_test.pl opcodes.yaml cpu_test && dos2unix cpu_test/*.asm 2> /dev/null

all: parse_code.h
parse_code.h: opcodes.yaml make_parser.pl Makefile
	perl make_parser.pl opcodes.yaml $@ && dos2unix $@ 2> /dev/null
