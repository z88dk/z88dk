#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use Data::HexDump;

# Test https://github.com/z88dk/z88dk/issues/343
# z80asm: Rabbit emulation of cpi and cpir is broken

spew("${test}.asm",<<END);
		extern __z80asm__cpir
		call   __z80asm__cpir
END

capture_ok("z88dk-z80asm -mz80 -b ${test}.asm", "");
my $bin1 = HexDump(slurp("${test}.bin"));

capture_ok("z88dk-z80asm -mr2ka -b ${test}.asm", "");
my $bin2 = HexDump(slurp("${test}.bin"));

isnt $bin1, $bin2, "binary different";

spew("${test}.c", <<'END');
#include <string.h>
#include <stdio.h>
int main () {
	printf("%d\n", strncmp("hello world", "hello", 5) == 0);
	printf("%d\n", strncmp("HELLO WORLD", "hello", 5) <  0);
	return 0;
}
END

run_ok("zcc +test -clib=rabbit -o${test}.bin ${test}.c");
run_ok("z88dk-ticks -mr2ka ${test}.bin > ${test}.out");
open(my $fh, "<", "${test}.out") or die;
like scalar(<$fh>), qr/^1\s*/, "first test true";
like scalar(<$fh>), qr/^1\s*/, "second test true";

unlink_testfiles();
done_testing();
