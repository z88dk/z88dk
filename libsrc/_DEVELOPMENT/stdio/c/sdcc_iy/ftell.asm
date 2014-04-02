
; unsigned long ftell(FILE *stream)

XDEF _ftell

_ftell:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_ftell.asm"
