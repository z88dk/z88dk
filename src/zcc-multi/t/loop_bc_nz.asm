; dec bc / jp nz is not a counted loop: 16-bit dec does not set Z.
	MODULE	t_loop_bc_nz

	SECTION	code_compiler

._foo
	ld	bc,0
.i_1
	inc	hl
	dec	bc
	jp	nz,i_1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
