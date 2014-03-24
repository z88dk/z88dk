
; int strncmp(const char *s1, const char *s2, size_t n)

XDEF strncmp

strncmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "string/z80/asm_strncmp.asm"
