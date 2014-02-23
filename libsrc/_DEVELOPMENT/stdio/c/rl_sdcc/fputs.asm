
; int fputs(const char *s, FILE *stream)

XDEF fputs

fputs:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fputs
   
   pop ix
   ret

   INCLUDE "../../asm_fputs.asm"
