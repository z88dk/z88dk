; Fixture: same _foo without an indirect jump.
	MODULE	t_jphl_alt

	SECTION	code_compiler

._foo
	ld	hl,1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
