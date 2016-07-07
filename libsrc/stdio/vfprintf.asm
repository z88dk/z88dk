

; int vfprintf(FILE *fp, unsigned char *fmt,void *ap)
		MODULE vfprintf
		SECTION	code_clib
		PUBLIC	vfprintf

		EXTERN	fputc_callee
		EXTERN  asm_printf

; Cores have signature (in __smallc)
; int vfprintf1(FILE *fp, void (*output_fn)(FILE *fp,int c), int sccz80, unsigned char *fmt,void *ap)


; sccz80
vfprintf:
	pop	af
	pop	hl	; ap
	pop	de	; fmt
	pop	bc	; fp
	push	bc
	push	de
	push	hl
	push	af
	push	ix
	push	bc			;fp
	ld	bc,fputc_callee		;output_fn
	push	bc
	ld	bc,1			;sccz80
	push	bc
	push	de			;fmt
	push	hl			;ap
	call	asm_printf
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc	
	pop	ix
	ret
