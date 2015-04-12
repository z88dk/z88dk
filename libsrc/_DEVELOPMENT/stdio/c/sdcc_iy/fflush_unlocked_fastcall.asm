
; int fflush_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _fflush_unlocked_fastcall

_fflush_unlocked_fastcall:
   
   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fflush_unlocked.asm"
