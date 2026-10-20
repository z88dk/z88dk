#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/3192
# z80asm: record in the map file which bank each section belongs to
# The section column of __<section>_head, _tail and _size shows the section
# that starts the block the section is linked into: the last section at or
# before it with an ORG (or ORG -1), the one that names its binary file.

for my $one_step ( 0, 1 ) {
    unlink_testfiles;
    spew( "${test}1.asm", <<END );
		SECTION code_crt0

		SECTION BANK_0
		org 0x8000
		SECTION code_user
		SECTION rodata_user

		SECTION BANK_1
		org -1
		SECTION code_b1

		SECTION PAGE_20
		org 0x14C000
		SECTION code_p20
END

    spew( "${test}2.asm", <<END );
		SECTION code_crt0
		defb 1

		SECTION code_user
		PUBLIC _main
	_main:
		ret

		SECTION rodata_user
		defb 2,3,4

		SECTION code_b1
		defb 5

		SECTION code_p20
	p20:
		ld a,6
END

    if ($one_step) {
        capture_ok( "z88dk-z80asm -b -o${test}.bin -m ${test}1.asm ${test}2.asm",
            "" );
    }
    else {
        capture_ok( "z88dk-z80asm ${test}1.asm",                          "" );
        capture_ok( "z88dk-z80asm ${test}2.asm",                          "" );
        capture_ok( "z88dk-z80asm -b -o${test}.bin -m ${test}1.o ${test}2.o", "" );
    }

    check_bin_file( "${test}.bin",         bytes( 1 ) );
    check_bin_file( "${test}_BANK_0.bin",  bytes( 0xC9, 2, 3, 4 ) );
    check_bin_file( "${test}_BANK_1.bin",  bytes( 5 ) );
    check_bin_file( "${test}_PAGE_20.bin", bytes( 0x3E, 6 ) );
    check_text_file( "${test}.map", <<END );
__BANK_0_head                   = \$8000 ; const, public, def, , BANK_0,
__BANK_0_size                   = \$0000 ; const, public, def, , BANK_0,
__BANK_0_tail                   = \$8000 ; const, public, def, , BANK_0,
__BANK_1_head                   = \$8004 ; const, public, def, , BANK_1,
__BANK_1_size                   = \$0000 ; const, public, def, , BANK_1,
__BANK_1_tail                   = \$8004 ; const, public, def, , BANK_1,
__PAGE_20_head                  = \$14C000 ; const, public, def, , PAGE_20,
__PAGE_20_size                  = \$0000 ; const, public, def, , PAGE_20,
__PAGE_20_tail                  = \$14C000 ; const, public, def, , PAGE_20,
__code_b1_head                  = \$8004 ; const, public, def, , BANK_1,
__code_b1_size                  = \$0001 ; const, public, def, , BANK_1,
__code_b1_tail                  = \$8005 ; const, public, def, , BANK_1,
__code_crt0_head                = \$0000 ; const, public, def, , ,
__code_crt0_size                = \$0001 ; const, public, def, , ,
__code_crt0_tail                = \$0001 ; const, public, def, , ,
__code_p20_head                 = \$14C000 ; const, public, def, , PAGE_20,
__code_p20_size                 = \$0002 ; const, public, def, , PAGE_20,
__code_p20_tail                 = \$14C002 ; const, public, def, , PAGE_20,
__code_user_head                = \$8000 ; const, public, def, , BANK_0,
__code_user_size                = \$0001 ; const, public, def, , BANK_0,
__code_user_tail                = \$8001 ; const, public, def, , BANK_0,
__head                          = \$0000 ; const, public, def, , ,
__rodata_user_head              = \$8001 ; const, public, def, , BANK_0,
__rodata_user_size              = \$0003 ; const, public, def, , BANK_0,
__rodata_user_tail              = \$8004 ; const, public, def, , BANK_0,
__size                          = \$14C002 ; const, public, def, , ,
__tail                          = \$14C002 ; const, public, def, , ,
_main                           = \$8000 ; addr, public, , ${test}2, code_user, ${test}2.asm:6
p20                             = \$14C000 ; addr, local, , ${test}2, code_p20, ${test}2.asm:16
END
}

unlink_testfiles;
done_testing;
