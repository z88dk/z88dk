; CPC - fast ISR handler (ignoring firmware)
;
;

		SECTION		code_clib
		PUBLIC		__add_fast_isr
		PUBLIC		__del_fast_isr
		PUBLIC		asm_cpc_add_fast_isr
		PUBLIC		asm_cpc_remove_fast_isr

		EXTERN		fast_vectors
		EXTERN		CLIB_FAST_VECTOR_COUNT
		EXTERN		asm_interrupt_add_handler
		EXTERN		asm_interrupt_remove_handler

__add_fast_isr:
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

__del_fast_isr:
	pop	bc
	pop	de
	push	de
	push	bc
	; de = vector to add
asm_cpc_remove_fast_isr:
	ld	hl, fast_vectors
	ld	b,  CLIB_FAST_VECTOR_COUNT
	call	asm_interrupt_remove_handler
	ld	hl,0
