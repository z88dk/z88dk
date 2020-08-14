#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test https://github.com/z88dk/z88dk/issues/222
# z80asm: Can I use the assembler to make a .tap image, like pasmo does?

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

build_appmake();

#------------------------------------------------------------------------------
# appmake +zx
#------------------------------------------------------------------------------
my $asm = <<END;
	ld bc, 1234
	ret
END
my $bin = pack("C", 0x01).pack("v", 1234).pack("C", 0xC9);

# see http://faqwiki.zxnet.co.uk/wiki/TAP_format
my $rem_tap =
		# header
		tap_block(
				pack("C", 0). 		# header
				pack("C", 0).		# program
				"test.bin  ".		# file name
				pack("v", 25).		# length of data block
				pack("v", 10). 		# auto start line number
				pack("v", 25) 		# start of variable area
		).
		# program
		tap_block(
				pack("C", 0xFF).	# data
				pack("n", 1).		# Line 1
				pack("v", 6).		# Line 1 size
				pack("C*", 0xEA).	# REM
				$bin.				# asm program
				pack("C*", 0x0D).	# end of line
				pack("n", 10).		# Line 10
				pack("v", 11).		# Line 10 size
				pack("C*", 0xF9, 0xC0, 0xB0).				# RAND USR VAL
				'"23760"'.									# address
				pack("C*", 0x0D)	# end of line
		);

my $ramtop_tap = 
		# header1
		tap_block(
				pack("C", 0). 		# header
				pack("C", 0).		# program
				"Loader    ".		# file name
				pack("v", 30).		# length of data block
				pack("v", 10). 		# auto start line number
				pack("v", 30) 		# start of variable area
		).
		# loader program
		tap_block(
				pack("C", 0xFF).	# data
				pack("n", 10).		# Line 10
				pack("v", 26).		# Line 10 size
				pack("C*", 0xFD, 0xB0).						# CLEAR VAL
				'"23999":'.									# address :
				pack("C*", 0xEF).							# LOAD
				'""'.										# ""
				pack("C*", 0xAF).							# CODE
				':'.										# :
				pack("C*", 0xF9, 0xC0, 0xB0).				# RAND USR VAL
				'"24000"'.									# address
				pack("C*", 0x0D)	# end of line
		).
		# header2
		tap_block(
				pack("C", 0). 		# header
				pack("C", 3).		# data
				"test.bin  ".		# file name
				pack("v", 4).		# length of data block
				pack("v", 24000).	# address
				pack("v", 0) 		# n/a
		).
		# program
		tap_block(
				pack("C", 0xFF).	# data
				$bin				# asm program
		);


# no org, not verbose
unlink_testfiles();
z80asm($asm, "+zx -m");
check_bin_file("test.bin", $bin);
check_bin_file("test.tap", $rem_tap);


# no org, verbose
unlink_testfiles();
z80asm($asm, "+zx -m -v", 0, <<'END');
	Reading library 'z80asm-z80-.lib'
	Predefined constant: __CPU_Z80__ = $0001
	Predefined constant: __CPU_ZILOG__ = $0001
	Assembling 'test.asm' to 'test.o'
	Reading 'test.asm' = 'test.asm'
	Writing object file 'test.o'
	Module 'test' size: 4 bytes

	Code size: 4 bytes ($5CD0 to $5CD3)
	Creating binary 'test.bin'
	appmake +zx -b "test.bin" -o "test.tap" --org 23760
END
check_bin_file("test.bin", $bin);
check_bin_file("test.tap", $rem_tap);


# ignore ORG statements
unlink_testfiles();
z80asm("org 20000\n".$asm, "+zx -m");
check_bin_file("test.bin", $bin);
check_bin_file("test.tap", $rem_tap);


# error for -r below 23760
unlink_testfiles();
z80asm($asm, "+zx -m -r23759", 1, "", <<'END');
	Error: invalid origin: 23759
END
check_bin_file("test.bin", $bin);
ok ! -f "test.tap", "no test.tap";


# ignore split sections
unlink_testfiles();
z80asm(<<'END', "+zx -m", 0, "", <<'END');
	section code1
	org 23760
	ld bc, 1234

	section code2
	org 50000
	ret
END
	Warning: ORG ignored at file 'test.o', section 'code1'
	Warning: ORG ignored at file 'test.o', section 'code2'
END
check_bin_file("test.bin", $bin);
check_bin_file("test.tap", $rem_tap);


# above ramtop
unlink_testfiles();
z80asm($asm, "+zx -m -r24000");
check_bin_file("test.bin", $bin);
check_bin_file("test.tap", $ramtop_tap);


#------------------------------------------------------------------------------
# appmake +zx81
#------------------------------------------------------------------------------
my $rem_P = 
	# SYSTEM VARS before "VERSN" are not saved 
	# (ERR_NR, FLAGS, ERR_SP, RAMTOP, MODE, PPC are preserved)
	pack("C*", 0).				# VERSN ($4009)
	pack("v*", 1,				# E_PPC
			   16534,			# D_FILE
			   16535,			# DF_CC
			   16559+768,		# VARS
			   0,				# DEST
			   16560+768,		# E_LINE
			   16564+768,		# CH_ADD ($4016)
			   0,				# X_PTR
			   16565+768,		# STKBOT
			   16565+768).		# STKEND
	pack("C*", 0).				# BERG
	pack("v*", 16477).			# MEM
	pack("C*", 0, 				# not used
			   2).				# DF_SZ
	pack("v*", 0).				# S_TOP
	pack("C*", 191,				# LAST_K
			   253,
			   255,				# DB_ST
			   55).				# MARGIN (55 if 50hz, 31 if 60 hz)
	pack("v*", 16509,			# NXTLIN
			   0).				# OLDPPC
	pack("C*", 0).				# FLAGX
	pack("v*", 0,				# STRLEN
			   3213,			# T_ADDR
			   0, 				# SEED .. should we 'randomize' it?
			   63000,			# FRAMES
			   0).				# COORDS
	pack("C*", 188,				# PR_CC
			   33,				# S_POSN (X)
			   24,				# S_POSN (Y)
			   64).				# CDFLAG
	pack("v*", (0) x 16).
	pack("C*", 118).
	pack("v*", (0) x 5).
	pack("C*", 132,
			   32).
	pack("v*", (0) x 10).

	# Now, the basic program, here.
	# 1 REM....
	pack("n*", 1).				# line number big-endian
	pack("v*", 6).				# length
	pack("C*", 234).			# REM
	$bin.		
	pack("C*", 118).			# NEWLINE

	# 2 RAND USR VAL "16514"
	pack("n*", 2).				# line number big-endian
	pack("v*", 11).				# length
	pack("C*", 249,				# RAND
			   212,				# USR
			   197,				# VAL
			   11,				# "
			   29,				# 1
			   34,				# 6
			   33,				# 5
			   29,				# 1
			   32,				# 4
			   11,				# "
			   118).			# NEWLINE

	# At last the DISPLAY FILE
	pack("C*", (118, (0) x 32) x 24, 118, 128);


# no org, not verbose
unlink_testfiles();
z80asm($asm, "+zx81");
check_bin_file("test.bin", $bin);
check_bin_file("test.P", $rem_P);


# no org, verbose
unlink_testfiles();
z80asm($asm, "+zx81 -v", 0, <<'END', "");
	Reading library 'z80asm-z80-.lib'
	Predefined constant: __CPU_Z80__ = $0001
	Predefined constant: __CPU_ZILOG__ = $0001
	Assembling 'test.asm' to 'test.o'
	Reading 'test.asm' = 'test.asm'
	Writing object file 'test.o'
	Module 'test' size: 4 bytes

	Code size: 4 bytes ($4082 to $4085)
	Creating binary 'test.bin'
	appmake +zx81 -b "test.bin" -o "test.P" --org 16514
END
check_bin_file("test.bin", $bin);
check_bin_file("test.P", $rem_P);


unlink_testfiles();
done_testing();


sub tap_block {
	my($data) = @_;
	my $size = length($data);
	my $checksum = 0;
	for (split(//, $data)) {
		$checksum ^= ord($_);
	}
	return pack("v", $size+1).$data.pack("C", $checksum & 0xFF);
}
