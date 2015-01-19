;
;       OSCA C Library
;
; 	ANSI Video handling
;
;	Scrollup
;
;	Stefano Bodrato - June 2012
;
;	$Id: f_ansi_scrollup.asm,v 1.2 2015-01-19 01:33:18 pauloscustodio Exp $
;

	PUBLIC	ansi_SCROLLUP
    INCLUDE "flos.def"

.ansi_SCROLLUP
	jp kjt_scroll_up
