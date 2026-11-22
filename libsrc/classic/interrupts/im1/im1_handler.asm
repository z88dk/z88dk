		SECTION		code_clib

		PUBLIC		asm_im1_handler

		EXTERN		im1_vectors
		EXTERN		asm_interrupt_handler

asm_im1_handler:
	push	af
	push	hl
	ld	hl,im1_vectors
	call	asm_interrupt_handler
	pop	hl
	pop	af
IF __CPU_INTEL__
	ei
	ret
ELSE
	ei
	reti
ENDIF

