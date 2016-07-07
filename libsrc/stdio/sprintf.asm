	MODULE sprintf
	SECTION	code_clib

	PUBLIC	sprintf

	EXTERN	asm_printf
	EXTERN	sprintf_outc
	EXTERN	__sgoioblk




; sccz80 version
;void sprintf(char *buf, char *fmt,...)
;{
;        printf1(fp, print_func, sccz80_delta, *ct,ct-1);
;}
sprintf:
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
	ld	de,65535	;len
	push	de
	push	bc
	ex	de,hl		;de=&fmt+1
	ld	hl,0
	add	hl,sp
	push	hl		;fp
	ld	bc,sprintf_outc
	push	bc
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
	call	asm_printf
	ex	de,hl
	ld	hl,10+4
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	pop	ix
	ret


