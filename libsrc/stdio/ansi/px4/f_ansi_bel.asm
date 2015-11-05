;
; 	ANSI Video handling for the Epson PX4
;	By Stefano Bodrato - Nov 2014
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.1 2015-11-05 16:08:04 stefano Exp $
;

	PUBLIC	ansi_BEL


.ansi_BEL
		ld c,7	; BEL
		jp $eb0c	; CONOUT

