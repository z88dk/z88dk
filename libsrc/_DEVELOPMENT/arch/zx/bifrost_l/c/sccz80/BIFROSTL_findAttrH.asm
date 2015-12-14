; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTL_findAttrH(unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_findAttrH

EXTERN asm_BIFROSTL_findAttrH

BIFROSTL_findAttrH:

   	ld hl,2
   	ld b,h
   	ld d,h
   	add hl,sp
   	ld c,(hl)       ; BC=col
   	inc hl
   	inc hl
   	ld e,(hl)       ; DE=lin

   	jp asm_BIFROSTL_findAttrH
