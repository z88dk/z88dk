; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getTile(unsigned int px, unsigned int py)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_getTile

EXTERN asm_BIFROSTL_getTile

_BIFROSTL_getTile:

   	ld hl,2
   	ld b,h          ; B=0
   	add hl,sp
   	ld a,(hl)       ; A=px
   	inc hl
   	inc hl
   	ld c,(hl)       ; BC=py
   	ld l,a          ; L=px

   	jp asm_BIFROSTL_getTile
