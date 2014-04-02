
; int vprintf(const char *format, void *arg)

XDEF _vprintf

_vprintf:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   push ix
   
   call asm_vprintf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vprintf.asm"
