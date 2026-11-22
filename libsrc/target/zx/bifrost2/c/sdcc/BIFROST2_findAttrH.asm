; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROST2_findAttrH(unsigned char lin,unsigned char col)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_findAttrH

EXTERN asm_BIFROST2_findAttrH

_BIFROST2_findAttrH:

   ld hl,3
	add hl,sp
	ld c,(hl)        ; C = col
	dec hl
	ld l,(hl)        ; L = lin
	
	jp asm_BIFROST2_findAttrH
