
; char *strchr_callee(const char *s, int c)

SECTION code_string

PUBLIC _strchr_callee

_strchr_callee:

   pop af
   pop hl
   pop bc
   push af

   INCLUDE "string/z80/asm_strchr.asm"
