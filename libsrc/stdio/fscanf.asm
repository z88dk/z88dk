	MODULE  fscanf
	SECTION	code_clib

	PUBLIC	fscanf

	EXTERN	asm_scanf




; sccz80 version
;void fscanf(FILE *fp, char *fmt,...)
;{
;        asm_scanf(fp, sccz80_delta, *ct,ct-1);
;}
fscanf:
	ld	l,a
	ld	h,0
        add     hl,hl
	add	hl,sp		;&buf
	ld	c,(hl)		;fp
	inc	hl
	ld	b,(hl)
	push	bc		;fp on stack
	dec	hl
	dec	hl		;&fmt+1
	ld	bc,1		;sccz80
	push	bc
	ld	b,(hl)		;fmt
	dec	hl
	ld	c,(hl)
	push	bc
	dec	hl
	dec	hl
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


