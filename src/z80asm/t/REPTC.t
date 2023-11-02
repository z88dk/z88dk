#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

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


unlink_testfiles;
done_testing;
