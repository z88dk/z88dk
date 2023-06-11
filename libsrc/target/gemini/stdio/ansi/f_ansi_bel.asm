;
; 	ANSI Video handling for the Gemini Galaxy
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

        PUBLIC	 ansi_BEL
        EXTERN   putvid_a


.ansi_BEL
        ld a,7
        jp putvid_a

