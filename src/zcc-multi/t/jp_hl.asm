; Fixture: indirect jump must not use ticks.
	MODULE	t_jphl

	SECTION	code_compiler

._foo
	jp	(hl)
	ret

	SECTION	code_compiler
	GLOBAL	_foo
