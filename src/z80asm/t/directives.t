#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/directives.t,v 1.2 2015-01-02 18:21:15 pauloscustodio Exp $
#
# Test assembly directives

use Modern::Perl;
use t::TestZ80asm;

#------------------------------------------------------------------------------
# ORG
#------------------------------------------------------------------------------

# no ORG defined
z80asm(
	asm		=> "start: jp start ;; C3 00 00",
);

# ORG defined
z80asm(
	asm		=> "org 0x1234 \n start: jp start ;; C3 34 12",
);
z80asm(
	asm		=> "defc org = 0x1234 \n org org \n start: jp start ;; C3 34 12",
);

# ORG defined and overridden by command line
z80asm(
	options	=> "-b -r1234",
	asm		=> "org 0x1000 \n start: jp start ;; C3 34 12",
);

# ORG redefined
z80asm(
	asm		=> "org 0x1234 \n org 0x5678 ;; error: ORG redefined",
);

# ORG out of range
z80asm(
	asm		=> "org -2 ;; error: integer '-2' out of range",
);
z80asm(
	asm		=> "org 65536 ;; error: integer '65536' out of range",
);

# ORG not constant
z80asm(
	asm		=> "org start ;; error: symbol not defined",
);

# -r, --origin
for my $origin (0, 0x1234) {
	for my $options ("-r", "-r=", "--origin", "--origin=") {
		z80asm(
			options	=> "-b $options".sprintf("%x", $origin),
			asm		=> "start: jp start",
			bin		=> "\xC3" . pack("v", $origin),
		);
	}
}

# option out of range
for my $origin (-1, 0x10000) {
	my $origin_hex = ($origin < 0 ? "-" : "") . sprintf("%x", abs($origin));
	z80asm(
		options	=> "-b -r$origin_hex",
		asm		=> "start: jp start",
		error	=> "Error: integer '$origin' out of range",
	);
}
z80asm(
	options	=> "-b -r123Z",
	asm		=> "start: jp start",
	error	=> "Error: invalid ORG option '123Z'",
);

# BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()
z80asm(
	asm		=> "jr ASMPC+2-129 ;; error: integer '-129' out of range",
);
z80asm(
	asm		=> "jr ASMPC+2+128 ;; error: integer '128' out of range",
);

# --split-bin, ORG -1
z80asm(
	asm 	=> <<END,
	defw ASMPC
	
	section code
	defw ASMPC
	
	section data
	defw ASMPC
	
	section bss		; split file here
	org 0x4000
	defw ASMPC
END
	bin		=> pack("v*", 0, 2, 4),
);
ok   -f "test.bin";
ok ! -f "test_code.bin";
ok ! -f "test_data.bin";
test_binfile("test_bss.bin", pack("v*", 0x4000));

z80asm(
	options	=> "-b --split-bin",
	asm 	=> <<END,
	defw ASMPC		; split file here
	
	section code	; split file here
	defw ASMPC
	
	section data	; split file here
	defw ASMPC
	
	section bss		; split file here
	org 0x4000
	defw ASMPC
END
	bin		=> pack("v*", 0),
);
ok   -f "test.bin";
test_binfile("test_code.bin", 	pack("v*", 2));
test_binfile("test_data.bin", 	pack("v*", 4));
test_binfile("test_bss.bin", 	pack("v*", 0x4000));

# ORG -1 to split
z80asm(
	options	=> "-b",
	asm 	=> <<END,
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
	bin		=> pack("v*", 0, 2),
);
ok   -f "test.bin";
ok ! -f "test_code.bin";
test_binfile("test_data.bin", 	pack("v*", 0x4000));
test_binfile("test_bss.bin", 	pack("v*", 0x4002));
