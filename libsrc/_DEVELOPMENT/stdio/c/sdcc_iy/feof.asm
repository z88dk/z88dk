
; int feof(FILE *stream)

XDEF _feof

_feof:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_feof.asm"
