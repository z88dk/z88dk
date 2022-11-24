;
; 	ANSI Video handling for the Alphatronic
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - 2022
;
;
;	$Id: f_ansi_bel.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_BEL
	EXTERN	generic_console_printc

; A fine double frequency beep for BEL

.ansi_BEL
	ld		a,7
	jp	generic_console_printc

