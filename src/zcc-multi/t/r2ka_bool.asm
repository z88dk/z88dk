; Rabbit native bool hl is 2 T. Not the z80asm 9-byte expansion.
; bool hl + ret = 2 + 8 = 10 T.
	MODULE	t_r2ka_bool

	SECTION	code_compiler

._foo
	bool	hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
