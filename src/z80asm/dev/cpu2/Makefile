#------------------------------------------------------------------------------
# z80asm Z80 macro assembler
#
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

all: opcodes.txt

opcodes.txt: opcodes.json make_table.py Makefile
	python3 make_table.py opcodes.json opcodes.txt
	dos2unix opcodes.txt

opcodes.json: make_opcodes.py Makefile
	python3 make_opcodes.py opcodes.json
	dos2unix opcodes.json
