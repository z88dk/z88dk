#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2333
# z80asm: Binary content in a defm statement generates unexpected results

my $bin = bytes(0x01, 0x18, 0xff);

spew("$test.asm", 'defm "'.$bin.'"');
run_ok("z88dk-z80asm -l -b $test.asm");
check_bin_file("$test.bin", $bin);

$bin = bytes(grep {$_ != 10 && $_ != 13 && $_ != ord('"') && $_ != ord('\\')}
			 1..255);

spew("$test.asm", 'defm "'.$bin.'"');
run_ok("z88dk-z80asm -l -b $test.asm");
check_bin_file("$test.bin", $bin);

unlink_testfiles;
done_testing;
