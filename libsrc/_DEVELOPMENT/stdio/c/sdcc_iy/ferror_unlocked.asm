
; int ferror_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ferror_unlocked

EXTERN asm_ferror_unlocked

_ferror_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_ferror_unlocked
