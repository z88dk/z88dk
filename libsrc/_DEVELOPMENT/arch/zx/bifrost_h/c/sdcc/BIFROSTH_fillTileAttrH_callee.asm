; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void void BIFROSTH_fillTileAttrH(unsigned int lin,unsigned int col,unsigned int attr)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_fillTileAttrH_callee

EXTERN asm_BIFROSTH_fillTileAttrH

_BIFROSTH_fillTileAttrH_callee:

   pop hl
	pop bc
	dec sp
	ex (sp),hl
	ld c,l          ; C = attr
	ld d,c          ; D = lin
	ld e,b          ; E = col
	
	jp asm_BIFROSTH_fillTileAttrH
