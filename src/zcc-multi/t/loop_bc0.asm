; Fixture: ld bc,0 wrap. dec bc does not set Z; test is or through A.
	MODULE	t_loop_bc0

	SECTION	code_compiler

._foo
	ld	bc,0
.i_1
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jp	nz,i_1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
