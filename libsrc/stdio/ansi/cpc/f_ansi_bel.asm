;
; 	ANSI Video handling for the Amstrad CPC
;
; 	BEL - chr(7)   Beep it out
;	
;
;	Stefano Bodrato - Jul. 2004
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2007-10-27 09:13:40 stefano Exp $
;

        XLIB	ansi_BEL

    INCLUDE "#cpcfirm.def"

        XREF    firmware

.ansi_BEL
        ld      a,7
        call    firmware
        defw    txt_output
        ret
