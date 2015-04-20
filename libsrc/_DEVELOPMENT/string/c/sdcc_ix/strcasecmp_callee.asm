
; int strcasecmp_callee(const char *s1, const char *s2)

SECTION code_string

PUBLIC _strcasecmp_callee

_strcasecmp_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strcasecmp.asm"
