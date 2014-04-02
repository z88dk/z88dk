
; int fseek(FILE *stream, long offset, int whence)

XDEF _fseek

_fseek:

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
   
   call asm_fseek
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fseek.asm"
