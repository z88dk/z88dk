
	MODULE _snprintf
	SECTION	code_clib

	PUBLIC	_snprintf

	EXTERN	asm_printf
	EXTERN	sprintf_outc





;sdcc version
;snprintf(buf,len,fmt,...)
_snprintf:
	ld	hl,2
	add	hl,sp	;points to buf
	push	ix	;save callers

	ld	c,(hl)	;buf
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	e,(hl)	;len
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de
	push	bc
	ex	de,hl
	ld	hl,0
	add	hl,sp
	push	hl		;save fp
	ld	bc,sprintf_outc
	push	bc
	ld	bc,0		;sdcc
	push	bc
	ex	de,hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	push	bc		;fmt
	push	hl		;&ap
	call	asm_printf
	ex	de,hl
	ld	hl,4+10
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	pop	ix	;restore ix
	ret

