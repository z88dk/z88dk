	XLIB	xorborder
	LIB	xorpixel
        LIB     swapgfxbk
	XREF	swapgfxbk1

;
;	$Id: xorborder.asm,v 1.1 2002-03-28 09:41:14 stefano Exp $
;

; ***********************************************************************
;
; XORs a dotted box.  Useful for GUIs.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;

.xorborder
		call	swapgfxbk
		
		ld	ix,0
		add	ix,sp
		ld	b,(ix+2)
		ld	c,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)

		push	bc
		push	hl

; -- Vertical lines --
		push	hl
		ld	a,h
		add	a,b
		ret	c	; overflow ?
		ld	h,a
		pop	de
.rowloop
		push	bc
		
		inc	l
		ex	de,hl
		push	hl
		push	de
		call	xorpixel
		pop	de
		pop	hl
		inc	l

		pop	bc
		dec	c
		jr	nz,rowloop

		pop	hl
		pop	bc

; -- Horizontal lines --
		push	hl
		ld	a,l
		add	a,c
		ret	c	; overflow ?
		ld	l,a
		pop	de

.vrowloop
		push	bc
		
		push	hl
		push	de
		call	xorpixel
		pop	de
		pop	hl
		inc	h
		ex	de,hl
		inc	h
		
		pop	bc
		
		djnz	vrowloop
		
		jp	swapgfxbk1
