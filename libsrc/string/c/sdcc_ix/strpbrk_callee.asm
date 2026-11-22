
; char *strpbrk_callee(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strpbrk_callee

EXTERN asm_strpbrk

_strpbrk_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strpbrk
