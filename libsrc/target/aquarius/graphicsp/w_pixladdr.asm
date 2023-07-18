
	SECTION	  code_graphics 

	PUBLIC	w_pixeladdress
        EXTERN  __aquarius_video_base
  


; Entry  hl = x
;        de = y
; Exit: hl = de = address	
;	 a = pixel number
;        c = x character
;        b = y character
; Uses: a, bc, de, hl
.w_pixeladdress
	; Reduce x down to the byte number
	ld	a,l		;Save lower of number
	srl	h		;Max 320 -> 160
	rr	l
	srl	l		;Max 160 -> 80
	srl	l		;Max 80 -> 40
	; l = byte offset in row
	ld	c,l

        ld      b,e
        srl     b
        srl     b
        srl     b

	ex	de,hl		;hl = y, we need to multiple by 40
	add	hl,hl		;y * 2
	add	hl,hl		;y * 4
	add	hl,hl		;y * 8
        ld      de,hl
	add	hl,hl		;y * 16
	add	hl,hl		;y * 32
	add	hl,de		;y * 40
	ld	e,c
	ld	d,0
	add	hl,de		;Now point to byte
	ld	de,(__aquarius_video_base)
	add	hl,de
	and	0x07
	xor	0x07
	ld	d,h
	ld	e,l
	ret

