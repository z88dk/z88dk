

	SECTION	code_clib

	PUBLIC	asm_set_palette
	PUBLIC	asm_get_palette


; Set the palette bitsets
;
; Entry:	l = blue bitset
;		h = red bitset
;		e = green bitset


asm_set_palette:
	ld	bc,$1000
	out	(c),l		;Blue
	inc	b
	out	(c),h		;Red
	inc	b
	out	(c),e		;Green
	ld	(__x1_default_palette),hl
	ld	a,e
	ld	(__x1_default_palette+2),a
	ret


asm_get_palette:
	ld	hl,(__x1_default_palette)
	ld	a,(__x1_default_palette+2)
	ld	e,a
	ret



	SECTION	data_clib

__x1_default_palette:
	defb	$aa, $cc, $f0

