
; char *strrchr_callee(const char *s, int c)

SECTION code_string

PUBLIC _strrchr_callee

_strrchr_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strrchr.asm"
