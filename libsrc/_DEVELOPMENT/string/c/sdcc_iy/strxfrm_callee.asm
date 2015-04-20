
; size_t strxfrm_callee(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_string

PUBLIC _strxfrm_callee

_strxfrm_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strxfrm.asm"
