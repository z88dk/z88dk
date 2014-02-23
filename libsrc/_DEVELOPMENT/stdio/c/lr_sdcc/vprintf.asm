
; int vprintf(const char *format, void *arg)

XDEF vprintf

vprintf:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_vprintf.asm"
