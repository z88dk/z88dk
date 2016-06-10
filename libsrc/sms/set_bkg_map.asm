	SECTION code_clib	
	PUBLIC	set_bkg_map
	PUBLIC	_set_bkg_map

	INCLUDE "sms/sms.hdr"
	
	EXTERN	DrawOneLine
	
;==============================================================
; void set_bkg_map(unsigned int *data, int x, int y, int w, int h)
;==============================================================
; Sets the attributes of a rectangular region of SMS's bkg map
; ** no validations are made **
;==============================================================
.set_bkg_map
._set_bkg_map
	ld	hl, 2
	add	hl, sp
	ld	b, (hl)		; Height
	inc	hl
	inc	hl
	ld	c, (hl)		; Width
	inc	hl
	inc	hl
	ld	d, (hl)		; Y
	inc	hl
	inc	hl
	ld	e, (hl)		; X
	inc	hl
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a		; Data address
	
	; Computes bkg map VRAM starting address
	push	hl	
	ld	l, d
	ld	h, 0
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl		; HL = Y*32
	ld	d, 0
	add	hl, de		; HL = (Y*32) + X
	add	hl, hl		; HL = ((Y*32) + X) * 2
	ld	de, NameTableAddress
	add	hl, de
	ld	d, h
	ld	e, l
	pop	hl
	
.lineloop
	push	bc
	call	DrawOneLine
	pop	bc

	; Calculates next VRAM addr
	ld	a, e
	add	64
	jp	nc, notcarry
	inc	d	
.notcarry
	ld	e, a

	dec	b
	jp	nz, lineloop	; Loop until all lines are drawn
	
	ret
