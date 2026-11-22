
; int strcmp_callee(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcmp_callee

EXTERN asm_strcmp

_strcmp_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strcmp
