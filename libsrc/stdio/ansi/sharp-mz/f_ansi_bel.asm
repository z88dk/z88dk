;
; 	ANSI Video handling for the Sharp MZ
;	By Stefano Bodrato - 5/5/2000
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
	jp	$3E	; Beep !
