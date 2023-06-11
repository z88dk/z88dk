#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0001: Error in expression during link
# BUG_0001(a): during correction of BUG_0001, new symbol 

spew("${test}1.asm", <<'END');
                PUBLIC value
                DEFC   value = 10
END
z80asm_ok("-b", "${test}.asm ${test}1.asm", "",
          "     JP NN"          => bytes(0xc3).words(6),
          "     JP NN"          => bytes(0xc3).words(6),
          "NN:"                 => "",
          "     EXTERN value"   => "",
          "     LD A, value-0"  => bytes(0x3e, 10));

unlink_testfiles;
done_testing;
