
; int fputc_unlocked(int c, FILE *stream)

SECTION seg_code_stdio

PUBLIC _fputc_unlocked

_fputc_unlocked:

   pop af
   pop de
   pop ix
   
   push ix
   push de
   push af
   
   INCLUDE "stdio/z80/asm_fputc_unlocked.asm"
