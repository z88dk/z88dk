
; size_t strlcpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strlcpy_callee

EXTERN asm_strlcpy

strlcpy_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strlcpy
