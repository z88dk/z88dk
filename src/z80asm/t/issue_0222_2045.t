#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use CPU::Z80::Assembler;

# Test https://github.com/z88dk/z88dk/issues/222
# z80asm: Can I use the assembler to make a .tap image, like pasmo does?

# Test https://github.com/z88dk/z88dk/issues/2045
# z80asm: +zx creates invalid tap file if code has split sections

path("${test}dir")->mkpath;
chdir("${test}dir") or die;
{
	local $ENV{PATH} = join($Config{path_sep}, 
			"..",
			"../../../bin",
			$ENV{PATH});

#------------------------------------------------------------------------------
# appmake +zx
#------------------------------------------------------------------------------

my $zx_rem_org = 0x5CD0;	# = 23760
my $zx_ramtop_org = 24000;	# = 0x5DC0

my $asm = <<END;
asm_code:
	ld bc, 1234
	jp l1
l1:	ret
END

sub bin_code {
	my($org) = @_;
	my $bin = z80asm("org $org\n".$asm);
	return $bin;
}

spew("test.bin", bin_code($zx_rem_org));

# see http://faqwiki.zxnet.co.uk/wiki/TAP_format
my $rem_tap =
		# header
		tap_block(
				pack("C", 0). 		# header
				pack("C", 0).		# program
				"test.bin  ".		# file name
				pack("v", 28).		# length of data block
				pack("v", 10). 		# auto start line number
				pack("v", 28) 		# start of variable area
		).
		# program
		tap_block(
				pack("C", 0xFF).	# data
				pack("n", 1).		# Line 1
				pack("v", 9).		# Line 1 size
				pack("C*", 0xEA).	# REM
				bin_code($zx_rem_org). # asm program
				pack("C*", 0x0D).	# end of line
				pack("n", 10).		# Line 10
				pack("v", 11).		# Line 10 size
				pack("C*", 0xF9, 0xC0, 0xB0).				# RAND USR VAL
				'"'.$zx_rem_org.'"'.						# address
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
				'"'.($zx_ramtop_org-1).'":'.				# address :
				pack("C*", 0xEF).							# LOAD
				'""'.										# ""
				pack("C*", 0xAF).							# CODE
				':'.										# :
				pack("C*", 0xF9, 0xC0, 0xB0).				# RAND USR VAL
				'"'.$zx_ramtop_org.'"'.						# address
				pack("C*", 0x0D)	# end of line
		).
		# header2
		tap_block(
				pack("C", 0). 		# header
				pack("C", 3).		# data
				"test.bin  ".		# file name
				pack("v", 7).		# length of data block
				pack("v", 24000).	# address
				pack("v", 0) 		# n/a
		).
		# program
		tap_block(
				pack("C", 0xFF).	# data
				bin_code($zx_ramtop_org)	# asm program
		);

#------------------------------------------------------------------------------
# no org, not verbose
unlink(qw( test.asm test.o test.map test.bin test.tap ));

spew("test.asm", $asm);

capture_ok("z88dk-z80asm +zx -m test.asm", "");

check_bin_file("test.bin", bin_code($zx_rem_org));
check_bin_file("test.tap", $rem_tap);
check_text_file("test.map", <<'END');
asm_code                        = $5CD0 ; addr, local, , test, , test.asm:1
l1                              = $5CD6 ; addr, local, , test, , test.asm:4
__head                          = $5CD0 ; const, public, def, , ,
__tail                          = $5CD7 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# no org, verbose
unlink(qw( test.asm test.o test.map test.bin test.tap ));

spew("test.asm", $asm);

capture_ok("z88dk-z80asm +zx -v -m -L.. test.asm", <<'END');
% z88dk-z80asm +zx -v -m -L.. test.asm
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Library 'z88dk-z80asm.lib' not found
Reading library '../z88dk-z80asm.lib'
Assembling 'test.asm'
Writing object file 'test.o'

Code size: 7 bytes ($5CD0 to $5CD6)
Creating file 'test.map'
Creating binary 'test.bin'
z88dk-appmake +zx -b "test.bin" -o "test.tap" --org 23760
END

check_bin_file("test.bin", bin_code($zx_rem_org));
check_bin_file("test.tap", $rem_tap);
check_text_file("test.map", <<'END');
asm_code                        = $5CD0 ; addr, local, , test, , test.asm:1
l1                              = $5CD6 ; addr, local, , test, , test.asm:4
__head                          = $5CD0 ; const, public, def, , ,
__tail                          = $5CD7 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# ignore ORG statements
unlink(qw( test.asm test.o test.map test.bin test.tap ));

spew("test.asm", "org 20000\n".$asm);

capture_ok("z88dk-z80asm +zx -m test.asm", "");

check_bin_file("test.bin", bin_code($zx_rem_org));
check_bin_file("test.tap", $rem_tap);
check_text_file("test.map", <<'END');
asm_code                        = $5CD0 ; addr, local, , test, , test.asm:2
l1                              = $5CD6 ; addr, local, , test, , test.asm:5
__head                          = $5CD0 ; const, public, def, , ,
__tail                          = $5CD7 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# error for -r below 23760
unlink(qw( test.asm test.o test.map test.bin test.tap ));

spew("test.asm", $asm);

capture_nok("z88dk-z80asm +zx -r".($zx_rem_org-1)." -m test.asm", <<END);
error: invalid ORG: \$5ccf
END

check_bin_file("test.bin", bin_code($zx_rem_org-1));
ok ! -f "test.tap", "no test.tap";
check_text_file("test.map", <<'END');
asm_code                        = $5CCF ; addr, local, , test, , test.asm:1
l1                              = $5CD5 ; addr, local, , test, , test.asm:4
__head                          = $5CCF ; const, public, def, , ,
__tail                          = $5CD6 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# ignore split sections in one module
unlink(qw( test.asm test.o test.map test.bin test.tap ));

spew("test.asm", <<END);
	section code1
	org $zx_rem_org

asm_code:
	ld bc, 1234
	jp l1

	section code2
	org 0x8000

l1:	ret
END

capture_ok("z88dk-z80asm +zx -m test.asm 2> ${test}.err", "");

check_text_file("${test}.err", <<'END');
test.asm: warning: ORG ignored: file test.o, section code1
test.asm: warning: ORG ignored: file test.o, section code2
END

check_bin_file("test.bin", bin_code($zx_rem_org));
check_bin_file("test.tap", $rem_tap);
check_text_file("test.map", <<'END');
asm_code                        = $5CD0 ; addr, local, , test, code1, test.asm:4
l1                              = $5CD6 ; addr, local, , test, code2, test.asm:11
__head                          = $5CD0 ; const, public, def, , ,
__tail                          = $5CD7 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
__code1_head                    = $5CD0 ; const, public, def, , ,
__code1_tail                    = $5CD6 ; const, public, def, , ,
__code1_size                    = $0006 ; const, public, def, , ,
__code2_head                    = $5CD6 ; const, public, def, , ,
__code2_tail                    = $5CD7 ; const, public, def, , ,
__code2_size                    = $0001 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# ignore split sections in several modules
unlink(qw( test.asm test.o test.map test.bin test.tap ));

spew("test.asm", <<END);
	extern l1
	section code1
	org $zx_rem_org

asm_code:
	ld bc, 1234
	jp l1
END

spew("test1.asm", <<END);
	public l1
	section code2
	org 0x8000

l1:	ret
END

capture_ok("z88dk-z80asm +zx -m test.asm test1.asm 2> ${test}.err", "");

check_text_file("${test}.err", <<'END');
test.asm: warning: ORG ignored: file test.o, section code1
test1.asm: warning: ORG ignored: file test1.o, section code1
test1.asm: warning: ORG ignored: file test1.o, section code2
END

check_bin_file("test.bin", bin_code($zx_rem_org));
check_bin_file("test.tap", $rem_tap);
check_text_file("test.map", <<'END');
asm_code                        = $5CD0 ; addr, local, , test, code1, test.asm:5
l1                              = $5CD6 ; addr, public, , test1, code2, test1.asm:5
__head                          = $5CD0 ; const, public, def, , ,
__tail                          = $5CD7 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
__code1_head                    = $5CD0 ; const, public, def, , ,
__code1_tail                    = $5CD6 ; const, public, def, , ,
__code1_size                    = $0006 ; const, public, def, , ,
__code2_head                    = $5CD6 ; const, public, def, , ,
__code2_tail                    = $5CD7 ; const, public, def, , ,
__code2_size                    = $0001 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# above ramtop
unlink(qw( test.asm test.o test.map test.bin test.tap ));

spew("test.asm", $asm);

capture_ok("z88dk-z80asm +zx -m -r$zx_ramtop_org test.asm 2> ${test}.err", "");

check_text_file("${test}.err", <<'END');
END

check_bin_file("test.bin", bin_code($zx_ramtop_org));
check_bin_file("test.tap", $ramtop_tap);
check_text_file("test.map", <<'END');
asm_code                        = $5DC0 ; addr, local, , test, , test.asm:1
l1                              = $5DC6 ; addr, local, , test, , test.asm:4
__head                          = $5DC0 ; const, public, def, , ,
__tail                          = $5DC7 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
END


#------------------------------------------------------------------------------
# appmake +zx81
#------------------------------------------------------------------------------

my $zx81_rem_org = 16514;

my $rem_P = 
	# SYSTEM VARS before "VERSN" are not saved 
	# (ERR_NR, FLAGS, ERR_SP, RAMTOP, MODE, PPC are preserved)
	pack("C*", 0).				# VERSN ($4009)
	pack("v*", 1,				# E_PPC
			   16537,			# D_FILE
			   16538,			# DF_CC
			   16562+768,		# VARS
			   0,				# DEST
			   16563+768,		# E_LINE
			   16567+768,		# CH_ADD ($4016)
			   0,				# X_PTR
			   16568+768,		# STKBOT
			   16568+768).		# STKEND
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
	pack("v*", 9).				# length
	pack("C*", 234).			# REM
	bin_code($zx81_rem_org).		
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

#------------------------------------------------------------------------------
# no org, not verbose
unlink(qw( test.asm test.o test.map test.bin test.P ));

spew("test.asm", $asm);

capture_ok("z88dk-z80asm +zx81 -m test.asm 2> ${test}.err", "");

check_text_file("${test}.err", <<'END');
END

check_bin_file("test.bin", bin_code($zx81_rem_org));
check_bin_file("test.P", $rem_P);
check_text_file("test.map", <<'END');
asm_code                        = $4082 ; addr, local, , test, , test.asm:1
l1                              = $4088 ; addr, local, , test, , test.asm:4
__head                          = $4082 ; const, public, def, , ,
__tail                          = $4089 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# no org, verbose
unlink(qw( test.asm test.o test.map test.bin test.P ));

spew("test.asm", $asm);

capture_ok("z88dk-z80asm +zx81 -m -v -L.. test.asm 2> ${test}.err", <<'END');
% z88dk-z80asm +zx81 -m -v -L.. test.asm
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Library 'z88dk-z80asm.lib' not found
Reading library '../z88dk-z80asm.lib'
Assembling 'test.asm'
Writing object file 'test.o'

Code size: 7 bytes ($4082 to $4088)
Creating file 'test.map'
Creating binary 'test.bin'
z88dk-appmake +zx81 -b "test.bin" -o "test.P" --org 16514
END

check_text_file("${test}.err", <<'END');
END

check_bin_file("test.bin", bin_code($zx81_rem_org));
check_bin_file("test.P", $rem_P);
check_text_file("test.map", <<'END');
asm_code                        = $4082 ; addr, local, , test, , test.asm:1
l1                              = $4088 ; addr, local, , test, , test.asm:4
__head                          = $4082 ; const, public, def, , ,
__tail                          = $4089 ; const, public, def, , ,
__size                          = $0007 ; const, public, def, , ,
END


}
chdir("..") or die;
path("${test}dir")->remove_tree if Test::More->builder->is_passing;
unlink_testfiles;
done_testing;


#------------------------------------------------------------------------------
sub tap_block {
	my($data) = @_;
	my $size = length($data);
	my $checksum = 0;
	for (split(//, $data)) {
		$checksum ^= ord($_);
	}
	return pack("v", $size+1).$data.pack("C", $checksum & 0xFF);
}
