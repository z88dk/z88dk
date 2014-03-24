
; int vprintf_unlocked(const char *format, void *arg)

XDEF vprintf_unlocked_callee

vprintf_unlocked_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_vprintf_unlocked.asm"
