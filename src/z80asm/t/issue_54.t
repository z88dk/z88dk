#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test https://github.com/z88dk/z88dk/issues/54
# z80asm: overflow errors in calculated constants at linking stage

use Modern::Perl;
use Test::More;
require './t/testlib.pl';


unlink_testfiles();
z80asm(<<'END', "-b -s -g -m -Ddummy");
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
END
check_bin_file("test.bin", pack("C*", 0xC9));
check_text_file("test.sym", <<'END');
here                            = $0000 ; addr, local, , , , test.asm:20
there                           = $0000 ; addr, local, , , , test.asm:21
program                         = $0000 ; addr, public, , , , test.asm:19
asm_BIFROST2_start              = $0000 ; comput, public, , , , test.asm:9
asm_BIFROST2_stop               = $0000 ; comput, public, , , , test.asm:10
asm_BIFROST2_showNext2Tiles     = $C9C2 ; const, public, , , , test.asm:11
END
check_text_file("test.map", <<'END');
here                            = $FDE8 ; addr, local, , test, , test.asm:20
there                           = $FDE8 ; addr, local, , test, , test.asm:21
program                         = $FDE8 ; addr, public, , test, , test.asm:19
asm_BIFROST2_start              = $C9A9 ; addr, public, , test, , test.asm:9
asm_BIFROST2_stop               = $C9B2 ; addr, public, , test, , test.asm:10
asm_BIFROST2_showNext2Tiles     = $C9C2 ; const, public, , test, , test.asm:11
__head                          = $FDE8 ; const, public, def, , ,
__tail                          = $FDE9 ; const, public, def, , ,
__size                          = $0001 ; const, public, def, , ,
END
check_text_file("test.def", <<'END');
DEFC program                         = $FDE8
DEFC asm_BIFROST2_start              = $C9A9
DEFC asm_BIFROST2_stop               = $C9B2
DEFC asm_BIFROST2_showNext2Tiles     = $C9C2
END


z80nm("test.o", <<'END');
Object  file test.o at $0000: Z80RMF16
  Name: test
  Section "": 1 bytes, ORG $FDE8
    C $0000: C9
  Symbols:
    L A $0000 here (section "") (file test.asm:20)
    L A $0000 there (section "") (file test.asm:21)
    G A $0000 program (section "") (file test.asm:19)
    G = $0000 asm_BIFROST2_start (section "") (file test.asm:9)
    G = $0000 asm_BIFROST2_stop (section "") (file test.asm:10)
    G C $C9C2 asm_BIFROST2_showNext2Tiles (section "") (file test.asm:11)
  Expressions:
    E =  $0000 $0000: asm_BIFROST2_start := 51625+$-$ (section "") (file test.asm:9)
    E =  $0000 $0000: asm_BIFROST2_stop := 51634+here-there (section "") (file test.asm:10)
END

unlink_testfiles();
done_testing();
