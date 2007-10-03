;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Sept 2007
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.3 2007-10-03 15:11:39 stefano Exp $
;

	XLIB	ansi_cls
	LIB	_clg_hr		; we use the graphics CLS routine

.ansi_cls
	jp	_clg_hr
