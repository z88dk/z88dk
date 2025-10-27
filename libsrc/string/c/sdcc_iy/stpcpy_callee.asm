
; char *stpcpy_callee(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC _stpcpy_callee

EXTERN asm_stpcpy

_stpcpy_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_stpcpy
