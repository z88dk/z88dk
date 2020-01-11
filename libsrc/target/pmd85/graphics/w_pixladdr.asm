
	SECTION	  code_driver 

	PUBLIC	w_pixeladdress
	EXTERN	l_div


; Entry  hl = x
;        de = y
; Exit: hl = de = address	
;	 a = pixel number
; Uses: a, bc, de, hl
.w_pixeladdress
	; Display is 288 pixels wide, 256 pixels high
	push	de
	ld	de,-6
	ld	c,255	;Number of cells
divloop:
	inc	c
	add	hl,de
	ld	a,h
	cp	255
	jp	nz,divloop
	ld	a,l
	add	6
	ld	b,a	;Pixel position
	pop	hl	;Get y position back, we need to *64
	add	hl,hl	;*2
	add	hl,hl	;*4
	add	hl,hl	;*8
	add	hl,hl	;*16
	add	hl,hl	;*32
	add	hl,hl	;*64
	ld	e,c
	ld	d,$c0
	add	hl,de	;hl = screen address
	ld	d,h
	ld	e,l
	ld	a,b	;Pixel number
	and	a
	ret

