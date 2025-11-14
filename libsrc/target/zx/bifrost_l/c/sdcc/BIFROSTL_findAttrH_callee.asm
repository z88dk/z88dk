; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTL_findAttrH(unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_findAttrH_callee

EXTERN asm_BIFROSTL_findAttrH

_BIFROSTL_findAttrH_callee:

   pop hl
	ex (sp),hl
	ld e,l          ; E = lin
	ld c,h          ; C = col
	
	jp asm_BIFROSTL_findAttrH
