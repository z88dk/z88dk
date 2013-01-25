;
; 	ANSI Video handling for the PC6001
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Jan 2013
;
;
;	$Id: f_ansi_bel.asm,v 1.1 2013-01-25 09:05:46 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
		ld	a,7
        jp	$26c7

