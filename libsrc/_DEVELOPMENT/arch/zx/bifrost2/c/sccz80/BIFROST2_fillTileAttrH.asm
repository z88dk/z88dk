; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void void BIFROST2_fillTileAttrH(unsigned int lin,unsigned int col,unsigned int attr)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_fillTileAttrH

EXTERN asm_BIFROST2_fillTileAttrH

BIFROST2_fillTileAttrH:

   	ld hl,2
   	add hl,sp
   	ld c,(hl)       ; C=attrib
   	inc hl
   	inc hl
   	ld e,(hl)       ; E=col
   	inc hl
   	inc hl
   	ld d,(hl)       ; D=lin

   	jp asm_BIFROST2_fillTileAttrH        ; execute 'fill_tile_attr'
