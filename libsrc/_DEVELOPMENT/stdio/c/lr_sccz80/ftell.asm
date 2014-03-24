
; unsigned long ftell(FILE *stream)

XDEF ftell

ftell:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ftell.asm"
