;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
	;No sound support on the ZX81
        ret

