;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;
;
;       Clear the graph. screen
;
;
;	$Id: clg.asm,v 1.3 2003-05-21 13:52:35 stefano Exp $
;


	XLIB    clg
	XREF	base_graphics

	LIB     swapgfxbk
	XREF	swapgfxbk1

.clg

	call	swapgfxbk

	ld      hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
	ld      bc,2400-1
	xor	a
	ld	(hl),a
	ldir

	jp	swapgfxbk1
