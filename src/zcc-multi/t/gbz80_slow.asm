; Smaller, slower gbz80 body: 16 * inc hl + ret = 144 T, 17 bytes.
	MODULE	t_gbz80_slow

	SECTION	code_compiler

._foo
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
