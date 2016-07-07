	MODULE fprintf
	SECTION	code_clib

	PUBLIC	fprintf

	EXTERN	asm_printf
	EXTERN	fputc_callee
	EXTERN	__sgoioblk




; sccz80 version
;void printf(FILE *fp, char *fmt,...)
;{
;        int  *ct;
;        ct= (getarg()*2)+&fmt-4;
;
;vfprintf((FILE *)(*ct),(unsigned char *)(*(ct-1)),ct-2));
;
;        printf1(fp, print_func, sccz80_delta, *ct,ct-1);
;}
fprintf:
	ld	l,a
	ld	h,0
        add     hl,hl
	add	hl,sp		;points to fp
	push	ix
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	dec	hl
	dec	hl
	push	bc
	ld	bc,fputc_callee
	push	bc
	ld	bc,1
	push	bc
	ld	d,(hl)		;fmt
	dec	hl
	ld	e,(hl)	
	push	de
	dec	hl
	dec	hl		;points too ap
	push	hl
	call	asm_printf
	pop	bc
	pop	bc	
	pop	bc	
	pop	bc
	pop	bc
	pop	ix		;restore callers
	ret


