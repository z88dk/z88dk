#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

path("$test.asm")->spew(<<END);
lstoff
ld bc,1
lston
ld hl,1
END

run_ok("./z88dk-z80asm -b -l $test.asm");
ok -f "$test.lis", "$test.lis exists";

check_bin_file("$test.bin", bytes(1, 1, 0, 0x21, 1, 0));
check_txt_file("$test.lis", <<END);
1     0000              lstoff
4     0003  21 01 00    ld hl,1
5     0006              
END

unlink("$test.lis");
run_ok("./z88dk-z80asm -b $test.asm");
ok ! -f "$test.lis", "$test.lis does not exist";


unlink_testfiles;
done_testing;
