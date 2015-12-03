; void sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateRect

EXTERN l0_sp1_IterateUpdateRect_callee

_sp1_IterateUpdateRect:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_sp1_IterateUpdateRect_callee
