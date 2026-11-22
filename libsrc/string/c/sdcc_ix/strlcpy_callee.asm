
; size_t strlcpy_callee(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strlcpy_callee

EXTERN asm_strlcpy

_strlcpy_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_strlcpy
