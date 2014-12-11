
; int obstack_printf(struct obstack *obstack, const char *format, ...)

SECTION code_stdio

PUBLIC obstack_printf

obstack_printf:

   INCLUDE "stdio/z80/asm_obstack_printf.asm"
