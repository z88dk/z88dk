
; int vprintf_unlocked(const char *format, void *arg)

SECTION code_stdio

PUBLIC _vprintf_unlocked

_vprintf_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_vprintf_unlocked.asm"
