
; int feof_unlocked(FILE *stream)

XDEF feof_unlocked

feof_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_feof_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_feof_unlocked.asm"
