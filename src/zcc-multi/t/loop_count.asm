; Fixture: counted djnz loop, trip 8 is visible.
	MODULE	t_loop

	SECTION	code_compiler

._foo
	ld	b,8
.i_1
	inc	hl
	djnz	i_1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
