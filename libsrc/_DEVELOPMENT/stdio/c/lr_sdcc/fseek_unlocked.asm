
; int fseek_unlocked(FILE *stream, long offset, int whence)

XDEF fseek_unlocked

fseek_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push hl
   push bc
   push af
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_fseek_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fseek_unlocked.asm"
