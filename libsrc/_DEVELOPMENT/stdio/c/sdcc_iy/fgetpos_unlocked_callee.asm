
; int fgetpos_unlocked_callee(FILE *stream, fpos_t *pos)

SECTION code_stdio

PUBLIC _fgetpos_unlocked_callee

_fgetpos_unlocked_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fgetpos_unlocked.asm"
