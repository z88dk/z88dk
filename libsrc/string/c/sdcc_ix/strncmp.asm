
; int strncmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strncmp

EXTERN asm_strncmp

_strncmp:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm_strncmp
