;
; 	ANSI Video handling for the NASCOM1/2
;
; 	BEL - chr(7)   Beep it out
;
;	Stefano Bodrato - May 2003
;
;	No sound on nascom (?).  We'll look for some trick..
;	What about making buzz the tape relais ?
;
;	$Id: f_ansi_bel.asm,v 1.1 2003-06-30 15:58:53 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
	ret

