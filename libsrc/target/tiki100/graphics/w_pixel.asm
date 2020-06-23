

	EXTERN		w_pixeladdress

	EXTERN		getmaxy
	EXTERN		getmaxx
	EXTERN		l_graphics_cmp
	EXTERN		swapgfxbk
	EXTERN		swapgfxbk1
	EXTERN		generic_console_get_mode
	EXTERN		__gfx_coords

	EXTERN		__MODE2_attr
	EXTERN		__MODE3_attr


; Generic code to handle the pixel commands
; Define NEEDxxx before including

	push	hl				;save x
	call	getmaxy				;hl = maxy
	inc	hl
	call	l_graphics_cmp
	pop	hl
	ret	nc

	ex	de,hl				;de = x, hl = y
	push	hl				;save y
	call	getmaxx
	inc	hl
	call	l_graphics_cmp
	pop	hl
	ret	nc
	ex	de,hl

	ld	(__gfx_coords),hl
	ld	(__gfx_coords+2),de
	
	push	bc
	call	generic_console_get_mode
	ld	b,@00000001
	ld	c,@11111110
	cp	1
	jr	z,calc_address
	add	hl,hl
	ld	bc,(__MODE2_attr-1)
	ld	c,@11111100
	cp	2
	jr	z,calc_address
	add	hl,hl
	ld	bc,(__MODE3_attr-1)
	ld	c,@11110000
calc_address:
	call	w_pixeladdress			;leaves bc
	ld	d,b				;ink
	ld	b,a
	jr	z,rotated			; pixel is at bit 0...
.plot_position
	rlc	c				; pixel mask
	sla	d				; ink colour
	djnz	plot_position
rotated:
; c = byte holding pixel mask
; d = ink to use 
; hl = address
call	swapgfxbk
IF NEEDplot
	ld	a,(hl)
	and	c
	or	d
	ld	(hl),a
ENDIF
IF NEEDunplot
	ld	a,(hl)
	and	c
	ld	(hl),a
ENDIF
IF NEEDxor
	ld	a,c
	cpl
	and	(hl)
	jr	z,do_xor_plot
	; We need to reset
	ld	d,0
do_xor_plot:
	ld	a,(hl)
	and	c
	or	d
	ld	(hl),a
ENDIF
IF NEEDpoint
	ld	a,c
	cpl
	and	(hl)
ENDIF
	call	swapgfxbk1
	pop	bc				;Restore callers
	ret
