#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# syntax
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		macro
END_ASM
$test.asm:1: error: syntax error
  ^---- macro
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		endm
END_ASM
$test.asm:1: error: unbalanced control structure
  ^---- endm
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		macro name
		macro name
END_ASM
$test.asm:2: error: unbalanced control structure started at: $test.asm:1
  ^---- macro name
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
