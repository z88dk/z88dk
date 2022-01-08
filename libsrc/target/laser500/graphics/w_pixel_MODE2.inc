
	EXTERN w_pixeladdress

	EXTERN	getmaxy
	EXTERN	getmaxx
	EXTERN	l_cmp
	EXTERN	__laser500_attr
	EXTERN	__gfx_coords

	INCLUDE	"target/laser500/def/laser500.def"


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
	ld	a,(SYSVAR_bank1)
	ld	d,a		;Save the old bank value
	ld	a,7
        ld      (SYSVAR_bank1),a
	out	($41),a
IF NEEDplot
	ld	a,e
	or	(hl)
	ld	(hl),a
	inc	hl
	ld	a,(__laser500_attr)
	ld	(hl),a
ENDIF
IF NEEDunplot
	ld	a,e
	and	(hl)
	ld	(hl),a
ENDIF
IF NEEDxor
	ld	a,e
	xor	(hl)
	ld	(hl),a
	inc	hl
ENDIF
IF NEEDpoint
	ld	a,(hl)
	and	e		;Bit to check
ENDIF
	ld	a,d
	ld	(SYSVAR_bank1),a
	out	($41),a
	pop	bc		;Restore callers
	ret
