; Medium size, unusable ticks: halt + 4 * nop + ret = 6 bytes.
	MODULE	t_mix_fb

	SECTION	code_compiler

._foo
	halt
	nop
	nop
	nop
	nop
	ret

	SECTION	code_compiler
	GLOBAL	_foo
