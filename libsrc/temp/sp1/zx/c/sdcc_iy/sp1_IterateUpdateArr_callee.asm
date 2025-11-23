; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateArr_callee

EXTERN asm_sp1_IterateUpdateArr

_sp1_IterateUpdateArr_callee:

   pop af
   pop hl
   pop ix
   push af

   jp asm_sp1_IterateUpdateArr
