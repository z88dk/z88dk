
; int ungetc(int c, FILE *stream)

XDEF ungetc

ungetc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_ungetc
   
   pop ix
   ret

   INCLUDE "../../z80/asm_ungetc.asm"
