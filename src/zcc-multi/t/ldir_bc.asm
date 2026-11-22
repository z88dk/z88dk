; Known BC on ldir: 4 repeats.
	MODULE	t_ldir_bc

	SECTION	code_compiler

._foo
	ld	bc,4
	ldir
	ret

	SECTION	code_compiler
	GLOBAL	_foo
