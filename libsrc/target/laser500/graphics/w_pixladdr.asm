
	SECTION	  code_driver 

	PUBLIC	w_pixeladdress
	EXTERN	generic_console_xypos


; Entry  hl = x
;        de = y
; Exit: hl = address	
;	 a = pixel number
; Uses: a, bc, de, hl
.w_pixeladdress
	push	hl
	push	de
	srl	h		;divide x by 8
	rr	l
	srl	l
	srl	l
	ld	c,l		;x/8
	srl	e		;divide y by 8
	srl	e
	srl	e
	ld	b,e		;y/8
	call	generic_console_xypos
	add	hl,bc			;bc = at top of character
	pop	bc			;get y back
	ld	a,c
pixel_row_loop:
	and	7
	jr	z,pixel_row_done
	ld	de,$800
	add	hl,de
	dec	a
	jr	pixel_row_loop
pixel_row_done:
	pop	bc		; get x back
	ld	a,c		; x position
	and	7
	ret
