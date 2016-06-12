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
;	$Id: f_ansi_cls.asm,v 1.3 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls
    INCLUDE "flos.def"

.ansi_cls
	jp kjt_clear_screen
