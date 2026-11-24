; Larger, faster Z180 body: mlt de + 15 nop + ret = 71 T, 18 bytes.
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
	ret

	SECTION	code_compiler
	GLOBAL	_foo
