;
;       OSCA C Library
;
; 	ANSI Video handling
;
;	Scrollup
;
;	Stefano Bodrato - June 2012
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2012-05-31 14:52:59 stefano Exp $
;

	XLIB	ansi_SCROLLUP
    INCLUDE "flos.def"

.ansi_SCROLLUP
	jp kjt_scroll_up
