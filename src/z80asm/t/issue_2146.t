#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/2146
# z80asm pseudo instruction defs, defw, defb does not produce binary data for calculated values

spew("$test.asm", <<'END');
.PLY1TBL	defw 0					; Player 1 x coord y coord
.PLY1FLG	defb 0
.PLY1CFLG	defb 0
.PLY1TBLEND							; End of Player 1 table

defc PLY1TBLLENGTH = PLY1TBLEND - PLY1TBL	; Length of Player record

defc MAXPLAYERS = 16	

PLAYERARRAY:
            defw PLY1TBLLENGTH
            defw PLY1TBLLENGTH * MAXPLAYERS
            defs PLY1TBLLENGTH * MAXPLAYERS, $00
PLAYERARRAYEND:

; This will produce 0 for defb, defw values and nothing for defs values

PLAYERARRAY2:
            defw (PLY1TBLEND - PLY1TBL) * MAXPLAYERS
            defs (PLY1TBLEND - PLY1TBL) * MAXPLAYERS, $00
PLAYERARRAY2END:

; This will produce the correct values for defb and defw values and corrupted bytes for defs values
END

# assemble
capture_ok("z88dk-z80asm +zx -s -l -m -g -r0x6100 $test.asm", "");
check_bin_file("$test.bin",
			words(0).bytes(0, 0).
			words(4, 4*16).(bytes(0) x (4*16)).
			words(4*16).(bytes(0) x (4*16)));
check_text_file("$test.map", <<END);
PLY1TBL                         = \$6100 ; addr, local, , $test, , $test.asm:1
PLY1FLG                         = \$6102 ; addr, local, , $test, , $test.asm:2
PLY1CFLG                        = \$6103 ; addr, local, , $test, , $test.asm:3
PLY1TBLEND                      = \$6104 ; addr, local, , $test, , $test.asm:4
PLY1TBLLENGTH                   = \$0004 ; const, local, , $test, , $test.asm:6
MAXPLAYERS                      = \$0010 ; const, local, , $test, , $test.asm:8
PLAYERARRAY                     = \$6104 ; addr, local, , $test, , $test.asm:10
PLAYERARRAYEND                  = \$6148 ; addr, local, , $test, , $test.asm:14
PLAYERARRAY2                    = \$6148 ; addr, local, , $test, , $test.asm:18
PLAYERARRAY2END                 = \$618A ; addr, local, , $test, , $test.asm:21
__head                          = \$6100 ; const, public, def, , ,
__tail                          = \$618A ; const, public, def, , ,
__size                          = \$008A ; const, public, def, , ,
END

# different sections
spew("$test.asm", <<'END');
	section aa
aa_start:	defb 1
aa_end:

	section bb
bb_start:	defb 2
bb_end:

	defc aa_length = aa_end-aa_start
	defc bb_length = bb_end-bb_start
	defc nonsence = bb_start-aa_start
	
	defs aa_length, 3
	defs bb_length, 4
IF ERROR
	defs nonsence, 5
ENDIF
END

capture_ok("z88dk-z80asm -b -m $test.asm", "");
check_bin_file("$test.bin",
			bytes(1, 2, 3, 4));
check_text_file("$test.map", <<END);
aa_start                        = \$0000 ; addr, local, , $test, aa, $test.asm:2
aa_end                          = \$0001 ; addr, local, , $test, aa, $test.asm:3
bb_start                        = \$0001 ; addr, local, , $test, bb, $test.asm:6
bb_end                          = \$0002 ; addr, local, , $test, bb, $test.asm:7
aa_length                       = \$0001 ; const, local, , $test, bb, $test.asm:9
bb_length                       = \$0001 ; const, local, , $test, bb, $test.asm:10
nonsence                        = \$0001 ; comput, local, , $test, bb, $test.asm:11
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$0004 ; const, public, def, , ,
__size                          = \$0004 ; const, public, def, , ,
__aa_head                       = \$0000 ; const, public, def, , ,
__aa_tail                       = \$0001 ; const, public, def, , ,
__aa_size                       = \$0001 ; const, public, def, , ,
__bb_head                       = \$0001 ; const, public, def, , ,
__bb_tail                       = \$0004 ; const, public, def, , ,
__bb_size                       = \$0003 ; const, public, def, , ,
END

capture_nok("z88dk-z80asm -DERROR -b $test.asm", <<END);
$test.asm:16: error: constant expression expected
  ^---- defs nonsence, 5
END

# no DEFC
spew("$test.asm", <<'END');
aa_start:	defb 1
aa_end:
bb_start:	defb 2, 2
bb_end:

	defs aa_end-aa_start, 3
	defs 2*(aa_end-aa_start), 4
	defs -aa_start+aa_end, 5
	defs aa_end+2-aa_start, 6
	defs bb_end-bb_start+aa_end-aa_start, 7
END

capture_ok("z88dk-z80asm -b -m $test.asm", "");
check_bin_file("$test.bin",
			bytes(1).
			bytes(2,2).
			bytes(3).
			bytes(4,4).
			bytes(5).
			bytes(6,6,6).
			bytes(7,7,7));
check_text_file("$test.map", <<END);
aa_start                        = \$0000 ; addr, local, , $test, , $test.asm:1
aa_end                          = \$0001 ; addr, local, , $test, , $test.asm:2
bb_start                        = \$0001 ; addr, local, , $test, , $test.asm:3
bb_end                          = \$0003 ; addr, local, , $test, , $test.asm:4
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$000D ; const, public, def, , ,
__size                          = \$000D ; const, public, def, , ,
END

# different expressions
spew("$test.asm", <<'END');
aa_start:	defb 1
aa_end:
bb_start:	defb 2, 2
bb_end:

	defc s1=aa_end-aa_start
	defc s2=2*(aa_end-aa_start)
	defc s3=-aa_start+aa_end
	defc s4=aa_end+2-aa_start
	defc s5=bb_end-bb_start+aa_end-aa_start
	
	defs s1,3
	defs s2,4
	defs s3,5
	defs s4,6
	defs s5,7
END

capture_ok("z88dk-z80asm -b -m $test.asm", "");
check_bin_file("$test.bin",
			bytes(1).
			bytes(2,2).
			bytes(3).
			bytes(4,4).
			bytes(5).
			bytes(6,6,6).
			bytes(7,7,7));
check_text_file("$test.map", <<END);
aa_start                        = \$0000 ; addr, local, , $test, , $test.asm:1
aa_end                          = \$0001 ; addr, local, , $test, , $test.asm:2
bb_start                        = \$0001 ; addr, local, , $test, , $test.asm:3
bb_end                          = \$0003 ; addr, local, , $test, , $test.asm:4
s1                              = \$0001 ; const, local, , $test, , $test.asm:6
s2                              = \$0002 ; const, local, , $test, , $test.asm:7
s3                              = \$0001 ; const, local, , $test, , $test.asm:8
s4                              = \$0003 ; const, local, , $test, , $test.asm:9
s5                              = \$0003 ; const, local, , $test, , $test.asm:10
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$000D ; const, public, def, , ,
__size                          = \$000D ; const, public, def, , ,
END

unlink_testfiles;
done_testing;
