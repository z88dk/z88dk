
; int fseek_unlocked_callee(FILE *stream, long offset, int whence)

SECTION code_stdio

PUBLIC _fseek_unlocked_callee

_fseek_unlocked_callee:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "stdio/z80/asm_fseek_unlocked.asm"
