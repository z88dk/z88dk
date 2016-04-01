; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getTile(unsigned int px,unsigned int py)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_getTile

EXTERN asm_BIFROST2_getTile

_BIFROST2_getTile:

   	ld hl,2
   	ld b,h          ; B=0
   	add hl,sp
   	ld a,(hl)       ; A=px
   	inc hl
   	inc hl
   	ld c,(hl)       ; BC=py
   	ld l,a          ; L=px

   	jp asm_BIFROST2_getTile
