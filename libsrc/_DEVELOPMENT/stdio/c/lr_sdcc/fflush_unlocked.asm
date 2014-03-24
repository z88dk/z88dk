
; int fflush_unlocked(FILE *stream)

XDEF fflush_unlocked

fflush_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fflush_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fflush_unlocked.asm"
