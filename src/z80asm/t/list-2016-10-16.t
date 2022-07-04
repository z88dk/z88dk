#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Bug report: z80asm: bug with relative jumps across sections
# alvin (alvin_albrecht@hotmail.com) <lists@suborbital.org.uk> 	Sun, Oct 16, 2016 at 6:30 PM
# JR across sections generate wrong code
for my $op ("jr", "djnz", "jr nc,") {
	spew("$test.asm", <<END);
		SECTION LOADER
		$op 0+(pietro_loader)
		
		SECTION LOADER_CODE
	pietro_loader:
		ret
END
	capture_nok("z88dk-z80asm -b $test.asm", <<END);
$test.asm:2: error: relative jump address not local
  ^---- 0+(pietro_loader)
END
}

unlink_testfiles;
done_testing;
