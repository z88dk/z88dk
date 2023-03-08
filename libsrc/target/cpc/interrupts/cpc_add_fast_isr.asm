
		SECTION		code_clib
		PUBLIC		cpc_add_fast_isr
		PUBLIC		_cpc_add_fast_isr
		PUBLIC		asm_cpc_add_fast_isr

		EXTERN		fast_vectors
		EXTERN		CLIB_FAST_VECTOR_COUNT
		EXTERN		asm_interrupt_add_handler

cpc_add_fast_isr:
_cpc_add_fast_isr:
	pop	bc
	pop	de
	push	de
	push	bc
	; de = vector to add
asm_cpc_add_fast_isr:
	ld	hl, fast_vectors
	ld	b,  CLIB_FAST_VECTOR_COUNT
	call	asm_interrupt_add_handler
	ld	hl,0
	rl	l
	ret
