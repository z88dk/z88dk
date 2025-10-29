
; size_t strspn_callee(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strspn_callee

EXTERN asm_strspn

_strspn_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strspn
