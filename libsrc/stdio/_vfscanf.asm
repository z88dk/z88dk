
	MODULE _vfscanf
	SECTION	code_clib

	PUBLIC	_vfscanf

        EXTERN  asm_scanf
        EXTERN  scanf_ungetc
        EXTERN  scanf_getc




; sdcc version
;void vfscanf(FILE *fp, char *fmt,va_list ap)
_vfscanf:
	pop	af
	pop	hl	;fp
	pop	de	;fmt
	pop	bc	;ap
	push	bc
	push	de
	push	hl
	push	af

	push	ix	;save callers
	push	hl	;fp
	ld	hl,scanf_ungetc
	push	hl
	ld	hl,scanf_getc
	push	hl
	ld	hl,0	;sdcc mode
	push	hl
	push	de	;fmt
	push	bc	;ap
	call	asm_scanf
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	ix	;restore callers
	ret


