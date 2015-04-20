
; char *strstr_callee(const char *s1, const char *s2)

SECTION code_string

PUBLIC _strstr_callee

_strstr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strstr.asm"
