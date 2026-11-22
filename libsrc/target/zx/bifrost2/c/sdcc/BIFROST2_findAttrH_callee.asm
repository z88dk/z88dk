; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROST2_findAttrH(unsigned char lin,unsigned char col)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_findAttrH_callee

EXTERN asm_BIFROST2_findAttrH

_BIFROST2_findAttrH_callee:

   pop hl
	ex (sp),hl      ; L = lin
	ld c,h          ; C = col

   jp asm_BIFROST2_findAttrH
