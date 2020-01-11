
	EXTERN w_pixeladdress

	EXTERN	getmaxy
	EXTERN	getmaxx
	EXTERN	l_cmp
	EXTERN	__gfx_coords
	EXTERN	__set_graphics_colour

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
IF NEEDunplot
	cpl
ENDIF
	ld	e,a		;Save the pixel mask
IF NEEDplot
	ld	a,(hl)
	or	e
	ld	(hl),a
	call	__set_graphics_colour
ENDIF
IF NEEDunplot
	ld	a,(hl)
	and	e
	ld	(hl),a
ENDIF
IF NEEDxor
	ld	a,(hl)
	xor	e
	ld	(hl),a
	call	__set_graphics_colour
ENDIF
IF NEEDpoint
	ld	a,(hl)
	and	e
ENDIF
	pop	bc		;Restore callers
	ret
