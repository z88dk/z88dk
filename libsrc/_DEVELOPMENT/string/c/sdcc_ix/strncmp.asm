
; int strncmp(const char *s1, const char *s2, size_t n)

XDEF _strncmp

_strncmp:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_strncmp.asm"
