;
; 	ANSI Video handling for the PC6001
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Jan 2013
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;

	PUBLIC	ansi_BEL


.ansi_BEL
		ld	a,7
        jp	$26c7

