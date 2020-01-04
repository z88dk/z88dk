;
; 	ANSI Video handling for the Mattel Aquarius
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Dec. 2000
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
	ld	a,7
	jp	$1d94


