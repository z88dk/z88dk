
; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncpy_callee

EXTERN asm_strncpy

strncpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_strncpy
