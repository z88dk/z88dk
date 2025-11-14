
; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcat

EXTERN asm_strcat

_strcat:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strcat
