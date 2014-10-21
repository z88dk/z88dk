
; int fileno_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC _fileno_unlocked

_fileno_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fileno_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fileno_unlocked.asm"
