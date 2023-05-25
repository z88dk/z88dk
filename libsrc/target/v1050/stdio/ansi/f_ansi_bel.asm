;
; 	ANSI Video handling for the Visual 1050
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - 2023
;
;
;	$Id: f_ansi_bel.asm $
;

        SECTION  code_clib

        PUBLIC	 ansi_BEL
        EXTERN   v1050_sendchar


.ansi_BEL
		ld l,7
		jp v1050_sendchar

