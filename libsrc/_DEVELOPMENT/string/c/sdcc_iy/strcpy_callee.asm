
; char *strcpy_callee(char * restrict s1, const char * restrict s2)

SECTION code_string

PUBLIC _strcpy_callee

_strcpy_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strcpy.asm"
