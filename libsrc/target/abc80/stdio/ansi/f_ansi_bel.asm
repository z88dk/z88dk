;
; 	ANSI Video handling for the ABC80
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.5 2016-06-12 16:06:42 dom Exp $
;

	SECTION code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
	; Put here the BEEP code
	ld	a,7
        jp	1a8h

