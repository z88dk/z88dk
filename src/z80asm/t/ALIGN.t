#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# range check
z80asm_nok("", "", "align 0", <<END_ERR);
$test.asm:1: error: integer range: 0
  ^---- align 0
END_ERR

z80asm_nok("", "", "align 0x10000", <<END_ERR);
$test.asm:1: error: integer range: 0x10000
  ^---- align 0x10000
      ^---- align 65536
END_ERR

# align redefined
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		align 1
		align 2
END_ASM
$test.asm:2: error: ALIGN redefined
  ^---- align 2
END_ERR

# ORG and ALIGN not compatible
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		org		1
		align	16
END_ASM
$test.asm:2: error: ORG not aligned: origin=1, align=0x10
  ^---- align 16
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		align	16
		org		1
END_ASM
$test.asm:2: error: ORG not aligned: origin=1, align=0x10
  ^---- org 1
END_ERR

# constant expression
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		extern	SIXTEEN
		align	SIXTEEN
END_ASM
$test.asm:2: error: constant expression expected
  ^---- align SIXTEEN
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		extern	SIXTEEN, FILL
		align	SIXTEEN, FILL
END_ASM
$test.asm:2: error: constant expression expected
  ^---- align SIXTEEN, FILL
END_ERR

# align inside a section, check when address is already aligned
spew("$test.asm", <<END_ASM);
	defb 	1
l1:	align 	4
	defb 	2, 2
l2:	align 	4
	defb 	3, 3, 3
l3:	align 	4
	defb 	4, 4, 4, 4
l4:	align 	4
	defb 	5, 5, 5, 5
END_ASM

run_ok("z88dk-z80asm -b $test.asm");
check_bin_file("$test.bin", bytes(1,0,0,0, 2,2,0,0, 3,3,3,0, 4,4,4,4, 5,5,5,5));

# align inside a section with different filler byte
run_ok("z88dk-z80asm -b -f9 $test.asm");
check_bin_file("$test.bin", bytes(1,9,9,9, 2,2,9,9, 3,3,3,9, 4,4,4,4, 5,5,5,5));

# align inside a section with different filler byte
spew("$test.asm", <<END_ASM);
	defb 	1
l1:	align 	4, 9
	defb 	2, 2
l2:	align 	4, 9
	defb 	3, 3, 3
l3:	align 	4, 9
	defb 	4, 4, 4, 4
l4:	align 	4, 9
	defb 	5, 5, 5, 5
END_ASM

run_ok("z88dk-z80asm -b $test.asm");
check_bin_file("$test.bin", bytes(1,9,9,9, 2,2,9,9, 3,3,3,9, 4,4,4,4, 5,5,5,5));

# check section align within same group
spew("$test.asm", <<END_ASM);
	section code
	nop

	section data
	align 	16
	defb	1, 2, 3, 4
END_ASM

run_ok("z88dk-z80asm -b $test.asm");
check_bin_file("$test.bin", bytes(0, (0) x 15, 1,2,3,4));

capture_ok("z88dk-z80nm -a $test.o", <<END);
Object  file $test.o at \$0000: Z80RMF16
  Name: $test
  Section code: 1 bytes
    C \$0000: 00
  Section data: 4 bytes, ALIGN 16
    C \$0000: 01 02 03 04
END

run_ok("z88dk-z80asm -b -f0xff $test.asm");
check_bin_file("$test.bin", bytes(0, (0xff) x 15, 1,2,3,4));

# check section align in another group
spew("$test.asm", <<END_ASM);
	section code
	org 	0
	nop

	section data
	align 	16
	org		0x100
	defb	1, 2, 3, 4
END_ASM

run_ok("z88dk-z80asm -b $test.asm");
check_bin_file("${test}_code.bin", bytes(0));
check_bin_file("${test}_data.bin", bytes(1,2,3,4));

unlink_testfiles;
done_testing;
