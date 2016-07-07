
	MODULE printk
	SECTION	code_clib

	PUBLIC	printk

	EXTERN	asm_printf
	EXTERN	printk_outc




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
	add	hl,sp		;&fmt

	push	ix
	push	bc		;fp (we don't care about the fp)
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
	call	asm_printf
	pop	bc
	pop	bc	
	pop	bc	
	pop	bc
	pop	bc
	pop	ix
	ret

