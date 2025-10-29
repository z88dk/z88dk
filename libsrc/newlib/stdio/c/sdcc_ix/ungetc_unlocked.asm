
; int ungetc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ungetc_unlocked

EXTERN l0_ungetc_unlocked_callee

_ungetc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_ungetc_unlocked_callee
