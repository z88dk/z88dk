
; int fgetc_unlocked(FILE *stream)

XDEF fgetc_unlocked

fgetc_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b

   call asm_fgetc_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fgetc_unlocked.asm"
