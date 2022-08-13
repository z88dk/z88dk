#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

all: opcodes.yaml
opcodes.yaml: make_opcodes.pl Makefile
	perl make_opcodes.pl opcodes.yaml && dos2unix -q opcodes.yaml

all: opcodes.txt
opcodes.txt: opcodes.yaml dump_opcodes.pl Makefile
	perl dump_opcodes.pl opcodes.yaml opcodes.txt && dos2unix -q opcodes.txt

all: cpu_test_z80_ok.asm
cpu_test_z80_ok.asm: opcodes.yaml make_cpu_test.pl Makefile
	perl make_cpu_test.pl opcodes.yaml cpu_test && dos2unix -q cpu_test_*.asm

all: cpu_rules.h
cpu_rules.h: opcodes.yaml make_cpu_rules.pl Makefile
	perl make_cpu_rules.pl opcodes.yaml cpu_rules.h && dos2unix -q cpu_rules.h

all: parser1.yaml
parser1.yaml: opcodes.yaml make_opcodes_parser.pl Makefile
	perl make_opcodes_parser.pl opcodes.yaml parser1.yaml && dos2unix -q parser1.yaml

all: parser2.yaml
parser2.yaml: directives.y make_directives_parser.pl Makefile
	perl make_directives_parser.pl directives.y parser2.yaml && dos2unix -q parser2.yaml

all: parser.yaml
parser.yaml: parser1.yaml parser2.yaml merge_parsers.pl Makefile
	perl merge_parsers.pl parser1.yaml parser2.yaml parser.yaml && dos2unix -q parser.yaml

all: asm_parse_main.cpp
asm_parse_main.cpp: parser.yaml make_parser_code.pl Makefile
	perl make_parser_code.pl parser.yaml asm_parse_main.cpp && dos2unix -q asm_parse_main.cpp
