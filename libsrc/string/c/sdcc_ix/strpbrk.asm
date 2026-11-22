
; char *strpbrk(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strpbrk

EXTERN asm_strpbrk

_strpbrk:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strpbrk
