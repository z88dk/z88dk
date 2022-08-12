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
		   "-Dmten=-+-+-10 -Dmnine=-9 -Dzero=0 -Dnine=+9 -Dten=10 ${test}.asm", <<END);
Predefined constant: mten = -\$000A
Predefined constant: mnine = -9
Predefined constant: zero = 0
Predefined constant: nine = 9
Predefined constant: ten = \$000A
Reading library 'z88dk-z80asm-z80-.lib'
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Assembling 'test_t_option_define.asm' to 'test_t_option_define.o'
Reading 'test_t_option_define.asm' = 'test_t_option_define.asm'
Writing object file 'test_t_option_define.o'
Module 'test_t_option_define' size: 1 bytes

END

unlink_testfiles;
done_testing;
