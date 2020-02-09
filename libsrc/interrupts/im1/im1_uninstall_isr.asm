
		SECTION		code_clib
		PUBLIC		im1_install_isr
		PUBLIC		_im1_install_isr

		EXTERN		im1_vectors
		EXTERN		CLIB_IM1_VECTOR_COUNT
		EXTERN		asm_interrupt_remove_handler

im1_install_isr:
_im1_install_isr:
	pop	bc
	pop	de
	push	de
	push	bc
	ld	hl, im1_vectors
	ld	b,  CLIB_IM1_VECTOR_COUNT
	call	asm_interrupt_remove_handler
	ld	hl,0
IF __CPU_INTEL__
	ld	a,l
	rla
	ld	l,a
ELSE
	rl	l
ENDIf
	ret
