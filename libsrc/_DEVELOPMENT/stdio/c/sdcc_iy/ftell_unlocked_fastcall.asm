
; unsigned long ftell_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _ftell_unlocked_fastcall

_ftell_unlocked_fastcall:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ftell_unlocked.asm"
