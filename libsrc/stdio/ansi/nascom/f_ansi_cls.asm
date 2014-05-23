;
; 	ANSI Video handling for the NASCOM1/2
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Jul 2004
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2014-05-23 10:37:17 stefano Exp $
;

	XLIB	ansi_cls
	LIB		cleargraphics

.ansi_cls
	jp cleargraphics

