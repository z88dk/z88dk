
; int strcasecmp(const char *s1, const char *s2)

PUBLIC _strcasecmp

_strcasecmp:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_strcasecmp.asm"
