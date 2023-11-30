#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2417
# z80asm: Issue with spaces in the directory name

my $list = "$test.1.lst";
my $file1 = "$test 1.asm"; spew($file1, "defb 1");
my $file2 = "$test 2.asm"; spew($file2, "defb 2");
my $file3 = "$test 3.asm"; spew($file3, "defb 3");
spew($list, <<END);
 $test 1.asm
 '$test 2.asm'
 "'$test 3.asm'"
END

capture_ok("z88dk-z80asm -b ".quote_os('@'.$list), "");
check_bin_file("$test 1.bin", bytes(1,2,3));

unlink_testfiles();
done_testing();
