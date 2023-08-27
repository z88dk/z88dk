#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/53
# z80asm: public constants not being listed in global .def file

z80asm_ok("-b -s -g -m -Ddummy", "", "", <<'END', bytes(0xC9));
	org 65000

	PUBLIC program

	PUBLIC asm_BIFROST2_start
	PUBLIC asm_BIFROST2_stop

	DEFC asm_BIFROST2_start              = $C9A9 ;   asm_BIFROST2
	DEFC asm_BIFROST2_stop               = $C9B2 ;   asm_BIFROST2
	DEFC asm_BIFROST2_showNext2Tiles     = $C9C2 ;   asm_BIFROST2
	DEFC asm_BIFROST2_showNextTile       = $C9C5 ;   asm_BIFROST2
	DEFC asm_BIFROST2_showTilePosH       = $C9E3 ;   asm_BIFROST2
	DEFC asm_BIFROST2_drawTileH          = $CA02 ;   asm_BIFROST2
	DEFC _BIFROST2_TILE_IMAGES           = $CA17 ;   asm_BIFROST2
	DEFC _BIFROST2_ISR_HOOK              = $FD29 ;   asm_BIFROST2
	DEFC asm_BIFROST2_fillTileAttrH      = $FD3D ;   asm_BIFROST2

	program:
	ret
END

check_text_file("${test}.sym", <<END);
program                         = \$0000 ; addr, public, , , , ${test}.asm:18
asm_BIFROST2_start              = \$C9A9 ; const, public, , , , ${test}.asm:8
asm_BIFROST2_stop               = \$C9B2 ; const, public, , , , ${test}.asm:9
END

check_text_file("${test}.map", <<END);
program                         = \$FDE8 ; addr, public, , ${test}, , ${test}.asm:18
asm_BIFROST2_start              = \$C9A9 ; const, public, , ${test}, , ${test}.asm:8
asm_BIFROST2_stop               = \$C9B2 ; const, public, , ${test}, , ${test}.asm:9
__head                          = \$FDE8 ; const, public, def, , ,
__tail                          = \$FDE9 ; const, public, def, , ,
__size                          = \$0001 ; const, public, def, , ,
END

check_text_file("${test}.def", <<'END');
DEFC program                         = $FDE8
DEFC asm_BIFROST2_start              = $C9A9
DEFC asm_BIFROST2_stop               = $C9B2
END

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 1 bytes, ORG \$FDE8
    C \$0000: C9
  Symbols:
    G A \$0000: program (section "") (file ${test}.asm:18)
    G C \$C9A9: asm_BIFROST2_start (section "") (file ${test}.asm:8)
    G C \$C9B2: asm_BIFROST2_stop (section "") (file ${test}.asm:9)
END


unlink_testfiles;
done_testing;
