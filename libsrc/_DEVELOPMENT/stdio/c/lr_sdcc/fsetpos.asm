
; int fsetpos(FILE *stream, const fpos_t *pos)

XDEF fsetpos

fsetpos:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fsetpos
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fsetpos.asm"
