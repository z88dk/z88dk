
; int fputc_unlocked_callee(int c, FILE *stream)

SECTION code_stdio

PUBLIC _fputc_unlocked_callee

_fputc_unlocked_callee:

   pop af
   pop de
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fputc_unlocked.asm"
