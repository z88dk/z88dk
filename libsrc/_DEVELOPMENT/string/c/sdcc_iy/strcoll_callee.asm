
; int strcoll_callee(const char *s1, const char *s2)

SECTION code_string

PUBLIC _strcoll_callee

_strcoll_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strcoll.asm"
