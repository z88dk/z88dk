#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/1572
# z80asm: -reloc-info adds -O directory path twice

unlink_testfiles;
path("${test}dir")->remove_tree;
path("${test}dir")->mkpath;

spew("${test}.asm", <<END);
		start:
			nop
			jp start
END

capture_ok("z88dk-z80asm -O${test}dir -b -reloc-info -g -m -l ${test}.asm", "");

ok -f "${test}dir/${test}.bin", 	"${test}dir/${test}.bin created";
ok -f "${test}dir/${test}.lis", 	"${test}dir/${test}.lis created";
ok -f "${test}dir/${test}.map", 	"${test}dir/${test}.map created";
ok -f "${test}dir/${test}.def", 	"${test}dir/${test}.def created";
ok -f "${test}dir/${test}.o", 	 	"${test}dir/${test}.o created";
ok -f "${test}dir/${test}.reloc", 	"${test}dir/${test}.reloc created";

check_bin_file("${test}dir/${test}.bin", bytes(0,0xC3,0,0));

path("${test}dir")->remove_tree;
unlink_testfiles;
done_testing;
