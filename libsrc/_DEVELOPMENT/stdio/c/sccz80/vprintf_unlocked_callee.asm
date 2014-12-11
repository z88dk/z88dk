
; int vprintf_unlocked(const char *format, void *arg)

SECTION code_stdio

PUBLIC vprintf_unlocked_callee

vprintf_unlocked_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_vprintf_unlocked.asm"
