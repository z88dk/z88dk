; void __CALLEE__ sp1_GetTiles_callee(struct sp1_Rect *r, struct sp1_tp *dest)

PUBLIC sp1_GetTiles_callee

sp1_GetTiles_callee:

   pop af
   pop hl
   ex (sp),hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   push af

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_GetTiles.asm"
