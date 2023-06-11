#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#-------------------------------------------------------------------------------
# REPT
#-------------------------------------------------------------------------------

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
$test.asm:1: error: undefined symbol: xx
  ^---- rept xx
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
      ^---- l1:rept 10
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept 1,
END_ASM
$test.asm:1: error: syntax error
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

#-------------------------------------------------------------------------------
# REPC
#-------------------------------------------------------------------------------

# Syntax
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		reptc
END_ASM
$test.asm:1: error: syntax error
  ^---- reptc
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
l1:		reptc var, "hello"
END_ASM
$test.asm:1: error: syntax error
  ^---- l1: reptc var, "hello"
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
.l1		reptc var, "hello"
END_ASM
$test.asm:1: error: syntax error
  ^---- .l1 reptc var, "hello"
      ^---- l1:reptc var,"hello"
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		reptc ,
END_ASM
$test.asm:1: error: syntax error
  ^---- reptc ,
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		reptc var.
END_ASM
$test.asm:1: error: syntax error
  ^---- reptc var.
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		reptc var, !
		endr
END_ASM
$test.asm:1: error: syntax error
  ^---- reptc var, !
END_ERR

# functional
z80asm_ok("", "", "", <<'END', "hello".bytes(13,10));
		reptc var, "hello\r\n"
		defb var
		endr
END

z80asm_ok("", "", "", <<'END', "123");
		reptc var, 123
		defb var
		endr
END

z80asm_ok("", "", "", <<'END', "hello");
		reptc var, hello
		defb var
		endr
END

z80asm_ok("", "", "", <<'END', "hello");
		defl text = "hello"
		reptc var, text
		defb var
		endr
END

z80asm_ok("", "", "", <<'END', "123");
		defl num = 123
		reptc var, num
		defb var
		endr
END

z80asm_ok("", "", "", <<'END', "hello");
#define cat(a, b) a ## b
		reptc var, cat(hell, o)
		defb var
		endr
END

# test the manual examples
my $expected = ""; 
for (split //, "hello world") { 
	$expected .= bytes(0x3e, ord($_), 0xd7);
}
z80asm_ok("", "", "", <<'END', $expected);
		; output "hello" on a ZX Spectrum
		REPTC var, "hello world"
		ld  a, var
		rst 10h
		ENDR
END

z80asm_ok("", "", "", <<'END', "23");
		; store the digits of the version
		DEFL version=23
		REPTC var, version
		defb var
		ENDR
END

#-------------------------------------------------------------------------------
# REPI
#-------------------------------------------------------------------------------

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
      ^---- l1:repti var,"hello"
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
