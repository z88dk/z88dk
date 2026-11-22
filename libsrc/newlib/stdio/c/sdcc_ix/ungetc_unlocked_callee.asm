
; int ungetc_unlocked_callee(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ungetc_unlocked_callee, l0_ungetc_unlocked_callee

EXTERN asm_ungetc_unlocked

_ungetc_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af

l0_ungetc_unlocked_callee:

   push bc
   ex (sp),ix
   
   call asm_ungetc_unlocked
   
   pop ix
   ret
