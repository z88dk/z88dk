;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_clg.asm,v 1.2 2001-04-18 13:21:38 stefano Exp $
;


;Usage: g_clg(GrayLevel)

		INCLUDE "graphics/grafix.inc"    /* Contains fn defs */

		XLIB    g_clg

		XREF	graybit1
		XREF	graybit2

.g_clg
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel

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
		ld	bc,row_bytes*64
		ldir

		ret
