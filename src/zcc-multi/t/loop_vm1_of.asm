; VM1 jp of after dec bc is not a counted 16-bit loop. OF is not K.
; Trip stays 1. Compare with t/loop_8085_k.asm.
	MODULE	t_loop_vm1_of

	SECTION	code_compiler

._foo
	ld	bc,8
.i_1
	inc	hl
	dec	bc
	jp	of,i_1
	ret

	SECTION	code_compiler
	GLOBAL	_foo
