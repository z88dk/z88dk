
	MODULE _fprintf
	SECTION	code_clib

	PUBLIC	_fprintf

	EXTERN	asm_printf
	EXTERN	fputc_callee





;sdcc version
_fprintf:
	ld	hl,6
	add	hl,sp	;points to ap
	pop	af	;ret address
	pop	bc	;fp
	pop	de	;fmt
	push	de
	push	bc
	push	af
	push	ix	;save ix
	push	bc	;fp
	ld	bc,fputc_callee
	push	bc
	ld	bc,0	;flag
	push	bc
	push	de	;fmt
	push	hl	;argument
	call	asm_printf
	pop	bc
	pop	bc
	pop	bc	
	pop	bc
	pop	bc
	pop	ix	;restore ix
	ret

