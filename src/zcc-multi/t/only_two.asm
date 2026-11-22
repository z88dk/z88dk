; Two functions. Pair with only_one.asm: _bar exists here only.
	MODULE	t_only_two

	SECTION	code_compiler

._foo
	ret

._bar
	nop
	ret

	SECTION	code_compiler
	GLOBAL	_foo
	GLOBAL	_bar
