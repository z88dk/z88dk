
; int fclose_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC _fclose_unlocked

_fclose_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fclose_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fclose_unlocked.asm"
