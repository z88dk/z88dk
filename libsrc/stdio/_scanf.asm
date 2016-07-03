
	MODULE _scanf
	SECTION	code_clib

	PUBLIC	_scanf

	EXTERN	asm_scanf
	EXTERN  __sgoioblk
	EXTERN	scanf_ungetc
	EXTERN	scanf_getc





;sdcc version
_scanf:
	ld	hl,4
	add	hl,sp	;points to ap
	pop	bc	;ret address
	pop	de	;fmt
	push	de
	push	bc
	push	ix	;save ix
	ld	bc,__sgoioblk	;stdin
	push	bc
	ld	bc,scanf_ungetc
	push	bc
	ld	bc,scanf_getc
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
	pop	bc
	pop	bc
	pop	ix	;restore ix
	ret

