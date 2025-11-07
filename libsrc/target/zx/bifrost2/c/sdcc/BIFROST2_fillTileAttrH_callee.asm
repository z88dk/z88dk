; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void void BIFROST2_fillTileAttrH(unsigned char lin,unsigned char col,unsigned char attr)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_fillTileAttrH_callee

EXTERN asm_BIFROST2_fillTileAttrH

_BIFROST2_fillTileAttrH_callee:

   pop hl
	dec sp
	pop de          ; D = lin
	ex (sp),hl
	ld e,l          ; E = col
	ld c,h          ; C = attr
	
	jp asm_BIFROST2_fillTileAttrH
