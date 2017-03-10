	MODULE  sscanf
	SECTION	code_clib

	PUBLIC	sscanf

	EXTERN	asm_scanf
	EXTERN	scanf_ungetc
	EXTERN	scanf_getc
	EXTERN	__sgoioblk




; sccz80 version
;void sscanf(char *buf, char *fmt,...)
;{
;        asm_scanf(fp, sccz80_delta, *ct,ct-1);
;}
sscanf:
	ld	l,a
	ld	h,0
        add     hl,hl
	add	hl,sp		;&buf
	push	ix		;save callers
	ld	c,(hl)		;buf
	inc	hl
	ld	b,(hl)
	dec	hl
	dec	hl		;&fmt+1
	ex	de,hl		;de=&fmy+1
	ld	hl,65535	;infinite length
	push	hl
	ld	hl,1+2+128	;h=ungetc, l=_IOREAD|_IOSTRING|_IOUSE
	push	hl		;
	push	bc		;buf
	ld	hl,0
	add	hl,sp
	push	hl		;fp
	ld	bc,1		;sccz80
	push	bc
	ex	de,hl		;hl=&fmt+1
	ld	b,(hl)		;fmt
	dec	hl
	ld	c,(hl)
	push	bc

	dec	hl
	dec	hl
	push	hl		;&ap
	call	asm_scanf
        pop     bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	ix
	ret


