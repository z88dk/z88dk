
; int fgetc_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgetc_unlocked

EXTERN asm_fgetc_unlocked

_fgetc_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_fgetc_unlocked
