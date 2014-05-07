; void sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook)

XDEF _sp1_IterateUpdateRect

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

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_IterateUpdateRect.asm"
