	MODULE printk_outc
	SECTION	code_clib

	PUBLIC	printk_outc
	EXTERN	fputc_cons


printk_outc:
	pop	bc
	pop	de	
	pop	hl
	push	bc
	push	hl
	call	fputc_cons
	pop	hl
	ret
	
