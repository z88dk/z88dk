	MODULE  vfscanf
	SECTION	code_clib

	PUBLIC	vfscanf

	EXTERN	asm_scanf
	EXTERN	scanf_ungetc
	EXTERN	scanf_getc




; sccz80 version
;void vfscanf(FILE *fp, char *fp, va_list ap)
;{
;        printf1(fp, ungetc, getc, sccz80_delta, *ct,ct-1);
;}
vfscanf:
	pop	af
	pop	hl	;ap
	pop	de	;fmt
	pop	bc	;fp
	push	bc
	push	de
	push	hl
	push	af
	push	ix	;save callers

	push	bc	;fp
	ld	bc,1		;sccz80
	push	bc
	push	de		;fmt
	push	hl		;ap
	call	asm_scanf
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	ix
	ret


