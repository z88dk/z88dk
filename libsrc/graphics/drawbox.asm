	
	SECTION         code_graphics
				
	PUBLIC	drawbox

;
;	$Id: drawbox.asm $
;

; ***********************************************************************
;
; Draw a box.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;

.drawbox
		ld	a,2
		cp b
		ret nc
		cp c
		ret nc
		
		push	bc
		push	hl

; -- Vertical lines --
		push	hl
		ld	a,h
		add	a,b
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
		inc	h
		dec b
		dec b
		push	hl
		ld	a,l
		add	a,c
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
