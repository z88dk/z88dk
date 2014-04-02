
; int vprintf_unlocked(const char *format, void *arg)

XDEF _vprintf_unlocked

_vprintf_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_vprintf_unlocked.asm"
