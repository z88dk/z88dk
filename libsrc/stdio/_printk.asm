
	MODULE _printk
	SECTION	code_clib

	PUBLIC	_printk

	EXTERN	asm_printf
	EXTERN	printk_outc





;sdcc version
_printk:
	ld	hl,4
	add	hl,sp	;points to first argument
	pop	bc	;ret address
	pop	de	;fmt
	push	de
	push	bc
	push	ix	;save ix
	push	bc		;fp (we don't care about it)
	ld	bc,printk_outc
	push	bc
	ld	bc,0	;flag
	push	bc
	push	de	;fmt
	push	hl	;argument
	call	asm_printf
	pop	bc
	pop	bc
	pop	bc	
	pop	bc
	pop	bc
	pop	ix	;restore ix
	ret

