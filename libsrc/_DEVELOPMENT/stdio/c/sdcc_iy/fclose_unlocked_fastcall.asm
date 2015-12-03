
; int fclose_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fclose_unlocked_fastcall

EXTERN asm_fclose_unlocked

_fclose_unlocked_fastcall:

   push hl
   pop ix
   
   jp asm_fclose_unlocked
