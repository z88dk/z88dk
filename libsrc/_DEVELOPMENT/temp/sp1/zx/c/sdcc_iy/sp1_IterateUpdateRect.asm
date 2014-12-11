; void sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook)

SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateRect

_sp1_IterateUpdateRect:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   INCLUDE "temp/sp1/zx/updater/asm_sp1_IterateUpdateRect.asm"
