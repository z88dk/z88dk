
; size_t strxfrm_callee(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strxfrm_callee

EXTERN asm_strxfrm

_strxfrm_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_strxfrm
