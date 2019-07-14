#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/312
# z80asm: implement zx next opcodes

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

my(@asm, @bin);
sub add {
	my($asm, @bytes) = @_;
	push @asm, "$asm\n";
	push @bin, pack("C*", @bytes);
}

# New Z80n opcodes on the NEXT (more to come)
# ======================================================================================
# T=4+           8T     swapnib           ED 23           A bits 7-4 swap with A bits 3-0
add("swapnib",			0xED, 0x23);

# T=4+           8T     mirror a          ED 24           mirror the bits in A
add("mirror a",			0xED, 0x24);

# 4T     mirror de         ED 26           mirror the bits in DE     
# add("mirror de",		0xED, 0x26);

# M=2+          11T   test NN (tst A,NN)  ED 27 NN       AND A with NN and set all flags. A is not affected.
add("tst 31",			0xED, 0x27, 0x1F);
add("test 31",			0xED, 0x27, 0x1F);   
add("tst a,31",			0xED, 0x27, 0x1F);
add("test a,31",		0xED, 0x27, 0x1F);

# 8T   bsla de,b          ED 28          shift DE left by B places - uses bits 4..0 of B only
# 8T   bsra de,b          ED 29          arithmetic shift right DE by B places - uses bits 4..0 of B only
# 8T   bsrl de,b          ED 2A          logical shift right DE by B places - uses bits 4..0 of B only
# 8T   bsrf de,b          ED 2B          shift right DE by B places, filling from left with 1s - uses bits 4..0 of B only
# 8T   brlc de,b          ED 2C          rotate DE left by B places - uses bits 3..0 of B only
add("bsla de,b",		0xED, 0x28);
add("bsra de,b",		0xED, 0x29);
add("bsrl de,b",		0xED, 0x2A);
add("bsrf de,b",		0xED, 0x2B);
add("brlc de,b",		0xED, 0x2C);

# T=4+           8T     mul d,e (mlt de)  ED 30           multiply DE = D*E (no flags set)
add("mul d,e",			0xED, 0x30);
add("mlt de",			0xED, 0x30);
add("mul de",			0xED, 0x30);

# T=4+           8T     add  hl,a         ED 31           Add A to HL (no flags set) not sign extended
# T=4+           8T     add  de,a         ED 32           Add A to DE (no flags set) not sign extended
# T=4+           8T     add  bc,a         ED 33           Add A to BC (no flags set) not sign extended
add("add hl,a",			0xED, 0x31);
add("add de,a",			0xED, 0x32);
add("add bc,a",			0xED, 0x33);

# M=3+, T=4           16T    add  hl,NNNN     ED 34 LO HI     Add NNNN to HL (no flags set)
# M=3+, T=4           16T    add  de,NNNN     ED 35 LO HI     Add NNNN to DE (no flags set)
# M=3+, T=4           16T    add  bc,NNNN     ED 36 LO HI     Add NNNN to BC (no flags set)
add("add hl,32767",		0xED, 0x34, 0xFF, 0x7F);
add("add de,32767",		0xED, 0x35, 0xFF, 0x7F);
add("add bc,32767",		0xED, 0x36, 0xFF, 0x7F);

# M=6+           23T    push NNNN        ED 8A HI LO     push 16bit immediate value, note big endian order
add("push 1",			0xED, 0x8A, 0x00, 0x01);
add("push 256",			0xED, 0x8A, 0x01, 0x00);
add("push 32767",		0xED, 0x8A, 0x7F, 0xFF);

# 4T*    pop x             ED 8B           pop value and discard
# add("pop x",			0xED, 0x8B);

# 16T   outinb             ED 90          outi without modifying B, out (c),(hl), hl++
add("outinb",			0xED, 0x90);

# M=5+           20T    nextreg reg,val   ED 91 reg,val   Set a NEXT register (like doing out($243b),reg then out($253b),val
# M=4+           17T    nextreg reg,a     ED 92 reg       Set a NEXT register using A (like doing out($243b),reg then out($253b),A )
# ** reg,val are both 8-bit numbers
add("nextreg 31,63", 	0xED, 0x91, 0x1F, 0x3F);
add("nextreg 31,a",		0xED, 0x92, 0x1F);

# T=4+           8T   pixeldn           ED 93           move down a line on the ULA screen
# T=4+           8T   pixelad           ED 94           using D,E (as Y,X) calculate the ULA screen address and store in HL
# T=4+           8T   setae             ED 95           Using the lower 3 bits of E (X coordinate), set the correct bit value in A
add("pixeldn",			0xED, 0x93);
add("pixelad",			0xED, 0x94);
add("setae",			0xED, 0x95);

# 13T   jp (c)             ED 98          PC[13:0] = IN (C) << 6
add("jp (c)",			0xED, 0x98);

# M=4+           16T    ldix              ED A4           As LDI,  but if byte==A does not copy
# M=4+           14T    ldws              ED A5           (de)=(hl), l++, d++ for layer 2 vertical tile copy
# M=4+           16T    lddx              ED AC           As LDD,  but if byte==A does not copy, and DE is incremented
# M=4+           21T    ldirx             ED B4           As LDIR, but if byte==A does not copy
# M=4+           21T*   ldpirx            ED B7           (de) = ( (hl&$fff8)+(E&7) ) when != A
# M=4+           21T    lddrx             ED BC           As LDDR,  but if byte==A does not copy, and DE is incremented
add("ldix",				0xED, 0xA4);
add("ldws",				0xED, 0xA5);
add("lddx",				0xED, 0xAC);
add("ldirx",			0xED, 0xB4);
add("ldpirx",			0xED, 0xB7);
add("lddrx",			0xED, 0xBC);

# ** Instructions that have been removed due to limited fpga space.
#    They have been removed from z80asm in the current main branch.
# 
# "mul" 
# "ld a32,dehl" 
# "ld dehl,a32" 
# "ex a32, dehl" 
# "ld hl,sp" 
# "inc dehl" 
# "dec dehl" 
# "add dehl,a"
# "add dehl,bc" 
# "add dehl,NN" 
# "sub dehl,a" 
# "sub dehl,bc" 
# "popx" 
# "fillde" 
# "ldirscale"		add("ldirscale",		0xED, 0xB6);


# Memory mapping - specify which 8k ram page is placed into
# the corresponding 8k slot of the z80's 64k memory space.
# 
# 12T*  mmu0 NN           ED 91 50 NN      macro: Ram page in slot 0-8k
# 12T*  mmu1 NN           ED 91 51 NN      macro: Ram page in slot 8k-16k
# 12T*  mmu2 NN           ED 91 52 NN      macro: Ram page in slot 16k-24k
# 12T*  mmu3 NN           ED 91 53 NN      macro: Ram page in slot 24k-32k
# 12T*  mmu4 NN           ED 91 54 NN      macro: Ram page in slot 32k-40k
# 12T*  mmu5 NN           ED 91 55 NN      macro: Ram page in slot 40k-48k
# 12T*  mmu6 NN           ED 91 56 NN      macro: Ram page in slot 48k-56k
# 12T*  mmu7 NN           ED 91 57 NN      macro: Ram page in slot 56k-64k
for my $page (0..7) {
	add("mmu$page 31",	0xED, 0x91, 0x50 + $page, 0x1F);
	add("mmu $page,31",	0xED, 0x91, 0x50 + $page, 0x1F);
}

# 
# 12T*  mmu0 a            ED 92 50         macro: Ram page in slot 0-8k
# 12T*  mmu1 a            ED 92 51         macro: Ram page in slot 8k-16k
# 12T*  mmu2 a            ED 92 52         macro: Ram page in slot 16k-24k
# 12T*  mmu3 a            ED 92 53         macro: Ram page in slot 24k-32k
# 12T*  mmu4 a            ED 92 54         macro: Ram page in slot 32k-40k
# 12T*  mmu5 a            ED 92 55         macro: Ram page in slot 40k-48k
# 12T*  mmu6 a            ED 92 56         macro: Ram page in slot 48k-56k
# 12T*  mmu7 a            ED 92 57         macro: Ram page in slot 56k-64k
for my $page (0..7) {
	add("mmu$page a",	0xED, 0x92, 0x50 + $page);
	add("mmu $page,a",	0xED, 0x92, 0x50 + $page);
}

# 
# * Times are guesses based on other instruction times.  All of this subject to change.

# COPPER UNIT
# ======================================================================================
# cu.wait VER,HOR   ->  16-bit encoding 0x8000 + (HOR << 9) + VER
# (0<=VER<=311, 0<=HOR<=55)  BIG ENDIAN!
add("cu.wait 0,1",		0x82, 0x00);
add("cu.wait 0,2",		0x84, 0x00);
add("cu.wait 0,55",		0xEE, 0x00);

add("cu.wait 1,0",		0x80, 0x01);
add("cu.wait 2,0",		0x80, 0x02);
add("cu.wait 311,0",	0x81, 0x37);

# cu.move REG,VAL  -> 16-bit encoding (REG << 8) + VAL
# (0<= REG <= 127, 0 <= VAL <= 255)  BIG ENDIAN!
add("cu.move 0,0",		0x00, 0x00);
add("cu.move 1,0",		0x01, 0x00);
add("cu.move 127,0",	0x7F, 0x00);

add("cu.move 0,1",		0x00, 0x01);
add("cu.move 0,2",		0x00, 0x02);
add("cu.move 0,127",	0x00, 0x7F);
add("cu.move 0,255",	0x00, 0xFF);
add("cu.move 0,-1",		0x00, 0xFF);
add("cu.move 0,-128",	0x00, 0x80);

# cu.stop   -> 16-bit encoding 0xffff (impossible cu.wait)
add("cu.stop", 			0xFF, 0xFF);

# cu.nop  -> 16-bit encoding 0x0000 (do nothing cu.move)
add("cu.nop", 			0x00, 0x00);

z80asm(join('', @asm), "-mz80n -l -b", 0, "", "");
check_bin_file("test.bin", join('', @bin));

#------------------------------------------------------------------------------
# test list file
z80asm(<<END, "-mz80n -l", 0, "", "");
	cu.wait 0,1
END
check_text_file("test.lis", <<END);
1     0000  82 00       cu.wait 0,1
2     0002
END

#------------------------------------------------------------------------------
# test error
z80asm("cu.wait 0,1", "-mz80", 1, "", <<'END');
Error at file 'test.asm' line 1: illegal identifier
END

#------------------------------------------------------------------------------
# link-time constants
my $HOR = 1; 
my $VER = 2; 
my $REG = 3; 
my $VAL = 4;
spew("test1.asm", <<"END");
	public VER,HOR,REG,VAL
	defc VER = $VER
	defc HOR = $HOR
	defc REG = $REG
	defc VAL = $VAL
END
run("z80asm test1.asm", 0, "", "");

z80asm(<<'END', "-mz80n -b -otest.bin test1.o", 0, "", "");
	extern VER,HOR,REG,VAL
	cu.wait VER,HOR
	cu.move REG,VAL
END
check_bin_file("test.bin", pack("n*", 0x8000 + ($HOR << 9) + $VER, ($REG << 8) + $VAL));

unlink_testfiles();
unlink_testfiles();
done_testing;
