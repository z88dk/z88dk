	MODULE scanf_ungetc
	SECTION	code_clib

	PUBLIC  scanf_ungetc	
	EXTERN	ungetc


scanf_ungetc:
	pop	bc
	pop	hl	;fp
	pop	de	;charcter
	push	bc
	push	de
	push	hl
	call	ungetc
	pop	bc
	pop	bc
	ret
