
; int fflush_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fflush_unlocked

EXTERN asm_fflush_unlocked

_fflush_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_fflush_unlocked
