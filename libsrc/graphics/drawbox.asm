	xlib	drawbox
	lib	plotpixel

;
;	$Id: drawbox.asm,v 1.4 2002-03-28 11:08:49 stefano Exp $
;

; ***********************************************************************
;
; Clear specified graphics area in map.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;

.drawbox

		push	bc
		push	hl

; -- Vertical lines --
		push	hl
		ld	a,h
		add	a,b
		ret	c	; overflow ?
		dec	a
		ld	h,a
		pop	de
.rowloop
		push	bc
		
		push	hl
		push	de
		ld	de, p_RET1
		push	de
		jp	(ix)	;	execute PLOT at (h,l)
.p_RET1
		pop	de
		pop	hl
		inc	l
		ex	de,hl

		push	hl
		push	de
		ld	de, p_RET2
		push	de
		jp	(ix)	;	execute PLOT at (h,l)
.p_RET2
		pop	de
		pop	hl
		inc	l
		ex	de,hl

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
		dec	a
		ld	l,a
		pop	de

.vrowloop
		push	bc
		
		push	hl
		push	de
		ld	de, p_RET3
		push	de
		jp	(ix)	;	execute PLOT at (h,l)
.p_RET3
		pop	de
		pop	hl
		inc	h
		ex	de,hl
		
		push	hl
		push	de
		ld	de, p_RET4
		push	de
		jp	(ix)	;	execute PLOT at (h,l)
.p_RET4
		pop	de
		pop	hl
		inc	h
		ex	de,hl
		
		pop	bc
		
		djnz	vrowloop

		ret
