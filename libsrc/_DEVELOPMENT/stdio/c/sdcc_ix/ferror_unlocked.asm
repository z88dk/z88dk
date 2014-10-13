
; int ferror_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC _ferror_unlocked

_ferror_unlocked:

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
   
   INCLUDE "stdio/z80/asm_ferror_unlocked.asm"
