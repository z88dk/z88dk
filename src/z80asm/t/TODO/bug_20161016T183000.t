#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Bug report: z80asm: bug with relative jumps across sections
# alvin (alvin_albrecht@hotmail.com) <lists@suborbital.org.uk> 	Sun, Oct 16, 2016 at 6:30 PM
# JR across sections generate wrong code

# same file
for (["jr", 0x18], ["djnz", 0x10], ["jr nc,", 0x30]) {
	my($op, $opcode) = @$_;
	spew("$test.asm", <<END);
		SECTION LOADER
		$op 0+(pietro_loader)
		
		SECTION LOADER_CODE
	pietro_loader:
		ret
END
	capture_ok("z88dk-z80asm -b $test.asm", "");
	check_bin_file("$test.bin", bytes($opcode, 0, 0xC9));

#	capture_nok("z88dk-z80asm -b $test.asm", <<END);
#$test.asm:2: error: relative jump address not local
#  ^---- 0+(pietro_loader)
#END
}

# different files
spew("${test}.asm", <<END);
	EXTERN pietro_loader
	SECTION LOADER
	jr 0+(pietro_loader)
END
spew("${test}1.asm", <<END);
	PUBLIC pietro_loader
	SECTION LOADER_CODE
pietro_loader:
	ret
END

capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("$test.bin", bytes(0x18, 0, 0xC9));

# out of range
spew("${test}.asm", <<END);
	EXTERN pietro_loader
	SECTION LOADER
	ORG 0
	jr 0+(pietro_loader)
END
spew("${test}1.asm", <<END);
	PUBLIC pietro_loader
	SECTION LOADER_CODE
	ORG 0x8000
pietro_loader:
	ret
END

capture_nok("z88dk-z80asm -b ${test}.asm ${test}1.asm", <<END);
${test}.asm:4: error: integer range: \$7ffe
  ^---- 0+(pietro_loader)
END

unlink_testfiles;
done_testing;
