
; int ferror_unlocked(FILE *stream)

XDEF ferror_unlocked

ferror_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_ferror_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_ferror_unlocked.asm"
