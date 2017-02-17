
	MODULE printf
	SECTION	code_clib

	PUBLIC	printf

	EXTERN	asm_printf
	EXTERN	printf_outc
	EXTERN	__sgoioblk
	EXTERN	fputc_callee




; sccz80 version
;void printf(char *fmt,...)
;{
;        int  *ct;
;        ct= (getarg()*2)+&fmt-4;
;
;        printf1(fp, print_func, sccz80_delta, *ct,ct-1);
;}
printf:
	ld	l,a
	ld	h,0
        add     hl,hl
	add	hl,sp

	push	ix		;save callers
	ld	bc,__sgoioblk+6
	push	bc
	ld	bc,fputc_callee		;printf_outc
	push	bc
	ld	bc,1
	push	bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)	
	push	de
	dec	hl
	dec	hl
	dec	hl
	push	hl
	call	asm_printf
	pop	bc
	pop	bc	
	pop	bc	
	pop	bc
	pop	bc
	pop	ix
	ret


