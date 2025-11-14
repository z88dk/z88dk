; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateSpr

EXTERN asm_sp1_IterateUpdateSpr

_sp1_IterateUpdateSpr:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   jp asm_sp1_IterateUpdateSpr
