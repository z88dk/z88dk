#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# -g
my $asm = <<END;
	PUBLIC main
	PUBLIC x31_x31_x31_x31_x31_x31_x31_x31
	PUBLIC x_32_x32_x32_x32_x32_x32_x32_x32
main: ld b,10
loop: djnz loop
	PUBLIC last
last:
x31_x31_x31_x31_x31_x31_x31_x31: defb 0
x_32_x32_x32_x32_x32_x32_x32_x32: defb 0
END

my $asm1 = <<END;
	; show DEFC alias in map file
	PUBLIC alias_main
	EXTERN main
	defc alias_main = main
	
	PUBLIC alias_last
	EXTERN last
	defc alias_last = last

	PUBLIC func
func: ret
END

my $bin = bytes(0x06, 0x0A, 0x10, 0xFE, 0x00, 0x00, 0xC9);

# no -g
unlink_testfiles;
spew("${test}.asm", $asm);
spew("${test}1.asm", $asm1);
run_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm");
ok !-f "${test}.def", "no definitions file";

# -g
unlink_testfiles;
spew("${test}.asm", $asm);
spew("${test}1.asm", $asm1);
run_ok("z88dk-z80asm -b -g ${test}.asm ${test}1.asm");
ok -f "${test}.def", "no definitions file";
check_text_file("${test}.def", <<END);
DEFC main                            = \$0000
DEFC x31_x31_x31_x31_x31_x31_x31_x31 = \$0004
DEFC x_32_x32_x32_x32_x32_x32_x32_x32 = \$0005
DEFC last                            = \$0004
DEFC alias_main                      = \$0000
DEFC alias_last                      = \$0004
DEFC func                            = \$0006
END

unlink_testfiles;
done_testing;
