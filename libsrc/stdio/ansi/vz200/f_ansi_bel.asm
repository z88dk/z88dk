;
; 	ANSI Video handling for the VZ200
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2015-01-19 01:33:19 pauloscustodio Exp $
;

	PUBLIC	ansi_BEL


.ansi_BEL
	call 13392
        ret

