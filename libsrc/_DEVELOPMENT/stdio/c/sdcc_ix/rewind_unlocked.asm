
; void rewind_unlocked(FILE *stream)

XDEF rewind_unlocked

rewind_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_rewind_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_rewind_unlocked.asm"
