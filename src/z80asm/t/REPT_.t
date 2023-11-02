#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Syntax
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept
END_ASM
$test.asm:1: error: syntax error
  ^---- rept
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept xx
END_ASM
$test.asm:1: error: constant expression expected
  ^---- rept xx
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		extern xx
		rept xx
END_ASM
$test.asm:2: error: constant expression expected
  ^---- rept xx
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
l1:		rept 10
END_ASM
$test.asm:1: error: syntax error
  ^---- l1: rept 10
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
.l1		rept 10
END_ASM
$test.asm:1: error: syntax error
  ^---- .l1 rept 10
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept 1,
END_ASM
$test.asm:1: error: end of line expected
  ^---- rept 1,
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		endr
END_ASM
$test.asm:1: error: unbalanced control structure
  ^---- endr
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept 10
		rept 10
END_ASM
$test.asm:2: error: unbalanced control structure started at: $test.asm:1
  ^---- rept 10
END_ERR

# functional
z80asm_ok("", "", "", <<'END', bytes(1,1));
		rept 2
		defb 1
		endr
END

z80asm_ok("", "", "", <<'END', bytes(1,1));
		defl count=2
		rept count
		defb 1
		endr
END

# test the manual examples
z80asm_ok("", "", "", <<'END', bytes((0x3e, 0x20, 0xd7) x 10));
		; output 10 spaces on a ZX Spectrum
		REPT 10
		ld  a, ' '
		rst 10h
		ENDR
END

unlink_testfiles;
done_testing;


