; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_drawTileH(unsigned char lin,unsigned char col,unsigned char tile)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_drawTileH_callee

EXTERN asm_BIFROST2_drawTileH

_BIFROST2_drawTileH_callee:

   pop hl
	dec sp
	pop de          ; D = lin
	ex (sp),hl
	ld e,l          ; E = col
	ld a,h          ; A = tile

   jp asm_BIFROST2_drawTileH
