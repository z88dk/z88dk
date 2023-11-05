#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Empty sections do not appear in the map file, except "" section
z80asm_ok("-r4 -b -m -g -Dminus_d_var", "", "", <<END, bytes());
				; empty			;; 
END

check_text_file("$test.map", <<END);
__head                          = \$0004 ; const, public, def, , ,
__tail                          = \$0004 ; const, public, def, , ,
__size                          = \$0000 ; const, public, def, , ,
END


z80asm_ok("-b -m", "", "", <<END, bytes(0));
				section empty
				section code
				nop				;; 00
END

check_text_file("$test.map", <<END);
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$0001 ; const, public, def, , ,
__size                          = \$0001 ; const, public, def, , ,
__empty_head                    = \$0000 ; const, public, def, , ,
__empty_tail                    = \$0000 ; const, public, def, , ,
__empty_size                    = \$0000 ; const, public, def, , ,
__code_head                     = \$0000 ; const, public, def, , ,
__code_tail                     = \$0001 ; const, public, def, , ,
__code_size                     = \$0001 ; const, public, def, , ,
END

unlink_testfiles;
done_testing;
