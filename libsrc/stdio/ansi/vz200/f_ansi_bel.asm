;
; 	ANSI Video handling for the VZ200
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
	call 13392
        ret

