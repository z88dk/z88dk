;
; 	ANSI Video handling for the PC6001
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Jan 2013
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
		ld	a,7
        jp	$26c7

