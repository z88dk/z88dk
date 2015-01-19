;
; 	ANSI Video handling for the ABC80
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.4 2015-01-19 01:33:17 pauloscustodio Exp $
;

	PUBLIC	ansi_BEL


.ansi_BEL
	; Put here the BEEP code
	ld	a,7
        jp	1a8h

