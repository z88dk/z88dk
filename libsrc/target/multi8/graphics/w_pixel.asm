
	EXTERN w_pixeladdress

	EXTERN	getmaxy
	EXTERN	getmaxx
	EXTERN	l_cmp
	EXTERN	__gfx_coords

	EXTERN	__vram_in
	EXTERN	__vram_out

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
	ex	de,hl
	ld	(__gfx_coords),hl	;x
	ld	(__gfx_coords+2),de	;y
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
IF NEEDunplot
	cpl
ENDIF
	ld	e,a		;Save the pixel mask
	ld	a,(__vram_in)
	ld	b,a
IF NEEDplot
	; We need to flip in the planes we want and set the bit we want
	or	@00000110
	out	($2a),a
	ld	a,e
	or	(hl)
	ld	(hl),a
	ld	a,b
	or	@00000101
	out	($2a),a
	ld	a,e
	or	(hl)
	ld	(hl),a
	ld	a,b
	or	@00000011
	out	($2a),a
	ld	a,e
	or	(hl)
	ld	(hl),a
ENDIF
IF NEEDunplot
	or	@00000110
	out	($2a),a
	ld	a,e
	and	(hl)
	ld	(hl),a
	ld	a,b
	or	@00000101
	out	($2a),a
	ld	a,e
	and	(hl)
	ld	(hl),a
	ld	a,b
	or	@00000011
	out	($2a),a
	ld	a,e
	and	(hl)
	ld	(hl),a
ENDIF
IF NEEDxor
	or	@00000110
	out	($2a),a
	ld	a,e
	xor	(hl)
	ld	(hl),a
	ld	a,b
	or	@00000101
	out	($2a),a
	ld	a,e
	xor	(hl)
	ld	(hl),a
	ld	a,b
	or	@00000011
	out	($2a),a
	ld	a,e
	xor	(hl)
	ld	(hl),a
ENDIF
IF NEEDpoint
	or	@00000110
	out	($2a),a
	ld	d,(hl)
	ld	a,b
	or	@00000101
	out	($2a),a
	ld	a,(hl)
	or	d
	ld	d,a
	ld	a,b
	or	@00000011
	out	($2a),a
	ld	a,(hl)
	or	d
	and	e		;Bit to check
ENDIF
	ld	a,(__vram_out)
	out	($2a),a
	pop	bc		;Restore callers
	ret
