
; int fputc(int c, FILE *stream)

XDEF fputc

fputc:

   pop af
   pop de
   pop ix
   
   push ix
   push de
   push af
   
   INCLUDE "stdio/z80/asm_fputc.asm"
