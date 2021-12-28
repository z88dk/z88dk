#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

#-------------------------------------------------------------------------------
# REPT
#-------------------------------------------------------------------------------

# Syntax
z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept xx
END_ASM
Error at file '$test.asm' line 1: symbol 'xx' not defined
Error at file '$test.asm' line 1: expected constant expression
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		extern xx
		rept xx
END_ASM
Error at file '$test.asm' line 2: expected constant expression
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
l1:		rept 10
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
.l1		rept 10
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept 1,
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		endr
END_ASM
Error at file '$test.asm' line 1: unbalanced control structure
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		rept 10
		rept 10
END_ASM
Error at file '$test.asm' line 2: unbalanced control structure started at file '$test.asm' line 1
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
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
l1:		reptc var, "hello"
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
.l1		reptc var, "hello"
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		reptc ,
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		reptc var.
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		reptc var, !
		endr
END_ASM
Error at file '$test.asm' line 1: syntax error
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
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
l1:		repti var, "hello"
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
.l1		repti var, "hello"
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		repti ,
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		repti var.
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<'END_ASM', <<END_ERR);
		repti var,
END_ASM
Error at file '$test.asm' line 1: syntax error
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
