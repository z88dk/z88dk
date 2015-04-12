
; void clearerr_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _clearerr_unlocked_fastcall

_clearerr_unlocked_fastcall:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_clearerr_unlocked.asm"
