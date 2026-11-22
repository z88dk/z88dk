; Larger, faster 8085 body: sub hl,bc + 18 nop + ret = 92 T, 20 bytes.
	MODULE	t_8085_fast

	SECTION	code_compiler

._foo
	sub	hl,bc
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
