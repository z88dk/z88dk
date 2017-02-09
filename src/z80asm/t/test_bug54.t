#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test https://github.com/z88dk/z88dk/issues/54

use Modern::Perl;
use Capture::Tiny::Extended 'capture';
use t::TestZ80asm;
use t::Listfile;

unlink "test.sym", "test.map", "test.def";
z80asm(
	asm => 	<<'ASM',
		org 65000

		PUBLIC program

		PUBLIC asm_BIFROST2_start
		PUBLIC asm_BIFROST2_stop
		PUBLIC asm_BIFROST2_showNext2Tiles

		DEFC asm_BIFROST2_start              = $C9A9 + ASMPC - ASMPC
		DEFC asm_BIFROST2_stop               = $C9B2 + here - there
		DEFC asm_BIFROST2_showNext2Tiles     = $C9C2 + 50000 - 50000
		DEFC asm_BIFROST2_showNextTile       = $C9C5 ;   asm_BIFROST2
		DEFC asm_BIFROST2_showTilePosH       = $C9E3 ;   asm_BIFROST2
		DEFC asm_BIFROST2_drawTileH          = $CA02 ;   asm_BIFROST2
		DEFC _BIFROST2_TILE_IMAGES           = $CA17 ;   asm_BIFROST2
		DEFC _BIFROST2_ISR_HOOK              = $FD29 ;   asm_BIFROST2
		DEFC asm_BIFROST2_fillTileAttrH      = $FD3D ;   asm_BIFROST2

		program:
		here:
		there:
		ret
ASM
	options => "-b -s -g -m -Ddummy",
	bin 	=> "\xC9",
);

eq_or_diff_text scalar(read_file("test.sym")), <<'END';
asm_BIFROST2_start              = $0000 ; G 
asm_BIFROST2_stop               = $0000 ; G 
here                            = $0000 ; L 
program                         = $0000 ; G 
there                           = $0000 ; L 
asm_BIFROST2_showNext2Tiles     = $C9C2 ; G 
END

eq_or_diff_text scalar(read_file("test.map")), <<'END';
__size                          = $0001 ; G 
asm_BIFROST2_start              = $C9A9 ; G test
asm_BIFROST2_stop               = $C9B2 ; G test
asm_BIFROST2_showNext2Tiles     = $C9C2 ; G test
__head                          = $FDE8 ; G 
here                            = $FDE8 ; L test
program                         = $FDE8 ; G test
there                           = $FDE8 ; L test
__tail                          = $FDE9 ; G 
END

eq_or_diff_text scalar(read_file("test.def")), <<'END';
DEFC asm_BIFROST2_start              = $C9A9 ;   test
DEFC asm_BIFROST2_stop               = $C9B2 ;   test
DEFC asm_BIFROST2_showNext2Tiles     = $C9C2 ;   test
DEFC program                         = $FDE8 ;   test
END

z80nm("test.o", <<'END');

File test.o at $0000: Z80RMF08
  Name: test
  Names:
    L A $0000 here
    L A $0000 there
    G A $0000 program
    G = $0000 asm_BIFROST2_start
    G = $0000 asm_BIFROST2_stop
    G C $C9C2 asm_BIFROST2_showNext2Tiles
  Expressions:
    E =  (test.asm:9) $0000 $0000: asm_BIFROST2_start := 51625+ASMPC-ASMPC
    E =  (test.asm:10) $0000 $0000: asm_BIFROST2_stop := 51634+here-there
  Code: 1 bytes, ORG at $FDE8
    C $0000: C9
END

