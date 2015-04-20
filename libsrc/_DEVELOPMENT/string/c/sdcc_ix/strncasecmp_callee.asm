
; int strncasecmp_callee(const char *s1, const char *s2, size_t n)

SECTION code_string

PUBLIC _strncasecmp_callee

_strncasecmp_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strncasecmp.asm"
