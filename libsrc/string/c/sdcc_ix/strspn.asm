
; size_t strspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strspn

EXTERN asm_strspn

_strspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strspn
