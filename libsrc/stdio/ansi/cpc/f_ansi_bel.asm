;
; 	ANSI Video handling for the Amstrad CPC
;
; 	BEL - chr(7)   Beep it out
;	
;
;	Stefano Bodrato - Jul. 2004
;
;
;	$Id: f_ansi_bel.asm,v 1.1 2004-07-15 10:03:49 stefano Exp $
;

	XLIB	ansi_BEL

; A fine double frequency beep for BEL

.ansi_BEL
	ld	a,7
	jp	$BB5A
