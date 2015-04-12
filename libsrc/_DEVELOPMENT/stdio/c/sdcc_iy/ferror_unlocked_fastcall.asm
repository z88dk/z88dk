
; int ferror_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _ferror_unlocked_fastcall

_ferror_unlocked_fastcall:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ferror_unlocked.asm"
