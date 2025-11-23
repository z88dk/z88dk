
; size_t strlcat_callee(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strlcat_callee

EXTERN asm_strlcat

_strlcat_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_strlcat
