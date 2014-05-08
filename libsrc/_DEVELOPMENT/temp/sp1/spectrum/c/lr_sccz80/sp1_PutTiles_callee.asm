; void __CALLEE__ sp1_PutTiles_callee(struct sp1_Rect *r, struct sp1_tp *src)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_PutTiles_callee

sp1_PutTiles_callee:

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

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_PutTiles.asm"
