
	MODULE _scanf
	SECTION	code_clib

	PUBLIC	_scanf

	EXTERN	asm_scanf
	EXTERN  __sgoioblk





;sdcc version
_scanf:
	ld	hl,4
	add	hl,sp	;points to ap
	pop	bc	;ret address
	pop	de	;fmt
	push	de
	push	bc
IF !__CPU_INTEL__
	push	ix	;save ix
ENDIF
	ld	bc,__sgoioblk	;stdin
	push	bc
	ld	bc,0	;flag
	push	bc
	push	de	;fmt
	push	hl	;argument
	call	asm_scanf
	pop	bc
	pop	bc	
	pop	bc
	pop	bc
IF !__CPU_INTEL__
	pop	ix	;restore ix
ENDIF
	ret

