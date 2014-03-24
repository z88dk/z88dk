
; int fputc(int c, FILE *stream)

XDEF fputc_callee

fputc_callee:

   pop af
   pop ix
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_fputc.asm"
