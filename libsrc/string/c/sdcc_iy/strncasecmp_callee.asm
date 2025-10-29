
; int strncasecmp_callee(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strncasecmp_callee

EXTERN asm_strncasecmp

_strncasecmp_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_strncasecmp
