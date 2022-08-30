#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/850
# (z80asm) Doesn't handle empty library files

# not possible to create empty library file
unlink_testfiles;
capture_nok("z88dk-z80asm -x${test}.lib ".quote_os("${test}*.asm"), <<END);
error: pattern returned no files: ${test}*.asm
END

# force the error and check behaviour
unlink_testfiles;
spew("${test}.asm", "");
capture_ok("z88dk-z80asm -x${test}.lib ${test}.asm", "");
ok -f "${test}.lib", "${test}.lib created";

# invalid lib, only header
my $bytes = slurp("${test}.lib");
spew("${test}.lib", substr($bytes, 0, 8));		

# link with empty lib
spew("${test}.asm", <<END);
	extern main
	jp main
END

capture_nok("z88dk-z80asm -b -l${test}.lib ${test}.asm", <<END);
${test}.asm:2: error: undefined symbol: main
  ^---- main
END

unlink_testfiles;
done_testing;
