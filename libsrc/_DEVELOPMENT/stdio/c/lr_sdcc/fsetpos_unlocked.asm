
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

XDEF fsetpos_unlocked

fsetpos_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fsetpos_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fsetpos_unlocked.asm"
