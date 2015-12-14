; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_fillTileAttrL(unsigned int row, unsigned int col, unsigned int attr)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_fillTileAttrL

EXTERN asm_BIFROSTL_fillTileAttrL

BIFROSTL_fillTileAttrL:

   	ld hl,2
   	add hl,sp
   	ld c,(hl)       ; C=attrib
   	inc hl
   	inc hl
   	ld e,(hl)       ; E=col
   	inc hl
   	inc hl
   	ld d,(hl)       ; D=row

   	jp asm_BIFROSTL_fillTileAttrL        ; execute 'fill_tile_attr'
