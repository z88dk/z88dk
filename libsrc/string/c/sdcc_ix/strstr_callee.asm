
; char *strstr_callee(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strstr_callee

EXTERN asm_strstr

_strstr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strstr
