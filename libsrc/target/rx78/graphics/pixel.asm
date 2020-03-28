	INCLUDE	"graphics/grafix.inc"
	EXTERN pixeladdress
	EXTERN __gfx_coords

; Generic code to handle the pixel commands
; Define NEEDxxx before including

IF maxx <> 256
	ld	a,h
	cp	maxx
	ret	nc
ENDIF
	ld	a,l
	cp	maxy
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
	cpl
ENDIF
	ld	e,a		;Save pixel mask
	ld	c,1
	ld	b,@00000001
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
IF NEEDplot
	ld	a,(hl)
	or	e
	ld	(hl),a
	inc	c
	sla	b
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
	ld	a,(hl)
	or	e
	ld	(hl),a
	inc	c
	sla	b
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
	ld	a,(hl)
	or	e
	ld	(hl),a
ENDIF
IF NEEDunplot
	ld	a,(hl)
	and	e
	ld	(hl),a
	inc	c
	sla	b
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
	ld	a,(hl)
	and	e
	ld	(hl),a
	inc	c
	sla	b
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
	ld	a,(hl)
	and	e
	ld	(hl),a
ENDIF
IF NEEDxor
	ld	a,(hl)
	xor	e
	ld	(hl),a
	inc	c
	sla	b
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
	ld	a,(hl)
	xor	e
	ld	(hl),a
	inc	c
	sla	b
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
	ld	a,(hl)
	xor	e
	ld	(hl),a
	xor	l
	out	(c),a
ENDIF
IF NEEDpoint
	ld	a,(hl)
	and	e
	jr	z,got_point
	inc	c
	sla	b
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
	ld	a,(hl)
	and	e
	jr	z,got_point
	inc	c
	sla	b
	ld	a,c
	out	($f1),a
	ld	a,b
	out	($f2),a
	ld	a,(hl)
	and	e
got_point:
ENDIF
	pop	bc		;Restore callers
	ret
