
; int ungetc_unlocked(int c, FILE *stream)

PUBLIC _ungetc_unlocked

_ungetc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_ungetc_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_ungetc_unlocked.asm"
