
		SECTION		code_clib
		PUBLIC		sam_uninstall_line_isr
		PUBLIC		_sam_uninstall_line_isr
		PUBLIC		asm_sam_uninstall_line_isr

		EXTERN		line_vectors
		EXTERN		CLIB_LINE_VECTOR_COUNT
		EXTERN		asm_interrupt_remove_handler

sam_uninstall_line_isr:
_sam_uninstall_line_isr:
	pop	bc
	pop	de
	push	de
	push	bc
	; Entry de = vector to remove
asm_sam_uninstall_line_isr:
	ld	hl, line_vectors
	ld	b,  CLIB_LINE_VECTOR_COUNT
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
