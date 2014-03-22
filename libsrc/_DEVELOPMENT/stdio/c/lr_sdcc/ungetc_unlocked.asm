
; int ungetc_unlocked(int c, FILE *stream)

XDEF ungetc_unlocked

ungetc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_ungetc_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_ungetc_unlocked.asm"
