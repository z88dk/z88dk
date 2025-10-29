
; int strcoll_callee(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcoll_callee

EXTERN asm_strcoll

_strcoll_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strcoll
