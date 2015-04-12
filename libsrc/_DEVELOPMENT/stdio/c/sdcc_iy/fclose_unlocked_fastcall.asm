
; int fclose_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _fclose_unlocked_fastcall

_fclose_unlocked_fastcall:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fclose_unlocked.asm"
