#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test ALIGN

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

# range check
unlink_testfiles();
z80asm("align 0", "", 1, "", <<'END');
Error at file 'test.asm' line 1: integer '0' out of range
END

unlink_testfiles();
z80asm("align 0x10000", "", 1, "", <<'END');
Error at file 'test.asm' line 1: integer '65536' out of range
END

# align redefined
unlink_testfiles();
z80asm("align 1 \n align 2", "", 1, "", <<'END');
Error at file 'test.asm' line 2: ALIGN redefined
END

# ORG and ALIGN not compatible
unlink_testfiles();
z80asm("org 1 \n align 16", "", 1, "", <<'END');
Error at file 'test.asm' line 2: ORG '0x0001' not ALIGNed '16'
END

unlink_testfiles();
z80asm("align 16 \n org 1", "", 1, "", <<'END');
Error at file 'test.asm' line 2: ORG '0x0001' not ALIGNed '16'
END

# constant expression
z80asm("extern SIXTEEN \n align SIXTEEN", "", 1, "", <<'END');
Error at file 'test.asm' line 2: expected constant expression
END

z80asm("extern SIXTEEN, FILL \n align SIXTEEN, FILL", "", 1, "", <<'END');
Error at file 'test.asm' line 2: expected constant expression
END

# align inside a section, check when address is already aligned
unlink_testfiles();
z80asm(<<'END', "-l -s -b -m", 0, "", "");
	defb 	1
l1:	align 	4
	defb 	2, 2
l2:	align 	4
	defb 	3, 3, 3
l3:	align 	4
	defb 	4, 4, 4, 4
l4:	align 	4
	defb 	5, 5, 5, 5
END
check_bin_file("test.bin", pack("C*", 1,0,0,0, 2,2,0,0, 3,3,3,0, 4,4,4,4, 5,5,5,5));

# align inside a section with different filler byte
unlink_testfiles();
z80asm(<<'END', "-l -s -b -m -f9", 0, "", "");
	defb 	1
l1:	align 	4
	defb 	2, 2
l2:	align 	4
	defb 	3, 3, 3
l3:	align 	4
	defb 	4, 4, 4, 4
l4:	align 	4
	defb 	5, 5, 5, 5
END
check_bin_file("test.bin", pack("C*", 1,9,9,9, 2,2,9,9, 3,3,3,9, 4,4,4,4, 5,5,5,5));

# align inside a section with different filler byte
unlink_testfiles();
z80asm(<<'END', "-l -s -b -m", 0, "", "");
	defb 	1
l1:	align 	4, 9
	defb 	2, 2
l2:	align 	4, 9
	defb 	3, 3, 3
l3:	align 	4, 9
	defb 	4, 4, 4, 4
l4:	align 	4, 9
	defb 	5, 5, 5, 5
END
check_bin_file("test.bin", pack("C*", 1,9,9,9, 2,2,9,9, 3,3,3,9, 4,4,4,4, 5,5,5,5));

# check section align within same group
unlink_testfiles();
z80asm(<<'END', "-l -s -b -m", 0, "", "");
	section code
	nop

	section data
	align 	16
	defb	1, 2, 3, 4
END
check_bin_file("test.bin", pack("C*", 0, (0) x 15, 1,2,3,4));

z80nm("test.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section code: 1 bytes
    C $0000: 00
  Section data: 4 bytes, ALIGN 16
    C $0000: 01 02 03 04
END

unlink_testfiles();
z80asm(<<'END', "-l -s -b -m -f0xFF", 0, "", "");
	section code
	nop

	section data
	align 	16
	defb	1, 2, 3, 4
END
check_bin_file("test.bin", pack("C*", 0, (0xFF) x 15, 1,2,3,4));

# check section align in another group
unlink_testfiles();
z80asm(<<'END', "-l -s -b -m", 0, "", "");
	section code
	org 	0
	nop

	section data
	align 	16
	org		0x100
	defb	1, 2, 3, 4
END
check_bin_file("test_code.bin", pack("C*", 0));
check_bin_file("test_data.bin", pack("C*", 1,2,3,4));

unlink_testfiles();
done_testing();
