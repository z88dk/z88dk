
	XLIB	cleargraphics

	XREF	base_graphics

;
;	$Id: clsgraph.asm,v 1.1 2001-05-07 16:02:04 stefano Exp $
;

; ******************************************************************
;
; Clear graphics area
;
; Jupiter ACE version.  
; Emulated 96x64 resolution (TI82/TI83) with 64x48 dots.
;
; (x=x*2/3;  y=y*3/4)
;
;
.cleargraphics
			push	bc
			push	de
			push	hl
			ld	hl,$2400
			ld	(hl),32 ;' '
			ld	d,h
			ld	e,l
			inc	de
			ld	bc,32*24
			ldir
			pop	hl
			pop	de
			pop	bc
			ret
