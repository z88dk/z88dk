#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test org

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

# no ORG defined
unlink_testfiles();
z80asm("start: jp start");
check_bin_file("test.bin", pack("C*", 0xC3, 0x00, 0x00));

# ORG defined
unlink_testfiles();
z80asm("org 0x1234 \n start: jp start");
check_bin_file("test.bin", pack("C*", 0xC3, 0x34, 0x12));

unlink_testfiles();
z80asm("defc org = 0x1234 \n org org \n start: jp start");
check_bin_file("test.bin", pack("C*", 0xC3, 0x34, 0x12));

# ORG defined and overridden by command line
unlink_testfiles();
z80asm("org 0x1000 \n start: jp start", "-b -r0x1234");
check_bin_file("test.bin", pack("C*", 0xC3, 0x34, 0x12));

# no ORG
unlink_testfiles();
z80asm("org", "", 1, "", <<'ERR');
Error at file 'test.asm' line 1: syntax error
ERR

# ORG redefined
unlink_testfiles();
z80asm("org 0x1234 \n org 0x5678", "", 1, "", <<'ERR');
Error at file 'test.asm' line 2: ORG redefined
ERR

# ORG OK
unlink_testfiles();
z80asm("org 0 \n jp ASMPC");
check_bin_file("test.bin", pack("C*", 0xC3, 0x00, 0x00));

unlink_testfiles();
z80asm("org 65535 \n defb ASMPC & 0xFF");
check_bin_file("test.bin", pack("C*", 0xFF));

unlink_testfiles();
z80asm("org 65535 \n defb ASMPC >> 8");
check_bin_file("test.bin", pack("C*", 0xFF));

# ORG out of range
unlink_testfiles();
z80asm("org -2", "", 1, "", <<'ERR');
Error at file 'test.asm' line 1: integer '-2' out of range
ERR

# ORG not constant
unlink_testfiles();
z80asm("extern start \n org start", "", 1, "", <<'ERR');
Error at file 'test.asm' line 2: expected constant expression
ERR

# -r, --origin -- tested in options.t

# BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()
unlink_testfiles();
z80asm("jr ASMPC+2-129", "", 1, "", <<'ERR');
Error at file 'test.asm' line 1: integer '-129' out of range
ERR

unlink_testfiles();
z80asm("jr ASMPC+2+128", "", 1, "", <<'ERR');
Error at file 'test.asm' line 1: integer '128' out of range
ERR

# --split-bin, ORG -1
unlink_testfiles();
z80asm(<<'END');
	defw ASMPC
	
	section code
	defw ASMPC
	
	section data
	defw ASMPC
	
	section bss		; split file here
	org 0x4000
	defw ASMPC
END
check_bin_file("test.bin", pack("v*", 0, 2, 4));
ok ! -f "test_code.bin", "test_code.bin";
ok ! -f "test_data.bin", "test_data.bin";
check_bin_file("test_bss.bin", pack("v*", 0x4000));

unlink_testfiles();
z80asm(<<'END', "-b --split-bin");
	defw ASMPC		; split file here
	
	section code	; split file here
	defw ASMPC
	
	section data	; split file here
	defw ASMPC
	
	section bss		; split file here
	org 0x4000
	defw ASMPC
END
check_bin_file("test_code.bin", 	pack("v*", 2));
check_bin_file("test_data.bin", 	pack("v*", 4));
check_bin_file("test_bss.bin", 		pack("v*", 0x4000));

# ORG -1 to split
unlink_testfiles();
z80asm(<<'END', "-b");
	defw ASMPC
	
	section code
	defw ASMPC
	
	section data	; split file here
	org 0x4000
	defw ASMPC
	
	section bss		; split file here
	org -1
	defw ASMPC
END
check_bin_file("test.bin", pack("v*", 0, 2));
ok ! -f "test_code.bin", "test_code.bin";
check_bin_file("test_data.bin", 	pack("v*", 0x4000));
check_bin_file("test_bss.bin", 		pack("v*", 0x4002));

unlink_testfiles();
done_testing();
