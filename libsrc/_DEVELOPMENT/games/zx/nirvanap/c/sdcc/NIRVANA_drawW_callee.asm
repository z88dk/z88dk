; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_drawW(unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_drawW_callee

EXTERN asm_NIRVANA_drawW

_NIRVANA_drawW_callee:

	pop hl          ; RET address
	pop de          ; tile
	ld a,e
	pop de          ; lin
	ld d,e
	ex (sp),hl      ; col
	ld e,l

	jp asm_NIRVANA_drawW
