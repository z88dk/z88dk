
; char *strpbrk_callee(const char *s1, const char *s2)

SECTION code_string

PUBLIC _strpbrk_callee

_strpbrk_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strpbrk.asm"
