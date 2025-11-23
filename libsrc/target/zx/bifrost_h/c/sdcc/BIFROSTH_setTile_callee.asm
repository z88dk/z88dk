; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_setTile(unsigned char px,unsigned char py,unsigned char tile)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_setTile_callee

EXTERN asm_BIFROSTH_setTile

_BIFROSTH_setTile_callee:

   pop hl
	pop de
	dec sp
	ex (sp),hl
	ld l,e          ; L = px
	ld e,h          ; E = tile
	ld c,d          ; C = py

   jp asm_BIFROSTH_setTile
