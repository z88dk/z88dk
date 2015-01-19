;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;
;
;       Clear the graph. screen
;
;
;	$Id: clg.asm,v 1.4 2015-01-19 01:32:49 pauloscustodio Exp $
;


	PUBLIC    clg
	EXTERN	base_graphics

	EXTERN     swapgfxbk
	EXTERN	swapgfxbk1

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
