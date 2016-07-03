
	MODULE _vsscanf
	SECTION	code_clib

	PUBLIC	_vsscanf

        EXTERN  asm_scanf
        EXTERN  scanf_ungetc
        EXTERN  scanf_getc




; sdcc version
;void vsscanf(char *buf, char *fmt,va_list ap)
_vsscanf:
	ld	hl,2
	add	hl,sp	;hl = &buf

	push	ix	;save callers

	ld	bc,1+2+128      ;h=ungetc, l=_IOREAD|_IOSTRING|_IOUSE
	push	bc
	ld	c,(hl)		;get buf
	inc	hl
	ld	b,(hl)
	inc	hl
	push	bc
	ex	de,hl		;de=&fmt
	ld	hl,0
	add	hl,sp		;&fp
	push	hl
	ld	hl,scanf_ungetc
	push	hl
	ld	hl,scanf_getc
	push	hl
	ld	hl,0	;sdcc mode
	push	hl
	ex	de,hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	push	bc	;fmt
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	push	bc	;ap
	call	asm_scanf
        ex      de,hl
        ld      hl,12 + 4
        add     hl,sp
        ld      sp,hl
        ex      de,hl
        pop     ix
	ret


