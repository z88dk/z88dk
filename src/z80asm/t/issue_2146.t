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

capture_nok("z88dk-z80asm -DERROR -b -m $test.asm", <<END);
$test.asm:16: error: constant expression expected
  ^---- defs nonsence, 5
END

unlink_testfiles;
done_testing;
