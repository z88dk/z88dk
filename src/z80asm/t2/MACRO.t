#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# syntax
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		macro
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		endm
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		macro name
		macro name
END_ASM
Error at file '$test.asm' line 2: unbalanced control structure started at file '$test.asm' line 1
END_ERR

# simple macro
z80asm_ok("", "", "", <<END, bytes(0xc5, 0xd5, 0xe5, 0, 1));
		macro pushreg reg
		push reg
		endm
l1:		pushreg bc
.l2		pushreg de
		pushreg hl
		defb l1, l2
END

z80asm_ok("", "", "", <<END, bytes(0xc5, 0xd5, 0xe5, 0, 1));
pushreg macro reg
		push reg
		endm
l1:		pushreg bc
.l2		pushreg de
		pushreg hl
		defb l1, l2
END

z80asm_ok("", "", "", <<END, bytes(0xc5, 0xd5, 0xe5, 0, 1));
pushreg:macro reg
		push reg
		endm
l1:		pushreg bc
.l2		pushreg de
		pushreg hl
		defb l1, l2
END

unlink_testfiles;
done_testing;
