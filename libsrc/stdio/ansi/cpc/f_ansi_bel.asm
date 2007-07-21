;
; 	ANSI Video handling for the Amstrad CPC
;
; 	BEL - chr(7)   Beep it out
;	
;
;	Stefano Bodrato - Jul. 2004
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;

        XLIB	ansi_BEL

        XREF    firmware
; A fine double frequency beep for BEL

.ansi_BEL
        ld      a,7
        call    firmware
        defw    txt_output
        ret
