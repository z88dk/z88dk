; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_fillTileAttrH(unsigned char lin,unsigned char col,unsigned char attr)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_fillTileAttrH

EXTERN asm_BIFROST2_fillTileAttrH

_BIFROST2_fillTileAttrH:

   	ld hl,2
   	add hl,sp
   	ld d,(hl)       ; D=lin
   	inc hl
   	ld e,(hl)       ; E=col
   	inc hl
   	ld c,(hl)       ; C=attrib

   	jp asm_BIFROST2_fillTileAttrH        ; execute 'fill_tile_attr'
