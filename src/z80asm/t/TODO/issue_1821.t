#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/1821
# z80asm: Wrong warning using ZSDCC and GameBoy target

spew("${test}.asm", <<END);
    extern hhll, ll

    ldh a,(0x40)
    ldh a,(0xff40)
    ldh (0x40),a
    ldh (0xff40),a

    ldh a,(ll)
    ldh a,(hhll)
    ldh (ll),a
    ldh (hhll),a
END

spew("${test}1.asm", <<END);
    public hhll, ll
    defc hhll = 0xff40
    defc ll = 0x40
END

capture_ok("z88dk-z80asm -mgbz80 -b -l ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", 
			   bytes(0xF0,0x40,0xF0,0x40,0xE0,0x40,0xE0,0x40,
			         0xF0,0x40,0xF0,0x40,0xE0,0x40,0xE0,0x40));

z80asm_nok("-mgbz80 -l", "", <<ASM, <<ERR);
    ldh a,(0xfe01)
    ldh a,0xff01
ASM
${test}.asm:2: error: syntax error
  ^---- ldh a,0xff01
      ^---- ldh a,65281
${test}.asm:1: warning: integer range: \$fe01
  ^---- (65025)
ERR

unlink_testfiles;
done_testing;
