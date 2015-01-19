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
;	$Id: f_ansi_scrollup.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;

	PUBLIC	ansi_SCROLLUP


.ansi_SCROLLUP
	ld	de,0		;top xy
	ld	h,32
	ld	l,80
	ld	b,1
	xor	a		;clear line
	ld	c,$55		;SCROLL
	rst	$10
	ret
 
