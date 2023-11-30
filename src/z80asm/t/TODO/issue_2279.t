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

z80asm_ok("-mez80 -b -l", "", "", <<ASM, bytes(1,5,7));
	ifdef __CPU_EZ80__ 	   : defb 1 : endif
	ifdef __CPU_EZ80_Z80__ : defb 2 : endif

	.ASSUME ADL=0
	ifdef __CPU_EZ80__ 	   : defb 4 : endif
	ifdef __CPU_EZ80_Z80__ : defb 5 : endif
	
	.ASSUME ADL=1
	ifdef __CPU_EZ80__ 	   : defb 7 : endif
	ifdef __CPU_EZ80_Z80__ : defb 8 : endif
ASM

z80asm_ok("-mez80_z80 -b -l", "", "", <<ASM, bytes(2,5,7));
	ifdef __CPU_EZ80__ 	   : defb 1 : endif
	ifdef __CPU_EZ80_Z80__ : defb 2 : endif

	.ASSUME ADL=0
	ifdef __CPU_EZ80__ 	   : defb 4 : endif
	ifdef __CPU_EZ80_Z80__ : defb 5 : endif
	
	.ASSUME ADL=1
	ifdef __CPU_EZ80__ 	   : defb 7 : endif
	ifdef __CPU_EZ80_Z80__ : defb 8 : endif
ASM

z80asm_ok("-mez80_z80 -b -l", "", "", <<ASM, bytes(0xCD, 0x56, 0x34));
	call 0x123456
ASM

z80asm_ok("-mez80 -b -l", "", "", <<ASM, bytes(0xCD, 0x56, 0x34, 0x12));
	call 0x123456
ASM

z80asm_ok("-mez80 -b -l", "", "", <<ASM, bytes(0xCD, 0x56, 0x34, 0xCD, 0x56, 0x34, 0x12));
	.ASSUME ADL=0
	call 0x123456
	.ASSUME ADL=1
	call 0x123456
ASM

unlink_testfiles;
done_testing;
