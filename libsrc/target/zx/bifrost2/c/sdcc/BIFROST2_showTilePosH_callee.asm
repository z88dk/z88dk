; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_showTilePosH(unsigned char lin,unsigned char col)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_showTilePosH_callee

EXTERN asm_BIFROST2_showTilePosH

_BIFROST2_showTilePosH_callee:

   pop hl
	ex (sp),hl
	ld d,l          ; D = lin
	ld e,h          ; E = col
	
	jp asm_BIFROST2_showTilePosH
