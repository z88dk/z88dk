; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_fillT(unsigned int attr, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_fillT_callee

EXTERN asm_NIRVANAP_fillT

_NIRVANAP_fillT_callee:

	pop hl          ; RET address
	pop de          ; attr
	ld a,e
	pop de          ; lin
	ld d,e
	ex (sp),hl      ; col
	ld e,l

	jp asm_NIRVANAP_fillT
