
; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcat_callee

EXTERN asm_strcat

strcat_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strcat
