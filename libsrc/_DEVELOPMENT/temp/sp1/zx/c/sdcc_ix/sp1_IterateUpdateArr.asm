; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)

SECTION seg_code_sp1

PUBLIC _sp1_IterateUpdateArr

_sp1_IterateUpdateArr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_sp1_IterateUpdateArr
   
   pop ix
   ret

   INCLUDE "temp/sp1/zx/updater/asm_sp1_IterateUpdateArr.asm"
