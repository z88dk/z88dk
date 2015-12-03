
; char *strstr(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strstr_callee

EXTERN asm_strstr

strstr_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strstr
