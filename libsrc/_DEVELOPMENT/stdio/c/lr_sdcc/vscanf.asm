
; int vscanf(const char *format, void *arg)

XDEF vscanf

vscanf:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_vscanf.asm"
