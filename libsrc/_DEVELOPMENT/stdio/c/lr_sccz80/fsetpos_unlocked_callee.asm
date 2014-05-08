
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

PUBLIC fsetpos_unlocked_callee

fsetpos_unlocked_callee:

   pop af
   pop hl
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fsetpos_unlocked.asm"
