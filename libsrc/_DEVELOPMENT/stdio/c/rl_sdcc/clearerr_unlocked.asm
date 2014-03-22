
; void clearerr_unlocked(FILE *stream)

XDEF clearerr_unlocked

clearerr_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_clearerr_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_clearerr_unlocked.asm"
