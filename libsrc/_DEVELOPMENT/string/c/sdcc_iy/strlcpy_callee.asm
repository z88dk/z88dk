
; size_t strlcpy_callee(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_string

PUBLIC _strlcpy_callee

_strlcpy_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strlcpy.asm"
