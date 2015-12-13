; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getTile(unsigned int px,unsigned int py)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_getTile

EXTERN asm_BIFROSTH_getTile

_BIFROSTH_getTile:

   	ld hl,2
   	ld b,h          ; B=0
   	add hl,sp
   	ld e,(hl)       ; E=px
   	inc hl
   	inc hl
   	ld c,(hl)       ; BC=py
   	ld l,e          ; L=px

   	jp asm_BIFROSTH_getTile
