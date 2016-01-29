; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawT(unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_drawT_callee

EXTERN asm_NIRVANAM_drawT

_NIRVANAM_drawT_callee:

	pop hl          ; RET address
	pop de          ; tile
	ld a,e
	pop de          ; line
	ld d,e
	ex (sp),hl      ; col
	ld e,l

	jp asm_NIRVANAM_drawT
