
; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcpy

EXTERN asm_strcpy

_strcpy:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strcpy
