
; char *strstr(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strstr

EXTERN asm_strstr

_strstr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strstr
