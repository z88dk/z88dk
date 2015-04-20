
; size_t strcspn_callee(const char *s1, const char *s2)

SECTION code_string

PUBLIC _strcspn_callee

_strcspn_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strcspn.asm"
