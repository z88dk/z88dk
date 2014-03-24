
; int vscanf(const char *format, void *arg)

XDEF vscanf

vscanf:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   push ix
   
   call asm_vscanf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vscanf.asm"
