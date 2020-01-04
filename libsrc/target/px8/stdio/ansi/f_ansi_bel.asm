;
; 	ANSI Video handling for the Epson PX8
;	By Stefano Bodrato - 2019
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm $
;

        SECTION code_clib
	PUBLIC	ansi_BEL
	
	EXTERN	px8_conout


.ansi_BEL
		ld c,7	; BEL
		jp px8_conout

