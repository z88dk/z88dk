#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

spew("$test.asm", <<'END');
	SECTION	code
	ld de,hl+1
	ld de,sp+2
	SECTION data
	defs 2
	defs 2
END

capture_ok("z88dk-z80asm -m8085 -l $test.asm", "");
check_text_file("$test.lis", <<'END');
test_t_issue_2632.asm:
     1                          	SECTION	code
     2  0000  2801              	ld de,hl+1
     3  0002  3802              	ld de,sp+2
     4                          	SECTION data
     5  0000  0000              	defs 2
     6  0002  0000              	defs 2
     7                          
END

unlink_testfiles;
done_testing;
