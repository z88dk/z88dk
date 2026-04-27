#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

all: opcodes.dat opcodes.txt
all: synthetic.dat
all: ../opcodes_trie_token.h ../opcodes_trie_token.cpp
all: ../opcodes_synth_trie.h ../opcodes_synth_trie.cpp

opcodes.dat: make_opcodes.pl Opcodes.pm $(wildcard opcodes*.pl) Makefile
	perl make_opcodes.pl opcodes.dat
	dos2unix opcodes.dat

opcodes.txt: dump_opcodes.pl opcodes.dat Opcodes.pm Makefile
	perl dump_opcodes.pl opcodes.dat opcodes.txt
	dos2unix opcodes.txt

synthetic.dat: opcodes.dat make_synthetic.pl validate_synthetic.pl Makefile
	perl make_synthetic.pl opcodes.dat synthetic.dat
	dos2unix synthetic.dat
	perl validate_synthetic.pl synthetic.dat

../opcodes_trie_token.h ../opcodes_trie_token.cpp &: \
		make_trie_token.pl Makefile \
		../cpu.def ../lexer_tokens.def ../lexer_keywords.def
	perl make_trie_token.pl opcodes_trie_token
	dos2unix ../opcodes_trie_token.h ../opcodes_trie_token.cpp

../opcodes_synth_trie.h ../opcodes_synth_trie.cpp &: \
		make_synth_trie.pl Makefile \
		../opcodes_trie_token.h \
		opcodes.dat
	perl make_synth_trie.pl opcodes_synth_trie
	dos2unix ../opcodes_synth_trie.h ../opcodes_synth_trie.cpp
