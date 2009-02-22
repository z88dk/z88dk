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
;	$Id: f_ansi_scrollup.asm,v 1.3 2009-02-22 08:33:25 stefano Exp $
;

	XLIB	ansi_SCROLLUP

	XREF  call_rom3


.ansi_SCROLLUP
	 ld     a,(23693)
	 ld     (23624),a
	 call    call_rom3
	 defw	3582	;scrollup
	 ret
 