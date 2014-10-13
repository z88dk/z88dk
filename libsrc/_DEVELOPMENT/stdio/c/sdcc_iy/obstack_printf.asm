
; int obstack_printf(struct obstack *obstack, const char *format, ...)

SECTION seg_code_stdio

PUBLIC _obstack_printf

_obstack_printf:

   INCLUDE "stdio/z80/asm_obstack_printf.asm"
