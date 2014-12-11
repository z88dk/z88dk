
; int fputc_unlocked(int c, FILE *stream)

SECTION code_stdio

PUBLIC _fputc_unlocked

_fputc_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fputc_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fputc_unlocked.asm"
