
; int fseek_unlocked(FILE *stream, long offset, int whence)

XDEF fseek_unlocked

fseek_unlocked:

   pop af
   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   exx
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_fseek_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_fseek_unlocked.asm"
