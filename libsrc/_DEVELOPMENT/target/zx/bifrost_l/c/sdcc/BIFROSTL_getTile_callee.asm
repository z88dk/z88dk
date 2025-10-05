; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getTile(unsigned char px, unsigned char py)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_getTile_callee

EXTERN asm_BIFROSTL_getTile

_BIFROSTL_getTile_callee:

   pop hl
	ex (sp),hl      ; L = px
	ld c,h          ; C = py
	
	jp asm_BIFROSTL_getTile
