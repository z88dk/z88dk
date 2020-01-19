	

                SECTION         code_graphics
	PUBLIC	xorclrarea
	EXTERN	xorpixel

;
;	$Id: xorclrarea.asm $
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

.xorclrarea

		push	hl
		push	bc
.rowloop
		push	hl
		push	de
		push	bc
		call	xorpixel
		pop	bc
		pop	de
		pop	hl
		
		inc	h
		djnz	rowloop
		pop	bc
		pop	hl
		inc	l
		dec	c
		jr	nz,xorclrarea
		ret
