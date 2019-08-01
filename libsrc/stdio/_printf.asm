
	MODULE _printf
	SECTION	code_clib

	PUBLIC	_printf

	EXTERN	asm_printf
	EXTERN	fputc_callee
	EXTERN  __sgoioblk





;sdcc version
_printf:
	ld	hl,4
	add	hl,sp	;points to ap
	pop	bc	;ret address
	pop	de	;fmt
	push	de
	push	bc
IF !__CPU_INTEL__
	push	ix	;save ix
ENDIF
	ld	bc,__sgoioblk+10	;file
	push	bc
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
IF !__CPU_INTEL__
	pop	ix	;restore ix
ENDIF
	ret

