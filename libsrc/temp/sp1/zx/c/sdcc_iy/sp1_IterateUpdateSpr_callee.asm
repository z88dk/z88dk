; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateSpr_callee

EXTERN asm_sp1_IterateUpdateSpr

_sp1_IterateUpdateSpr_callee:

   pop af
   pop hl
   pop ix
   push af
   
   jp asm_sp1_IterateUpdateSpr
