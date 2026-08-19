; zcc-multi fixture: smaller _foo, larger _bar
	MODULE	t_small

	SECTION	code_compiler

._foo
	ld	hl,1
	ret

._bar
	ld	hl,0
	ld	de,0
	add	hl,de
	add	hl,de
	add	hl,de
	ret

	SECTION	bss_compiler
._g
	defs	2

	SECTION	code_compiler
	GLOBAL	_foo
	GLOBAL	_bar
	GLOBAL	_g
