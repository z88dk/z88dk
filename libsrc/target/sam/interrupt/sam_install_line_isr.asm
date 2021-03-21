
		SECTION		code_clib
		PUBLIC		sam_install_line_isr
		PUBLIC		_sam_install_line_isr
		PUBLIC		asm_sam_install_line_isr

		EXTERN		line_vectors
		EXTERN		CLIB_LINE_VECTOR_COUNT
		EXTERN		asm_interrupt_add_handler

sam_install_line_isr:
_sam_install_line_isr:
	pop	bc
	pop	de
	push	de
	push	bc
	; de = vector to add
asm_sam_install_line_isr:
	ld	hl, line_vectors
	ld	b,  CLIB_LINE_VECTOR_COUNT
	call	asm_interrupt_add_handler
	ld	hl,0
IF __CPU_INTEL__
	ld	a,l
	rla
	ld	l,a
ELSE
	rl	l
ENDIF
	ret
