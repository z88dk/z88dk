
; int vprintf(const char *format, void *arg)

XDEF vprintf_callee

vprintf_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_vprintf.asm"
