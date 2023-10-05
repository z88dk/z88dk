#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# -D

# no -D
z80asm_nok("-b", "", "ld a,_value23", <<END);
${test}.asm:1: error: undefined symbol: _value23
  ^---- _value23
END

# invalid -D
# quote because of '*'
for my $ident (qw( 23 a* )) {
	z80asm_nok("-b ".quote_os("-D$ident"), "", "", <<END);
error: illegal identifier: $ident
END
}

for my $options ('aaa=', 'aaa=a', 'aaa=!', 'aaa=1x') {
	z80asm_nok("-b -D$options", "", "", <<END);
error: invalid define (-Dvar=value) option: ${options}
END
}

# -D
for my $ident (qw( a_123 _123 a123 )) {
	for my $eq ('', '=') {
		z80asm_ok("-b -D${eq}${ident}", "", "", "ld a, $ident", bytes(0x3E, 0x01));
	}
}

# -Dvar=value
for my $ident (qw( a_123 _123 a123 )) {
	for my $value (255, "0xff", "0XFF", "0ffh", "0FFH", "\$FF") {
		for my $eq ('', '=') {
			# quote because of '$'
			z80asm_ok("-b ".quote_os("-D${eq}${ident}=${value}"), "", "", 
					  "ld a, $ident", bytes(0x3E, 0xFF));
			z80asm_ok("-b -D${eq}${ident}=".quote_os("${value}"), "", "", 
					  "ld a, $ident", bytes(0x3E, 0xFF));
		}
	}
}

# -D with environment variables
$ENV{TEST_ENV} = 'value';
z80asm_ok("-b ".quote_os("-D_\${TEST_ENV}23"), "", "", 
		"ld a,_value23", bytes(0x3E, 0x01));
		
$ENV{TEST_ENV} = '127';
z80asm_ok("-b ".quote_os("-D_value23=\${TEST_ENV}"), "", "", 
		"ld a,_value23", bytes(0x3E, 0x7F));
		
delete $ENV{TEST_ENV};
z80asm_ok("-b ".quote_os("-D_value\${TEST_ENV}23"), "", "", 
		"ld a,_value23", bytes(0x3E, 0x01));

# -D with verbose
spew("${test}.asm", "nop");
capture_ok("z88dk-z80asm -v ".
		   "-Dmten=-+-+-10 -Dmnine=-9 -Dzero=0 -Done -Dnine=+9 -Dten=10 ${test}.asm", <<'END');
% z88dk-z80asm -v -Dmten=-+-+-10 -Dmnine=-9 -Dzero=0 -Done -Dnine=+9 -Dten=10 test_t_option_define.asm
Predefined constant: mten = -$000a
Predefined constant: mnine = -9
Predefined constant: zero = 0
Predefined constant: one = 1
Predefined constant: nine = 9
Predefined constant: ten = $000a
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_option_define.asm'
Writing object file 'test_t_option_define.o'

END

# duplicate definition
z80asm_ok("-b -Dabcd -Dabcd", "", "", "defb abcd", bytes(1));
z80asm_ok("-b -Dabcd=3 -Dabcd=3", "", "", "defb abcd", bytes(3));

z80asm_nok("-b -Dabcd=1 -Dabcd=2", "", "", <<END);
error: duplicate definition: abcd
END

z80asm_ok("-b", "", "", <<END, bytes(1));
	define abcd
	define abcd
	defb abcd
END

z80asm_ok("-b -Dabcd", "", "", <<END, bytes(1));
	define abcd
	define abcd
	defb abcd
END

z80asm_nok("-b", "", <<ASM, <<ERR);
	define abcd
	defc abcd=1
ASM
$test.asm:2: error: duplicate definition: abcd
  ^---- defc abcd=1
ERR

z80asm_nok("-b", "", <<ASM, <<ERR);
	section a1
	define abcd
	section a2
	define abcd
	defb abcd
ASM
$test.asm:4: error: duplicate definition: abcd
  ^---- define abcd
ERR

unlink_testfiles;
done_testing;
