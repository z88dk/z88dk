;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
; 	BEL - chr(7)   Beep it out
;
;	$Id: f_ansi_bel.asm,v 1.1 2014-04-18 07:38:59 stefano Exp $
;

	XLIB	ansi_BEL


.ansi_BEL
	ld		a,7
	jp  $60C0

