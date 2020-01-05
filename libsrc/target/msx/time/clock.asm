;
;	clock()  for the MSX / SVI
;
;	Stefano, 2017
;
; ------
; $Id: clock.asm $
;

	SECTION code_clib
	PUBLIC	clock
	PUBLIC	_clock

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
        INCLUDE "target/msx/def/msxbasic.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
        INCLUDE "target/svi/def/svibasic.def"
ENDIF

.clock
._clock
	ld	hl,(JIFFY)
	ld	de,0
	ret
