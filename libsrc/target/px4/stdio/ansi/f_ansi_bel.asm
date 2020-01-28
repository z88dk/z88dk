;
; 	ANSI Video handling for the Epson PX4
;	By Stefano Bodrato - Nov 2014
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
		ld c,7	; BEL
		jp $eb0c	; CONOUT

