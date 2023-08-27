#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test map file
# - BUG_0036 : Map file does not show local symbols with the same name in different modules
# If the same local symbol is defined in multiple modules, only one of
# them appears in the map file.

my $asm = <<END;
	define not_shown
	defc zero=0
	PUBLIC main
main: ld b,10
loop: djnz loop
	PUBLIC last
last:
x31_x31_x31_x31_x31_x31_x31_x31: defb zero
x_32_x32_x32_x32_x32_x32_x32_x32: defb zero
END

my $asm_s = <<END;
	ld b,10
	djnz ASMPC
	defw 0
END

my $asm1 = <<END;
	define not_shown
	
	; show DEFC alias in map file
	PUBLIC alias_main
	EXTERN main
	defc alias_main = main
	
	PUBLIC alias_last
	EXTERN last
	defc alias_last = last

	PUBLIC func
func: ld b,10
loop: djnz loop
	  ret
END

my $asm1_s = <<END;
	ld b,10
	djnz ASMPC
	ret
END

my $bin = bytes(0x06, 0x0A, 0x10, 0xFE, 0x00, 0x00, 0x06, 0x0A, 0x10, 0xFE, 0xC9);


# no -m
unlink_testfiles;
spew("${test}.asm", $asm_s);
spew("${test}1.asm", $asm1_s);
run_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm");
ok ! -f "${test}.map", "no ${test}.map";
check_bin_file("${test}.bin", $bin);


# -m, no symbols
unlink_testfiles;
spew("${test}.asm", $asm_s);
spew("${test}1.asm", $asm1_s);
run_ok("z88dk-z80asm -b -m ${test}.asm ${test}1.asm");
ok -f "${test}.map", "found ${test}.map";
check_bin_file("${test}.bin", $bin);
check_text_file("${test}.map", <<'END');
__head                          = $0000 ; const, public, def, , ,
__tail                          = $000B ; const, public, def, , ,
__size                          = $000B ; const, public, def, , ,
END


# -m, symbols
unlink_testfiles;
spew("${test}.asm", $asm);
spew("${test}1.asm", $asm1);
run_ok("z88dk-z80asm -b -m ${test}.asm ${test}1.asm");
ok -f "${test}.map", "found ${test}.map";
check_bin_file("${test}.bin", $bin);
check_text_file("${test}.map", <<'END');
zero                            = $0000 ; const, local, , test_t_option_map, , test_t_option_map.asm:2
loop                            = $0002 ; addr, local, , test_t_option_map, , test_t_option_map.asm:5
x31_x31_x31_x31_x31_x31_x31_x31 = $0004 ; addr, local, , test_t_option_map, , test_t_option_map.asm:8
x_32_x32_x32_x32_x32_x32_x32_x32 = $0005 ; addr, local, , test_t_option_map, , test_t_option_map.asm:9
loop                            = $0008 ; addr, local, , test_t_option_map1, , test_t_option_map1.asm:14
main                            = $0000 ; addr, public, , test_t_option_map, , test_t_option_map.asm:4
last                            = $0004 ; addr, public, , test_t_option_map, , test_t_option_map.asm:7
alias_main                      = $0000 ; addr, public, , test_t_option_map1, , test_t_option_map1.asm:6
alias_last                      = $0004 ; addr, public, , test_t_option_map1, , test_t_option_map1.asm:10
func                            = $0006 ; addr, public, , test_t_option_map1, , test_t_option_map1.asm:13
__head                          = $0000 ; const, public, def, , ,
__tail                          = $000B ; const, public, def, , ,
__size                          = $000B ; const, public, def, , ,
END

unlink_testfiles;
done_testing;
