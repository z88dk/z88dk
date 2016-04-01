; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROST2_findAttrH(unsigned int lin,unsigned int col)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_findAttrH

EXTERN asm_BIFROST2_findAttrH

_BIFROST2_findAttrH:

   	ld hl,2
   	ld b,h
   	ld d,h
   	add hl,sp
   	ld e,(hl)       ; DE=lin
   	inc hl
   	inc hl
  	ld c,(hl)       ; BC=col
  	ex de,hl        ; HL=lin

   	jp asm_BIFROST2_findAttrH
