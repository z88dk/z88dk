;
; 	ANSI Video handling for the Amstrad CPC
;
; 	BEL - chr(7)   Beep it out
;	
;
;	Stefano Bodrato - Jul. 2004
;
;
;	$Id: f_ansi_bel.asm,v 1.6 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
        PUBLIC	ansi_BEL

    INCLUDE "cpcfirm.def"

        EXTERN    firmware

.ansi_BEL
        ld      a,7
        call    firmware
        defw    txt_output
        ret
