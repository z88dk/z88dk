
	MODULE vsnprintf
	SECTION	code_clib

	PUBLIC	vsnprintf

	EXTERN	asm_printf
	EXTERN	sprintf_outc
	EXTERN	__sgoioblk




; sccz80 version
;void vsprintf(char *buf, size_t, char *fmt,va_list ap)
; int vfprintf1(FILE *fp, void __CALLEE__ (*output_fn)(int c,FILE *fp), int sccz80, unsigned char *fmt,void *ap)

vsnprintf:
	ld	hl,8
	add	hl,sp		;&buf
	push	ix
	ld	c,(hl)		;buf
	inc	hl
	ld	b,(hl)
	dec	hl
	dec	hl
	ld	d,(hl)		;size
	dec	hl
	ld	e,(hl)
	dec	hl
	push	de
	push	bc
	ex	de,hl		;de=&fmt
	ld	hl,0
	add	hl,sp
	push	hl		;file
	ld	bc,sprintf_outc
	push	bc
	ld	bc,1	;sccz80 mode
	push	bc
	ex	de,hl	;hl=&fmt+1
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
	dec	hl	;&ap
	push	de	;fmt
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
	push	de
	call	asm_printf
	ex	de,hl
	ld	hl,10+4
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	pop	ix
	ret


