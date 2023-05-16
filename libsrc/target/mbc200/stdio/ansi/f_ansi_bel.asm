;
; 	ANSI Video handling for the Sanyo computers
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
        EXTERN    mbc_sendchar


.ansi_BEL
		ld l,7
		jp mbc_sendchar

