;
; 	ANSI Video handling for the Mattel Aquarius
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Dec. 2000
;
;
;	$Id: f_ansi_bel.asm,v 1.1 2001-12-27 09:35:57 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
	ld	a,7
	jp	$1d94


