; z80asm word synthetic sra hl is two CB ops (16 T), not sra r (8).
; sra hl + ret = 26 T.
	MODULE	t_srahl

	SECTION	code_compiler

._foo
	sra	hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
