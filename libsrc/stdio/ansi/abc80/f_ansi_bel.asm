;
; 	ANSI Video handling for the ABC80
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2007-10-31 14:01:47 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
	; Put here the BEEP code
	ld	a,7
        jp	1a8h

