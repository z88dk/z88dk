;
;       OSCA C Library
;
; 	ANSI Video handling
;
;	Scrollup
;
;	Stefano Bodrato - June 2012
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_SCROLLUP
    INCLUDE "flos.def"

.ansi_SCROLLUP
	jp kjt_scroll_up
