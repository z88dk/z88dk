	xlib	cleararea
	lib	respixel

;
;	$Id: clrarea.asm,v 1.3 2002-03-28 09:41:14 stefano Exp $
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

.cleararea

		push	hl
		push	bc
.rowloop
		push	hl
		push	de
		push	bc
		call	respixel
		pop	bc
		pop	de
		pop	hl
		
		inc	h
		djnz	rowloop
		pop	bc
		pop	hl
		inc	l
		dec	c
		jr	nz,cleararea
		ret
