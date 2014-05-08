
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

PUBLIC _fgetpos_unlocked

_fgetpos_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fgetpos_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgetpos_unlocked.asm"
