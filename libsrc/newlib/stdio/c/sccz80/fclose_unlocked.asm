
; int fclose_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fclose_unlocked

EXTERN asm_fclose_unlocked

fclose_unlocked:

   push hl
   pop ix
   
   jp asm_fclose_unlocked
