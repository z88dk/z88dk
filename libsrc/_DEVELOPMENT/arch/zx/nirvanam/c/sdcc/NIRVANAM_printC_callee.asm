; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_printC(unsigned int ch, unsigned char *attrs, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_printC_callee

EXTERN asm_NIRVANAM_printC

_NIRVANAM_printC_callee:

	pop hl          ; RET address
	pop de          ; ch
	ld a,e
	pop bc          ; attrs
	pop de          ; lin
	ld d,e
	ex (sp),hl      ; col
	ld e,l

	jp asm_NIRVANAM_printC
