; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_fillTileAttrH(unsigned int lin,unsigned int col,unsigned int attr)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_fillTileAttrH

EXTERN asm_BIFROSTH_fillTileAttrH

_BIFROSTH_fillTileAttrH:

   	ld hl,2
   	add hl,sp
   	ld d,(hl)       ; D=lin
   	inc hl
   	inc hl
   	ld e,(hl)       ; E=col
   	inc hl
   	inc hl
   	ld c,(hl)       ; C=attrib

   	jp asm_BIFROSTH_fillTileAttrH        ; execute 'fill_tile_attr'
