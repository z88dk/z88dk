; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTH_findAttrH(unsigned int lin,unsigned int col)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_findAttrH

EXTERN asm_BIFROSTH_findAttrH

_BIFROSTH_findAttrH:

   	ld hl,2
   	ld b,h
   	ld d,h
   	add hl,sp
   	ld e,(hl)       ; DE=lin
   	inc hl
   	inc hl
  	ld c,(hl)       ; BC=col
  	ex de,hl        ; HL=lin

   	jp asm_BIFROSTH_findAttrH
