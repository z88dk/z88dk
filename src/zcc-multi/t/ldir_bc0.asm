; Known BC=0 on ldir: 65536 repeats (16-bit wrap).
	MODULE	t_ldir_bc0

	SECTION	code_compiler

._foo
	ld	bc,0
	ldir
	ret

	SECTION	code_compiler
	GLOBAL	_foo
