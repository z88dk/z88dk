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
        INCLUDE "msxbios.def"
        INCLUDE "msxbasic.def"
ELSE
        INCLUDE "svibios.def"
        INCLUDE "svibasic.def"
ENDIF

.clock
._clock
	ld	hl,(JIFFY)
	ld	de,0
	ret
