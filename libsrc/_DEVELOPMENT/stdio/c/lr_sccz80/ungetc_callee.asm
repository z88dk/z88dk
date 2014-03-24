
; int ungetc(int c, FILE *stream)

XDEF ungetc_callee

ungetc_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_ungetc.asm"
