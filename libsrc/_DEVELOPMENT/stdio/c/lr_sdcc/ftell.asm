
; unsigned long ftell(FILE *stream)

XDEF ftell

ftell:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_ftell
   
   pop ix
   ret

   INCLUDE "../../z80/asm_ftell.asm"
