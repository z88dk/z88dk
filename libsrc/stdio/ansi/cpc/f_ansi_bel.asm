;
; 	ANSI Video handling for the Amstrad CPC
;
; 	BEL - chr(7)   Beep it out
;	
;
;	Stefano Bodrato - Jul. 2004
;
;
;	$Id: f_ansi_bel.asm,v 1.5 2015-01-19 01:33:18 pauloscustodio Exp $
;

        PUBLIC	ansi_BEL

    INCLUDE "cpcfirm.def"

        EXTERN    firmware

.ansi_BEL
        ld      a,7
        call    firmware
        defw    txt_output
        ret
