;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;

	XLIB	ansi_SCROLLUP


.ansi_SCROLLUP
	 ld     a,(23693)
	 ld     (23624),a
	 call 3582 ;scrollup
	 ret
 