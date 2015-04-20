
; int strcmp_callee(const char *s1, const char *s2)

SECTION code_string

PUBLIC _strcmp_callee

_strcmp_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strcmp.asm"
