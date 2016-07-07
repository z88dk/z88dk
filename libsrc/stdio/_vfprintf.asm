
	MODULE _vfprintf
	SECTION	code_clib

	PUBLIC	_vfprintf

	EXTERN	asm_printf
	EXTERN	fputc_callee
	EXTERN	__sgoioblk




; sdcc version
;void vfprintf(FILE *fp, char *fmt,va_list ap)
_vfprintf:
	pop	af
	pop	hl	;fp
	pop	de	;fmt
	pop	bc	;ap
	push	bc
	push	de
	push	hl
	push	af

	push	ix
	push	hl	;fp
	ld	hl,fputc_callee
	push	hl
	ld	hl,0
	push	hl
	push	de
	push	bc
	call	asm_printf
	pop	bc
	pop	bc	
	pop	bc	
	pop	bc
	pop	bc
	pop	ix
	ret


