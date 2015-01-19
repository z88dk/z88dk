;
; 	ANSI Video handling for the Mattel Aquarius
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Dec. 2000
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2015-01-19 01:33:18 pauloscustodio Exp $
;

	PUBLIC	ansi_BEL


.ansi_BEL
	ld	a,7
	jp	$1d94


