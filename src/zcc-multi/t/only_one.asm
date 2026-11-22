; One function. Pair with only_two.asm.
	MODULE	t_only_one

	SECTION	code_compiler

._foo
	ret

	SECTION	code_compiler
	GLOBAL	_foo
