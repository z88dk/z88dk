
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)

SECTION code_stdio

PUBLIC _freopen_unlocked

_freopen_unlocked:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_freopen_unlocked.asm"
