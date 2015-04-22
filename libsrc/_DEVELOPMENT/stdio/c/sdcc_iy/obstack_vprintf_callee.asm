
; int obstack_vprintf_callee(struct obstack *obstack, const char *format, void *arg)

SECTION code_stdio

PUBLIC _obstack_vprintf_callee

_obstack_vprintf_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "stdio/z80/asm_obstack_vprintf.asm"
