; ld hl,n is 10 T, ret is 10 T. Total 20.
	MODULE	t_ldimm

	SECTION	code_compiler

._foo
	ld	hl,1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
