
	SECTION	code_clib

	PUBLIC	printk
	PUBLIC	_printk

	EXTERN	l_neg
	EXTERN	l_gint
	EXTERN	printk1



sccz80_delta:
	call	l_neg
sdcc_delta:
	ret

; sccz80 version
;void printk(char *fmt,...)
;{
;        int  *ct;
;        ct= (getarg()*2)+&fmt-4;
;
;        printk1(sccz80_delta, *ct,ct-1);
;}
printk:
	ld	l,a
	ld	h,0
        add     hl,hl
	add	hl,sp

	ld	bc,sccz80_delta
	push	bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)	
	push	de
	dec	hl
	dec	hl
	dec	hl
	push	hl
	call	printk1
	pop	bc
	pop	bc	
	pop	bc	
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

	ld	bc,sdcc_delta
	push	bc
	push	de	;fmt
	push	hl	;argument
	call	printk1
	pop	bc
	pop	bc
	pop	bc	
	pop	ix	;restore ix
	ret

