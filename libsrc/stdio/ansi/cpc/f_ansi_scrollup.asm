;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2004-07-15 10:03:49 stefano Exp $
;

	XLIB	ansi_SCROLLUP

	XREF	text_rows


.ansi_SCROLLUP
	ld	a,50
	call	$BB72
	ld	a,10
	jp	$BB5A
 
 