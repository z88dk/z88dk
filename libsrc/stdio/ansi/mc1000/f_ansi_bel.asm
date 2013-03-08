;
; 	ANSI Video handling for the CCE MC-1000
;	By Stefano Bodrato - March 2013
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.1 2013-03-08 13:40:20 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
        jp	$C060

