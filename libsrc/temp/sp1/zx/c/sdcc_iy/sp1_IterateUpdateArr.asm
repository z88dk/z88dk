; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateArr

EXTERN asm_sp1_IterateUpdateArr

_sp1_IterateUpdateArr:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af

   jp asm_sp1_IterateUpdateArr
