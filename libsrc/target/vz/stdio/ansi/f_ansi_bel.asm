;
; 	ANSI Video handling for the VZ200
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: f_ansi_bel.asm,v 1.4 2016-06-10 23:56:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
	call 13392
        ret

