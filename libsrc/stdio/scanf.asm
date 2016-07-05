	MODULE scanf
	SECTION	code_clib

	PUBLIC	scanf

	EXTERN	asm_scanf
	EXTERN	__sgoioblk




; sccz80 version
;void scanf(char *fmt,...)
;{
;        asm_scanf(fp, ungetc, getc, sccz80_delta, *ct,ct-1);
;}
scanf:
	ld	l,a
	ld	h,0
        add     hl,hl
	add	hl,sp		;&fmt
	push	ix		;save callers

	ld	bc,__sgoioblk	;stdin
	push	bc		;fp
	ld	bc,1		;sccz80
	push	bc
	ld	c,(hl)		;fmt
	inc	hl
	ld	b,(hl)
	push	bc
	dec	hl
	dec	hl
	dec	hl
	push	hl		;&ap
	call	asm_scanf
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	ix
	ret


