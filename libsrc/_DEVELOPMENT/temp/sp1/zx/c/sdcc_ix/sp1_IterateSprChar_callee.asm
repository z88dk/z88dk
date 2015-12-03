; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateSprChar_callee, l0_sp1_IterateSprChar_callee

EXTERN asm_sp1_IterateSprChar

_sp1_IterateSprChar_callee:

   pop af
   pop hl
   pop bc
   push af

l0_sp1_IterateSprChar_callee:

   push bc
   ex (sp),ix
   
   call asm_sp1_IterateSprChar
   
   pop ix
   ret
