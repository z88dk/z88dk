
; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcmp_callee

EXTERN asm_strcmp

strcmp_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strcmp
