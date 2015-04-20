
; size_t strspn_callee(const char *s1, const char *s2)

SECTION code_string

PUBLIC _strspn_callee

_strspn_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strspn.asm"
