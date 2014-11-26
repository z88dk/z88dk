; void sp1_Validate(struct sp1_Rect *r)

SECTION seg_code_sp1

PUBLIC _sp1_Validate

_sp1_Validate:

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

   INCLUDE "temp/sp1/zx/updater/asm_sp1_Validate.asm"
