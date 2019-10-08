
	MODULE _fprintf
	SECTION	code_clib

	PUBLIC	_fprintf

	EXTERN	asm_printf
	EXTERN	fputc_callee





;sdcc version
_fprintf:
	ld	hl,6
	add	hl,sp	;points to ap
	pop	af	;ret address
	pop	bc	;fp
	pop	de	;fmt
	push	de
	push	bc
	push	af
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	push	ix	;save ix
ENDIF
	push	bc	;fp
	ld	bc,fputc_callee
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

