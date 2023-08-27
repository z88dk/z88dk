#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0002 : CreateLibFile and GetLibFile: buffer overrun
spew("$test.asm", <<END);
		PUBLIC one
one:	ld a,1
		ret
END
run_ok("z88dk-z80asm -x$test.lib $test.asm");
z80asm_ok("-b -l$test.lib", "", "", <<END, bytes(0xc3,3,0, 0x3e,1, 0xc9));
		EXTERN one
		jp one
END

unlink_testfiles;
done_testing;
