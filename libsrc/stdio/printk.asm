
	SECTION	code_clib

	PUBLIC	printk
	PUBLIC	_printk

	EXTERN	l_gint
	EXTERN	printk1
	EXTERN	asm_vfprintf1
	EXTERN	fputc_cons




; sccz80 version
;void printk(char *fmt,...)
;{
;        int  *ct;
;        ct= (getarg()*2)+&fmt-4;
;
;        printk1(fp, print_func, sccz80_delta, *ct,ct-1);
;}
printk:
	ld	l,a
	ld	h,0
        add     hl,hl
	add	hl,sp

	ld	bc,0	
	push	bc
	ld	bc,printk_outc
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
	call	asm_vfprintf1
	pop	bc
	pop	bc	
	pop	bc	
	pop	bc
	pop	bc
	ret


printk_outc:
	pop	bc
	pop	de	
	pop	hl
	push	bc
	push	hl
	call	fputc_cons
	pop	hl
	ret
	

;sdcc version
_printk:
	ld	hl,4
	add	hl,sp	;points to first argument
	pop	bc	;ret address
	pop	de	;fmt
	push	de
	push	bc
	push	ix	;save ix
	ld	bc,0	;file
	push	bc
	ld	bc,printk_outc
	push	bc
	ld	bc,0	;flag
	push	bc
	push	de	;fmt
	push	hl	;argument
	call	asm_vfprintf1
	pop	bc
	pop	bc
	pop	bc	
	pop	bc
	pop	bc
	pop	ix	;restore ix
	ret

