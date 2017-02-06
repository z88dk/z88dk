; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTH_findAttrH(unsigned char lin,unsigned char col)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_findAttrH_callee

EXTERN asm_BIFROSTH_findAttrH

_BIFROSTH_findAttrH_callee:

   pop hl
	ex (sp),hl      ; L = lin
	ld c,h          ; C = col

   jp asm_BIFROSTH_findAttrH
