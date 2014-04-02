
; int vscanf(const char *format, void *arg)

XDEF _vscanf

_vscanf:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_vscanf.asm"
