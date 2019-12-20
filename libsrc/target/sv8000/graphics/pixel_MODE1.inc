
	EXTERN pixeladdress
	EXTERN __gfx_coords

	INCLUDE	"graphics/grafix.inc"

; Generic code to handle the pixel commands
; Define NEEDxxx before including

	ld	a,l
	cp	192
	ret	nc
	ld	(__gfx_coords),hl

	push	bc	;Save callers value
	call	pixeladdress		;hl = address, a = pixel number
	ld	b,a
	ld	a,1
	jr	z, rotated 	; pixel is at bit 0...
.plot_position	
	rlca
	djnz	plot_position
	; a = byte holding pixel mask
	; hl = address
rotated:
	ld	c,(hl)
IF NEEDplot
	or	c
	ld	(hl),a
ENDIF
IF NEEDunplot
	cpl
	and	c
	ld	(hl),a
ENDIF
IF NEEDxor
	xor	c
	ld	(hl),c
ENDIF
IF NEEDpoint
	and	c
ENDIF
	pop	bc		;Restore callers
	ret
