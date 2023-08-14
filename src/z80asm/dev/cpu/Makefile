#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

all: opcodes.yaml
opcodes.yaml: make_opcodes.pl Makefile
	perl make_opcodes.pl opcodes.yaml && dos2unix opcodes.yaml 2> /dev/null

all: opcodes.txt
opcodes.txt: opcodes.yaml dump_opcodes.pl Makefile
	perl dump_opcodes.pl opcodes.yaml opcodes.txt && dos2unix opcodes.txt 2> /dev/null

all: cpu_test_z80_ok.asm
cpu_test_z80_ok.asm: opcodes.yaml make_cpu_test.pl Makefile
	perl make_cpu_test.pl opcodes.yaml cpu_test && dos2unix cpu_test_*.asm 2> /dev/null

all: cpu_rules.h
cpu_rules.h: opcodes.yaml make_cpu_rules.pl Makefile
	perl make_cpu_rules.pl opcodes.yaml cpu_rules.h && dos2unix cpu_rules.h 2> /dev/null

all: parser1.yaml
parser1.yaml: opcodes.yaml make_opcodes_parser.pl Makefile
	perl make_opcodes_parser.pl opcodes.yaml parser1.yaml && dos2unix parser1.yaml 2> /dev/null

all: parser2.yaml
parser2.yaml: directives.y make_directives_parser.pl Makefile
	perl make_directives_parser.pl directives.y parser2.yaml && dos2unix parser2.yaml 2> /dev/null

all: parser.yaml
parser.yaml: parser1.yaml parser2.yaml merge_parsers.pl Makefile
	perl merge_parsers.pl parser1.yaml parser2.yaml parser.yaml && dos2unix parser.yaml 2> /dev/null

all: parse_main1.cpp
parse_main1.cpp: parser.yaml make_parser_code.pl \
		../../src/cpp/keyword.def \
		../../src/cpp/scan.def \
		Makefile
	perl make_parser_code.pl parser.yaml parse_main1.cpp && dos2unix parse_main1.cpp 2> /dev/null
