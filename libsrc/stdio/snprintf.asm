	MODULE snprintf
	SECTION	code_clib

	PUBLIC	snprintf

	EXTERN	asm_printf
	EXTERN	sprintf_outc
	EXTERN	__sgoioblk




; sccz80 version
;void snprintf(char *buf, size_t,char *fmt,...)
;{
;void vsprintf(char *buf, char *fmt,va_list ap)
;
;        num=vfprintf(temp,(unsigned char *)(*(ct-1)),ct-2);
;
;        printf1(fp, print_func, sccz80_delta, *ct,ct-1);
;}
snprintf:
	ld	l,a
	ld	h,0
        add     hl,hl
	add	hl,sp		;points to buf
	push	ix		;save callers
	ld	c,(hl)		;buf
	inc	hl
	ld	b,(hl)
	dec	hl
	dec	hl		;&size+1
	ld	d,(hl)	
	dec	hl
	ld	e,(hl)
	dec	hl		;&fmt+1
	push	de
	push	bc
	ex	de,hl		;de=&fmt
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


