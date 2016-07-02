	MODULE scanf_getc
	SECTION	code_clib

	PUBLIC  scanf_getc	
	EXTERN	fgetc


scanf_getc:
	pop	bc
	pop	hl	;fp
	push	bc
	push	hl
	call	fgetc
	pop	bc
	ret
