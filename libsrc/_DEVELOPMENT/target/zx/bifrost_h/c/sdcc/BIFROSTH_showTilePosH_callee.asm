; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_showTilePosH(unsigned char lin,unsigned char col)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_showTilePosH_callee

EXTERN asm_BIFROSTH_showTilePosH

_BIFROSTH_showTilePosH_callee:

   pop hl
	ex (sp),hl
	ld d,l          ; D = lin
	ld e,h          ; E = col
	
	jp asm_BIFROSTH_showTilePosH
