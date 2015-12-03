
; char *stpcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC stpcpy_callee

EXTERN asm_stpcpy

stpcpy_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_stpcpy
