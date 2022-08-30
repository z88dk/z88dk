#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/2049
# z80asm: inconsistent output with -oFILE

#------------------------------------------------------------------------------
# single binary objects
#------------------------------------------------------------------------------

# no -o
unlink_testfiles;
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b ${test}.asm");
ok -f "${test}.bin", "binary file";
check_bin_file("${test}.bin", bytes(0));

# -o without extension
unlink_testfiles;
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b -o${test}xx ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
check_bin_file("${test}xx", bytes(0));

# -o with bin extension
unlink_testfiles;
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b -o${test}xx.bin ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
check_bin_file("${test}xx.bin", bytes(0));

# -o with extension != .bin
unlink_testfiles;
spew("${test}.asm", "nop");
run_ok("z88dk-z80asm -b -o${test}.sms ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
check_bin_file("${test}.sms", bytes(0));

#------------------------------------------------------------------------------
# multiple binary objects
#------------------------------------------------------------------------------
my $asm = <<END;
	section code
	org 0
	ret
	
	section data
	org 0x8000
	defb 1
END

# no -o
unlink_testfiles;
spew("${test}.asm", $asm);
run_ok("z88dk-z80asm -b ${test}.asm");
check_bin_file("${test}.bin", bytes());
check_bin_file("${test}_code.bin", bytes(0xC9));
check_bin_file("${test}_data.bin", bytes(1));

# -o without extension
unlink_testfiles;
spew("${test}.asm", $asm);
run_ok("z88dk-z80asm -b -o${test}xx ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
check_bin_file("${test}xx", bytes());
check_bin_file("${test}xx_code.bin", bytes(0xC9));
check_bin_file("${test}xx_data.bin", bytes(1));

# -o with bin extension
unlink_testfiles;
spew("${test}.asm", $asm);
run_ok("z88dk-z80asm -b -o${test}xx.bin ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
check_bin_file("${test}xx.bin", bytes());
check_bin_file("${test}xx_code.bin", bytes(0xC9));
check_bin_file("${test}xx_data.bin", bytes(1));

# -o with extension != .bin
unlink_testfiles;
spew("${test}.asm", $asm);
run_ok("z88dk-z80asm -b -o${test}xx.sms ${test}.asm");
ok !-f "${test}.bin", "no default binary file";
check_bin_file("${test}xx.sms", bytes());
check_bin_file("${test}xx_code.bin", bytes(0xC9));
check_bin_file("${test}xx_data.bin", bytes(1));

unlink_testfiles;
done_testing;
