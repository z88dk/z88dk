
	SECTION	  code_clib 

	PUBLIC	w_pixeladdress
        EXTERN  __gfx_fatpix


; Entry  hl = x
;        de = y
; Exit: hl = de = address	
;	 a = pixel number
; Uses: a, bc, de, hl
.w_pixeladdress
        ld      a,(__gfx_fatpix)
        and     a
        jr      z,not_fatpix	;We could just jump into the rotation properly
        add     hl,hl
not_fatpix:
	; Reduce x down to the byte number
	ld	a,l		;Save lower of number
	srl	h		;Max 640
	rr	l
	srl	h		;Max 320
	rr	l
	srl	l		;Max 160 -> 80
	; l = byte offset in row
	ld	c,l

	ex	de,hl		;hl = y, we need to multiple by 80
	add	hl,hl		;y * 2
	add	hl,hl		;y * 4
	add	hl,hl		;y * 8
	add	hl,hl		;y * 16
	ld	d,h
	ld	e,l
	add	hl,hl		;y * 32
	add	hl,hl		;y * 64
	add	hl,de		;y * 80
	ld	e,c
	ld	d,0
	add	hl,de		;Now point to byte
	ld	de,0xC000	;DISPLAY
	add	hl,de
	;ld	a,b
	and	0x07
	xor	0x07
	ld	d,h
	ld	e,l
	ret

