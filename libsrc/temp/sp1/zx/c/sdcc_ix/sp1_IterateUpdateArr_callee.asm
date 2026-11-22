; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateArr_callee, l0_sp1_IterateUpdateArr_callee

EXTERN asm_sp1_IterateUpdateArr

_sp1_IterateUpdateArr_callee:

   pop af
   pop hl
   pop bc
   push af

l0_sp1_IterateUpdateArr_callee:

   push bc
   ex (sp),ix
   
   call asm_sp1_IterateUpdateArr
   
   pop ix
   ret
