;
;       OSCA C Library
;
; 	ANSI Video handling
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - June 2012
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2012-05-31 14:52:59 stefano Exp $
;

	XLIB	ansi_cls
    INCLUDE "flos.def"

.ansi_cls
	jp kjt_clear_screen
