
; char *stpcpy_callee(char * restrict s1, const char * restrict s2)

SECTION code_string

PUBLIC _stpcpy_callee

_stpcpy_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_stpcpy.asm"
