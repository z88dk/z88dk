
; int fputc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fputc_unlocked

EXTERN l0_fputc_unlocked_callee

_fputc_unlocked:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp l0_fputc_unlocked_callee
