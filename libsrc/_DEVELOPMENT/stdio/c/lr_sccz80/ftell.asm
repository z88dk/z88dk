
; unsigned long ftell(FILE *stream)

XDEF ftell

ftell:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_ftell.asm"
