;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;
;
;       Clear the graph. screen
;
;
;	$Id: clg.asm,v 1.2 2003-05-21 12:53:22 stefano Exp $
;


	XLIB    clg
	XREF	base_graphics

	LIB     swapgfxbk
	XREF	swapgfxbk1

.ansi_cls

	call	swapgfxbk

	ld      hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
	ld      bc,2400-1
	ldir

	jp	swapgfxbk1
