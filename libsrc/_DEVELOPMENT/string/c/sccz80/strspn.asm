
; size_t strspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strspn

EXTERN asm_strspn

strspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strspn
