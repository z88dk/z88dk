
	EXTERN w_pixeladdress

	EXTERN	getmaxy
	EXTERN	getmaxx
	EXTERN	l_cmp
	EXTERN	__gfx_coords
	EXTERN	__pc88_lores_pixel_map
	EXTERN	generic_console_plotc
	EXTERN	generic_console_vpeek

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
	push	bc			;Save callers

	; Reduce down
	ld	h,l	;x
	ld	l,e	;y
	ld	c,h	;x
	srl	c	;/2
	ld	b,e	;y
	srl	b	;/4
	srl	b


	push	bc	;Save coords
	push	hl	;Save original coordinates
	call	generic_console_vpeek	;-> a = graphics character
	pop	bc	;c=orig y b=orig x (160x100)

	ld	d,a			;Save what's at the location
	ld	a,b
	and	1
	add	a
	add	a
	ld	e,a
	ld	a,c
	and	3
	or	e
	ld	c,a
	ld	b,0
	ld	hl,__pc88_lores_pixel_map
	add	hl,bc
	ld	a,(hl)
IF NEEDplot
	or	d
	ld	d,a
	pop	bc
	call	generic_console_plotc
ENDIF
IF NEEDunplot
	cpl
	and	d
	ld	d,a
	pop	bc
	call	generic_console_plotc
ENDIF
IF NEEDxor
	xor	d
	ld	d,a
	pop	bc
	call	generic_console_plotc
ENDIF
IF NEEDpoint
	and	d
	pop	bc
ENDIF
	pop	bc	;restore callers
	ret
