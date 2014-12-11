
; int fseek_unlocked(FILE *stream, long offset, int whence)

SECTION code_stdio

PUBLIC fseek_unlocked_callee

fseek_unlocked_callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fseek_unlocked.asm"
