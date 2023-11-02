#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Syntax
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		repti
END_ASM
$test.asm:1: error: syntax error
  ^---- repti
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
l1:		repti var, "hello"
END_ASM
$test.asm:1: error: syntax error
  ^---- l1: repti var, "hello"
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
.l1		repti var, "hello"
END_ASM
$test.asm:1: error: syntax error
  ^---- .l1 repti var, "hello"
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		repti ,
END_ASM
$test.asm:1: error: syntax error
  ^---- repti ,
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		repti var.
END_ASM
$test.asm:1: error: syntax error
  ^---- repti var.
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		repti var,
END_ASM
$test.asm:1: error: syntax error
  ^---- repti var,
END_ERR

# functional
z80asm_ok("", "", "", <<'END', "hello".bytes(13,10, 0, 123, 0));
		defl world=123
		repti var, "hello\r\n", world
		defb var
		defb 0
		endr
END

# test the manual examples
z80asm_ok("", "", "", <<'END', bytes(0xc5, 0xd5, 0xe5, 0xf5));
		; push all registers
		REPTI reg, bc, de, hl, af
		push reg
		ENDR
END


unlink_testfiles;
done_testing;
