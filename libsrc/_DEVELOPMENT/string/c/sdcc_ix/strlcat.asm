
; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_string

PUBLIC _strlcat

_strlcat:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strlcat.asm"
