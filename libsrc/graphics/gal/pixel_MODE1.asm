
	EXTERN pixeladdress
	EXTERN __gfx_coords

        INCLUDE "graphics/grafix.inc"

; Generic code to handle the pixel commands
; Define NEEDxxx before including

	ld	a,l
	cp	208
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
IF NEEDunplot
	or	(hl)
	ld	(hl),a
ENDIF
IF NEEDplot
	cpl
	and	(hl)
	ld	(hl),a
ENDIF
IF NEEDxor
	ld	c,a
	ld	a,(hl)
	cpl
	xor	c
	cpl
	ld	(hl),a
ENDIF
IF NEEDpoint
	ld	c,a
	ld	a,(hl)
	cpl
	and	c
ENDIF
	pop	bc		;Restore callers
	ret
