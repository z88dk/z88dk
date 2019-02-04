		SECTION		code_clib

		PUBLIC		asm_nmi_handler

		EXTERN		nmi_vectors
		EXTERN		asm_interrupt_handler

asm_nmi_handler:
	push	af
	push	hl
	ld	hl,nmi_vectors
	call	asm_interrupt_handler
	pop	hl
	pop	af
	retn

