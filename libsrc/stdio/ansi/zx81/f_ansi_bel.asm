;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	ansi_BEL


.ansi_BEL
	;No sound support on the ZX81
        ret

