;
; 	ANSI Video handling for the CCE MC-1000
;	By Stefano Bodrato - March 2013
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2015-01-19 01:33:18 pauloscustodio Exp $
;

	PUBLIC	ansi_BEL


.ansi_BEL
        jp	$C060

