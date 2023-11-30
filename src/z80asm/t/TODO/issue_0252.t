#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/252
# z80asm: z80asm ignores _map file if 0 bytes

for my $one_step (0, 1) {
	unlink_testfiles;
	spew("${test}map.asm", <<'END');
		section s0
		org 0
		section s1
		section s2
		section s3
		section a0
		org 0x100
		section a1
		section b0
		org 0x200
		section b1
END
	spew("${test}src.asm", <<'END');
		section s0
		defb 0

		section s1
		defb 1

		section s2
		defb 2

		section s3
		defb 3

		section a0
		defb 10

		section a1
		defb 11

		section b0
		defb 20

		section b1
		defb 21
END

	if ($one_step) {
		capture_ok("z88dk-z80asm -b -o${test}.bin -m ${test}map.asm ${test}src.asm", "");
	}
	else {
		capture_ok("z88dk-z80asm ${test}map.asm ${test}src.asm", "");
		capture_ok("z88dk-z80asm -b -o${test}.bin -m ${test}map.o ${test}src.o", "");
	}

	check_bin_file("${test}_s0.bin", bytes(0, 1, 2, 3));
	check_bin_file("${test}_a0.bin", bytes(10, 11));
	check_bin_file("${test}_b0.bin", bytes(20, 21));

	check_text_file("${test}.map", <<'END');
__head                          = $0000 ; const, public, def, , ,
__tail                          = $0202 ; const, public, def, , ,
__size                          = $0202 ; const, public, def, , ,
__s0_head                       = $0000 ; const, public, def, , ,
__s0_tail                       = $0001 ; const, public, def, , ,
__s0_size                       = $0001 ; const, public, def, , ,
__s1_head                       = $0001 ; const, public, def, , ,
__s1_tail                       = $0002 ; const, public, def, , ,
__s1_size                       = $0001 ; const, public, def, , ,
__s2_head                       = $0002 ; const, public, def, , ,
__s2_tail                       = $0003 ; const, public, def, , ,
__s2_size                       = $0001 ; const, public, def, , ,
__s3_head                       = $0003 ; const, public, def, , ,
__s3_tail                       = $0004 ; const, public, def, , ,
__s3_size                       = $0001 ; const, public, def, , ,
__a0_head                       = $0100 ; const, public, def, , ,
__a0_tail                       = $0101 ; const, public, def, , ,
__a0_size                       = $0001 ; const, public, def, , ,
__a1_head                       = $0101 ; const, public, def, , ,
__a1_tail                       = $0102 ; const, public, def, , ,
__a1_size                       = $0001 ; const, public, def, , ,
__b0_head                       = $0200 ; const, public, def, , ,
__b0_tail                       = $0201 ; const, public, def, , ,
__b0_size                       = $0001 ; const, public, def, , ,
__b1_head                       = $0201 ; const, public, def, , ,
__b1_tail                       = $0202 ; const, public, def, , ,
__b1_size                       = $0001 ; const, public, def, , ,
END

	run_ok("z88dk-appmake +glue -b ${test} -c ${test} --clean");
	
	check_bin_file("${test}__.bin", bytes(
			0, 1, 2, 3, (0xFF) x (0x100 - 4), 
			10, 11, (0xFF) x (0x100 - 2), 
			20, 21));
}

unlink_testfiles;
done_testing;
