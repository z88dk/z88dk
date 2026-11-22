; Fixture: ld b,0 / djnz wraps to 256 trips.
	MODULE	t_loop_b0

	SECTION	code_compiler

._foo
	ld	b,0
.i_1
	inc	hl
	djnz	i_1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
