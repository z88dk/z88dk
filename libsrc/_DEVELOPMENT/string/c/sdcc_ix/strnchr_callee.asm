
; char *strnchr_callee(const char *s, size_t n, int c)

SECTION code_string

PUBLIC _strnchr_callee

_strnchr_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "string/z80/asm_strnchr.asm"
