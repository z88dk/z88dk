
; int fclose_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fclose_unlocked

EXTERN asm_fclose_unlocked

_fclose_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_fclose_unlocked
