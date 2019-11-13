
	SECTION	code_clib

	PUBLIC	x1_set_palette
	PUBLIC	_x1_set_palette

	EXTERN	asm_set_palette

; void x1_set_palette(int blue, int red, int green)

x1_set_palette:
_x1_set_palette:
	ld	hl,6
	add	hl,sp
	ld	e,(hl)
	dec	hl
	dec	hl
	ld	d,(hl)
	dec	hl
	dec	hl
	ld	l,(hl)
	ex	de,hl
	jp	asm_set_palette

