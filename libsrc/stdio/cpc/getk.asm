;
;	Amstrad CPC Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: getk.asm,v 1.5 2009-06-22 21:44:17 dom Exp $
;

        XLIB	getk

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
