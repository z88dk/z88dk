;
; 	ANSI Video handling for the Sharp MZ
;	By Stefano Bodrato - 5/5/2000
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

	SECTION code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
	jp	$3E	; Beep !
