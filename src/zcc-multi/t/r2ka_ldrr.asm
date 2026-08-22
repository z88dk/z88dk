; Pair copy is two 8-bit loads. Rabbit 2+2 = 4 T, not Z80 4+4 = 8.
; ld de,hl + ret = 14 T with the Z80 ret stand-in (10).
	MODULE	t_r2ka_ldrr

	SECTION	code_compiler

._foo
	ld	de,hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
