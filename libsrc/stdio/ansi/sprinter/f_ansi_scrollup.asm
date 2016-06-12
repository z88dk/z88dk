;
;       Sprinter C Library
;
; 	ANSI Video handling for Sprinter
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
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
 
