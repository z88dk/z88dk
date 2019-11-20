;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;   Based on the source of
;
;	Enterprise 64/128 clock()
;
;	stefano 5/4/2007
;

        SECTION code_clib
        PUBLIC	clock
        PUBLIC	_clock
        include "target/tvc/def/tvc.def"
.clock
._clock
; defw INTINC 0b1dh
	ld hl,(INTINC) ; count of 20.096ms from start (can count up to almost 22mins)
	
    ;              C hours   0 .. 23 (BCD)
    ;              D minutes 0 .. 59 (BCD)
    ;              E seconds 0 .. 59 (BCD) 	

	; let's copy the result in dehl
	; in a quick but wrong way..
    ld c,0
	ex	de,hl
	ld	d,0
	ld	e,c
	
	ret
