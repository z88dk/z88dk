; 8085 ld bc,0 / dec bc / jp nk wraps to 65536. K sets on underflow.
	MODULE	t_loop_8085_k0

	SECTION	code_compiler

._foo
	ld	bc,0
.i_1
	inc	hl
	dec	bc
	jp	nk,i_1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
