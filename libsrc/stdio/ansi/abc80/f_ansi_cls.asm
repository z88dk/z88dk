;
; 	ANSI Video handling for the ABC80
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - May 2000
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2007-10-31 14:01:47 stefano Exp $
;

	XLIB	ansi_cls

.ansi_cls
	jp	$276
