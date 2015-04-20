
; char *strchrnul_callee(const char *s, int c)

SECTION code_string

PUBLIC _strchrnul_callee

_strchrnul_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strchrnul.asm"
