#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/717
# z80asm: sections with ALIGN property should not insert padding if the section is empty

z80asm_ok("", "", "", <<END, bytes(1,3));
	section a
	defb 1
	
	section b
	align 16
	
	section c
	defb 3
END

z80asm_ok("", "", "", <<END, bytes(1, (0) x 15, 2, 3));
	section a
	defb 1
	
	section b
	align 16
	defb 2
	
	section c
	defb 3
END


unlink_testfiles;
done_testing;
