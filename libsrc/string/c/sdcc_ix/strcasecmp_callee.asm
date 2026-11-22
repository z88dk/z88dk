
; int strcasecmp_callee(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcasecmp_callee

EXTERN asm_strcasecmp

_strcasecmp_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strcasecmp
