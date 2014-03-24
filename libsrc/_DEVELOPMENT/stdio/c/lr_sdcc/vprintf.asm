
; int vprintf(const char *format, void *arg)

XDEF vprintf

vprintf:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   push ix
   
   call asm_vprintf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vprintf.asm"
