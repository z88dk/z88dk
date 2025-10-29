; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getTile(unsigned char px,unsigned char py)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_getTile_callee

EXTERN asm_BIFROSTH_getTile

_BIFROSTH_getTile_callee:

   pop hl
	ex (sp),hl      ; L = px
	ld c,h          ; C = py

   jp asm_BIFROSTH_getTile
