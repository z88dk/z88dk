
; int obstack_printf(struct obstack *obstack, const char *format, ...)

XDEF obstack_printf

obstack_printf:

   push ix
   
   call asm_obstack_printf
   
   pop ix
   ret

   INCLUDE "../../z80/asm_obstack_printf.asm"
