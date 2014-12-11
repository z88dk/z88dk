; void sp1_PutTilesInv(struct sp1_Rect *r, struct sp1_tp *src)

SECTION code_temp_sp1

PUBLIC _sp1_PutTilesInv

_sp1_PutTilesInv:

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

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_PutTilesInv.asm"
