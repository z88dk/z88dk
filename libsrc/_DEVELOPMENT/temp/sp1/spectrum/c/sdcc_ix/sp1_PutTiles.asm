; void sp1_PutTiles(struct sp1_Rect *r, struct sp1_tp *src)

PUBLIC _sp1_PutTiles

_sp1_PutTiles:

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
   
   push ix
   
   call asm_sp1_PutTiles

   pop ix
   ret

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_PutTiles.asm"
