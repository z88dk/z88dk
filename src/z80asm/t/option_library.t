#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# -L

# create library
unlink_testfiles;
my $lib_dir  = "t/data";
my $lib_base = "${test}.lib";
my $lib = "$lib_dir/$lib_base";

spew("${test}.asm", <<END);
	PUBLIC main
main: ret
END

run_ok("z88dk-z80asm -x$lib ${test}.asm");
ok -f $lib, "library created";

my $asm = <<END;
	EXTERN main
	call main
	ret
END

my $bin = bytes(0xCD, 0x04, 0x00, 0xC9, 0xC9);

# no -L, full path : OK
z80asm_ok("-b -l$lib", "", "", $asm, $bin);

# no -L, only file name : error
z80asm_nok("-b -l$lib_base", "", $asm, <<END);
error: file open: ${test}.lib
END

# -L : OK
z80asm_ok("-b -L$lib_dir -l$lib_base", "", "", $asm, $bin);

# use environment variable in -L
$ENV{TEST_ENV} = 'data';
z80asm_ok("-b -Lt/\${TEST_ENV} -l$lib_base", "", "", $asm, $bin);

delete $ENV{TEST_ENV};
z80asm_ok("-b -Lt/\${TEST_ENV}data -l$lib_base", "", "", $asm, $bin);

unlink_testfiles($lib);


# link objects and libs
# library modules are loaded in alpha-sequence of labels, starting at 10
unlink_testfiles;
spew("${test}1.asm", <<END);
	PUBLIC A1
A1:	defb 1
END

spew("${test}2.asm", <<END);
	PUBLIC A2
A2:	defb 2
END

spew("${test}3.asm", <<END);
	PUBLIC A3
A3:	defb 3
END

capture_ok("z88dk-z80asm ".
		   "-x${test}1.lib ${test}1.asm ${test}2.asm ${test}3.asm", "");
ok -f "${test}1.lib";

spew("${test}4.asm", <<END);
	PUBLIC A4
A4:	defb 4
END

spew("${test}5.asm", <<END);
	PUBLIC A5
A5:	defb 5
END

spew("${test}6.asm", <<END);
	PUBLIC A6
A6:	defb 6
END

capture_ok("z88dk-z80asm ".
		   "-x${test}2.lib ${test}4.asm ${test}5.asm ${test}6.asm", "");
ok -f "${test}2.lib";

spew("${test}.asm", <<END);
A0:	
	EXTERN A1,A2,A3,A4,A5,A6,A7,A8,A9
	defb   A1,A2,A3,A4,A5,A6,A7,A8,A9
	defb   0
END

spew("${test}7.asm", <<END);
	PUBLIC A7
A7:	defb 7
END

spew("${test}8.asm", <<END);
	PUBLIC A8
A8:	defb 8
END

spew("${test}9.asm", <<END);
	PUBLIC A9
A9: defb 9
END

capture_ok("z88dk-z80asm ".
		   "-l -b -l${test}1.lib -l${test}2.lib ".
		   "${test}.asm ${test}7.asm ${test}8.asm ${test}9.asm", "");
ok -f "${test}.bin";

check_bin_file("${test}.bin", 
				bytes(	13, 14, 15, 16, 17, 18, 10, 11, 12,
						0,
						7, 8, 9, 1, 2, 3, 4, 5, 6,
						));

# PUBLIC and EXTERN
unlink_testfiles;
spew("${test}1.asm", <<END);
	PUBLIC func_1
	PUBLIC func_2
func_1:
	ld a,1
func_2:
	ld a,2
	ret
END

spew("${test}2.asm", <<END);
	EXTERN  func_2
	call func_2
	ret
END

# link object files
capture_ok("z88dk-z80asm -b ${test}2.asm ${test}1.asm", "");
check_bin_file("${test}2.bin", 
		bytes(0xCD, 0x06, 0x00, 0xC9, 0x3E, 0x01, 0x3E, 0x02, 0xC9));

# link library files
capture_ok("z88dk-z80asm -x${test}1.lib ${test}1.asm", "");
capture_ok("z88dk-z80asm -b -l${test}1.lib ${test}2.asm", "");
check_bin_file("${test}2.bin", 
		bytes(0xCD, 0x06, 0x00, 0xC9, 0x3E, 0x01, 0x3E, 0x02, 0xC9));


unlink_testfiles;
done_testing;
