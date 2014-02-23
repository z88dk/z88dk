
; unsigned long ftell_unlocked(FILE *stream)

XDEF ftell_unlocked

ftell_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_ftell_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_ftell_unlocked.asm"
