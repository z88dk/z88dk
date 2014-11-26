; void sp1_GetTiles(struct sp1_Rect *r, struct sp1_tp *dest)

SECTION seg_code_sp1

PUBLIC _sp1_GetTiles

_sp1_GetTiles:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push de
   
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   pop hl

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_GetTiles.asm"
