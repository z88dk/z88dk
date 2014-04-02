
; int obstack_printf(struct obstack *obstack, const char *format, ...)

XDEF _obstack_printf

_obstack_printf:

   push ix
   
   call asm_obstack_printf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_obstack_printf.asm"
