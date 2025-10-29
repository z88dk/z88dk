
; char *strcpy_callee(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcpy_callee

EXTERN asm_strcpy

_strcpy_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strcpy
