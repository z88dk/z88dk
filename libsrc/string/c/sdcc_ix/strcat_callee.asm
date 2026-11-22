
; char *strcat_callee(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcat_callee

EXTERN asm_strcat

_strcat_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strcat
