#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# z80asm: deletion of empty binary files except first not always working #2043 
# https://github.com/z88dk/z88dk/issues/2043

#------------------------------------------------------------------------------
# empty default section and empty code section
unlink_testfiles;
spew("${test}.asm", <<END);
	section code
END

capture_ok("z88dk-z80asm -b -reloc-info -split-bin ${test}.asm", "");

ok -f "${test}.bin", "${test}.bin exists";
check_bin_file("${test}.bin", bytes());

ok -f "${test}.reloc", "${test}.reloc exists";
check_bin_file("${test}.reloc", bytes());

ok !-f "${test}_code.bin", "${test}_code.bin does not exist";
ok !-f "${test}_code.reloc", "${test}_code.reloc does not exist";

#------------------------------------------------------------------------------
# empty default section and non-empty code section
unlink_testfiles;
spew("${test}.asm", <<END);
	section code
	s2: jp s2
END

capture_ok("z88dk-z80asm -b -reloc-info -split-bin ${test}.asm", "");

ok -f "${test}.bin", "${test}.bin exists";
check_bin_file("${test}.bin", bytes());

ok -f "${test}.reloc", "${test}.reloc exists";
check_bin_file("${test}.reloc", bytes());

ok -f "${test}_code.bin", "${test}_code.bin exists";
check_bin_file("${test}_code.bin", bytes(0xC3, 0, 0));

ok -f "${test}_code.reloc", "${test}_code.reloc exists";
check_bin_file("${test}_code.reloc", words(1));

#------------------------------------------------------------------------------
# non-empty default section and empty code section
unlink_testfiles;
spew("${test}.asm", <<END);
	s1: jp s1
	section code
END

capture_ok("z88dk-z80asm -b -reloc-info -split-bin ${test}.asm", "");

ok -f "${test}.bin", "${test}.bin exists";
check_bin_file("${test}.bin", bytes(0xC3, 0, 0));

ok -f "${test}.reloc", "${test}.reloc exists";
check_bin_file("${test}.reloc", words(1));

ok !-f "${test}_code.bin", "${test}_code.bin does not exist";
ok !-f "${test}_code.reloc", "${test}_code.reloc does not exist";

#------------------------------------------------------------------------------
# non-empty default section and non-empty code section
unlink_testfiles;
spew("${test}.asm", <<END);
	s1: jp s1
	section code
	s2: jp s2
END

capture_ok("z88dk-z80asm -b -reloc-info -split-bin ${test}.asm", "");

ok -f "${test}.bin", "${test}.bin exists";
check_bin_file("${test}.bin", bytes(0xC3, 0, 0));

ok -f "${test}.reloc", "${test}.reloc exists";
check_bin_file("${test}.reloc", words(1));

ok -f "${test}_code.bin", "${test}_code.bin exists";
check_bin_file("${test}_code.bin", bytes(0xC3, 3, 0));

ok -f "${test}_code.reloc", "${test}_code.reloc exists";
check_bin_file("${test}_code.reloc", words(1));

#------------------------------------------------------------------------------
# no reloc data in non-empty default section and non-empty code section
unlink_testfiles;
spew("${test}.asm", <<END);
	ld hl,1
	section code
	ld hl,2
END

capture_ok("z88dk-z80asm -b -reloc-info -split-bin ${test}.asm", "");

ok -f "${test}.bin", "${test}.bin exists";
check_bin_file("${test}.bin", bytes(0x21, 1, 0));

ok -f "${test}.reloc", "${test}.reloc exists";
check_bin_file("${test}.reloc", words());

ok -f "${test}_code.bin", "${test}_code.bin exists";
check_bin_file("${test}_code.bin", bytes(0x21, 2, 0));

ok -f "${test}_code.reloc", "${test}_code.reloc exists";
check_bin_file("${test}_code.reloc", words());



unlink_testfiles;
done_testing;
