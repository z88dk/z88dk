
; int vfprintf_unlocked_callee(FILE *stream, const char *format, void *arg)

SECTION code_stdio

PUBLIC _vfprintf_unlocked_callee

_vfprintf_unlocked_callee:

   pop af
   pop ix
   pop de
   pop bc
   push af
   
   INCLUDE "stdio/z80/asm_vfprintf_unlocked.asm"
