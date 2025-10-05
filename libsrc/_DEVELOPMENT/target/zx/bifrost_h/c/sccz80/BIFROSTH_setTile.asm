; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_setTile(unsigned int px,unsigned int py,unsigned int tile)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_setTile

EXTERN asm_BIFROSTH_setTile

BIFROSTH_setTile:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; E=tile
   	inc hl
   	inc hl
   	ld c,(hl)       ; C=py
   	inc hl
   	inc hl
   	ld l,(hl)       ; L=px

   	jp asm_BIFROSTH_setTile
