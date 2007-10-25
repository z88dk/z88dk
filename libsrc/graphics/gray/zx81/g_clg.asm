;
;       ZX 81 pseudo-Gray Library Functions
;
;       Written by Stefano Bodrato - Oct 2007
;
;	$Id: g_clg.asm,v 1.1 2007-10-25 14:53:04 stefano Exp $
;
;


;Usage: g_clg(GrayLevel)


		XLIB    g_clg
		XREF	base_graphics

		XREF	graybit1
		XREF	graybit2

.g_clg
		pop	hl
		pop	bc
		ld	a,c	;GrayLevel
		push	bc
		push	hl

	  	ld	hl,(graybit1)
		rra
		jr	nc,lbl1
		push	af
		ld	a,0
		call	cls
		pop	af
		jr	lbl2
.lbl1
		push	af
		ld	a,255
		call	cls
		pop	af
.lbl2

	  	ld	hl,(graybit2)
		rra
		ld	a,0
		jr	c,lbl3
		ld	a,255
.lbl3

.cls
		ld	(hl),a
		ld	d,h
		ld	e,l
		inc	de
		ld	bc,2047
		ldir

		ret
