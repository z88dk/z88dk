
; int strncmp_callee(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strncmp_callee

EXTERN asm_strncmp

_strncmp_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_strncmp
