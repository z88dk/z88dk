;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_SCROLLUP


.ansi_SCROLLUP
	 ld     a,(23693)
	 ld     (23624),a
	 call 3582 ;scrollup
	 ret
 