; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTL_findAttrH(unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_findAttrH

EXTERN asm_BIFROSTL_findAttrH

_BIFROSTL_findAttrH:

   ld hl,2
	add hl,sp
	ld e,(hl)       ; E = lin
	inc hl
	ld c,(hl)       ; C = col
	
	jp asm_BIFROSTL_findAttrH
