; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateSpr, l0_sp1_IterateUpdateSpr

EXTERN asm_sp1_IterateUpdateSpr

_sp1_IterateUpdateSpr:

   pop af
   pop hl
   pop bc
   push af

l0_sp1_IterateUpdateSpr:

   push bc
   ex (sp),ix
   
   call asm_sp1_IterateUpdateSpr
   
   pop ix
   ret
