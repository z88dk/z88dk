
; int vprintf(const char *format, void *arg)

XDEF vprintf

vprintf:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_vprintf.asm"
