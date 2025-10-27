
; char *strncpy_callee(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strncpy_callee

EXTERN asm_strncpy

_strncpy_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_strncpy
