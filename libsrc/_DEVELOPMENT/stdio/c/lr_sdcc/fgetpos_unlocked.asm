
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

XDEF fgetpos_unlocked

fgetpos_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fgetpos_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fgetpos_unlocked.asm"
