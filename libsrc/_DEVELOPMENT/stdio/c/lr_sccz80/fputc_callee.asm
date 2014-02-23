
; int fputc(int c, FILE *stream)

XDEF fputc_callee, putc_callee

fputc_callee:
putc_callee:

   pop af
   pop ix
   pop de
   push af
   
   INCLUDE "../../z80/asm_fputc.asm"
