; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_showTilePosL(unsigned char row, unsigned char col)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_showTilePosL_callee

EXTERN asm_BIFROSTL_showTilePosL

_BIFROSTL_showTilePosL_callee:

   pop hl
	ex (sp),hl
	ld d,l          ; D = row
	ld e,h          ; E = col
	
	jp asm_BIFROSTL_showTilePosL
