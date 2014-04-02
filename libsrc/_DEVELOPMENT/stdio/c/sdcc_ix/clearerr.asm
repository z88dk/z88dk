
; void clearerr(FILE *stream)

XDEF _clearerr

_clearerr:

   pop af
   pop bc
   
   push bc
   push af

   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_clearerr
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_clearerr.asm"
