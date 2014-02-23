
; void clearerr(FILE *stream)

XDEF clearerr

clearerr:

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
   
   INCLUDE "../../z80/asm_clearerr.asm"
