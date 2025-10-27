; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateArr

EXTERN l0_sp1_IterateUpdateArr_callee

_sp1_IterateUpdateArr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_sp1_IterateUpdateArr_callee
