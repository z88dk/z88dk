;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
; 	BEL - chr(7)   Beep it out
;
;	$Id: f_ansi_bel.asm,v 1.4 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
        ret	; Do nothing

