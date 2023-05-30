#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2279
# z80asm: support ez80

z80asm_nok("", "", <<ASM, <<ERR);
	.ASSUME ADL=0
ASM
$test.asm:1: error: illegal identifier
  ^---- .ASSUME ADL=0
      ^---- ASSUME ADL=0
ERR

z80asm_nok("-mez80", "", <<ASM, <<ERR);
	.ASSUME ADL=2
ASM
$test.asm:1: error: integer range: 2
  ^---- .ASSUME ADL=2
      ^---- ASSUME ADL=2
ERR

z80asm_ok("-mez80 -b", "", "", <<ASM, bytes());
	.ASSUME ADL=0
ASM

z80asm_ok("-mez80 -b", "", "", <<ASM, bytes());
	.ASSUME ADL=1
ASM

z80asm_ok("-mez80 -b", "", "", <<ASM, bytes());
	ASSUME ADL=0
ASM

z80asm_ok("-mez80 -b", "", "", <<ASM, bytes());
	ASSUME ADL=1
ASM

unlink_testfiles;
done_testing;
