;
; 	ANSI Video handling for the Jupiter ACE
;
;	Stefano Bodrato - Feb. 2001
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2001-10-18 15:22:46 stefano Exp $
;

	XLIB	ansi_SCROLLUP


.ansi_SCROLLUP
	ld	hl,$2420
	ld	de,$2400
	ld	bc,736
	ldir
	ld	hl,$2400+736
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	ret
