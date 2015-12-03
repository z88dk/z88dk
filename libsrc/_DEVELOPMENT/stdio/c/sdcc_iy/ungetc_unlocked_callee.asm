
; int ungetc_unlocked_callee(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ungetc_unlocked_callee

EXTERN asm_ungetc_unlocked

_ungetc_unlocked_callee:

   pop af
   pop hl
   pop ix
   push af
   
   jp asm_ungetc_unlocked
