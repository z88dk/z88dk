
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

SECTION code_stdio

PUBLIC _fgetpos_unlocked

_fgetpos_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fgetpos_unlocked.asm"
