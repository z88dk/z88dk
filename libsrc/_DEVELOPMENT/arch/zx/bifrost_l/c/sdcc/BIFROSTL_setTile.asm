; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_setTile(unsigned int px, unsigned int py, unsigned int tile)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_setTile

EXTERN asm_BIFROSTL_setTile

_BIFROSTL_setTile:

   	ld hl,2
   	add hl,sp
   	ld l,(hl)       ; L=px
   	inc hl
   	inc hl
   	ld c,(hl)       ; C=py
   	inc hl
   	inc hl
   	ld e,(hl)       ; E=tile

   	jp asm_BIFROSTL_setTile
