#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/312
# z80asm: implement zx next opcodes

use strict;
use warnings;
use v5.10;
use Test::More;
require './t/testlib.pl';

my(@asm, @bin);
sub add {
	my($asm, @bytes) = @_;
	push @asm, "$asm\n";
	push @bin, pack("C*", @bytes);
}

# New Z80 opcodes on the NEXT (more to come)
# ======================================================================================
# 4T*    swapnib           ED 23           A bits 7-4 swap with A bits 3-0
add("swap",				0xED, 0x23);
add("swapnib",			0xED, 0x23);

# 4T     mul               ED 30           multiply DE*HL = DEHL (no flags set)
add("mul",				0xED, 0x30);

# 4T     add  hl,a         ED 31           Add A to HL (no flags set) not sign extended
add("add hl,a",			0xED, 0x31);

# 4T*    add  de,a         ED 32           Add A to DE (no flags set) not sign extended
add("add de,a",			0xED, 0x32);

# 4T*    add  bc,a         ED 33           Add A to BC (no flags set) not sign extended
add("add bc,a",			0xED, 0x33);

# 12T    add  hl,NNNN    ED 34 LO HI     Add NNNN to HL (no flags set)
add("add hl,32767",		0xED, 0x34, 0xFF, 0x7F);

# 12T*   add  de,NNNN     ED 35 LO HI     Add NNNN to DE (no flags set)
add("add de,32767",		0xED, 0x35, 0xFF, 0x7F);

# 12T*   add  bc,NNNN     ED 36 LO HI     Add NNNN to BC (no flags set)
add("add bc,32767",		0xED, 0x36, 0xFF, 0x7F);

# 16T*      outinb            ED 90           out (c),(hl), hl++
add("outinb",			0xED, 0x90);

# 16T    ldix              ED A4           As LDI,  but if byte==A does not copy
add("ldix",				0xED, 0xA4);

# 21T    ldirx             ED B4           As LDIR, but if byte==A does not copy
add("ldirx",			0xED, 0xB4);

# 16T*   lddx              ED AC           As LDD,  but if byte==A does not copy, and DE is incremented
add("lddx",				0xED, 0xAC);

# 21T*   lddrx             ED BC           As LDDR,  but if byte==A does not copy
add("lddrx",			0xED, 0xBC);

# 21T*   fillde            ED B5           Using A fill from DE for BC bytes
add("fillde",			0xED, 0xB5);
add("fill de",			0xED, 0xB5);

# 21T*   ldirscale         ED B6           As LDIRX,  if(hl)!=A then (de)=(hl); HL_A'+=BC'; DE+=DE'; dec BC; Loop.
add("ldirscale",		0xED, 0xB6);

# 14T*   ldpirx            ED B7           (de) = ( (hl&$fff8)+(E&7) ) when != A
add("ldpirx",			0xED, 0xB7);

# 4T*    ld  hl,sp         ED 25           transfer SP to HL
add("ld hl,sp",			0xED, 0x25);

# 4T*    ld  a32,dehl    ED 20           transfer dehl into A32
add("ld a32,dehl",		0xED, 0x20);

# 4T*    ld  dehl,a32    ED 21           transfer A32 into dehl
add("ld dehl,a32",		0xED, 0x21);

# 4T*    ex  a32,dehl    ED 22           swap A32 with dehl
add("ex a32,dehl",		0xED, 0x22);

# 4T     inc dehl          ED 37           increment 32bit dehl
add("inc dehl",			0xED, 0x37);

# 4T*    dec dehl          ED 38           decrement 32bit dehl
add("dec dehl",			0xED, 0x38);

# 4T*    add dehl,a        ED 39           Add A to 32bit dehl not sign extended
add("add dehl,a",		0xED, 0x39);

# 4T     add dehl,bc       ED 3A           Add BC to 32bit dehl not sign extended
add("add dehl,bc",		0xED, 0x3A);

# 12T    add dehl,NNNN    ED 3B LO HI     Add NNNN to 32bit dehl
add("add dehl,32767",	0xED, 0x3B, 0xFF, 0x7F);

# 4T*    sub dehl,a        ED 3C           Subtract A from 32bit dehl not sign extended
add("sub dehl,a",		0xED, 0x3C);

# 4T*    sub dehl,bc       ED 3D           Subtract BC from 32bit dehl not sign extended
add("sub dehl,bc",		0xED, 0x3D);

# 4T     mirror a          ED 24           mirror the bits in A     
add("mirror a",			0xED, 0x24);

# 4T     mirror de         ED 26           mirror the bits in DE     
add("mirror de",		0xED, 0x26);

# 12T*   push NNNN        ED 8A LO HI     push 16bit immediate value
add("push 32767",		0xED, 0x8A, 0xFF, 0x7F);

# 4T*    popx              ED 8B           pop value and discard
add("popx",				0xED, 0x8B);

# ** reg,val are both 8-bit numbers
# 12T*   nextreg reg,val   ED 91 reg,val   Set a NEXT register (like doing out($243b),reg then out($253b),val
add("nextreg 31,63", 	0xED, 0x91, 0x1F, 0x3F);

#  8T*    nextreg reg,a     ED 92 reg       Set a NEXT register using A (like doing out($243b),reg then out($253b),A )
add("nextreg 31,a",		0xED, 0x92, 0x1F);

# 4T   pixeldn           ED 93           Move down a line on the ULA screen
add("pixeldn",			0xED, 0x93);

# 4T   pixelad           ED 94           using D,E (as Y,X) calculate the ULA screen address and store in HL
add("pixelad",			0xED, 0x94);

# 4T   setae             ED 95           Using the lower 3 bits of E (X coordinate), set the correct bit value in A
add("setae",			0xED, 0x95);

# 7T   test NN           ED 27 NN       And A with NN and set all flags. A is not affected.
add("tst 31",			0xED, 0x27, 0x1F);
add("test 31",			0xED, 0x27, 0x1F);   
add("tst a,31",			0xED, 0x27, 0x1F);
add("test a,31",		0xED, 0x27, 0x1F);

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
# * Times are guesses based on other instruction times.  All of this subject to change.


z80asm(join('', @asm), "--cpu=z80-zxn -l -b", 0, "", "");
check_bin_file("test.bin", join('', @bin));

unlink_testfiles();
done_testing;
