
; int strcmp(const char *s1, const char *s2)

XDEF strcmp

strcmp:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_strcmp.asm"
