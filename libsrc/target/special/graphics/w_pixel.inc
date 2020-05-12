
	EXTERN w_pixeladdress

	EXTERN	getmaxy
	EXTERN	getmaxx
	EXTERN	l_cmp
	EXTERN	__gfx_coords
	EXTERN	__special_attr

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
	ld	c,a
	ld	a,(hl)
	and	c
ENDIF
IF NEEDunplot
	cpl
	ld	c,a		;mask to get rid of
	ld	a,(hl)
	and	c
	ld	(hl),a
ENDIF
IF NEEDplot | NEEDxor
	ld	c,a		;bit we want to set
	ld	a,(__special_attr)
	ld	($ff02),a
	ld	a,(hl)
  IF NEEDxor
	xor	c
  ELSE
	or	c
  ENDIF
	ld	(hl),a
ENDIF
	pop	bc		;Restore callers
	ret
