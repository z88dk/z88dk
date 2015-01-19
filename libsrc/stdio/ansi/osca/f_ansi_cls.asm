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
;	$Id: f_ansi_cls.asm,v 1.2 2015-01-19 01:33:18 pauloscustodio Exp $
;

	PUBLIC	ansi_cls
    INCLUDE "flos.def"

.ansi_cls
	jp kjt_clear_screen
