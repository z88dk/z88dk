;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
; 	BEL - chr(7)   Beep it out
;
;	$Id: f_ansi_bel.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;

	PUBLIC	ansi_BEL


.ansi_BEL
	ld		a,7
	jp  $60C0

