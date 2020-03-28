
	SECTION	code_graphics

	PUBLIC	setpos
	PUBLIC	_setpos

	EXTERN	__gfx_coords

; void setpos(int x, int y) __smallc

setpos:
_setpos:
	ld	hl,sp+2
	ld	d,(hl)
	ld	hl,sp+4
	ld	e,(hl)
	ld	hl,__gfx_coords
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ret




