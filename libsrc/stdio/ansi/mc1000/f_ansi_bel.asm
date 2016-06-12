;
; 	ANSI Video handling for the CCE MC-1000
;	By Stefano Bodrato - March 2013
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
        jp	$C060

