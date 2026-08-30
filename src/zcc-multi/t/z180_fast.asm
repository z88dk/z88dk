; Larger, faster Z180 body: mlt de + 18 nop + ret = 99 T, 20 bytes.
	MODULE	t_z180_fast

	SECTION	code_compiler

._foo
	mlt	de
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
