
; int fputs(const char *s, FILE *stream)

XDEF fputs

fputs:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fputs
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fputs.asm"
