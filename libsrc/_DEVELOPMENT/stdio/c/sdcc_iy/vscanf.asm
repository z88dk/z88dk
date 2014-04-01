
; int vscanf(const char *format, void *arg)

XDEF vscanf

vscanf:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_vscanf.asm"
