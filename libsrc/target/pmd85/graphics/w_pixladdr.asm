
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
	; If we divide by 24
	ld	de,-24
	ld	c,255	;Number of cells
divloop:
	inc	c
	add	hl,de
	ld	a,h
	cp	255
	jp	nz,divloop
	ld	a,l
	add	24
	; a = pixel position
	ld	e,a
	ld	d,0
	ld	hl,lookup_table
	add	hl,de
	add	hl,de
	ld	a,c		;24 pixels = 4 chars, so *4
	add	a
	add	a
	add	(hl)		;Byte offset
	ld	c,a
	inc	hl
	ld	b,(hl)		;pixel position
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


	SECTION	rodata_clib

lookup_table:
	defb	0,0
	defb	0,1
	defb	0,2
	defb	0,3
	defb	0,4
	defb	0,5
	defb	1,0
	defb	1,1
	defb	1,2
	defb	1,3
	defb	1,4
	defb	1,5
	defb	2,0
	defb	2,1
	defb	2,2
	defb	2,3
	defb	2,4
	defb	2,5
	defb	3,0
	defb	3,1
	defb	3,2
	defb	3,3
	defb	3,4
	defb	3,5
