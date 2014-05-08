; void __FASTCALL__ sp1_Invalidate(struct sp1_Rect *r)

PUBLIC _sp1_Invalidate

_sp1_Invalidate:

   pop af
   pop hl
   
   push hl
   push af

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_Invalidate.asm"
