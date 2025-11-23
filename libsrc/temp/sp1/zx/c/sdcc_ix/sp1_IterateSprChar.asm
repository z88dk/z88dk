; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateSprChar

EXTERN l0_sp1_IterateSprChar_callee

_sp1_IterateSprChar:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_sp1_IterateSprChar_callee
