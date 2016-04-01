; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_setTile(unsigned int px,unsigned int py,unsigned int tile)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_setTile

EXTERN asm_BIFROST2_setTile

_BIFROST2_setTile:

   	ld hl,2
   	add hl,sp
   	ld l,(hl)       ; L=px
   	inc hl
   	inc hl
   	ld c,(hl)       ; C=py
   	inc hl
   	inc hl
   	ld e,(hl)       ; E=tile

   	jp asm_BIFROST2_setTile
