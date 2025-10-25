

SECTION code_clib

PUBLIC fputc_cons_selector
PUBLIC _fputc_cons_selector

PUBLIC set_fputc_cons
PUBLIC _set_fputc_cons

EXTERN fputc_cons_generic

fputc_cons_selector:
_fputc_cons_selector:
IF __CPU_GBZ80__
	ld	hl,__fputc_cons_selector
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__fputc_cons_selector)
ENDIF
	push	hl
	ret

set_fputc_cons:
_set_fputc_cons:
	pop	de
	pop	bc
	push	bc
	push	de
	ld	hl,__fputc_cons_selector
	ld	e,(hl)
	ld	(hl),c
	inc	hl
	ld	d,(hl)
	ld	(hl),b
	ex	de,hl	;Return the old version
	ret



SECTION data_clib

__fputc_cons_selector:	defw	fputc_cons_generic


