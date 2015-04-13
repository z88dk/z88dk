
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

SECTION code_stdio

PUBLIC _fsetpos_unlocked

_fsetpos_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_fsetpos_unlocked.asm"
