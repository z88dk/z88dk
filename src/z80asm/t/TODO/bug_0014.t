#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0014: -x./zx_clib should create ./zx_clib.lib but actually creates .lib
for my $lib (      "$test",    "$test.lib",
				 "./$test",  "./$test.lib",
				".\\$test", ".\\$test.lib" ) {
	next if ($lib =~ /\\/ && $^O !~ /MSWin32/);
	
    unlink("$test.lib");
	spew("$test.asm", <<END);
		PUBLIC main
main: 	ret
END
	run_ok("z88dk-z80asm -x$lib $test.asm");
	ok -f "$test.lib", "$test.lib created";
	unlink("$test.asm");
	z80asm_ok("-b -l$lib", "", "", <<END, bytes(0xc3,3,0, 0xc9));
		EXTERN main
		jp main
END
}

unlink_testfiles;
done_testing;
