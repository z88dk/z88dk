; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getTile(unsigned int px, unsigned int py)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_getTile

EXTERN asm_BIFROSTL_getTile

BIFROSTL_getTile:

   	ld hl,2
   	ld b,h          ; B=0
   	add hl,sp
   	ld c,(hl)       ; BC=py
   	inc hl
   	inc hl
   	ld l,(hl)       ; L=px

   	jp asm_BIFROSTL_getTile
