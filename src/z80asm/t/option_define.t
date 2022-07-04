#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# -D

my $asm = "ld a,_value23";		# BUG_0045

# no -D
z80asm_nok("-b", "", $asm, <<END);
${test}.asm:1: error: undefined symbol: _value23
  ^---- _value23
END

# invalid -D
# quote because of '*'
for my $options ('-D23', quote_os('-Da*')) {		
	z80asm_nok("-b $options", "", "", <<END);
error: illegal identifier
END
}

for my $options ('aaa=', 'aaa=a', 'aaa=!', 'aaa=1x') {
	z80asm_nok("-b -D$options", "", "", <<END);
error: invalid define (-Dvar=value) option: ${options}
END
}

# -D
z80asm_ok("-b -D_value23", "", "", $asm, bytes(0x3E, 0x01));

# -Dvar=value
for my $value (255, "0xff", "0XFF", "0ffh", "0FFH", "\$FF") {
	# quote because of '$'
	z80asm_ok("-b ".quote_os("-D_value23=${value}"), "", "", 
		$asm, bytes(0x3E, 0xFF));
}

# -D with environment variables
$ENV{TEST_ENV} = 'value';
z80asm_ok("-b ".quote_os("-D_\${TEST_ENV}23"), "", "", 
		$asm, bytes(0x3E, 0x01));
		
$ENV{TEST_ENV} = '127';
z80asm_ok("-b ".quote_os("-D_value23=\${TEST_ENV}"), "", "", 
		$asm, bytes(0x3E, 0x7F));
		
delete $ENV{TEST_ENV};
z80asm_ok("-b ".quote_os("-D_value\${TEST_ENV}23"), "", "", 
		$asm, bytes(0x3E, 0x01));

unlink_testfiles;
done_testing;

