; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateSpr

EXTERN l0_sp1_IterateUpdateSpr

_sp1_IterateUpdateSpr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_sp1_IterateUpdateSpr
