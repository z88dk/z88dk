; zcc-multi fixture: larger _foo, smaller _bar
	MODULE	t_large

	SECTION	code_compiler

._foo
	ld	hl,0
	ld	de,1
	add	hl,de
	add	hl,de
	add	hl,de
	ret

._bar
	ld	hl,2
	ret

	SECTION	bss_compiler
._g
	defs	2

	SECTION	code_compiler
	GLOBAL	_foo
	GLOBAL	_bar
	GLOBAL	_g
