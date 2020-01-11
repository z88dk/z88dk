;
; Set the colour of the pixel (according to ColorAce)
;


	SECTION	code_clib

	EXTERN	__gfx_coords
	EXTERN	__pmd85_attribute
	EXTERN	__pmd85_attribute2

	PUBLIC	__set_graphics_colour

; Entry: hl = address of plotted pixel
__set_graphics_colour:
	ld	a,(__gfx_coords+2)
	and	1
	jr	z,set_odd_row
	ld	a,(__pmd85_attribute)
	ld	c,a
	ld	a,(hl)
	and	@00111111
	or	c
	ld	(hl),a
	ld	bc,64
	add	hl,bc
	ld	a,(__pmd85_attribute2)
	ld	c,a
	ld	a,(hl)
	and	@00111111
	or	c
	ld	(hl),a
	ret

set_odd_row:
	ld	a,(__pmd85_attribute2)
	ld	c,a
	ld	a,(hl)
	and	@00111111
	or	c
	ld	(hl),a
	ld	bc,-64
	add	hl,bc
	ld	a,(__pmd85_attribute)
	ld	c,a
	ld	a,(hl)
	and	@00111111
	or	c
	ld	(hl),a
	ret

