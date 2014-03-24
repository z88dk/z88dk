
; int fseek(FILE *stream, long offset, int whence)

XDEF fseek_callee

fseek_callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fseek.asm"
