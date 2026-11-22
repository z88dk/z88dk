; Smaller, slower: 20 * inc hl + ret = 176 T, 21 bytes.
	MODULE	t_gbz80_ex_slow

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
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
