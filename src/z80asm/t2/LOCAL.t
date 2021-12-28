#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# syntax
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		local
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		local a a
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

# labels
z80asm_ok("", "", "", <<'END', bytes(0, 0));
L1:		local ABC
.L2		local DEF
		local GHI,JKL
		defb L1, L2		; 0, 0
END

# usage in macro
z80asm_ok("", "", "", <<END, bytes(0x06, 10, 0x10, 0xfe, 0x06, 20, 0x10, 0xfe));
		macro delay count
		local loop
		ld b, count
loop:	djnz loop
		endm
		
		delay 10
		delay 20
END

unlink_testfiles;
done_testing;
