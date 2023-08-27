#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/1077
# z80asm: ld hl, sp+ -6

for my $n (-4, 0, 4) {
	my $offset = $n > 0 ? "+$n" : $n < 0 ? "$n" : "";
	
	unlink_testfiles;
	z80asm_ok("-b -mgbz80", "", "", "ld hl, sp$offset", bytes(0xF8, $n & 0xFF));
	
	unlink_testfiles;
	z80asm_ok("-b -m8085", "", "", 
			"ldhi $n"			=> bytes(0x28, $n & 0xFF),
			"adi hl,$n"			=> bytes(0x28, $n & 0xFF),
			"ld de, hl$offset"	=> $n==0 ? bytes(0x54, 0x5D) : bytes(0x28, $n & 0xFF),
			"ldsi $n"			=> bytes(0x38, $n & 0xFF),
			"adi sp,$n"			=> bytes(0x38, $n & 0xFF),
			"ld de, sp$offset"	=> bytes(0x38, $n & 0xFF));
    
	unlink_testfiles;
	z80asm_ok("-b -mr2ka", "", "", 
			"ld hl, (ix$offset)"	=> bytes(0xE4, $n & 0xFF),
			"ld (ix$offset), hl"	=> bytes(0xF4, $n & 0xFF),
			"ld hl, (sp$offset)"	=> bytes(0xC4, $n & 0xFF),
			"ld (sp$offset), hl"	=> bytes(0xD4, $n & 0xFF));
}

# check warnings
for my $n (-129, -128, 0, 255, 256) {
	my $offset = $n > 0 ? "+$n" : $n < 0 ? "$n" : "";
	
	ok 1, "n=$n";
	
	my $n_report = int_to_hex($n);
	my $warning = ($n >= -128 && $n < 256) ? "" : <<END;
${test}.asm:1: warning: integer range: $n_report
  ^---- $n
END

    if ($n != 0) {
        unlink_testfiles;
        z80asm_ok("-b -m8085", "", $warning,
				"ld de, hl$offset"		=> bytes(0x28, $n & 0xFF));
    }
    
	unlink_testfiles;
	z80asm_ok("-b -m8085", "", $warning,
				"ld de, sp$offset"		=> bytes(0x38, $n & 0xFF));

	unlink_testfiles;
	z80asm_ok("-b -mr2ka", "", $warning, 
				"ld hl, (sp$offset)"	=> bytes(0xC4, $n & 0xFF));

	unlink_testfiles;
	z80asm_ok("-b -mr2ka", "", $warning, 
				"ld (sp$offset), hl"	=> bytes(0xD4, $n & 0xFF));
}

for my $n (-129, -128, 0, 127, 128) {
	my $offset = $n > 0 ? "+$n" : $n < 0 ? "$n" : "";

	ok 1, "n=$n";

	my $n_report = int_to_hex($n);
	my $warning = ($n >= -128 && $n < 128) ? "" : <<END;
${test}.asm:1: warning: integer range: $n_report
  ^---- $n
END

 	unlink_testfiles;
	z80asm_ok("-b -mr2ka", "", $warning, 
			"ld hl, (ix$offset)"		=> bytes(0xE4, $n & 0xFF));

	unlink_testfiles;
	z80asm_ok("-b -mr2ka", "", $warning, 
			"ld (ix$offset), hl"		=> bytes(0xF4, $n & 0xFF));
}

unlink_testfiles;
done_testing;


sub int_to_hex {
	my($n) = @_;
	if ($n <= -10) {
		return sprintf("-\$%02x", -$n);
	}
	elsif ($n < 10) {
		return $n;
	}
	else {
		return sprintf("\$%02x", $n);
	}
}

