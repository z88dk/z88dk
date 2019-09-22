
	MODULE _printk
	SECTION	code_clib

	PUBLIC	_printk
	PUBLIC  _cprintf

	EXTERN	asm_printf
	EXTERN	printk_outc





;sdcc version
_printk:
_cprintf:
	ld	hl,4
	add	hl,sp	;points to first argument
	pop	bc	;ret address
	pop	de	;fmt
	push	de
	push	bc
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	push	ix	;save ix
ENDIF
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
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	pop	ix	;restore ix
ENDIF
	ret

