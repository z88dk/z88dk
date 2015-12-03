
; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncat_callee

EXTERN asm_strncat

strncat_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_strncat
