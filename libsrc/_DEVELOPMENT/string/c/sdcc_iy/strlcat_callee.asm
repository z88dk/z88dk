
; size_t strlcat_callee(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_string

PUBLIC _strlcat_callee

_strlcat_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strlcat.asm"
