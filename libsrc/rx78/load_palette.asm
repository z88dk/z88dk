
	SECTION	code_clib
	PUBLIC	load_palette
	PUBLIC	_load_palette

; void load_palette(unsigned char *data, int index, int count)

load_palette:
_load_palette:
	ld	hl,2
	add	hl,sp
	ld	e,(hl)
	inc	hl
	inc	hl
	ld	c,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
;
; Parameters: hl = location
;              e = number to write
;              c = palette index to start with
;
asm_load_palette:
	ld	a,$f5
	add	c
	ld	c,a
	ld	b,0
loop_palette:
	ld	a,(hl)
	out	(c),a
	inc	hl
	inc	c
	dec	e
	jr	nz,loop_palette
	ret
