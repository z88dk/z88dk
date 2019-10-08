
	EXTERN pixeladdress
	EXTERN __gfx_coords

	INCLUDE	"graphics/grafix.inc"

	EXTERN	__MODE2_attr

; Generic code to handle the pixel commands
; Define NEEDxxx before including

	ld	a,h
	cp	128
	ret	nc
	ld	a,l
	cp	192
	ret	nc
	ld	(__gfx_coords),hl
	push	bc	;Save callers value
	call	pixeladdress		;hl = address, a = pixel number
	ld	b,h
	ld	c,l
	ld	h,a
	ld	a,(__MODE2_attr)
	rlca
	rlca
	ld	e,a
	ld	a,@00000011
	jr	z, rotated 	; pixel is at bit 0...
.plot_position	
	rlca
	rlca
	rlc	e
	rlc	e
	dec	h
	jr	nz,plot_position
rotated:
	ld	h,a		;the pixel mask
	cpl
	ld	l,a		;the excluded mask
	; e = byte holding pixels to plot
	; h = byte holding pixel mask
	; l = byte holding mask exlcuding this pixel
	; bc = address
	in	a,(c)
IF NEEDplot
	and	l
	or	e
	out	(c),a
ENDIF
IF NEEDunplot
	and	l
	out	(c),a
ENDIF
IF NEEDxor
	xor	e
	out	(c),a
ENDIF
IF NEEDpoint
	and	h
ENDIF
	pop	bc		;Restore callers
	ret
