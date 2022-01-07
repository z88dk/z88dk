#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test list and symbol files
# BUG_0026 : Incorrect paging in symbol list
# BUG_0027 : Incorrect tabulation in symbol list
# BUG_0028 : Not aligned page list in symbol list with more that 18 references
# BUG_0029 : Incorrect alignment in list file with more than 4 bytes opcode
# BUG_0030 : List bytes patching overwrites header
# BUG_0031 : List file garbled with input lines with 255 chars

use Modern::Perl;
use Test::More;
require './t/testlib.pl';


# check option combinations
my $asm = <<'END';
	defc X = 42
	defb X
END

my $bin = pack("C*", 42);

my $sym = <<'END';
	X                               = $002A ; const, local, , , , test.asm:1
END

my $lis = <<'END';
test.asm:
     1                          	defc X = 42
     2   000000 2a              	defb X
     3                          
END

# no -s, no -l
unlink_testfiles();
z80asm($asm, "-b");
ok ! -f "test.sym", "no test.sym";
ok ! -f "test.lis", "no test.lis";
check_bin_file("test.bin", $bin);

# -s, no -l
unlink_testfiles();
z80asm($asm, "-b -s");
ok   -f "test.sym", "test.sym";
ok ! -f "test.lis", "no test.lis";
check_bin_file("test.bin", $bin);
check_text_file("test.sym", $sym);

# no -s, -l
unlink_testfiles();
z80asm($asm, "-b -l");
ok ! -f "test.sym", "test.sym";
ok   -f "test.lis", "no test.lis";
check_bin_file("test.bin", $bin);
check_text_file("test.lis", $lis);

# -s, -l
unlink_testfiles();
z80asm($asm, "-b -s -l");
ok   -f "test.sym", "test.sym";
ok   -f "test.lis", "no test.lis";
check_bin_file("test.bin", $bin);
check_text_file("test.sym", $sym);
check_text_file("test.lis", $lis);


# public and local symbols
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	public global0
	public global1
	global0: defb 0
	global1: defb 1
	local0: defb 0
	local1: defb 1
END
check_bin_file("test.bin", pack("C*", 0, 1, 0, 1));
check_text_file("test.sym", <<'END');
	local0                          = $0002 ; addr, local, , , , test.asm:5
	local1                          = $0003 ; addr, local, , , , test.asm:6
	global0                         = $0000 ; addr, public, , , , test.asm:3
	global1                         = $0001 ; addr, public, , , , test.asm:4
END
check_text_file("test.lis", <<'END');
test.asm:
     1                          	public global0
     2                          	public global1
     3   000000 00              	global0: defb 0
     4   000001 01              	global1: defb 1
     5   000002 00              	local0: defb 0
     6   000003 01              	local1: defb 1
     7                          
END


# very long symbol
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	X_255_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X: defb 255
END
check_bin_file("test.bin", pack("C*", 255));
check_text_file("test.sym", <<'END');
	X_255_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X = $0000 ; addr, local, , , , test.asm:1
END
check_text_file("test.lis", <<'END');
test.asm:
     1   000000 ff              	X_255_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X: defb 255
     2                          
END


# different sizes of byte string
$asm = "";
$bin = "";
for (1..6, 64, 65) {
	$asm .= "defb ".join(",", 1..$_)."\n";
	$bin .= pack("C*", 1..$_);
}
unlink_testfiles();
z80asm($asm, "-b -s -l");
check_bin_file("test.bin", $bin);
check_text_file("test.sym", "");
check_text_file("test.lis", <<'END');
test.asm:
     1   000000 01              defb 1
     2   000001 0102            defb 1,2
     3   000003 010203          defb 1,2,3
     4   000006 01020304        defb 1,2,3,4
     5   00000a 0102030405      defb 1,2,3,4,5
     6   00000f 010203040506    defb 1,2,3,4,5,6
     7   000015 0102030405060708defb 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64
                090a0b0c0d0e0f10
                1112131415161718
                191a1b1c1d1e1f20
                2122232425262728
                292a2b2c2d2e2f30
                3132333435363738
                393a3b3c3d3e3f40
     8   000055 0102030405060708defb 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65
                090a0b0c0d0e0f10
                1112131415161718
                191a1b1c1d1e1f20
                2122232425262728
                292a2b2c2d2e2f30
                3132333435363738
                393a3b3c3d3e3f40
                41              
     9                          
END


# very long patch string
$asm = "defb ".join(",", ('X') x 256)."\n".
	   "defc X = 42\n";
$bin = pack("C*", (42) x 256);
unlink_testfiles();
z80asm($asm, "-b -s -l");
check_text_file("test.sym", <<'END');
	X                               = $002A ; const, local, , , , test.asm:2
END
check_text_file("test.lis", <<'END');
test.asm:
     1   000000 2a2a2a2a2a2a2a2adefb X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
                2a2a2a2a2a2a2a2a
     2                          defc X = 42
     3                          
END


# use after defined, local
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	defc A1 = 1
	defb A1
	defw A1
	defq A1
END
check_bin_file("test.bin", pack("C*", 1, 1,0, 1,0,0,0));
check_text_file("test.sym", <<'END');
	A1                              = $0001 ; const, local, , , , test.asm:1
END
check_text_file("test.lis", <<'END');
test.asm:
     1                          	defc A1 = 1
     2   000000 01              	defb A1
     3   000001 0100            	defw A1
     4   000003 01000000        	defq A1
     5                          
END


# use after defined, global
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	defc A1 = 1
	defb A1
	defw A1
	defq A1
	public A1
END
check_bin_file("test.bin", pack("C*", 1, 1,0, 1,0,0,0));
check_text_file("test.sym", <<'END');
	A1                              = $0001 ; const, public, , , , test.asm:1
END
check_text_file("test.lis", <<'END');
test.asm:
     1                          	defc A1 = 1
     2   000000 01              	defb A1
     3   000001 0100            	defw A1
     4   000003 01000000        	defq A1
     5                          	public A1
     6                          
END


# use before defined, local
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	defb A1
	defw A1
	defq A1
	defc A1 = 1
END
check_bin_file("test.bin", pack("C*", 1, 1,0, 1,0,0,0));
check_text_file("test.sym", <<'END');
	A1                              = $0001 ; const, local, , , , test.asm:4
END
check_text_file("test.lis", <<'END');
test.asm:
     1   000000 01              	defb A1
     2   000001 0100            	defw A1
     3   000003 01000000        	defq A1
     4                          	defc A1 = 1
     5                          
END


# use after defined, global
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	defb A1
	defw A1
	defq A1
	defc A1 = 1
	public A1
END
check_bin_file("test.bin", pack("C*", 1, 1,0, 1,0,0,0));
check_text_file("test.sym", <<'END');
	A1                              = $0001 ; const, public, , , , test.asm:4
END
check_text_file("test.lis", <<'END');
test.asm:
     1   000000 01              	defb A1
     2   000001 0100            	defw A1
     3   000003 01000000        	defq A1
     4                          	defc A1 = 1
     5                          	public A1
     6                          
END


# include file
unlink_testfiles();
spew("test.inc", <<'END');
	ld a, A1
	ld b, B1
	add a, b
END
z80asm(<<'END', "-b -s -l");
	defb A1, B1
	defc A1 = 1
	defc B1 = 2
	public B1
	include "test.inc"
	include "test.inc"
END
check_bin_file("test.bin", pack("C*", 
	1, 2,
	0x3E, 1, 0x06, 2, 0x80,
	0x3E, 1, 0x06, 2, 0x80));
check_text_file("test.sym", <<'END');
	A1                              = $0001 ; const, local, , , , test.asm:2
	B1                              = $0002 ; const, public, , , , test.asm:3
END
check_text_file("test.lis", <<'END');
test.asm:
     1   000000 0102            	defb A1, B1
     2                          	defc A1 = 1
     3                          	defc B1 = 2
     4                          	public B1
     5                          	include "test.inc"
test.inc:
     1   000002 3e01            	ld a, A1
     2   000004 0602            	ld b, B1
     3   000006 80              	add a, b
     4                          
test.asm:
     6                          	include "test.inc"
test.inc:
     1   000007 3e01            	ld a, A1
     2   000009 0602            	ld b, B1
     3   00000b 80              	add a, b
     4                          
test.asm:
     7                          
END


# defvars
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	defvars 0x4000
	{
		RUNTIMEFLAGS1 ds.b 1
		RUNTIMEFLAGS2 ds.b 1
	}
	defw RUNTIMEFLAGS1, RUNTIMEFLAGS2
END
check_bin_file("test.bin", pack("v*", 0x4000, 0x4001));
check_text_file("test.sym", <<'END');
	RUNTIMEFLAGS1                   = $4000 ; const, local, , , , test.asm:3
	RUNTIMEFLAGS2                   = $4001 ; const, local, , , , test.asm:4
END
check_text_file("test.lis", <<'END');
test.asm:
     1                          	defvars 0x4000
     2                          	{
     3                          		RUNTIMEFLAGS1 ds.b 1
     4                          		RUNTIMEFLAGS2 ds.b 1
     5                          	}
     6   000000 00400140        	defw RUNTIMEFLAGS1, RUNTIMEFLAGS2
     7                          
END


# defgroup
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	defgroup
	{
		SYM_NULL, SYM_DQUOTE, SYM_SQUOTE, SYM_SEMICOLON,
		SYM_COMMA, SYM_FULLSTOP, SYM_LPAREN, 
		SYM_LCURLY, SYM_RCURLY
	}
	defb SYM_NULL, SYM_DQUOTE, SYM_SQUOTE, SYM_SEMICOLON
	defb SYM_COMMA, SYM_FULLSTOP, SYM_LPAREN
	defb SYM_LCURLY, SYM_RCURLY
END
check_bin_file("test.bin", pack("C*", 0..8));
check_text_file("test.sym", <<'END');
	SYM_NULL                        = $0000 ; const, local, , , , test.asm:3
	SYM_DQUOTE                      = $0001 ; const, local, , , , test.asm:3
	SYM_SQUOTE                      = $0002 ; const, local, , , , test.asm:3
	SYM_SEMICOLON                   = $0003 ; const, local, , , , test.asm:3
	SYM_COMMA                       = $0004 ; const, local, , , , test.asm:4
	SYM_FULLSTOP                    = $0005 ; const, local, , , , test.asm:4
	SYM_LPAREN                      = $0006 ; const, local, , , , test.asm:4
	SYM_LCURLY                      = $0007 ; const, local, , , , test.asm:5
	SYM_RCURLY                      = $0008 ; const, local, , , , test.asm:5
END
check_text_file("test.lis", <<'END');
test.asm:
     1                          	defgroup
     2                          	{
     3                          		SYM_NULL, SYM_DQUOTE, SYM_SQUOTE, SYM_SEMICOLON,
     4                          		SYM_COMMA, SYM_FULLSTOP, SYM_LPAREN,
     5                          		SYM_LCURLY, SYM_RCURLY
     6                          	}
     7   000000 00010203        	defb SYM_NULL, SYM_DQUOTE, SYM_SQUOTE, SYM_SEMICOLON
     8   000004 040506          	defb SYM_COMMA, SYM_FULLSTOP, SYM_LPAREN
     9   000007 0708            	defb SYM_LCURLY, SYM_RCURLY
    10                          
END


# lston lstoff
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	ld bc, 0
	lstoff
	ld bc, -1
	lston
	inc bc
END
check_bin_file("test.bin", pack("C*", 1, 0,0, 1, 255,255, 3));
check_text_file("test.sym", "");
check_text_file("test.lis", <<'END');
test.asm:
     1   000000 010000          	ld bc, 0
     2                          	lstoff
     5   000006 03              	inc bc
     6                          
END



# if else endif
unlink_testfiles();
z80asm(<<'END', "-b -s -l");
	if 0
		ld bc, 0
	else
		ld bc, 1
	endif
	
	if 1
		ld hl, 1
	else
		ld hl, 0
	endif
END
check_bin_file("test.bin", pack("C*", 1, 1,0, 0x21, 1,0));
check_text_file("test.sym", "");
check_text_file("test.lis", <<'END');
test.asm:
     1                          	if 0
     2                          		ld bc, 0
     3                          	else
     4   000000 010100          		ld bc, 1
     5                          	endif
     6                          
     7                          	if 1
     8   000003 210100          		ld hl, 1
     9                          	else
    10                          		ld hl, 0
    11                          	endif
    12                          
END


# list with more than 10000 lines
my $num_lines = 10001;
unlink_testfiles();
z80asm(
	join("\n", ("nop") x $num_lines)."\n", 
	"-b -s -l");
check_bin_file("test.bin", pack("C*", (0) x $num_lines));
check_text_file("test.sym", "");
check_text_file("test.lis", 
	"test.asm:\n".
	join("", map {sprintf("%6d   %06x %02x              nop\n", $_+1, $_, 0)} 
				0..$num_lines-1).
	sprintf("%6d                          \n", $num_lines+1));

unlink_testfiles();
done_testing();
