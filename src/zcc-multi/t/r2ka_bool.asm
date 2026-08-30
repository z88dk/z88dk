; Rabbit native bool hl is 2 T. Not the z80asm 9-byte expansion.
; bool hl + ret = 12 T with the Z80 ret stand-in (10).
	MODULE	t_r2ka_bool

	SECTION	code_compiler

._foo
	bool	hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
