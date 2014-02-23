
; int vprintf_unlocked(const char *format, void *arg)

XDEF vprintf_unlocked

vprintf_unlocked:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_vprintf_unlocked.asm"
