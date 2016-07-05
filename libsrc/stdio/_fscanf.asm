	MODULE  fscanf
	SECTION	code_clib

	PUBLIC	_fscanf

	EXTERN	asm_scanf




; sdcc version
;void fscanf(FILE *fp, char *fmt,...)
;{
;        asm_scanf(fp, sccz80_delta, *ct,ct-1);
;}
_fscanf:
	ld	hl,2
	add	hl,sp		;points to buf
	push	ix		;save callers
	ld	c,(hl)		;fp
	inc	hl
	ld	b,(hl)
	inc	hl		;&fmt
	ld	bc,0		;sdcc
	ld	c,(hl)		;fmt
	inc	hl
	ld	b,(hl)
	inc	hl
	push	bc
	push	hl		;&ap
	call	asm_scanf
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	ix
	ret


