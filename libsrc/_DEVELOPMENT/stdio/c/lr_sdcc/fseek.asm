
; int fseek(FILE *stream, long offset, int whence)

XDEF fseek

fseek:

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
   
   call asm_fseek
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fseek.asm"
