#------------------------------------------------------------------------------
# z80asm Z80 macro assembler
#
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

ifeq ($(OS),Windows_NT)
  EXE := .exe
else
  EXE ?=
endif

ZASM_DIR = z80pack/z80asm
ZASM     = $(ZASM_DIR)/z80asm$(EXE)

all: opcodes.txt tested.txt

opcodes.txt: opcodes.json make_table.py Makefile
	python3 make_table.py opcodes.json opcodes.txt
	dos2unix opcodes.txt 2>/dev/null

opcodes.json: make_opcodes.py Makefile
	python3 make_opcodes.py opcodes.json
	dos2unix opcodes.json 2>/dev/null

all: $(ZASM)

$(ZASM): $(wildcard $(ZASM_DIR)/*.c $(ZASM_DIR)/*.h) Makefile
	cd $(ZASM_DIR) && $(MAKE)

tested.txt: test_opcodes.py opcodes.json $(ZASM) Makefile
	python3 test_opcodes.py opcodes.json $(ZASM)
	dos2unix test.asm 2>/dev/null
	echo >tested.txt
