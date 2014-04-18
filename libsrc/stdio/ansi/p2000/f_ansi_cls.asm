;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
; 	CLS - Clear the screen
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2014-04-18 07:38:59 stefano Exp $
;

	XLIB	ansi_cls

.ansi_cls
	ld		a,12
	jp  $60C0
