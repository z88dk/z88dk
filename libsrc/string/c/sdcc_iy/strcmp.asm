
; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcmp

EXTERN asm_strcmp

_strcmp:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strcmp
