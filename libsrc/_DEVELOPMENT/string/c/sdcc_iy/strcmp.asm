
; int strcmp(const char *s1, const char *s2)

PUBLIC _strcmp

_strcmp:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_strcmp.asm"
