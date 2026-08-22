; Smaller, slower Z180 body: 16 * inc hl + ret = 106 T, 17 bytes.
	MODULE	t_z180_slow

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
