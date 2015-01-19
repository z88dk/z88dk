;
;	Amstrad CPC Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: getk.asm,v 1.6 2015-01-19 01:33:20 pauloscustodio Exp $
;

        PUBLIC	getk

        INCLUDE "cpcfirm.def"


.getk
        call    firmware
        defw    km_read_char
        push	af
        call    firmware
        defw    km_initialise	; clear buffer for next reading
        pop	af
        ld      hl,0
        ret     nc
        ld      l,a
        ret
