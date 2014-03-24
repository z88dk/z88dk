
; int vscanf(const char *format, void *arg)

XDEF vscanf_callee

vscanf_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_vscanf.asm"
