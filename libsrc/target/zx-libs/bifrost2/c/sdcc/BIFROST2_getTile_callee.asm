; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getTile(unsigned char px,unsigned char py)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_getTile_callee

EXTERN asm_BIFROST2_getTile

_BIFROST2_getTile_callee:

   pop hl
	ex (sp),hl      ; L = px
	ld c,h          ; C = py
	
	jp asm_BIFROST2_getTile
