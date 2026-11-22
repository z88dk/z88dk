; Larger, faster Z80N body: mul de + 18 nop + ret = 90 T, 20 bytes.
	MODULE	t_z80n_fast

	SECTION	code_compiler

._foo
	mul	de
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ret

	SECTION	code_compiler
	GLOBAL	_foo
