; 8085 general 16-bit loop: dec bc sets K on 0 -> -1. Any N, not only 0.
	MODULE	t_loop_8085_k

	SECTION	code_compiler

._foo
	ld	bc,8
.i_1
	inc	hl
	dec	bc
	jp	nk,i_1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
