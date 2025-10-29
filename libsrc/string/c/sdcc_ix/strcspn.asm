
; size_t strcspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcspn

EXTERN asm_strcspn

_strcspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcspn
