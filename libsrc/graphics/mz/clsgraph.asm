
	XLIB	cleargraphics

	XREF	base_graphics

;
;	$Id: clsgraph.asm,v 1.1 2002-01-17 17:09:21 stefano Exp $
;

; ******************************************************************
;
; Clear graphics area
;
; Sharp MZ version.  
; 80x50 rez.
;
.cleargraphics

	ld	hl,$D000
	ld	(hl),0 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,40*25
	ldir

	ld	hl,$D800
	ld	(hl),$70
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,40*25
	ldir

	ret
