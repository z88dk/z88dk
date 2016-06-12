;
;	Amstrad CPC Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: getk.asm,v 1.9 2016-06-12 17:07:43 dom Exp $
;

        SECTION code_clib
        PUBLIC	getk
        PUBLIC	_getk

        INCLUDE "cpcfirm.def"


.getk
._getk
        call    firmware
        defw    km_read_char
        push	af
        call    firmware
        defw    km_initialise	; clear buffer for next reading
        pop	af
        ld      hl,0
        ret     nc
        ld      l,a
	cp	127
	ret	nz
	ld	l,12
        ret
