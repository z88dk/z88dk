;
;	Amstrad CPC Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: getk.asm $
;

        SECTION code_clib
        PUBLIC	getk
        PUBLIC	_getk

        INCLUDE "target/cpc/def/cpcfirm.def"


.getk
._getk		
        call    firmware
        defw    km_read_char
		
		push af

	; clear buffer for next reading
        call    firmware
        defw    km_initialise

		pop af
		
		
		ld		hl,0
        ret     nc
		ld		l,a
		
        cp	127
		ret	nz
        ld	l,12
        ret
