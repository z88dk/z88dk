
; int fputs(const char *s, FILE *stream)

XDEF fputs

fputs:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_fputs.asm"
