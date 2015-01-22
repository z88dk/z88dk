; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2)

SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateSpr

_sp1_IterateUpdateSpr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push bc
   ex (sp),ix
   
   call asm_sp1_IterateUpdateSpr
   
   pop ix
   ret

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_IterateUpdateSpr.asm"
