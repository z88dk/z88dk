
	EXTERN w_pixeladdress

	EXTERN	getmaxy
	EXTERN	getmaxx
	EXTERN	l_cmp
	EXTERN	__gfx_coords
	EXTERN	__vector06c_ink
	EXTERN	__vector06c_paper

; Generic code to handle the pixel commands
; Define NEEDxxx before including

	push	hl		;save x
	call	getmaxy		;hl = maxy
	inc	hl
	call	l_cmp
	pop	hl
	ret	nc

	ex	de,hl		;de = x, hl = y
	push	hl		;save y
	call	getmaxx
	inc	hl
	call	l_cmp
	pop	hl
	ret	nc
	ld	(__gfx_coords+2),hl	;y
	ex	de,hl
	ld	(__gfx_coords),hl	;x
	push	bc
	call	w_pixeladdress
	ld	b,a
	ld	a,1
	jr	z, rotated 	; pixel is at bit 0...
.plot_position	
	rlca
	djnz	plot_position
	; a = byte holding pixel mask
	; hl = address
rotated:
IF NEEDpoint
	pop	bc	;callers
	ld	e,a
	ld	a,(hl)
	and	e
	ret	z
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,(hl)
	and	e
	ret	z
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,(hl)
	and	e
	ret	z
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,(hl)
	and	e
	ret
ENDIF
	ld	c,a		;bit we want to set
	cpl
	ld	b,a		;mask to get rid of
IF NEEDplot | NEEDxor
	ld	a,(__vector06c_ink)
ELIF NEEDunplot
	ld	a,(__vector06c_paper)
ENDIF
	rrca
	ld	e,a	;save it
	sbc	a	;0/255
	and	c
	ld	d,a
	ld	a,(hl)
IF NEEDxor
	xor	d
ELSE
	and	b
	or	d
ENDIF
	ld	(hl),a

	;Plane 1
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,e
	rrca
	ld	e,a	;save it
	sbc	a	;0/255
	and	c
	ld	d,a
	ld	a,(hl)
IF NEEDxor
	xor	d
ELSE
	and	b
	or	d
ENDIF
	ld	(hl),a

	;Plane 2
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,e
	rrca
	ld	e,a	;save it
	sbc	a	;0/255
	and	c
	ld	d,a
	ld	a,(hl)
IF NEEDxor
	xor	d
ELSE
	and	b
	or	d
ENDIF
	ld	(hl),a

	;Plane 3
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,e
	rrca
	ld	e,a	;save it
	sbc	a	;0/255
	and	c
	ld	d,a
	ld	a,(hl)
IF NEEDxor
	xor	d
ELSE
	and	b
	or	d
ENDIF
	ld	(hl),a
	pop	bc		;Restore callers
	ret
