#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0044: binary constants with more than 8 bits not accepted
z80asm_ok("", "", "", 
q{	defw %"####---###--##-#"					}, words(0xf1cd),
q{	defw %01111000111001101 					}, words(0xf1cd),
q{	defq %"#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-"	}, dwords(0xaaaaaaaa),
);

unlink_testfiles;
done_testing;
