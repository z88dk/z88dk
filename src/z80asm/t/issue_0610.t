#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/610
# z80asm: z80asm removes .bin (and other) files when assembling files

unlink_testfiles;
spew("${test}.asm", 	"nop");
spew("${test}.o", 		"dummy");
spew("${test}.lis",		"test");
spew("${test}.bin",		"test");
spew("${test}.sym",		"test");
spew("${test}.map",		"test");
spew("${test}.reloc",	"test");
spew("${test}.def",		"test");

capture_ok("z88dk-z80asm ${test}", "");

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 1 bytes
    C \$0000: 00
END

check_text_file("${test}.lis",		"test");
check_text_file("${test}.bin",		"test");
check_text_file("${test}.sym",		"test");
check_text_file("${test}.map",		"test");
check_text_file("${test}.reloc",	"test");
check_text_file("${test}.def",		"test");

unlink_testfiles;
done_testing;
