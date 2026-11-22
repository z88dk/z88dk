; Faster, larger usable body: 6 * nop + ret = 34 T, 7 bytes.
	MODULE	t_mix_fast

	SECTION	code_compiler

._foo
	nop
	nop
	nop
	nop
	nop
	nop
	ret

	SECTION	code_compiler
	GLOBAL	_foo
