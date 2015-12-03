
; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcpy_callee

EXTERN asm_strcpy

strcpy_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strcpy
