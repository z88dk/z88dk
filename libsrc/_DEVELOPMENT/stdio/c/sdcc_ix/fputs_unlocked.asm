
; int fputs_unlocked(const char *s, FILE *stream)

PUBLIC _fputs_unlocked

_fputs_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fputs_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fputs_unlocked.asm"
