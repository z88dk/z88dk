
; int fsetpos_unlocked_callee(FILE *stream, const fpos_t *pos)

SECTION code_stdio

PUBLIC _fsetpos_unlocked_callee

_fsetpos_unlocked_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fsetpos_unlocked.asm"
