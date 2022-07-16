#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/312
# z80asm: implement zx next opcodes

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

z80asm_ok("-b -mz80n -l", "", "", join('', @asm), join('', @bin));

#------------------------------------------------------------------------------
# test list file
unlink_testfiles;
z80asm_ok("-b -mz80n -l", "", "", <<END, bytes(0x82, 0));
	cu.wait 0,1
END

check_text_file("${test}.lis", <<END);
${test}.asm:
     1   000000 8200            	cu.wait 0,1
     2                          
     3                          
END

#------------------------------------------------------------------------------
# test error
unlink_testfiles;
z80asm_nok("-mz80", "", "cu.wait 0,1", <<END);
${test}.asm:1: error: illegal identifier
  ^---- cu.wait 0,1
END

#------------------------------------------------------------------------------
# link-time constants
unlink_testfiles;
my $HOR = 1; 
my $VER = 2; 
my $REG = 3; 
my $VAL = 4;
spew("${test}1.asm", <<END);
	public VER,HOR,REG,VAL
	defc VER = $VER
	defc HOR = $HOR
	defc REG = $REG
	defc VAL = $VAL
END

spew("${test}.asm", <<END);
	extern VER,HOR,REG,VAL
	cu.wait VER,HOR
	cu.move REG,VAL
END

capture_ok("z88dk-z80asm ${test}1.asm", "");

capture_ok("z88dk-z80asm -b -mz80n ${test}.asm ${test}1.o", "");

check_bin_file("${test}.bin", 
	pack("n*", 0x8000 + ($HOR << 9) + $VER, ($REG << 8) + $VAL));


#==============================================================================
# Test DMA
#==============================================================================

#------------------------------------------------------------------------------
# check cpu
#------------------------------------------------------------------------------

z80asm_nok("-b", "", <<END, <<END);
	ld a,1
	dma.wr0 1
	ld a,2
END
${test}.asm:2: error: illegal identifier
  ^---- dma.wr0 1
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x01, 0x3E, 2));
	ld a,1
	dma.wr0 1
	ld a,2
END

#------------------------------------------------------------------------------
# DMA.WR0
#------------------------------------------------------------------------------

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr0
	ld a,2
END
${test}.asm:2: error: syntax error
  ^---- dma.wr0
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	extern ext
	ld a,1
	dma.wr0 ext
	ld a,2
END
${test}.asm:3: error: constant expression expected
  ^---- dma.wr0 ext
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr0 -1
	ld a,2
END
${test}.asm:2: error: integer range: -1
  ^---- dma.wr0 -1
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr0 255
	ld a,2
END
${test}.asm:2: error: DMA base register byte illegal: 0xff
  ^---- dma.wr0 255
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr0 0
	dma.wr0 2
	dma.wr0 3
	dma.wr0 128
	ld a,2
END
${test}.asm:2: error: DMA base register byte illegal: 0
  ^---- dma.wr0 0
${test}.asm:3: error: DMA base register byte illegal: 2
  ^---- dma.wr0 2
${test}.asm:4: error: DMA base register byte illegal: 3
  ^---- dma.wr0 3
${test}.asm:5: error: DMA base register byte illegal: 0x80
  ^---- dma.wr0 128
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr0 0
	ld a,2
END
${test}.asm:2: error: DMA base register byte illegal: 0
  ^---- dma.wr0 0
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x01, 0x3E, 2));
	ld a,1
	dma.wr0 1
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr0 1, 99
	ld a,2
END
${test}.asm:2: error: DMA too many arguments
  ^---- dma.wr0 1, 99
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr0 1, 
			99
	ld a,2
END
${test}.asm:3: error: DMA too many arguments
  ^---- 99
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr0 1, 
END
${test}.asm:3: error: syntax error
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
lbl:dma.wr0 0x09
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- lbl:dma.wr0 0x09
      ^---- lbl:dma.wr0 9
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x09, 0x02, 0x3E, 2));
	ld a,1
lbl:dma.wr0 0x09, 
			lbl
	ld a,2
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x11, 0x02, 0x3E, 2));
	ld a,1
lbl:dma.wr0 0x11, 
			lbl
	ld a,2
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x19, 0x02, 0x80, 0x3E, 2));
	ld a,1
lbl:dma.wr0 0x19, 
			lbl+0x8000
	ld a,2
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x21, 0x02, 0x3E, 2));
	ld a,1
lbl:dma.wr0 0x21, 
			lbl
	ld a,2
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x41, 0x02, 0x3E, 2));
	ld a,1
lbl:dma.wr0 0x41, 
			lbl
	ld a,2
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x61, 0x02, 0x80, 0x3E, 2));
	ld a,1
lbl:dma.wr0 0x61, 
			lbl+0x8000
	ld a,2
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x79, 0x02, 0x40, 0x02, 0x80, 0x3E, 2));
	ld a,1
lbl:dma.wr0 0x79, 
			lbl+0x4000,
			lbl+0x8000
	ld a,2
END

#------------------------------------------------------------------------------
# DMA.WR1
#------------------------------------------------------------------------------

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr1 1
	dma.wr1 2
	dma.wr1 3
	dma.wr1 5
	dma.wr1 6
	dma.wr1 7
	dma.wr1 128
	ld a,2
END
${test}.asm:2: error: DMA base register byte illegal: 1
  ^---- dma.wr1 1
${test}.asm:3: error: DMA base register byte illegal: 2
  ^---- dma.wr1 2
${test}.asm:4: error: DMA base register byte illegal: 3
  ^---- dma.wr1 3
${test}.asm:5: error: DMA base register byte illegal: 5
  ^---- dma.wr1 5
${test}.asm:6: error: DMA base register byte illegal: 6
  ^---- dma.wr1 6
${test}.asm:7: error: DMA base register byte illegal: 7
  ^---- dma.wr1 7
${test}.asm:8: error: DMA base register byte illegal: 0x80
  ^---- dma.wr1 128
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x04, 0x3E, 2));
	ld a,1
	dma.wr1 0x04
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr1 0x44
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr1 0x44
      ^---- dma.wr1 68
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	extern ext
	ld a,1
	dma.wr1 0x44, ext
	ld a,2
END
${test}.asm:3: error: constant expression expected
  ^---- dma.wr1 0x44, ext
      ^---- dma.wr1 68,ext
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr1 0x44, 0x10
	dma.wr1 0x44, 0x20
	dma.wr1 0x44, 0x30
	dma.wr1 0x44, 0x03
	ld a,2
END
${test}.asm:2: error: DMA illegal port A timing
  ^---- dma.wr1 0x44, 0x10
      ^---- dma.wr1 68,16
${test}.asm:3: error: DMA illegal port A timing
  ^---- dma.wr1 0x44, 0x20
      ^---- dma.wr1 68,32
${test}.asm:4: error: DMA illegal port A timing
  ^---- dma.wr1 0x44, 0x30
      ^---- dma.wr1 68,48
${test}.asm:5: error: DMA illegal port A timing
  ^---- dma.wr1 0x44, 0x03
      ^---- dma.wr1 68,3
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x44, 0x00, 0x44, 0x01, 0x44, 0x02, 0x3E, 2));
	ld a,1
	dma.wr1 0x44, 0x00
	dma.wr1 0x44, 0x01
	dma.wr1 0x44, 0x02
	ld a,2
END

z80asm_ok("-b -mz80n", "", <<END, <<END, bytes(0x3E, 1, 0x44, 0x80, 0x44, 0x40, 0x44, 0x08, 0x44, 0x04, 0x3E, 2));
${test}.asm:2: warning: DMA does not support half cycle timing
  ^---- dma.wr1 0x44, 0x80
      ^---- dma.wr1 68,128
${test}.asm:3: warning: DMA does not support half cycle timing
  ^---- dma.wr1 0x44, 0x40
      ^---- dma.wr1 68,64
${test}.asm:4: warning: DMA does not support half cycle timing
  ^---- dma.wr1 0x44, 0x08
      ^---- dma.wr1 68,8
${test}.asm:5: warning: DMA does not support half cycle timing
  ^---- dma.wr1 0x44, 0x04
      ^---- dma.wr1 68,4
END
	ld a,1
	dma.wr1 0x44, 0x80
	dma.wr1 0x44, 0x40
	dma.wr1 0x44, 0x08
	dma.wr1 0x44, 0x04
	ld a,2
END

#------------------------------------------------------------------------------
# DMA.WR2
#------------------------------------------------------------------------------

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr2 1
	dma.wr2 2
	dma.wr2 3
	dma.wr2 4
	dma.wr2 5
	dma.wr2 6
	dma.wr2 7
	dma.wr2 128
	ld a,2
END
${test}.asm:2: error: DMA base register byte illegal: 1
  ^---- dma.wr2 1
${test}.asm:3: error: DMA base register byte illegal: 2
  ^---- dma.wr2 2
${test}.asm:4: error: DMA base register byte illegal: 3
  ^---- dma.wr2 3
${test}.asm:5: error: DMA base register byte illegal: 4
  ^---- dma.wr2 4
${test}.asm:6: error: DMA base register byte illegal: 5
  ^---- dma.wr2 5
${test}.asm:7: error: DMA base register byte illegal: 6
  ^---- dma.wr2 6
${test}.asm:8: error: DMA base register byte illegal: 7
  ^---- dma.wr2 7
${test}.asm:9: error: DMA base register byte illegal: 0x80
  ^---- dma.wr2 128
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x00, 0x3E, 2));
	ld a,1
	dma.wr2 0x00
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr2 0x40
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr2 0x40
      ^---- dma.wr2 64
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	extern ext
	ld a,1
	dma.wr2 0x40, ext
	ld a,2
END
${test}.asm:3: error: constant expression expected
  ^---- dma.wr2 0x40, ext
      ^---- dma.wr2 64,ext
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr2 0x40, 0x10
	dma.wr2 0x40, 0x03
	ld a,2
END
${test}.asm:2: error: DMA illegal port B timing
  ^---- dma.wr2 0x40, 0x10
      ^---- dma.wr2 64,16
${test}.asm:3: error: DMA illegal port B timing
  ^---- dma.wr2 0x40, 0x03
      ^---- dma.wr2 64,3
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x40, 0x00, 0x40, 0x01, 0x40, 0x02, 0x3E, 2));
	ld a,1
	dma.wr2 0x40, 0x00
	dma.wr2 0x40, 0x01
	dma.wr2 0x40, 0x02
	ld a,2
END

z80asm_ok("-b -mz80n", "", <<END, <<END, bytes(0x3E, 1, 0x40, 0x80, 0x40, 0x40, 0x40, 0x08, 0x40, 0x04, 0x3E, 2));
${test}.asm:2: warning: DMA does not support half cycle timing
  ^---- dma.wr2 0x40, 0x80
      ^---- dma.wr2 64,128
${test}.asm:3: warning: DMA does not support half cycle timing
  ^---- dma.wr2 0x40, 0x40
      ^---- dma.wr2 64,64
${test}.asm:4: warning: DMA does not support half cycle timing
  ^---- dma.wr2 0x40, 0x08
      ^---- dma.wr2 64,8
${test}.asm:5: warning: DMA does not support half cycle timing
  ^---- dma.wr2 0x40, 0x04
      ^---- dma.wr2 64,4
END
	ld a,1
	dma.wr2 0x40, 0x80
	dma.wr2 0x40, 0x40
	dma.wr2 0x40, 0x08
	dma.wr2 0x40, 0x04
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr2 0x40, 0x20
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr2 0x40, 0x20
      ^---- dma.wr2 64,32
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x40, 0x20, 2, 0x3E, 2));
	ld a,1
lbl:dma.wr2 0x40, 0x20, lbl
	ld a,2
END

#------------------------------------------------------------------------------
# DMA.WR3
#------------------------------------------------------------------------------

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr3 1
	dma.wr2 2
	dma.wr2 3
	ld a,2
END
${test}.asm:2: error: DMA base register byte illegal: 1
  ^---- dma.wr3 1
${test}.asm:3: error: DMA base register byte illegal: 2
  ^---- dma.wr2 2
${test}.asm:4: error: DMA base register byte illegal: 3
  ^---- dma.wr2 3
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x80, 0x3E, 2));
	ld a,1
	dma.wr3 0x00
	ld a,2
END


z80asm_ok("-b -mz80n", "", <<END, <<END, bytes(0x3E, 1, 0x84, 0xA0, 0xC0, 0x3E, 2));
${test}.asm:2: warning: DMA does not support some features
  ^---- dma.wr3 0b00000100
      ^---- dma.wr3 4
${test}.asm:3: warning: DMA does not support some features
  ^---- dma.wr3 0b00100000
      ^---- dma.wr3 32
${test}.asm:4: warning: DMA does not support some features
  ^---- dma.wr3 0b01000000
      ^---- dma.wr3 64
END
	ld a,1
	dma.wr3 0b00000100
	dma.wr3 0b00100000
	dma.wr3 0b01000000
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr3 0x88
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr3 0x88
      ^---- dma.wr3 136
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x88, 23, 0x3E, 2));
	extern ext
	ld a,1
	dma.wr3 0x88, 23
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr3 0x98, 23
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr3 0x98, 23
      ^---- dma.wr3 152,23
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x98, 23, 45, 0x3E, 2));
	extern ext
	ld a,1
	dma.wr3 0x98, 23, 45
	ld a,2
END

#------------------------------------------------------------------------------
# DMA.WR4
#------------------------------------------------------------------------------

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr4 2
	ld a,2
END
${test}.asm:2: error: DMA base register byte illegal: 2
  ^---- dma.wr4 2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr4 0x11
	ld a,2
END
${test}.asm:2: error: DMA does not support interrupts
  ^---- dma.wr4 0x11
      ^---- dma.wr4 17
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr4 0x01
	dma.wr4 0x61
	ld a,2
END
${test}.asm:2: error: DMA illegal mode
  ^---- dma.wr4 0x01
      ^---- dma.wr4 1
${test}.asm:3: error: DMA illegal mode
  ^---- dma.wr4 0x61
      ^---- dma.wr4 97
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0xC1, 0x3E, 2));
	ld a,1
	dma.wr4 0x40
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr4 0x44
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr4 0x44
      ^---- dma.wr4 68
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr4 0x48
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr4 0x48
      ^---- dma.wr4 72
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0xC5, 23, 0x3E, 2));
	ld a,1
	dma.wr4 0x44, 23
	ld a,2
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0xC9, 23, 0x3E, 2));
	ld a,1
	dma.wr4 0x48, 23
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr4 0x4C
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr4 0x4C
      ^---- dma.wr4 76
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0xCD, 0x34, 0x12, 0x3E, 2));
	ld a,1
	dma.wr4 0x4C, 0x1234
	ld a,2
END

#------------------------------------------------------------------------------
# DMA.WR5
#------------------------------------------------------------------------------

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr5 0x01
	dma.wr5 0x04
	dma.wr5 0x40
	ld a,2
END
${test}.asm:2: error: DMA base register byte illegal: 1
  ^---- dma.wr5 0x01
      ^---- dma.wr5 1
${test}.asm:3: error: DMA base register byte illegal: 4
  ^---- dma.wr5 0x04
      ^---- dma.wr5 4
${test}.asm:4: error: DMA base register byte illegal: 0x40
  ^---- dma.wr5 0x40
      ^---- dma.wr5 64
END

z80asm_ok("-b -mz80n", "", <<END, <<END, bytes(0x3E, 1, 0x82, 0x8A, 0x3E, 2));
${test}.asm:3: warning: DMA does not support ready signals
  ^---- dma.wr5 0x08
      ^---- dma.wr5 8
END
	ld a,1
	dma.wr5 0
	dma.wr5 0x08
	ld a,2
END

#------------------------------------------------------------------------------
# DMA.WR6 | DMA.CMD
#------------------------------------------------------------------------------

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr6 0x00
	dma.cmd 0x00
	dma.wr6 0x01
	dma.cmd 0x01
	dma.wr6 0x02
	dma.cmd 0x02
	dma.wr6 0x03
	dma.cmd 0x03
	dma.wr6 0x04
	dma.cmd 0x04
	dma.wr6 0x05
	dma.cmd 0x05
	dma.wr6 0x06
	dma.cmd 0x06
	dma.wr6 0x07
	dma.cmd 0x07
	dma.wr6 0x08
	dma.cmd 0x08
	dma.wr6 0x09
	dma.cmd 0x09
	dma.wr6 0x0A
	dma.cmd 0x0A
	dma.wr6 0x0B
	dma.cmd 0x0B
	dma.wr6 0x0C
	dma.cmd 0x0C
	dma.wr6 0x0D
	dma.cmd 0x0D
	dma.wr6 0x0E
	dma.cmd 0x0E
	dma.wr6 0x0F
	dma.cmd 0x0F
	dma.wr6 0x10
	dma.cmd 0x10
	dma.wr6 0x11
	dma.cmd 0x11
	dma.wr6 0x12
	dma.cmd 0x12
	dma.wr6 0x13
	dma.cmd 0x13
	dma.wr6 0x14
	dma.cmd 0x14
	dma.wr6 0x15
	dma.cmd 0x15
	dma.wr6 0x16
	dma.cmd 0x16
	dma.wr6 0x17
	dma.cmd 0x17
	dma.wr6 0x18
	dma.cmd 0x18
	dma.wr6 0x19
	dma.cmd 0x19
	dma.wr6 0x1A
	dma.cmd 0x1A
	dma.wr6 0x1B
	dma.cmd 0x1B
	dma.wr6 0x1C
	dma.cmd 0x1C
	dma.wr6 0x1D
	dma.cmd 0x1D
	dma.wr6 0x1E
	dma.cmd 0x1E
	dma.wr6 0x1F
	dma.cmd 0x1F
	dma.wr6 0x20
	dma.cmd 0x20
	dma.wr6 0x21
	dma.cmd 0x21
	dma.wr6 0x22
	dma.cmd 0x22
	dma.wr6 0x23
	dma.cmd 0x23
	dma.wr6 0x24
	dma.cmd 0x24
	dma.wr6 0x25
	dma.cmd 0x25
	dma.wr6 0x26
	dma.cmd 0x26
	dma.wr6 0x27
	dma.cmd 0x27
	dma.wr6 0x28
	dma.cmd 0x28
	dma.wr6 0x29
	dma.cmd 0x29
	dma.wr6 0x2A
	dma.cmd 0x2A
	dma.wr6 0x2B
	dma.cmd 0x2B
	dma.wr6 0x2C
	dma.cmd 0x2C
	dma.wr6 0x2D
	dma.cmd 0x2D
	dma.wr6 0x2E
	dma.cmd 0x2E
	dma.wr6 0x2F
	dma.cmd 0x2F
	dma.wr6 0x30
	dma.cmd 0x30
	dma.wr6 0x31
	dma.cmd 0x31
	dma.wr6 0x32
	dma.cmd 0x32
	dma.wr6 0x33
	dma.cmd 0x33
	dma.wr6 0x34
	dma.cmd 0x34
	dma.wr6 0x35
	dma.cmd 0x35
	dma.wr6 0x36
	dma.cmd 0x36
	dma.wr6 0x37
	dma.cmd 0x37
	dma.wr6 0x38
	dma.cmd 0x38
	dma.wr6 0x39
	dma.cmd 0x39
	dma.wr6 0x3A
	dma.cmd 0x3A
	dma.wr6 0x3B
	dma.cmd 0x3B
	dma.wr6 0x3C
	dma.cmd 0x3C
	dma.wr6 0x3D
	dma.cmd 0x3D
	dma.wr6 0x3E
	dma.cmd 0x3E
	dma.wr6 0x3F
	dma.cmd 0x3F
	dma.wr6 0x40
	dma.cmd 0x40
	dma.wr6 0x41
	dma.cmd 0x41
	dma.wr6 0x42
	dma.cmd 0x42
	dma.wr6 0x43
	dma.cmd 0x43
	dma.wr6 0x44
	dma.cmd 0x44
	dma.wr6 0x45
	dma.cmd 0x45
	dma.wr6 0x46
	dma.cmd 0x46
	dma.wr6 0x47
	dma.cmd 0x47
	dma.wr6 0x48
	dma.cmd 0x48
	dma.wr6 0x49
	dma.cmd 0x49
	dma.wr6 0x4A
	dma.cmd 0x4A
	dma.wr6 0x4B
	dma.cmd 0x4B
	dma.wr6 0x4C
	dma.cmd 0x4C
	dma.wr6 0x4D
	dma.cmd 0x4D
	dma.wr6 0x4E
	dma.cmd 0x4E
	dma.wr6 0x4F
	dma.cmd 0x4F
	dma.wr6 0x50
	dma.cmd 0x50
	dma.wr6 0x51
	dma.cmd 0x51
	dma.wr6 0x52
	dma.cmd 0x52
	dma.wr6 0x53
	dma.cmd 0x53
	dma.wr6 0x54
	dma.cmd 0x54
	dma.wr6 0x55
	dma.cmd 0x55
	dma.wr6 0x56
	dma.cmd 0x56
	dma.wr6 0x57
	dma.cmd 0x57
	dma.wr6 0x58
	dma.cmd 0x58
	dma.wr6 0x59
	dma.cmd 0x59
	dma.wr6 0x5A
	dma.cmd 0x5A
	dma.wr6 0x5B
	dma.cmd 0x5B
	dma.wr6 0x5C
	dma.cmd 0x5C
	dma.wr6 0x5D
	dma.cmd 0x5D
	dma.wr6 0x5E
	dma.cmd 0x5E
	dma.wr6 0x5F
	dma.cmd 0x5F
	dma.wr6 0x60
	dma.cmd 0x60
	dma.wr6 0x61
	dma.cmd 0x61
	dma.wr6 0x62
	dma.cmd 0x62
	dma.wr6 0x63
	dma.cmd 0x63
	dma.wr6 0x64
	dma.cmd 0x64
	dma.wr6 0x65
	dma.cmd 0x65
	dma.wr6 0x66
	dma.cmd 0x66
	dma.wr6 0x67
	dma.cmd 0x67
	dma.wr6 0x68
	dma.cmd 0x68
	dma.wr6 0x69
	dma.cmd 0x69
	dma.wr6 0x6A
	dma.cmd 0x6A
	dma.wr6 0x6B
	dma.cmd 0x6B
	dma.wr6 0x6C
	dma.cmd 0x6C
	dma.wr6 0x6D
	dma.cmd 0x6D
	dma.wr6 0x6E
	dma.cmd 0x6E
	dma.wr6 0x6F
	dma.cmd 0x6F
	dma.wr6 0x70
	dma.cmd 0x70
	dma.wr6 0x71
	dma.cmd 0x71
	dma.wr6 0x72
	dma.cmd 0x72
	dma.wr6 0x73
	dma.cmd 0x73
	dma.wr6 0x74
	dma.cmd 0x74
	dma.wr6 0x75
	dma.cmd 0x75
	dma.wr6 0x76
	dma.cmd 0x76
	dma.wr6 0x77
	dma.cmd 0x77
	dma.wr6 0x78
	dma.cmd 0x78
	dma.wr6 0x79
	dma.cmd 0x79
	dma.wr6 0x7A
	dma.cmd 0x7A
	dma.wr6 0x7B
	dma.cmd 0x7B
	dma.wr6 0x7C
	dma.cmd 0x7C
	dma.wr6 0x7D
	dma.cmd 0x7D
	dma.wr6 0x7E
	dma.cmd 0x7E
	dma.wr6 0x7F
	dma.cmd 0x7F
	dma.wr6 0x80
	dma.cmd 0x80
	dma.wr6 0x81
	dma.cmd 0x81
	dma.wr6 0x82
	dma.cmd 0x82
	dma.wr6 0x84
	dma.cmd 0x84
	dma.wr6 0x85
	dma.cmd 0x85
	dma.wr6 0x86
	dma.cmd 0x86
	dma.wr6 0x88
	dma.cmd 0x88
	dma.wr6 0x89
	dma.cmd 0x89
	dma.wr6 0x8A
	dma.cmd 0x8A
	dma.wr6 0x8C
	dma.cmd 0x8C
	dma.wr6 0x8D
	dma.cmd 0x8D
	dma.wr6 0x8E
	dma.cmd 0x8E
	dma.wr6 0x8F
	dma.cmd 0x8F
	dma.wr6 0x90
	dma.cmd 0x90
	dma.wr6 0x91
	dma.cmd 0x91
	dma.wr6 0x92
	dma.cmd 0x92
	dma.wr6 0x93
	dma.cmd 0x93
	dma.wr6 0x94
	dma.cmd 0x94
	dma.wr6 0x95
	dma.cmd 0x95
	dma.wr6 0x96
	dma.cmd 0x96
	dma.wr6 0x97
	dma.cmd 0x97
	dma.wr6 0x98
	dma.cmd 0x98
	dma.wr6 0x99
	dma.cmd 0x99
	dma.wr6 0x9A
	dma.cmd 0x9A
	dma.wr6 0x9B
	dma.cmd 0x9B
	dma.wr6 0x9C
	dma.cmd 0x9C
	dma.wr6 0x9D
	dma.cmd 0x9D
	dma.wr6 0x9E
	dma.cmd 0x9E
	dma.wr6 0x9F
	dma.cmd 0x9F
	dma.wr6 0xA0
	dma.cmd 0xA0
	dma.wr6 0xA1
	dma.cmd 0xA1
	dma.wr6 0xA2
	dma.cmd 0xA2
	dma.wr6 0xA4
	dma.cmd 0xA4
	dma.wr6 0xA5
	dma.cmd 0xA5
	dma.wr6 0xA6
	dma.cmd 0xA6
	dma.wr6 0xA8
	dma.cmd 0xA8
	dma.wr6 0xA9
	dma.cmd 0xA9
	dma.wr6 0xAA
	dma.cmd 0xAA
	dma.wr6 0xAC
	dma.cmd 0xAC
	dma.wr6 0xAD
	dma.cmd 0xAD
	dma.wr6 0xAE
	dma.cmd 0xAE
	dma.wr6 0xB0
	dma.cmd 0xB0
	dma.wr6 0xB1
	dma.cmd 0xB1
	dma.wr6 0xB2
	dma.cmd 0xB2
	dma.wr6 0xB4
	dma.cmd 0xB4
	dma.wr6 0xB5
	dma.cmd 0xB5
	dma.wr6 0xB6
	dma.cmd 0xB6
	dma.wr6 0xB8
	dma.cmd 0xB8
	dma.wr6 0xB9
	dma.cmd 0xB9
	dma.wr6 0xBA
	dma.cmd 0xBA
	dma.wr6 0xBC
	dma.cmd 0xBC
	dma.wr6 0xBD
	dma.cmd 0xBD
	dma.wr6 0xBE
	dma.cmd 0xBE
	dma.wr6 0xC0
	dma.cmd 0xC0
	dma.wr6 0xC1
	dma.cmd 0xC1
	dma.wr6 0xC2
	dma.cmd 0xC2
	dma.wr6 0xC4
	dma.cmd 0xC4
	dma.wr6 0xC5
	dma.cmd 0xC5
	dma.wr6 0xC6
	dma.cmd 0xC6
	dma.wr6 0xC8
	dma.cmd 0xC8
	dma.wr6 0xC9
	dma.cmd 0xC9
	dma.wr6 0xCA
	dma.cmd 0xCA
	dma.wr6 0xCC
	dma.cmd 0xCC
	dma.wr6 0xCD
	dma.cmd 0xCD
	dma.wr6 0xCE
	dma.cmd 0xCE
	dma.wr6 0xD0
	dma.cmd 0xD0
	dma.wr6 0xD1
	dma.cmd 0xD1
	dma.wr6 0xD2
	dma.cmd 0xD2
	dma.wr6 0xD4
	dma.cmd 0xD4
	dma.wr6 0xD5
	dma.cmd 0xD5
	dma.wr6 0xD6
	dma.cmd 0xD6
	dma.wr6 0xD7
	dma.cmd 0xD7
	dma.wr6 0xD8
	dma.cmd 0xD8
	dma.wr6 0xD9
	dma.cmd 0xD9
	dma.wr6 0xDA
	dma.cmd 0xDA
	dma.wr6 0xDB
	dma.cmd 0xDB
	dma.wr6 0xDC
	dma.cmd 0xDC
	dma.wr6 0xDD
	dma.cmd 0xDD
	dma.wr6 0xDE
	dma.cmd 0xDE
	dma.wr6 0xDF
	dma.cmd 0xDF
	dma.wr6 0xE0
	dma.cmd 0xE0
	dma.wr6 0xE1
	dma.cmd 0xE1
	dma.wr6 0xE2
	dma.cmd 0xE2
	dma.wr6 0xE3
	dma.cmd 0xE3
	dma.wr6 0xE4
	dma.cmd 0xE4
	dma.wr6 0xE5
	dma.cmd 0xE5
	dma.wr6 0xE6
	dma.cmd 0xE6
	dma.wr6 0xE7
	dma.cmd 0xE7
	dma.wr6 0xE8
	dma.cmd 0xE8
	dma.wr6 0xE9
	dma.cmd 0xE9
	dma.wr6 0xEA
	dma.cmd 0xEA
	dma.wr6 0xEB
	dma.cmd 0xEB
	dma.wr6 0xEC
	dma.cmd 0xEC
	dma.wr6 0xED
	dma.cmd 0xED
	dma.wr6 0xEE
	dma.cmd 0xEE
	dma.wr6 0xEF
	dma.cmd 0xEF
	dma.wr6 0xF0
	dma.cmd 0xF0
	dma.wr6 0xF1
	dma.cmd 0xF1
	dma.wr6 0xF2
	dma.cmd 0xF2
	dma.wr6 0xF3
	dma.cmd 0xF3
	dma.wr6 0xF4
	dma.cmd 0xF4
	dma.wr6 0xF5
	dma.cmd 0xF5
	dma.wr6 0xF6
	dma.cmd 0xF6
	dma.wr6 0xF7
	dma.cmd 0xF7
	dma.wr6 0xF8
	dma.cmd 0xF8
	dma.wr6 0xF9
	dma.cmd 0xF9
	dma.wr6 0xFA
	dma.cmd 0xFA
	dma.wr6 0xFB
	dma.cmd 0xFB
	dma.wr6 0xFC
	dma.cmd 0xFC
	dma.wr6 0xFD
	dma.cmd 0xFD
	dma.wr6 0xFE
	dma.cmd 0xFE
	dma.wr6 0xFF
	dma.cmd 0xFF
	ld a,2
END
${test}.asm:2: error: DMA illegal command
  ^---- dma.wr6 0x00
      ^---- dma.wr6 0
${test}.asm:3: error: DMA illegal command
  ^---- dma.cmd 0x00
      ^---- dma.cmd 0
${test}.asm:4: error: DMA illegal command
  ^---- dma.wr6 0x01
      ^---- dma.wr6 1
${test}.asm:5: error: DMA illegal command
  ^---- dma.cmd 0x01
      ^---- dma.cmd 1
${test}.asm:6: error: DMA illegal command
  ^---- dma.wr6 0x02
      ^---- dma.wr6 2
${test}.asm:7: error: DMA illegal command
  ^---- dma.cmd 0x02
      ^---- dma.cmd 2
${test}.asm:8: error: DMA illegal command
  ^---- dma.wr6 0x03
      ^---- dma.wr6 3
${test}.asm:9: error: DMA illegal command
  ^---- dma.cmd 0x03
      ^---- dma.cmd 3
${test}.asm:10: error: DMA illegal command
  ^---- dma.wr6 0x04
      ^---- dma.wr6 4
${test}.asm:11: error: DMA illegal command
  ^---- dma.cmd 0x04
      ^---- dma.cmd 4
${test}.asm:12: error: DMA illegal command
  ^---- dma.wr6 0x05
      ^---- dma.wr6 5
${test}.asm:13: error: DMA illegal command
  ^---- dma.cmd 0x05
      ^---- dma.cmd 5
${test}.asm:14: error: DMA illegal command
  ^---- dma.wr6 0x06
      ^---- dma.wr6 6
${test}.asm:15: error: DMA illegal command
  ^---- dma.cmd 0x06
      ^---- dma.cmd 6
${test}.asm:16: error: DMA illegal command
  ^---- dma.wr6 0x07
      ^---- dma.wr6 7
${test}.asm:17: error: DMA illegal command
  ^---- dma.cmd 0x07
      ^---- dma.cmd 7
${test}.asm:18: error: DMA illegal command
  ^---- dma.wr6 0x08
      ^---- dma.wr6 8
${test}.asm:19: error: DMA illegal command
  ^---- dma.cmd 0x08
      ^---- dma.cmd 8
${test}.asm:20: error: DMA illegal command
  ^---- dma.wr6 0x09
      ^---- dma.wr6 9
${test}.asm:21: error: DMA illegal command
  ^---- dma.cmd 0x09
      ^---- dma.cmd 9
${test}.asm:22: error: DMA illegal command
  ^---- dma.wr6 0x0A
      ^---- dma.wr6 10
${test}.asm:23: error: DMA illegal command
  ^---- dma.cmd 0x0A
      ^---- dma.cmd 10
${test}.asm:24: error: DMA illegal command
  ^---- dma.wr6 0x0B
      ^---- dma.wr6 11
${test}.asm:25: error: DMA illegal command
  ^---- dma.cmd 0x0B
      ^---- dma.cmd 11
${test}.asm:26: error: DMA illegal command
  ^---- dma.wr6 0x0C
      ^---- dma.wr6 12
${test}.asm:27: error: DMA illegal command
  ^---- dma.cmd 0x0C
      ^---- dma.cmd 12
${test}.asm:28: error: DMA illegal command
  ^---- dma.wr6 0x0D
      ^---- dma.wr6 13
${test}.asm:29: error: DMA illegal command
  ^---- dma.cmd 0x0D
      ^---- dma.cmd 13
${test}.asm:30: error: DMA illegal command
  ^---- dma.wr6 0x0E
      ^---- dma.wr6 14
${test}.asm:31: error: DMA illegal command
  ^---- dma.cmd 0x0E
      ^---- dma.cmd 14
${test}.asm:32: error: DMA illegal command
  ^---- dma.wr6 0x0F
      ^---- dma.wr6 15
${test}.asm:33: error: DMA illegal command
  ^---- dma.cmd 0x0F
      ^---- dma.cmd 15
${test}.asm:34: error: DMA illegal command
  ^---- dma.wr6 0x10
      ^---- dma.wr6 16
${test}.asm:35: error: DMA illegal command
  ^---- dma.cmd 0x10
      ^---- dma.cmd 16
${test}.asm:36: error: DMA illegal command
  ^---- dma.wr6 0x11
      ^---- dma.wr6 17
${test}.asm:37: error: DMA illegal command
  ^---- dma.cmd 0x11
      ^---- dma.cmd 17
${test}.asm:38: error: DMA illegal command
  ^---- dma.wr6 0x12
      ^---- dma.wr6 18
${test}.asm:39: error: DMA illegal command
  ^---- dma.cmd 0x12
      ^---- dma.cmd 18
${test}.asm:40: error: DMA illegal command
  ^---- dma.wr6 0x13
      ^---- dma.wr6 19
${test}.asm:41: error: DMA illegal command
  ^---- dma.cmd 0x13
      ^---- dma.cmd 19
${test}.asm:42: error: DMA illegal command
  ^---- dma.wr6 0x14
      ^---- dma.wr6 20
${test}.asm:43: error: DMA illegal command
  ^---- dma.cmd 0x14
      ^---- dma.cmd 20
${test}.asm:44: error: DMA illegal command
  ^---- dma.wr6 0x15
      ^---- dma.wr6 21
${test}.asm:45: error: DMA illegal command
  ^---- dma.cmd 0x15
      ^---- dma.cmd 21
${test}.asm:46: error: DMA illegal command
  ^---- dma.wr6 0x16
      ^---- dma.wr6 22
${test}.asm:47: error: DMA illegal command
  ^---- dma.cmd 0x16
      ^---- dma.cmd 22
${test}.asm:48: error: DMA illegal command
  ^---- dma.wr6 0x17
      ^---- dma.wr6 23
${test}.asm:49: error: DMA illegal command
  ^---- dma.cmd 0x17
      ^---- dma.cmd 23
${test}.asm:50: error: DMA illegal command
  ^---- dma.wr6 0x18
      ^---- dma.wr6 24
${test}.asm:51: error: DMA illegal command
  ^---- dma.cmd 0x18
      ^---- dma.cmd 24
${test}.asm:52: error: DMA illegal command
  ^---- dma.wr6 0x19
      ^---- dma.wr6 25
${test}.asm:53: error: DMA illegal command
  ^---- dma.cmd 0x19
      ^---- dma.cmd 25
${test}.asm:54: error: DMA illegal command
  ^---- dma.wr6 0x1A
      ^---- dma.wr6 26
${test}.asm:55: error: DMA illegal command
  ^---- dma.cmd 0x1A
      ^---- dma.cmd 26
${test}.asm:56: error: DMA illegal command
  ^---- dma.wr6 0x1B
      ^---- dma.wr6 27
${test}.asm:57: error: DMA illegal command
  ^---- dma.cmd 0x1B
      ^---- dma.cmd 27
${test}.asm:58: error: DMA illegal command
  ^---- dma.wr6 0x1C
      ^---- dma.wr6 28
${test}.asm:59: error: DMA illegal command
  ^---- dma.cmd 0x1C
      ^---- dma.cmd 28
${test}.asm:60: error: DMA illegal command
  ^---- dma.wr6 0x1D
      ^---- dma.wr6 29
${test}.asm:61: error: DMA illegal command
  ^---- dma.cmd 0x1D
      ^---- dma.cmd 29
${test}.asm:62: error: DMA illegal command
  ^---- dma.wr6 0x1E
      ^---- dma.wr6 30
${test}.asm:63: error: DMA illegal command
  ^---- dma.cmd 0x1E
      ^---- dma.cmd 30
${test}.asm:64: error: DMA illegal command
  ^---- dma.wr6 0x1F
      ^---- dma.wr6 31
${test}.asm:65: error: DMA illegal command
  ^---- dma.cmd 0x1F
      ^---- dma.cmd 31
${test}.asm:66: error: DMA illegal command
  ^---- dma.wr6 0x20
      ^---- dma.wr6 32
${test}.asm:67: error: DMA illegal command
  ^---- dma.cmd 0x20
      ^---- dma.cmd 32
${test}.asm:68: error: DMA illegal command
  ^---- dma.wr6 0x21
      ^---- dma.wr6 33
${test}.asm:69: error: DMA illegal command
  ^---- dma.cmd 0x21
      ^---- dma.cmd 33
${test}.asm:70: error: DMA illegal command
  ^---- dma.wr6 0x22
      ^---- dma.wr6 34
${test}.asm:71: error: DMA illegal command
  ^---- dma.cmd 0x22
      ^---- dma.cmd 34
${test}.asm:72: error: DMA illegal command
  ^---- dma.wr6 0x23
      ^---- dma.wr6 35
${test}.asm:73: error: DMA illegal command
  ^---- dma.cmd 0x23
      ^---- dma.cmd 35
${test}.asm:74: error: DMA illegal command
  ^---- dma.wr6 0x24
      ^---- dma.wr6 36
${test}.asm:75: error: DMA illegal command
  ^---- dma.cmd 0x24
      ^---- dma.cmd 36
${test}.asm:76: error: DMA illegal command
  ^---- dma.wr6 0x25
      ^---- dma.wr6 37
${test}.asm:77: error: DMA illegal command
  ^---- dma.cmd 0x25
      ^---- dma.cmd 37
${test}.asm:78: error: DMA illegal command
  ^---- dma.wr6 0x26
      ^---- dma.wr6 38
${test}.asm:79: error: DMA illegal command
  ^---- dma.cmd 0x26
      ^---- dma.cmd 38
${test}.asm:80: error: DMA illegal command
  ^---- dma.wr6 0x27
      ^---- dma.wr6 39
${test}.asm:81: error: DMA illegal command
  ^---- dma.cmd 0x27
      ^---- dma.cmd 39
${test}.asm:82: error: DMA illegal command
  ^---- dma.wr6 0x28
      ^---- dma.wr6 40
${test}.asm:83: error: DMA illegal command
  ^---- dma.cmd 0x28
      ^---- dma.cmd 40
${test}.asm:84: error: DMA illegal command
  ^---- dma.wr6 0x29
      ^---- dma.wr6 41
${test}.asm:85: error: DMA illegal command
  ^---- dma.cmd 0x29
      ^---- dma.cmd 41
${test}.asm:86: error: DMA illegal command
  ^---- dma.wr6 0x2A
      ^---- dma.wr6 42
${test}.asm:87: error: DMA illegal command
  ^---- dma.cmd 0x2A
      ^---- dma.cmd 42
${test}.asm:88: error: DMA illegal command
  ^---- dma.wr6 0x2B
      ^---- dma.wr6 43
${test}.asm:89: error: DMA illegal command
  ^---- dma.cmd 0x2B
      ^---- dma.cmd 43
${test}.asm:90: error: DMA illegal command
  ^---- dma.wr6 0x2C
      ^---- dma.wr6 44
${test}.asm:91: error: DMA illegal command
  ^---- dma.cmd 0x2C
      ^---- dma.cmd 44
${test}.asm:92: error: DMA illegal command
  ^---- dma.wr6 0x2D
      ^---- dma.wr6 45
${test}.asm:93: error: DMA illegal command
  ^---- dma.cmd 0x2D
      ^---- dma.cmd 45
${test}.asm:94: error: DMA illegal command
  ^---- dma.wr6 0x2E
      ^---- dma.wr6 46
${test}.asm:95: error: DMA illegal command
  ^---- dma.cmd 0x2E
      ^---- dma.cmd 46
${test}.asm:96: error: DMA illegal command
  ^---- dma.wr6 0x2F
      ^---- dma.wr6 47
${test}.asm:97: error: DMA illegal command
  ^---- dma.cmd 0x2F
      ^---- dma.cmd 47
${test}.asm:98: error: DMA illegal command
  ^---- dma.wr6 0x30
      ^---- dma.wr6 48
${test}.asm:99: error: DMA illegal command
  ^---- dma.cmd 0x30
      ^---- dma.cmd 48
${test}.asm:100: error: DMA illegal command
  ^---- dma.wr6 0x31
      ^---- dma.wr6 49
${test}.asm:101: error: DMA illegal command
  ^---- dma.cmd 0x31
      ^---- dma.cmd 49
${test}.asm:102: error: DMA illegal command
  ^---- dma.wr6 0x32
      ^---- dma.wr6 50
${test}.asm:103: error: DMA illegal command
  ^---- dma.cmd 0x32
      ^---- dma.cmd 50
${test}.asm:104: error: DMA illegal command
  ^---- dma.wr6 0x33
      ^---- dma.wr6 51
${test}.asm:105: error: DMA illegal command
  ^---- dma.cmd 0x33
      ^---- dma.cmd 51
${test}.asm:106: error: DMA illegal command
  ^---- dma.wr6 0x34
      ^---- dma.wr6 52
${test}.asm:107: error: DMA illegal command
  ^---- dma.cmd 0x34
      ^---- dma.cmd 52
${test}.asm:108: error: DMA illegal command
  ^---- dma.wr6 0x35
      ^---- dma.wr6 53
${test}.asm:109: error: DMA illegal command
  ^---- dma.cmd 0x35
      ^---- dma.cmd 53
${test}.asm:110: error: DMA illegal command
  ^---- dma.wr6 0x36
      ^---- dma.wr6 54
${test}.asm:111: error: DMA illegal command
  ^---- dma.cmd 0x36
      ^---- dma.cmd 54
${test}.asm:112: error: DMA illegal command
  ^---- dma.wr6 0x37
      ^---- dma.wr6 55
${test}.asm:113: error: DMA illegal command
  ^---- dma.cmd 0x37
      ^---- dma.cmd 55
${test}.asm:114: error: DMA illegal command
  ^---- dma.wr6 0x38
      ^---- dma.wr6 56
${test}.asm:115: error: DMA illegal command
  ^---- dma.cmd 0x38
      ^---- dma.cmd 56
${test}.asm:116: error: DMA illegal command
  ^---- dma.wr6 0x39
      ^---- dma.wr6 57
${test}.asm:117: error: DMA illegal command
  ^---- dma.cmd 0x39
      ^---- dma.cmd 57
${test}.asm:118: error: DMA illegal command
  ^---- dma.wr6 0x3A
      ^---- dma.wr6 58
${test}.asm:119: error: DMA illegal command
  ^---- dma.cmd 0x3A
      ^---- dma.cmd 58
${test}.asm:120: error: DMA illegal command
  ^---- dma.wr6 0x3B
      ^---- dma.wr6 59
${test}.asm:121: error: DMA illegal command
  ^---- dma.cmd 0x3B
      ^---- dma.cmd 59
${test}.asm:122: error: DMA illegal command
  ^---- dma.wr6 0x3C
      ^---- dma.wr6 60
${test}.asm:123: error: DMA illegal command
  ^---- dma.cmd 0x3C
      ^---- dma.cmd 60
${test}.asm:124: error: DMA illegal command
  ^---- dma.wr6 0x3D
      ^---- dma.wr6 61
${test}.asm:125: error: DMA illegal command
  ^---- dma.cmd 0x3D
      ^---- dma.cmd 61
${test}.asm:126: error: DMA illegal command
  ^---- dma.wr6 0x3E
      ^---- dma.wr6 62
${test}.asm:127: error: DMA illegal command
  ^---- dma.cmd 0x3E
      ^---- dma.cmd 62
${test}.asm:128: error: DMA illegal command
  ^---- dma.wr6 0x3F
      ^---- dma.wr6 63
${test}.asm:129: error: DMA illegal command
  ^---- dma.cmd 0x3F
      ^---- dma.cmd 63
${test}.asm:130: error: DMA illegal command
  ^---- dma.wr6 0x40
      ^---- dma.wr6 64
${test}.asm:131: error: DMA illegal command
  ^---- dma.cmd 0x40
      ^---- dma.cmd 64
${test}.asm:132: error: DMA illegal command
  ^---- dma.wr6 0x41
      ^---- dma.wr6 65
${test}.asm:133: error: DMA illegal command
  ^---- dma.cmd 0x41
      ^---- dma.cmd 65
${test}.asm:134: error: DMA illegal command
  ^---- dma.wr6 0x42
      ^---- dma.wr6 66
${test}.asm:135: error: DMA illegal command
  ^---- dma.cmd 0x42
      ^---- dma.cmd 66
${test}.asm:136: error: DMA illegal command
  ^---- dma.wr6 0x43
      ^---- dma.wr6 67
${test}.asm:137: error: DMA illegal command
  ^---- dma.cmd 0x43
      ^---- dma.cmd 67
${test}.asm:138: error: DMA illegal command
  ^---- dma.wr6 0x44
      ^---- dma.wr6 68
${test}.asm:139: error: DMA illegal command
  ^---- dma.cmd 0x44
      ^---- dma.cmd 68
${test}.asm:140: error: DMA illegal command
  ^---- dma.wr6 0x45
      ^---- dma.wr6 69
${test}.asm:141: error: DMA illegal command
  ^---- dma.cmd 0x45
      ^---- dma.cmd 69
${test}.asm:142: error: DMA illegal command
  ^---- dma.wr6 0x46
      ^---- dma.wr6 70
${test}.asm:143: error: DMA illegal command
  ^---- dma.cmd 0x46
      ^---- dma.cmd 70
${test}.asm:144: error: DMA illegal command
  ^---- dma.wr6 0x47
      ^---- dma.wr6 71
${test}.asm:145: error: DMA illegal command
  ^---- dma.cmd 0x47
      ^---- dma.cmd 71
${test}.asm:146: error: DMA illegal command
  ^---- dma.wr6 0x48
      ^---- dma.wr6 72
${test}.asm:147: error: DMA illegal command
  ^---- dma.cmd 0x48
      ^---- dma.cmd 72
${test}.asm:148: error: DMA illegal command
  ^---- dma.wr6 0x49
      ^---- dma.wr6 73
${test}.asm:149: error: DMA illegal command
  ^---- dma.cmd 0x49
      ^---- dma.cmd 73
${test}.asm:150: error: DMA illegal command
  ^---- dma.wr6 0x4A
      ^---- dma.wr6 74
${test}.asm:151: error: DMA illegal command
  ^---- dma.cmd 0x4A
      ^---- dma.cmd 74
${test}.asm:152: error: DMA illegal command
  ^---- dma.wr6 0x4B
      ^---- dma.wr6 75
${test}.asm:153: error: DMA illegal command
  ^---- dma.cmd 0x4B
      ^---- dma.cmd 75
${test}.asm:154: error: DMA illegal command
  ^---- dma.wr6 0x4C
      ^---- dma.wr6 76
${test}.asm:155: error: DMA illegal command
  ^---- dma.cmd 0x4C
      ^---- dma.cmd 76
${test}.asm:156: error: DMA illegal command
  ^---- dma.wr6 0x4D
      ^---- dma.wr6 77
${test}.asm:157: error: DMA illegal command
  ^---- dma.cmd 0x4D
      ^---- dma.cmd 77
${test}.asm:158: error: DMA illegal command
  ^---- dma.wr6 0x4E
      ^---- dma.wr6 78
${test}.asm:159: error: DMA illegal command
  ^---- dma.cmd 0x4E
      ^---- dma.cmd 78
${test}.asm:160: error: DMA illegal command
  ^---- dma.wr6 0x4F
      ^---- dma.wr6 79
${test}.asm:161: error: DMA illegal command
  ^---- dma.cmd 0x4F
      ^---- dma.cmd 79
${test}.asm:162: error: DMA illegal command
  ^---- dma.wr6 0x50
      ^---- dma.wr6 80
${test}.asm:163: error: DMA illegal command
  ^---- dma.cmd 0x50
      ^---- dma.cmd 80
${test}.asm:164: error: DMA illegal command
  ^---- dma.wr6 0x51
      ^---- dma.wr6 81
${test}.asm:165: error: DMA illegal command
  ^---- dma.cmd 0x51
      ^---- dma.cmd 81
${test}.asm:166: error: DMA illegal command
  ^---- dma.wr6 0x52
      ^---- dma.wr6 82
${test}.asm:167: error: DMA illegal command
  ^---- dma.cmd 0x52
      ^---- dma.cmd 82
${test}.asm:168: error: DMA illegal command
  ^---- dma.wr6 0x53
      ^---- dma.wr6 83
${test}.asm:169: error: DMA illegal command
  ^---- dma.cmd 0x53
      ^---- dma.cmd 83
${test}.asm:170: error: DMA illegal command
  ^---- dma.wr6 0x54
      ^---- dma.wr6 84
${test}.asm:171: error: DMA illegal command
  ^---- dma.cmd 0x54
      ^---- dma.cmd 84
${test}.asm:172: error: DMA illegal command
  ^---- dma.wr6 0x55
      ^---- dma.wr6 85
${test}.asm:173: error: DMA illegal command
  ^---- dma.cmd 0x55
      ^---- dma.cmd 85
${test}.asm:174: error: DMA illegal command
  ^---- dma.wr6 0x56
      ^---- dma.wr6 86
${test}.asm:175: error: DMA illegal command
  ^---- dma.cmd 0x56
      ^---- dma.cmd 86
${test}.asm:176: error: DMA illegal command
  ^---- dma.wr6 0x57
      ^---- dma.wr6 87
${test}.asm:177: error: DMA illegal command
  ^---- dma.cmd 0x57
      ^---- dma.cmd 87
${test}.asm:178: error: DMA illegal command
  ^---- dma.wr6 0x58
      ^---- dma.wr6 88
${test}.asm:179: error: DMA illegal command
  ^---- dma.cmd 0x58
      ^---- dma.cmd 88
${test}.asm:180: error: DMA illegal command
  ^---- dma.wr6 0x59
      ^---- dma.wr6 89
${test}.asm:181: error: DMA illegal command
  ^---- dma.cmd 0x59
      ^---- dma.cmd 89
${test}.asm:182: error: DMA illegal command
  ^---- dma.wr6 0x5A
      ^---- dma.wr6 90
${test}.asm:183: error: DMA illegal command
  ^---- dma.cmd 0x5A
      ^---- dma.cmd 90
${test}.asm:184: error: DMA illegal command
  ^---- dma.wr6 0x5B
      ^---- dma.wr6 91
${test}.asm:185: error: DMA illegal command
  ^---- dma.cmd 0x5B
      ^---- dma.cmd 91
${test}.asm:186: error: DMA illegal command
  ^---- dma.wr6 0x5C
      ^---- dma.wr6 92
${test}.asm:187: error: DMA illegal command
  ^---- dma.cmd 0x5C
      ^---- dma.cmd 92
${test}.asm:188: error: DMA illegal command
  ^---- dma.wr6 0x5D
      ^---- dma.wr6 93
${test}.asm:189: error: DMA illegal command
  ^---- dma.cmd 0x5D
      ^---- dma.cmd 93
${test}.asm:190: error: DMA illegal command
  ^---- dma.wr6 0x5E
      ^---- dma.wr6 94
${test}.asm:191: error: DMA illegal command
  ^---- dma.cmd 0x5E
      ^---- dma.cmd 94
${test}.asm:192: error: DMA illegal command
  ^---- dma.wr6 0x5F
      ^---- dma.wr6 95
${test}.asm:193: error: DMA illegal command
  ^---- dma.cmd 0x5F
      ^---- dma.cmd 95
${test}.asm:194: error: DMA illegal command
  ^---- dma.wr6 0x60
      ^---- dma.wr6 96
${test}.asm:195: error: DMA illegal command
  ^---- dma.cmd 0x60
      ^---- dma.cmd 96
${test}.asm:196: error: DMA illegal command
  ^---- dma.wr6 0x61
      ^---- dma.wr6 97
${test}.asm:197: error: DMA illegal command
  ^---- dma.cmd 0x61
      ^---- dma.cmd 97
${test}.asm:198: error: DMA illegal command
  ^---- dma.wr6 0x62
      ^---- dma.wr6 98
${test}.asm:199: error: DMA illegal command
  ^---- dma.cmd 0x62
      ^---- dma.cmd 98
${test}.asm:200: error: DMA illegal command
  ^---- dma.wr6 0x63
      ^---- dma.wr6 99
${test}.asm:201: error: DMA illegal command
  ^---- dma.cmd 0x63
      ^---- dma.cmd 99
${test}.asm:202: error: DMA illegal command
  ^---- dma.wr6 0x64
      ^---- dma.wr6 100
${test}.asm:203: error: DMA illegal command
  ^---- dma.cmd 0x64
      ^---- dma.cmd 100
${test}.asm:204: error: DMA illegal command
  ^---- dma.wr6 0x65
      ^---- dma.wr6 101
${test}.asm:205: error: DMA illegal command
  ^---- dma.cmd 0x65
      ^---- dma.cmd 101
${test}.asm:206: error: DMA illegal command
  ^---- dma.wr6 0x66
      ^---- dma.wr6 102
${test}.asm:207: error: DMA illegal command
  ^---- dma.cmd 0x66
      ^---- dma.cmd 102
${test}.asm:208: error: DMA illegal command
  ^---- dma.wr6 0x67
      ^---- dma.wr6 103
${test}.asm:209: error: DMA illegal command
  ^---- dma.cmd 0x67
      ^---- dma.cmd 103
${test}.asm:210: error: DMA illegal command
  ^---- dma.wr6 0x68
      ^---- dma.wr6 104
${test}.asm:211: error: DMA illegal command
  ^---- dma.cmd 0x68
      ^---- dma.cmd 104
${test}.asm:212: error: DMA illegal command
  ^---- dma.wr6 0x69
      ^---- dma.wr6 105
${test}.asm:213: error: DMA illegal command
  ^---- dma.cmd 0x69
      ^---- dma.cmd 105
${test}.asm:214: error: DMA illegal command
  ^---- dma.wr6 0x6A
      ^---- dma.wr6 106
${test}.asm:215: error: DMA illegal command
  ^---- dma.cmd 0x6A
      ^---- dma.cmd 106
${test}.asm:216: error: DMA illegal command
  ^---- dma.wr6 0x6B
      ^---- dma.wr6 107
${test}.asm:217: error: DMA illegal command
  ^---- dma.cmd 0x6B
      ^---- dma.cmd 107
${test}.asm:218: error: DMA illegal command
  ^---- dma.wr6 0x6C
      ^---- dma.wr6 108
${test}.asm:219: error: DMA illegal command
  ^---- dma.cmd 0x6C
      ^---- dma.cmd 108
${test}.asm:220: error: DMA illegal command
  ^---- dma.wr6 0x6D
      ^---- dma.wr6 109
${test}.asm:221: error: DMA illegal command
  ^---- dma.cmd 0x6D
      ^---- dma.cmd 109
${test}.asm:222: error: DMA illegal command
  ^---- dma.wr6 0x6E
      ^---- dma.wr6 110
${test}.asm:223: error: DMA illegal command
  ^---- dma.cmd 0x6E
      ^---- dma.cmd 110
${test}.asm:224: error: DMA illegal command
  ^---- dma.wr6 0x6F
      ^---- dma.wr6 111
${test}.asm:225: error: DMA illegal command
  ^---- dma.cmd 0x6F
      ^---- dma.cmd 111
${test}.asm:226: error: DMA illegal command
  ^---- dma.wr6 0x70
      ^---- dma.wr6 112
${test}.asm:227: error: DMA illegal command
  ^---- dma.cmd 0x70
      ^---- dma.cmd 112
${test}.asm:228: error: DMA illegal command
  ^---- dma.wr6 0x71
      ^---- dma.wr6 113
${test}.asm:229: error: DMA illegal command
  ^---- dma.cmd 0x71
      ^---- dma.cmd 113
${test}.asm:230: error: DMA illegal command
  ^---- dma.wr6 0x72
      ^---- dma.wr6 114
${test}.asm:231: error: DMA illegal command
  ^---- dma.cmd 0x72
      ^---- dma.cmd 114
${test}.asm:232: error: DMA illegal command
  ^---- dma.wr6 0x73
      ^---- dma.wr6 115
${test}.asm:233: error: DMA illegal command
  ^---- dma.cmd 0x73
      ^---- dma.cmd 115
${test}.asm:234: error: DMA illegal command
  ^---- dma.wr6 0x74
      ^---- dma.wr6 116
${test}.asm:235: error: DMA illegal command
  ^---- dma.cmd 0x74
      ^---- dma.cmd 116
${test}.asm:236: error: DMA illegal command
  ^---- dma.wr6 0x75
      ^---- dma.wr6 117
${test}.asm:237: error: DMA illegal command
  ^---- dma.cmd 0x75
      ^---- dma.cmd 117
${test}.asm:238: error: DMA illegal command
  ^---- dma.wr6 0x76
      ^---- dma.wr6 118
${test}.asm:239: error: DMA illegal command
  ^---- dma.cmd 0x76
      ^---- dma.cmd 118
${test}.asm:240: error: DMA illegal command
  ^---- dma.wr6 0x77
      ^---- dma.wr6 119
${test}.asm:241: error: DMA illegal command
  ^---- dma.cmd 0x77
      ^---- dma.cmd 119
${test}.asm:242: error: DMA illegal command
  ^---- dma.wr6 0x78
      ^---- dma.wr6 120
${test}.asm:243: error: DMA illegal command
  ^---- dma.cmd 0x78
      ^---- dma.cmd 120
${test}.asm:244: error: DMA illegal command
  ^---- dma.wr6 0x79
      ^---- dma.wr6 121
${test}.asm:245: error: DMA illegal command
  ^---- dma.cmd 0x79
      ^---- dma.cmd 121
${test}.asm:246: error: DMA illegal command
  ^---- dma.wr6 0x7A
      ^---- dma.wr6 122
${test}.asm:247: error: DMA illegal command
  ^---- dma.cmd 0x7A
      ^---- dma.cmd 122
${test}.asm:248: error: DMA illegal command
  ^---- dma.wr6 0x7B
      ^---- dma.wr6 123
${test}.asm:249: error: DMA illegal command
  ^---- dma.cmd 0x7B
      ^---- dma.cmd 123
${test}.asm:250: error: DMA illegal command
  ^---- dma.wr6 0x7C
      ^---- dma.wr6 124
${test}.asm:251: error: DMA illegal command
  ^---- dma.cmd 0x7C
      ^---- dma.cmd 124
${test}.asm:252: error: DMA illegal command
  ^---- dma.wr6 0x7D
      ^---- dma.wr6 125
${test}.asm:253: error: DMA illegal command
  ^---- dma.cmd 0x7D
      ^---- dma.cmd 125
${test}.asm:254: error: DMA illegal command
  ^---- dma.wr6 0x7E
      ^---- dma.wr6 126
${test}.asm:255: error: DMA illegal command
  ^---- dma.cmd 0x7E
      ^---- dma.cmd 126
${test}.asm:256: error: DMA illegal command
  ^---- dma.wr6 0x7F
      ^---- dma.wr6 127
${test}.asm:257: error: DMA illegal command
  ^---- dma.cmd 0x7F
      ^---- dma.cmd 127
${test}.asm:258: error: DMA illegal command
  ^---- dma.wr6 0x80
      ^---- dma.wr6 128
${test}.asm:259: error: DMA illegal command
  ^---- dma.cmd 0x80
      ^---- dma.cmd 128
${test}.asm:260: error: DMA illegal command
  ^---- dma.wr6 0x81
      ^---- dma.wr6 129
${test}.asm:261: error: DMA illegal command
  ^---- dma.cmd 0x81
      ^---- dma.cmd 129
${test}.asm:262: error: DMA illegal command
  ^---- dma.wr6 0x82
      ^---- dma.wr6 130
${test}.asm:263: error: DMA illegal command
  ^---- dma.cmd 0x82
      ^---- dma.cmd 130
${test}.asm:264: error: DMA illegal command
  ^---- dma.wr6 0x84
      ^---- dma.wr6 132
${test}.asm:265: error: DMA illegal command
  ^---- dma.cmd 0x84
      ^---- dma.cmd 132
${test}.asm:266: error: DMA illegal command
  ^---- dma.wr6 0x85
      ^---- dma.wr6 133
${test}.asm:267: error: DMA illegal command
  ^---- dma.cmd 0x85
      ^---- dma.cmd 133
${test}.asm:268: error: DMA illegal command
  ^---- dma.wr6 0x86
      ^---- dma.wr6 134
${test}.asm:269: error: DMA illegal command
  ^---- dma.cmd 0x86
      ^---- dma.cmd 134
${test}.asm:270: error: DMA illegal command
  ^---- dma.wr6 0x88
      ^---- dma.wr6 136
${test}.asm:271: error: DMA illegal command
  ^---- dma.cmd 0x88
      ^---- dma.cmd 136
${test}.asm:272: error: DMA illegal command
  ^---- dma.wr6 0x89
      ^---- dma.wr6 137
${test}.asm:273: error: DMA illegal command
  ^---- dma.cmd 0x89
      ^---- dma.cmd 137
${test}.asm:274: error: DMA illegal command
  ^---- dma.wr6 0x8A
      ^---- dma.wr6 138
${test}.asm:275: error: DMA illegal command
  ^---- dma.cmd 0x8A
      ^---- dma.cmd 138
${test}.asm:276: error: DMA illegal command
  ^---- dma.wr6 0x8C
      ^---- dma.wr6 140
${test}.asm:277: error: DMA illegal command
  ^---- dma.cmd 0x8C
      ^---- dma.cmd 140
${test}.asm:278: error: DMA illegal command
  ^---- dma.wr6 0x8D
      ^---- dma.wr6 141
${test}.asm:279: error: DMA illegal command
  ^---- dma.cmd 0x8D
      ^---- dma.cmd 141
${test}.asm:280: error: DMA illegal command
  ^---- dma.wr6 0x8E
      ^---- dma.wr6 142
${test}.asm:281: error: DMA illegal command
  ^---- dma.cmd 0x8E
      ^---- dma.cmd 142
${test}.asm:282: error: DMA illegal command
  ^---- dma.wr6 0x8F
      ^---- dma.wr6 143
${test}.asm:283: error: DMA illegal command
  ^---- dma.cmd 0x8F
      ^---- dma.cmd 143
${test}.asm:284: error: DMA illegal command
  ^---- dma.wr6 0x90
      ^---- dma.wr6 144
${test}.asm:285: error: DMA illegal command
  ^---- dma.cmd 0x90
      ^---- dma.cmd 144
${test}.asm:286: error: DMA illegal command
  ^---- dma.wr6 0x91
      ^---- dma.wr6 145
${test}.asm:287: error: DMA illegal command
  ^---- dma.cmd 0x91
      ^---- dma.cmd 145
${test}.asm:288: error: DMA illegal command
  ^---- dma.wr6 0x92
      ^---- dma.wr6 146
${test}.asm:289: error: DMA illegal command
  ^---- dma.cmd 0x92
      ^---- dma.cmd 146
${test}.asm:290: error: DMA illegal command
  ^---- dma.wr6 0x93
      ^---- dma.wr6 147
${test}.asm:291: error: DMA illegal command
  ^---- dma.cmd 0x93
      ^---- dma.cmd 147
${test}.asm:292: error: DMA illegal command
  ^---- dma.wr6 0x94
      ^---- dma.wr6 148
${test}.asm:293: error: DMA illegal command
  ^---- dma.cmd 0x94
      ^---- dma.cmd 148
${test}.asm:294: error: DMA illegal command
  ^---- dma.wr6 0x95
      ^---- dma.wr6 149
${test}.asm:295: error: DMA illegal command
  ^---- dma.cmd 0x95
      ^---- dma.cmd 149
${test}.asm:296: error: DMA illegal command
  ^---- dma.wr6 0x96
      ^---- dma.wr6 150
${test}.asm:297: error: DMA illegal command
  ^---- dma.cmd 0x96
      ^---- dma.cmd 150
${test}.asm:298: error: DMA illegal command
  ^---- dma.wr6 0x97
      ^---- dma.wr6 151
${test}.asm:299: error: DMA illegal command
  ^---- dma.cmd 0x97
      ^---- dma.cmd 151
${test}.asm:300: error: DMA illegal command
  ^---- dma.wr6 0x98
      ^---- dma.wr6 152
${test}.asm:301: error: DMA illegal command
  ^---- dma.cmd 0x98
      ^---- dma.cmd 152
${test}.asm:302: error: DMA illegal command
  ^---- dma.wr6 0x99
      ^---- dma.wr6 153
${test}.asm:303: error: DMA illegal command
  ^---- dma.cmd 0x99
      ^---- dma.cmd 153
${test}.asm:304: error: DMA illegal command
  ^---- dma.wr6 0x9A
      ^---- dma.wr6 154
${test}.asm:305: error: DMA illegal command
  ^---- dma.cmd 0x9A
      ^---- dma.cmd 154
${test}.asm:306: error: DMA illegal command
  ^---- dma.wr6 0x9B
      ^---- dma.wr6 155
${test}.asm:307: error: DMA illegal command
  ^---- dma.cmd 0x9B
      ^---- dma.cmd 155
${test}.asm:308: error: DMA illegal command
  ^---- dma.wr6 0x9C
      ^---- dma.wr6 156
${test}.asm:309: error: DMA illegal command
  ^---- dma.cmd 0x9C
      ^---- dma.cmd 156
${test}.asm:310: error: DMA illegal command
  ^---- dma.wr6 0x9D
      ^---- dma.wr6 157
${test}.asm:311: error: DMA illegal command
  ^---- dma.cmd 0x9D
      ^---- dma.cmd 157
${test}.asm:312: error: DMA illegal command
  ^---- dma.wr6 0x9E
      ^---- dma.wr6 158
${test}.asm:313: error: DMA illegal command
  ^---- dma.cmd 0x9E
      ^---- dma.cmd 158
${test}.asm:314: error: DMA illegal command
  ^---- dma.wr6 0x9F
      ^---- dma.wr6 159
${test}.asm:315: error: DMA illegal command
  ^---- dma.cmd 0x9F
      ^---- dma.cmd 159
${test}.asm:316: error: DMA illegal command
  ^---- dma.wr6 0xA0
      ^---- dma.wr6 160
${test}.asm:317: error: DMA illegal command
  ^---- dma.cmd 0xA0
      ^---- dma.cmd 160
${test}.asm:318: error: DMA illegal command
  ^---- dma.wr6 0xA1
      ^---- dma.wr6 161
${test}.asm:319: error: DMA illegal command
  ^---- dma.cmd 0xA1
      ^---- dma.cmd 161
${test}.asm:320: error: DMA illegal command
  ^---- dma.wr6 0xA2
      ^---- dma.wr6 162
${test}.asm:321: error: DMA illegal command
  ^---- dma.cmd 0xA2
      ^---- dma.cmd 162
${test}.asm:322: error: DMA illegal command
  ^---- dma.wr6 0xA4
      ^---- dma.wr6 164
${test}.asm:323: error: DMA illegal command
  ^---- dma.cmd 0xA4
      ^---- dma.cmd 164
${test}.asm:324: error: DMA illegal command
  ^---- dma.wr6 0xA5
      ^---- dma.wr6 165
${test}.asm:325: error: DMA illegal command
  ^---- dma.cmd 0xA5
      ^---- dma.cmd 165
${test}.asm:326: error: DMA illegal command
  ^---- dma.wr6 0xA6
      ^---- dma.wr6 166
${test}.asm:327: error: DMA illegal command
  ^---- dma.cmd 0xA6
      ^---- dma.cmd 166
${test}.asm:328: error: DMA illegal command
  ^---- dma.wr6 0xA8
      ^---- dma.wr6 168
${test}.asm:329: error: DMA illegal command
  ^---- dma.cmd 0xA8
      ^---- dma.cmd 168
${test}.asm:330: error: DMA illegal command
  ^---- dma.wr6 0xA9
      ^---- dma.wr6 169
${test}.asm:331: error: DMA illegal command
  ^---- dma.cmd 0xA9
      ^---- dma.cmd 169
${test}.asm:332: error: DMA illegal command
  ^---- dma.wr6 0xAA
      ^---- dma.wr6 170
${test}.asm:333: error: DMA illegal command
  ^---- dma.cmd 0xAA
      ^---- dma.cmd 170
${test}.asm:334: error: DMA illegal command
  ^---- dma.wr6 0xAC
      ^---- dma.wr6 172
${test}.asm:335: error: DMA illegal command
  ^---- dma.cmd 0xAC
      ^---- dma.cmd 172
${test}.asm:336: error: DMA illegal command
  ^---- dma.wr6 0xAD
      ^---- dma.wr6 173
${test}.asm:337: error: DMA illegal command
  ^---- dma.cmd 0xAD
      ^---- dma.cmd 173
${test}.asm:338: error: DMA illegal command
  ^---- dma.wr6 0xAE
      ^---- dma.wr6 174
${test}.asm:339: error: DMA illegal command
  ^---- dma.cmd 0xAE
      ^---- dma.cmd 174
${test}.asm:340: error: DMA illegal command
  ^---- dma.wr6 0xB0
      ^---- dma.wr6 176
${test}.asm:341: error: DMA illegal command
  ^---- dma.cmd 0xB0
      ^---- dma.cmd 176
${test}.asm:342: error: DMA illegal command
  ^---- dma.wr6 0xB1
      ^---- dma.wr6 177
${test}.asm:343: error: DMA illegal command
  ^---- dma.cmd 0xB1
      ^---- dma.cmd 177
${test}.asm:344: error: DMA illegal command
  ^---- dma.wr6 0xB2
      ^---- dma.wr6 178
${test}.asm:345: error: DMA illegal command
  ^---- dma.cmd 0xB2
      ^---- dma.cmd 178
${test}.asm:346: error: DMA illegal command
  ^---- dma.wr6 0xB4
      ^---- dma.wr6 180
${test}.asm:347: error: DMA illegal command
  ^---- dma.cmd 0xB4
      ^---- dma.cmd 180
${test}.asm:348: error: DMA illegal command
  ^---- dma.wr6 0xB5
      ^---- dma.wr6 181
${test}.asm:349: error: DMA illegal command
  ^---- dma.cmd 0xB5
      ^---- dma.cmd 181
${test}.asm:350: error: DMA illegal command
  ^---- dma.wr6 0xB6
      ^---- dma.wr6 182
${test}.asm:351: error: DMA illegal command
  ^---- dma.cmd 0xB6
      ^---- dma.cmd 182
${test}.asm:352: error: DMA illegal command
  ^---- dma.wr6 0xB8
      ^---- dma.wr6 184
${test}.asm:353: error: DMA illegal command
  ^---- dma.cmd 0xB8
      ^---- dma.cmd 184
${test}.asm:354: error: DMA illegal command
  ^---- dma.wr6 0xB9
      ^---- dma.wr6 185
${test}.asm:355: error: DMA illegal command
  ^---- dma.cmd 0xB9
      ^---- dma.cmd 185
${test}.asm:356: error: DMA illegal command
  ^---- dma.wr6 0xBA
      ^---- dma.wr6 186
${test}.asm:357: error: DMA illegal command
  ^---- dma.cmd 0xBA
      ^---- dma.cmd 186
${test}.asm:358: error: DMA illegal command
  ^---- dma.wr6 0xBC
      ^---- dma.wr6 188
${test}.asm:359: error: DMA illegal command
  ^---- dma.cmd 0xBC
      ^---- dma.cmd 188
${test}.asm:360: error: DMA illegal command
  ^---- dma.wr6 0xBD
      ^---- dma.wr6 189
${test}.asm:361: error: DMA illegal command
  ^---- dma.cmd 0xBD
      ^---- dma.cmd 189
${test}.asm:362: error: DMA illegal command
  ^---- dma.wr6 0xBE
      ^---- dma.wr6 190
${test}.asm:363: error: DMA illegal command
  ^---- dma.cmd 0xBE
      ^---- dma.cmd 190
${test}.asm:364: error: DMA illegal command
  ^---- dma.wr6 0xC0
      ^---- dma.wr6 192
${test}.asm:365: error: DMA illegal command
  ^---- dma.cmd 0xC0
      ^---- dma.cmd 192
${test}.asm:366: error: DMA illegal command
  ^---- dma.wr6 0xC1
      ^---- dma.wr6 193
${test}.asm:367: error: DMA illegal command
  ^---- dma.cmd 0xC1
      ^---- dma.cmd 193
${test}.asm:368: error: DMA illegal command
  ^---- dma.wr6 0xC2
      ^---- dma.wr6 194
${test}.asm:369: error: DMA illegal command
  ^---- dma.cmd 0xC2
      ^---- dma.cmd 194
${test}.asm:370: error: DMA illegal command
  ^---- dma.wr6 0xC4
      ^---- dma.wr6 196
${test}.asm:371: error: DMA illegal command
  ^---- dma.cmd 0xC4
      ^---- dma.cmd 196
${test}.asm:372: error: DMA illegal command
  ^---- dma.wr6 0xC5
      ^---- dma.wr6 197
${test}.asm:373: error: DMA illegal command
  ^---- dma.cmd 0xC5
      ^---- dma.cmd 197
${test}.asm:374: error: DMA illegal command
  ^---- dma.wr6 0xC6
      ^---- dma.wr6 198
${test}.asm:375: error: DMA illegal command
  ^---- dma.cmd 0xC6
      ^---- dma.cmd 198
${test}.asm:376: error: DMA illegal command
  ^---- dma.wr6 0xC8
      ^---- dma.wr6 200
${test}.asm:377: error: DMA illegal command
  ^---- dma.cmd 0xC8
      ^---- dma.cmd 200
${test}.asm:378: error: DMA illegal command
  ^---- dma.wr6 0xC9
      ^---- dma.wr6 201
${test}.asm:379: error: DMA illegal command
  ^---- dma.cmd 0xC9
      ^---- dma.cmd 201
${test}.asm:380: error: DMA illegal command
  ^---- dma.wr6 0xCA
      ^---- dma.wr6 202
${test}.asm:381: error: DMA illegal command
  ^---- dma.cmd 0xCA
      ^---- dma.cmd 202
${test}.asm:382: error: DMA illegal command
  ^---- dma.wr6 0xCC
      ^---- dma.wr6 204
${test}.asm:383: error: DMA illegal command
  ^---- dma.cmd 0xCC
      ^---- dma.cmd 204
${test}.asm:384: error: DMA illegal command
  ^---- dma.wr6 0xCD
      ^---- dma.wr6 205
${test}.asm:385: error: DMA illegal command
  ^---- dma.cmd 0xCD
      ^---- dma.cmd 205
${test}.asm:386: error: DMA illegal command
  ^---- dma.wr6 0xCE
      ^---- dma.wr6 206
${test}.asm:387: error: DMA illegal command
  ^---- dma.cmd 0xCE
      ^---- dma.cmd 206
${test}.asm:388: error: DMA illegal command
  ^---- dma.wr6 0xD0
      ^---- dma.wr6 208
${test}.asm:389: error: DMA illegal command
  ^---- dma.cmd 0xD0
      ^---- dma.cmd 208
${test}.asm:390: error: DMA illegal command
  ^---- dma.wr6 0xD1
      ^---- dma.wr6 209
${test}.asm:391: error: DMA illegal command
  ^---- dma.cmd 0xD1
      ^---- dma.cmd 209
${test}.asm:392: error: DMA illegal command
  ^---- dma.wr6 0xD2
      ^---- dma.wr6 210
${test}.asm:393: error: DMA illegal command
  ^---- dma.cmd 0xD2
      ^---- dma.cmd 210
${test}.asm:394: error: DMA illegal command
  ^---- dma.wr6 0xD4
      ^---- dma.wr6 212
${test}.asm:395: error: DMA illegal command
  ^---- dma.cmd 0xD4
      ^---- dma.cmd 212
${test}.asm:396: error: DMA illegal command
  ^---- dma.wr6 0xD5
      ^---- dma.wr6 213
${test}.asm:397: error: DMA illegal command
  ^---- dma.cmd 0xD5
      ^---- dma.cmd 213
${test}.asm:398: error: DMA illegal command
  ^---- dma.wr6 0xD6
      ^---- dma.wr6 214
${test}.asm:399: error: DMA illegal command
  ^---- dma.cmd 0xD6
      ^---- dma.cmd 214
${test}.asm:400: error: DMA illegal command
  ^---- dma.wr6 0xD7
      ^---- dma.wr6 215
${test}.asm:401: error: DMA illegal command
  ^---- dma.cmd 0xD7
      ^---- dma.cmd 215
${test}.asm:402: error: DMA illegal command
  ^---- dma.wr6 0xD8
      ^---- dma.wr6 216
${test}.asm:403: error: DMA illegal command
  ^---- dma.cmd 0xD8
      ^---- dma.cmd 216
${test}.asm:404: error: DMA illegal command
  ^---- dma.wr6 0xD9
      ^---- dma.wr6 217
${test}.asm:405: error: DMA illegal command
  ^---- dma.cmd 0xD9
      ^---- dma.cmd 217
${test}.asm:406: error: DMA illegal command
  ^---- dma.wr6 0xDA
      ^---- dma.wr6 218
${test}.asm:407: error: DMA illegal command
  ^---- dma.cmd 0xDA
      ^---- dma.cmd 218
${test}.asm:408: error: DMA illegal command
  ^---- dma.wr6 0xDB
      ^---- dma.wr6 219
${test}.asm:409: error: DMA illegal command
  ^---- dma.cmd 0xDB
      ^---- dma.cmd 219
${test}.asm:410: error: DMA illegal command
  ^---- dma.wr6 0xDC
      ^---- dma.wr6 220
${test}.asm:411: error: DMA illegal command
  ^---- dma.cmd 0xDC
      ^---- dma.cmd 220
${test}.asm:412: error: DMA illegal command
  ^---- dma.wr6 0xDD
      ^---- dma.wr6 221
${test}.asm:413: error: DMA illegal command
  ^---- dma.cmd 0xDD
      ^---- dma.cmd 221
${test}.asm:414: error: DMA illegal command
  ^---- dma.wr6 0xDE
      ^---- dma.wr6 222
${test}.asm:415: error: DMA illegal command
  ^---- dma.cmd 0xDE
      ^---- dma.cmd 222
${test}.asm:416: error: DMA illegal command
  ^---- dma.wr6 0xDF
      ^---- dma.wr6 223
${test}.asm:417: error: DMA illegal command
  ^---- dma.cmd 0xDF
      ^---- dma.cmd 223
${test}.asm:418: error: DMA illegal command
  ^---- dma.wr6 0xE0
      ^---- dma.wr6 224
${test}.asm:419: error: DMA illegal command
  ^---- dma.cmd 0xE0
      ^---- dma.cmd 224
${test}.asm:420: error: DMA illegal command
  ^---- dma.wr6 0xE1
      ^---- dma.wr6 225
${test}.asm:421: error: DMA illegal command
  ^---- dma.cmd 0xE1
      ^---- dma.cmd 225
${test}.asm:422: error: DMA illegal command
  ^---- dma.wr6 0xE2
      ^---- dma.wr6 226
${test}.asm:423: error: DMA illegal command
  ^---- dma.cmd 0xE2
      ^---- dma.cmd 226
${test}.asm:424: error: DMA illegal command
  ^---- dma.wr6 0xE3
      ^---- dma.wr6 227
${test}.asm:425: error: DMA illegal command
  ^---- dma.cmd 0xE3
      ^---- dma.cmd 227
${test}.asm:426: error: DMA illegal command
  ^---- dma.wr6 0xE4
      ^---- dma.wr6 228
${test}.asm:427: error: DMA illegal command
  ^---- dma.cmd 0xE4
      ^---- dma.cmd 228
${test}.asm:428: error: DMA illegal command
  ^---- dma.wr6 0xE5
      ^---- dma.wr6 229
${test}.asm:429: error: DMA illegal command
  ^---- dma.cmd 0xE5
      ^---- dma.cmd 229
${test}.asm:430: error: DMA illegal command
  ^---- dma.wr6 0xE6
      ^---- dma.wr6 230
${test}.asm:431: error: DMA illegal command
  ^---- dma.cmd 0xE6
      ^---- dma.cmd 230
${test}.asm:432: error: DMA illegal command
  ^---- dma.wr6 0xE7
      ^---- dma.wr6 231
${test}.asm:433: error: DMA illegal command
  ^---- dma.cmd 0xE7
      ^---- dma.cmd 231
${test}.asm:434: error: DMA illegal command
  ^---- dma.wr6 0xE8
      ^---- dma.wr6 232
${test}.asm:435: error: DMA illegal command
  ^---- dma.cmd 0xE8
      ^---- dma.cmd 232
${test}.asm:436: error: DMA illegal command
  ^---- dma.wr6 0xE9
      ^---- dma.wr6 233
${test}.asm:437: error: DMA illegal command
  ^---- dma.cmd 0xE9
      ^---- dma.cmd 233
${test}.asm:438: error: DMA illegal command
  ^---- dma.wr6 0xEA
      ^---- dma.wr6 234
${test}.asm:439: error: DMA illegal command
  ^---- dma.cmd 0xEA
      ^---- dma.cmd 234
${test}.asm:440: error: DMA illegal command
  ^---- dma.wr6 0xEB
      ^---- dma.wr6 235
${test}.asm:441: error: DMA illegal command
  ^---- dma.cmd 0xEB
      ^---- dma.cmd 235
${test}.asm:442: error: DMA illegal command
  ^---- dma.wr6 0xEC
      ^---- dma.wr6 236
${test}.asm:443: error: DMA illegal command
  ^---- dma.cmd 0xEC
      ^---- dma.cmd 236
${test}.asm:444: error: DMA illegal command
  ^---- dma.wr6 0xED
      ^---- dma.wr6 237
${test}.asm:445: error: DMA illegal command
  ^---- dma.cmd 0xED
      ^---- dma.cmd 237
${test}.asm:446: error: DMA illegal command
  ^---- dma.wr6 0xEE
      ^---- dma.wr6 238
${test}.asm:447: error: DMA illegal command
  ^---- dma.cmd 0xEE
      ^---- dma.cmd 238
${test}.asm:448: error: DMA illegal command
  ^---- dma.wr6 0xEF
      ^---- dma.wr6 239
${test}.asm:449: error: DMA illegal command
  ^---- dma.cmd 0xEF
      ^---- dma.cmd 239
${test}.asm:450: error: DMA illegal command
  ^---- dma.wr6 0xF0
      ^---- dma.wr6 240
${test}.asm:451: error: DMA illegal command
  ^---- dma.cmd 0xF0
      ^---- dma.cmd 240
${test}.asm:452: error: DMA illegal command
  ^---- dma.wr6 0xF1
      ^---- dma.wr6 241
${test}.asm:453: error: DMA illegal command
  ^---- dma.cmd 0xF1
      ^---- dma.cmd 241
${test}.asm:454: error: DMA illegal command
  ^---- dma.wr6 0xF2
      ^---- dma.wr6 242
${test}.asm:455: error: DMA illegal command
  ^---- dma.cmd 0xF2
      ^---- dma.cmd 242
${test}.asm:456: error: DMA illegal command
  ^---- dma.wr6 0xF3
      ^---- dma.wr6 243
${test}.asm:457: error: DMA illegal command
  ^---- dma.cmd 0xF3
      ^---- dma.cmd 243
${test}.asm:458: error: DMA illegal command
  ^---- dma.wr6 0xF4
      ^---- dma.wr6 244
${test}.asm:459: error: DMA illegal command
  ^---- dma.cmd 0xF4
      ^---- dma.cmd 244
${test}.asm:460: error: DMA illegal command
  ^---- dma.wr6 0xF5
      ^---- dma.wr6 245
${test}.asm:461: error: DMA illegal command
  ^---- dma.cmd 0xF5
      ^---- dma.cmd 245
${test}.asm:462: error: DMA illegal command
  ^---- dma.wr6 0xF6
      ^---- dma.wr6 246
${test}.asm:463: error: DMA illegal command
  ^---- dma.cmd 0xF6
      ^---- dma.cmd 246
${test}.asm:464: error: DMA illegal command
  ^---- dma.wr6 0xF7
      ^---- dma.wr6 247
${test}.asm:465: error: DMA illegal command
  ^---- dma.cmd 0xF7
      ^---- dma.cmd 247
${test}.asm:466: error: DMA illegal command
  ^---- dma.wr6 0xF8
      ^---- dma.wr6 248
${test}.asm:467: error: DMA illegal command
  ^---- dma.cmd 0xF8
      ^---- dma.cmd 248
${test}.asm:468: error: DMA illegal command
  ^---- dma.wr6 0xF9
      ^---- dma.wr6 249
${test}.asm:469: error: DMA illegal command
  ^---- dma.cmd 0xF9
      ^---- dma.cmd 249
${test}.asm:470: error: DMA illegal command
  ^---- dma.wr6 0xFA
      ^---- dma.wr6 250
${test}.asm:471: error: DMA illegal command
  ^---- dma.cmd 0xFA
      ^---- dma.cmd 250
${test}.asm:472: error: DMA illegal command
  ^---- dma.wr6 0xFB
      ^---- dma.wr6 251
${test}.asm:473: error: DMA illegal command
  ^---- dma.cmd 0xFB
      ^---- dma.cmd 251
${test}.asm:474: error: DMA illegal command
  ^---- dma.wr6 0xFC
      ^---- dma.wr6 252
${test}.asm:475: error: DMA illegal command
  ^---- dma.cmd 0xFC
      ^---- dma.cmd 252
${test}.asm:476: error: DMA illegal command
  ^---- dma.wr6 0xFD
      ^---- dma.wr6 253
${test}.asm:477: error: DMA illegal command
  ^---- dma.cmd 0xFD
      ^---- dma.cmd 253
${test}.asm:478: error: DMA illegal command
  ^---- dma.wr6 0xFE
      ^---- dma.wr6 254
${test}.asm:479: error: DMA illegal command
  ^---- dma.cmd 0xFE
      ^---- dma.cmd 254
${test}.asm:480: error: DMA illegal command
  ^---- dma.wr6 0xFF
      ^---- dma.wr6 255
${test}.asm:481: error: DMA illegal command
  ^---- dma.cmd 0xFF
      ^---- dma.cmd 255
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E, 1, 0x83, 0x87, 0xCF, 0xD3, 0x83, 0x87, 0xCF, 0xD3, 0x3E, 2));
	ld a,1
	
	dma.wr6 0x83
	dma.wr6 0x87
	dma.wr6 0xCF
	dma.wr6 0xD3
	
	dma.cmd 0x83
	dma.cmd 0x87
	dma.cmd 0xCF
	dma.cmd 0xD3
	
	ld a,2
END

z80asm_ok("-b -mz80n", "", <<END, <<END, bytes(0x3E,1,0xC3,0xC7,0xCB,0xAF,0xAB,0xA3,0xB7,0xBF,0x8B,0xA7,0xB3,0xC3,0xC7,0xCB,0xAF,0xAB,0xA3,0xB7,0xBF,0x8B,0xA7,0xB3,0x3E,2));
${test}.asm:3: warning: DMA does not implement this command
  ^---- dma.wr6 0xC3
      ^---- dma.wr6 195
${test}.asm:4: warning: DMA does not implement this command
  ^---- dma.wr6 0xC7
      ^---- dma.wr6 199
${test}.asm:5: warning: DMA does not implement this command
  ^---- dma.wr6 0xCB
      ^---- dma.wr6 203
${test}.asm:6: warning: DMA does not implement this command
  ^---- dma.wr6 0xAF
      ^---- dma.wr6 175
${test}.asm:7: warning: DMA does not implement this command
  ^---- dma.wr6 0xAB
      ^---- dma.wr6 171
${test}.asm:8: warning: DMA does not implement this command
  ^---- dma.wr6 0xA3
      ^---- dma.wr6 163
${test}.asm:9: warning: DMA does not implement this command
  ^---- dma.wr6 0xB7
      ^---- dma.wr6 183
${test}.asm:10: warning: DMA does not implement this command
  ^---- dma.wr6 0xBF
      ^---- dma.wr6 191
${test}.asm:11: warning: DMA does not implement this command
  ^---- dma.wr6 0x8B
      ^---- dma.wr6 139
${test}.asm:12: warning: DMA does not implement this command
  ^---- dma.wr6 0xA7
      ^---- dma.wr6 167
${test}.asm:13: warning: DMA does not implement this command
  ^---- dma.wr6 0xB3
      ^---- dma.wr6 179
${test}.asm:15: warning: DMA does not implement this command
  ^---- dma.cmd 0xC3
      ^---- dma.cmd 195
${test}.asm:16: warning: DMA does not implement this command
  ^---- dma.cmd 0xC7
      ^---- dma.cmd 199
${test}.asm:17: warning: DMA does not implement this command
  ^---- dma.cmd 0xCB
      ^---- dma.cmd 203
${test}.asm:18: warning: DMA does not implement this command
  ^---- dma.cmd 0xAF
      ^---- dma.cmd 175
${test}.asm:19: warning: DMA does not implement this command
  ^---- dma.cmd 0xAB
      ^---- dma.cmd 171
${test}.asm:20: warning: DMA does not implement this command
  ^---- dma.cmd 0xA3
      ^---- dma.cmd 163
${test}.asm:21: warning: DMA does not implement this command
  ^---- dma.cmd 0xB7
      ^---- dma.cmd 183
${test}.asm:22: warning: DMA does not implement this command
  ^---- dma.cmd 0xBF
      ^---- dma.cmd 191
${test}.asm:23: warning: DMA does not implement this command
  ^---- dma.cmd 0x8B
      ^---- dma.cmd 139
${test}.asm:24: warning: DMA does not implement this command
  ^---- dma.cmd 0xA7
      ^---- dma.cmd 167
${test}.asm:25: warning: DMA does not implement this command
  ^---- dma.cmd 0xB3
      ^---- dma.cmd 179
END
	ld a,1
	
	dma.wr6 0xC3
	dma.wr6 0xC7
	dma.wr6 0xCB
	dma.wr6 0xAF
	dma.wr6 0xAB
	dma.wr6 0xA3
	dma.wr6 0xB7
	dma.wr6 0xBF
	dma.wr6 0x8B 
	dma.wr6 0xA7
	dma.wr6 0xB3
	
	dma.cmd 0xC3
	dma.cmd 0xC7
	dma.cmd 0xCB
	dma.cmd 0xAF
	dma.cmd 0xAB
	dma.cmd 0xA3
	dma.cmd 0xB7
	dma.cmd 0xBF
	dma.cmd 0x8B 
	dma.cmd 0xA7
	dma.cmd 0xB3
	
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr6 0xBB
	dma.cmd 0xBB
	ld a,2
END
${test}.asm:2: error: DMA missing register group member(s)
  ^---- dma.wr6 0xBB
      ^---- dma.wr6 187
${test}.asm:3: error: DMA missing register group member(s)
  ^---- dma.cmd 0xBB
      ^---- dma.cmd 187
END

z80asm_ok("-b -mz80n", "", "", <<END, bytes(0x3E,1,0xBB,0x7F,0xBB,0x7F,0x3E,2));
	ld a,1
	dma.wr6 0xBB, 0x7F
	dma.cmd 0xBB, 0x7F
	ld a,2
END

z80asm_nok("-b -mz80n", "", <<END, <<END);
	ld a,1
	dma.wr6 0xBB, 0x80
	dma.cmd 0xBB, 0x80
	ld a,2
END
${test}.asm:2: error: DMA illegal read mask
  ^---- dma.wr6 0xBB, 0x80
      ^---- dma.wr6 187,128
${test}.asm:3: error: DMA illegal read mask
  ^---- dma.cmd 0xBB, 0x80
      ^---- dma.cmd 187,128
END


unlink_testfiles;
done_testing;
